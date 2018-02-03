#importation des modules
import matplotlib.pyplot as plt
import numpy as np
from PIL import Image, ImageOps


#Definition des fonctions
def afficher(A):
    plt.xticks([])
    plt.yticks([])
    plt.imshow(A,cmap=plt.cm.gray,vmin=0,vmax=255)
    #plt.imshow(A,cmap=plt.cm.gray,vmin=0.0,vmax=255.0)
    #plt.imshow(A,vmin=0.0,vmax=255.0)
    
def augmenter_contraste(A,k):
    B=A
    for i in range(k):
        B=f(B)
    return B
    
def f(x):
    return (0.5+0.5*np.sin((x/255.0-0.5)*np.pi))*255.0
    
def noir_et_blanc(A):
    (n,p)=A.shape
    B=np.copy(A)
    for i in range(n):
        for j in range(p):
            if B[i,j]<60:
                B[i,j]=0
            else:
                B[i,j]=255
    return B
    
def histogramme(A):
    (n,p)=A.shape # recupere les dimensions de la matrice A
    B=A.reshape((1,n*p))[0] # transforme la matrice A en matrice ligne (1,np)
    L=np.sort(B) # ordonne les elements de L    
    x=[L[0]] # initialisation de la liste x
    y=[1] # initialisation de la liste y
    for i in range(1,len(L)):
        if L[i]>L[i-1] and L[i]<=255:
            x=x+[L[i]]
            y=y+[1]
        elif L[i]>255:
            y[len(y)-1]+=1
        else:
            y[len(y)-1]+=1
    plt.plot(x,y)
    plt.xlabel('Niveau de gris')
    plt.ylabel('Nombre de pixels')

#Programme principal    
prefixe='26-02-23-Alu2_recadre-'
T=[]
for i in range(1,2):
    im0=Image.open(prefixe+str(i)+'.jpg')#ouverture de l'image en couleur '26-02-23-Alu2_recadre-i.jpg'
    im=np.array(Image.open(prefixe+str(i)+'.jpg'))#conversion en matrice
    imbw=np.array(ImageOps.grayscale(im0))#conversion de l'image rgb en niveaux de gris
    
    #imbw2=augmenter_contraste(imbw,4)
    imbw2=noir_et_blanc(imbw)#conversion de l'image en noir et blanc
    
    nligne=np.size(imbw2,0) 
    ncolonne=np.size(imbw2,1)
    y=[]
    for n in range(nligne):
        S=0
        for p in range(ncolonne):
            S+=imbw2[n,p]/255 
        y+=[S]
    print(i)
    T.append(y)
    
T2=np.array(T)
np.save("data2",T2)
    

plt.figure(1)
plt.plot(y)

# Afficher l'image de base et l'image constrastee
plt.figure(2)
plt.subplot(1,2,1)
afficher(imbw)
plt.subplot(1,2,2)
afficher(imbw2)
#plt.savefig('tennis_constrate.png')

# Afficher l'histogramme de base et l'histogramme constrastee
plt.figure(3)
plt.subplot(1,2,1)
histogramme(imbw)
plt.subplot(1,2,2)
histogramme(imbw2)
#plt.savefig('histogrammes_contraste.eps')
plt.show()