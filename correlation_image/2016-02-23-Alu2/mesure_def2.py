import numpy as np
import matplotlib.pyplot as plt

data=np.transpose(np.load("data.npy"))

nim=np.size(data,1)
npix=np.size(data,0)

Lmoy=[]
L=[]
for k in range(nim):
    moy=np.mean(data[1000:1500,k])
    Lmoy.append(moy)
    S=0
    for n in range(npix):
        S+=int(abs(data[n,k]-moy)<10)
    L.append(S)


end=30
W=np.array(Lmoy[0:end])
L=np.array(L[0:end])
epsxx=(W-W[0])/W[0]
epsyy=(L-L[0])/L[0]
plt.figure(1)
plt.plot(epsxx,'r*-')
plt.xlabel("n° de l'image")
plt.ylabel('Déformation transverse')

plt.figure(2)
plt.plot(epsyy,'b*-')
plt.xlabel("n° de l'image")
plt.ylabel('Déformation axiale')

plt.figure(3)
plt.plot(epsyy,epsxx,'b*-')
plt.xlabel("Déformation axiale")
plt.ylabel('Déformation transverse')
plt.show()
