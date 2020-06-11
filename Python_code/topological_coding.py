import torch
import numpy as np
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader

from sklearn.metrics.pairwise import euclidean_distances
from torchsummary import summary
from tensorboardX import SummaryWriter
import argparse
import torchvision.utils as vutils
import matplotlib.pyplot as plt

argparser = argparse.ArgumentParser()
argparser.add_argument('--seed', type=int, default=200)
argparser.add_argument('--batch_size', type=int, default=400)
argparser.add_argument('--latent_shape', type=int, default=40, help='dimensions of S1 map')
argparser.add_argument('--n_epochs', type=int, default=100)
argparser.add_argument('--sampling', type=str, default='poisson')
argparser.add_argument('--n_samples', type=int, default=40)
argparser.add_argument('--layers', type=int, default=[50, 100])
argparser.add_argument('--cuda', action='store_true')
argparser.add_argument('--sigma', type=float, default=3.0, help='neibourhood factor')
argparser.add_argument('--eta', type=float, default=0.00001, help='learning rate')
argparser.add_argument('--lateral', type=str, default='mexican', help='type of lateral influence')
argparser.add_argument('--lambda_l', type=float, default=0.1, help='strength of lateral influence')
argparser.add_argument('--default_rate', type=float, default=0.01, help='expectation of rate')
argparser.add_argument('--save_path', type=str, default='model', help='path of saved model')
args = argparser.parse_args()

if args.cuda:
    print("Using CUDA")

latent_size = args.latent_shape**2
writer = SummaryWriter('runs/'+args.save_path+'/')
EPS = 1e-6
train = True
test = True
torch.manual_seed(args.seed)

def data_reorg(data):
    data = data/40.0
    s = np.sum(np.square(data), axis=1)
    t = np.tanh(s)/s
    return data * t[:,np.newaxis]


def locmap():
    '''
    :return: location of each neuron
    '''
    x = np.arange(0, args.latent_shape, dtype=np.float32)
    y = np.arange(0, args.latent_shape, dtype=np.float32)
    xv, yv = np.meshgrid(x, y)
    xv = np.reshape(xv, (xv.size, 1))
    yv = np.reshape(yv, (yv.size, 1))
    return np.hstack((xv, yv))


def lateral_effect():
    '''
    :return: functions of lateral effect
    '''
    locations = locmap()
    weighted_distance_matrix = euclidean_distances(locations, locations)/args.sigma

    if args.lateral is 'mexican':
        S = (1.0-0.5*np.square(weighted_distance_matrix))*np.exp(-0.5*np.square(weighted_distance_matrix))
        S = S-np.eye(len(locations))
        return S

    if args.lateral is 'rbf':
        S = np.exp(-0.5*np.square(weighted_distance_matrix))
        return S-np.eye(len(locations))
    print('no lateral effect is chosen')
    return np.zeros(weighted_distance_matrix.shape, dtype=np.float32)


class Encoder(nn.Module):
    def __init__(self, input_size):
        super(Encoder, self).__init__()
        self.layer1 = nn.Sequential(
            nn.Linear(input_size, args.layers[0], bias=False),
            nn.Tanh()
        )

        self.layer2 = nn.Sequential(
            nn.Linear(args.layers[0], args.layers[1], bias=False),
            nn.Tanh()
        )

        self.layer3 = nn.Sequential(
            nn.Linear(args.layers[1], latent_size, bias=False),
            # nn.Softplus()
            # nn.ReLU()
        )
        self.layer4 = nn.Sequential(
            # nn.Linear(args.layers[1], latent_size, bias=False),
            # nn.Softplus()
            nn.ReLU()
        )


    def forward(self, x):
        x = self.layer1(x)
        x = self.layer2(x)
        x = self.layer3(x)
        x = self.layer4(x)+0.005
        return x


class Decoder(nn.Module):
    def __init__(self, input_size):
        super(Decoder, self).__init__()
        self.layer = nn.Sequential(
            nn.Linear(latent_size, input_size, bias=False)
            # nn.Tanh()
        )

    def forward(self, x):
        output = self.layer(x)
        return output


class VAE(nn.Module):
    def __init__(self, encoder, decoder, lateral):
        super(VAE, self).__init__()
        self.encoder = encoder
        self.decoder = decoder
        self.lateral = torch.from_numpy(lateral).type(torch.FloatTensor) # not positive definite

    def forward(self, inputs):
        rates = self.encoder(inputs)

        if args.sampling is 'bernoulli':
            self.posterior = torch.distributions.Bernoulli(probs=rates)
            samples = self.posterior.sample([args.n_samples])
            samples = torch.transpose(samples, 0, 1)
            return torch.mean(self.decoder(samples), 1)

        if args.sampling is 'poisson':
            self.posterior = torch.distributions.Poisson(rates*args.n_samples)
            samples = self.posterior.sample()
            samples.clamp(max=args.n_samples)
            return self.decoder(samples/args.n_samples)

        if args.sampling is 'none':
            self.posterior = rates
            return self.decoder(rates)


    def kl_divergence(self):
        if args.sampling is 'bernoulli':
            prior = torch.distributions.Bernoulli(probs = torch.ones_like(self.posterior.probs)*args.default_rate)
            kl = torch.distributions.kl_divergence(self.posterior, prior)
            return torch.mean(kl)

        if args.sampling is 'poisson':
            prior = torch.distributions.Poisson(torch.ones_like(self.posterior.mean)*args.default_rate * args.n_samples)
            kl = torch.distributions.kl_divergence(self.posterior, prior)
            return torch.mean(kl)

        if args.sampling is 'none':
            return 0.0

    def lateral_loss(self):
        if args.sampling is 'bernoulli':
            rates = torch.squeeze(self.posterior.probs)
        if args.sampling is 'poisson':
            rates = torch.squeeze(self.posterior.mean)
        if args.sampling is 'none':
            rates = torch.squeeze(self.posterior)

        n = rates.norm(2, 1).view(-1, 1).repeat(1, latent_size)
        rates = rates/n
        A = rates.mm(self.lateral).mm(rates.t())/latent_size # self.lateral is a lower triangular matrix
        loss = torch.diag(A)
        return -torch.mean(loss)

    def normalise_weight(self):
        weight = self.decoder.layer[0].weight.data
        tmp = torch.norm(weight, dim=0)
        self.decoder.layer[0].weight.data = weight/tmp.repeat([input_size, 1])

    def save(self):
        torch.save(self.state_dict(), args.save_path)






my_data = np.genfromtxt('/home/yw2613/homedir/Analysis/Topological/train.csv', delimiter=',')
my_data = data_reorg(my_data)
dataloader = DataLoader(torch.from_numpy(my_data[0:-1:2]).type(torch.FloatTensor), batch_size=args.batch_size,
                                              shuffle=True)

test_data = torch.from_numpy(my_data[:1000]).type(torch.FloatTensor)
# test_data = np.genfromtxt('/home/yw2613/homedir/Analysis/Topological/test.csv', delimiter=',')/40.0
# test_data = torch.from_numpy(test_data).type(torch.FloatTensor)


input_size = len(my_data[0])
encoder = Encoder(input_size=input_size)
decoder = Decoder(input_size=input_size)
lateral = lateral_effect()
vae = VAE(encoder, decoder, lateral)

summary(vae, input_size=(1,9))

if args.cuda:
    vae.cuda()

if train:
    criterion = nn.MSELoss()
    l1_criterion = nn.L1Loss()
    optimizer = optim.Adam(vae.parameters(), lr=args.eta)

    for epoch in range(args.n_epochs):
        print(epoch)
        for i_batch, inputs in enumerate(dataloader):
            if args.cuda:
                inputs.cuda()
            optimizer.zero_grad()

            xhat = vae(inputs)
            recon_error = criterion(xhat, inputs)

            kl = vae.kl_divergence()
            lateral_loss = vae.lateral_loss()

            #weight_loss = torch.mean(vae.decoder.layer[0].weight*vae.decoder.layer[0].weight)
            weight_norm = torch.norm(vae.decoder.layer[0].weight, dim=0)-1.0
            # print(weight_norm.shape)
            weight_loss = torch.mean(weight_norm*weight_norm)
            loss = 10.0*recon_error + kl*0.005 + args.lambda_l*lateral_loss + 0.1*weight_loss

            loss.backward()
            optimizer.step()
            # vae.normalise_weight()

        weight = vae.decoder.layer[0].weight.data
        w = weight.reshape([-1, 1, args.latent_shape, args.latent_shape])
        imgs = vutils.make_grid(w, normalize=True, scale_each=False)
        writer.add_image('Model/Weight', imgs, epoch)

        writer.add_scalar('loss/total_loss', loss, epoch)
        writer.add_scalar('loss/kl', kl, epoch)
        writer.add_scalar('loss/lateral', lateral_loss, epoch)
        writer.add_scalar('loss/recon', recon_error, epoch)

        if epoch % 2 == 0:
            test_result = vae(test_data)
            # s = torch.norm(test_data, dim=1).view([-1, 1]).repeat([1, 9])
            # test_data_tanh = test_data/s*torch.tanh(s)

            fig, ax = plt.subplots(9,1)
            for i in range(9):
                ax[i].plot(test_data.numpy()[:,i])
                ax[i].plot(test_result.detach().numpy()[:,i])

            if args.sampling is 'bernoulli':
                rates = torch.squeeze(vae.posterior.probs)
            if args.sampling is 'poisson':
                rates = torch.squeeze(vae.posterior.mean)
            if args.sampling is 'none':
                rates = torch.squeeze(vae.posterior)
            rates = rates.reshape([-1, 1, args.latent_shape, args.latent_shape])
            response = vutils.make_grid(rates[0:-1:100], normalize=True, scale_each=False)
            writer.add_image('Model/Response', response, epoch)
            writer.add_figure('Model/test', fig, epoch)

    torch.save(vae.state_dict(), args.save_path+'model_sigma3_40_40')
else:
    vae.load_state_dict(torch.load(args.save_path+'model_sigma3_40_40'))
    vae.eval()

if test:
    test_data = np.genfromtxt('/home/yw2613/homedir/Analysis/Topological/test_sub.csv', delimiter=',')*0.8
    test_data = data_reorg(test_data)
    test_data = torch.from_numpy(test_data).type(torch.FloatTensor)

    test_result = vae(test_data)
    if args.sampling is 'bernoulli':
        rates = torch.squeeze(vae.posterior.probs)
    if args.sampling is 'poisson':
        rates = torch.squeeze(vae.posterior.mean)
    if args.sampling is 'none':
        rates = torch.squeeze(vae.posterior)

    rates = rates.detach().numpy()
    print(rates.shape)
    np.savetxt(args.save_path+'rates_sigma3_40_40.csv',rates , delimiter=',')

    # test_data = np.genfromtxt('/home/yw2613/homedir/Analysis/Topological/test.csv', delimiter=',')
    # test_data = data_reorg(test_data)
    # test_data = torch.from_numpy(test_data).type(torch.FloatTensor)
    #
    # test_result = vae(test_data)
    # if args.sampling is 'bernoulli':
    #     rates = torch.squeeze(vae.posterior.probs)
    # if args.sampling is 'poisson':
    #     rates = torch.squeeze(vae.posterior.mean)
    # if args.sampling is 'none':
    #     rates = torch.squeeze(vae.posterior)
    #
    # rates = rates.detach().numpy()
    # print(rates.shape)
    # np.savetxt('rates_sigma3_40_40_real.csv',rates , delimiter=',')


writer.export_scalars_to_json('./all_scalers.json')
writer.close()