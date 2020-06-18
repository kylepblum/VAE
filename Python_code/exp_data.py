import numpy as np
import matplotlib.pyplot as plt


X = np.genfromtxt('Han20160325PDdata.csv', delimiter=',')
electrode = X[:,0]
pd = X[:, 2]*180/np.pi

elec = np.abs(electrode[:,np.newaxis] - electrode[np.newaxis,:])
difference = pd[:,np.newaxis] - pd[np.newaxis,:]
difference[np.where(difference>180)] -=360
difference[np.where(difference<-180)] +=360
difference = np.abs(difference)

tmp = elec+np.eye(len(elec))
same_mask = np.where( tmp == 0)
dif_mask = np.where(elec > 0)

same = difference[same_mask]
diff = difference[dif_mask]


hs, x = np.histogram(same, bins=np.arange(19)*10)
hs = hs/len(same)
plt.plot(x[:-1],hs)
hd, x = np.histogram(diff, bins=np.arange(19)*10)
hd = hd/len(diff)
plt.plot(x[:-1],hd)
ha, x = np.histogram(difference, bins=np.arange(19)*10)
ha = ha/len(difference)

np.savetxt('PD_diff.csv', np.vstack((hs,hd,ha)), delimiter=',')

plt.show()



