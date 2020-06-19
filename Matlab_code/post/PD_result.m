function [Result] = PD_result()
epoch=140;
sigma = {'1_4','1_6','1_8','2'};

for s = 1:4
    for seed = 1:10
folder = ['/home/ning/Sama/New_Topological/model_sigma',sigma{s},'_shape80_seed',int2str(seed),'00/'];
file = ['PD',int2str(epoch),'.csv'];


argmax = csvread([folder, file]);
Result(s,seed).PD = argmax;
n = length(argmax);
size = sqrt(n);


argmax =reshape(argmax,[size,size]);
argmax = argmax(11:size-10, 11:size-10);
argmax = reshape(argmax, [1,(size-20)^2]);
size = size-20;
[locx,locy] = meshgrid(1:size,1:size);
loc(:,1) = reshape(locx,[],1);
loc(:,2) = reshape(locy,[],1);
D = pdist(loc);
D = squareform(D);
D = reshape(D,[],1);
EDGES = [0:10:170,179];
dif = repmat(argmax,[size^2,1]) - repmat(argmax', [1,size^2]); 
dif = reshape(dif, [],1);
dif(find(dif>=180)) = dif(find(dif>=180))-360;
dif(find(dif<-180)) = dif(find(dif<-180))+360;
dif = abs(dif);

near = find(D<=1 & D>0);
[Nnear,EDGES] = histcounts(dif(near),EDGES);

far = find(D>8);
[Nfar,EDGES] = histcounts(dif(far),EDGES);

all = find(D>0);
[Nall,EDGES] = histcounts(dif(all),EDGES);
barp = [Nnear/length(near); Nfar/length(far); Nall/length(all)];

x = [10:10:180]';
y = Nnear/length(near);
[f, gof] = fit(x,y','exp1');
Result(s,seed).fitcoef = coeffvalues(f);
Result(s,seed).PDdiff = barp;
Result(s,seed).R2 = gof.rsquare;
    end
end
save('PDResult.mat','Result');

end

