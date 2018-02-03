function calc(iim,pathdat,images)
filname='bla';
num=1;

% images=50:500;

prefixe='2016-02-23-Alu2-';
pathref='2016-02-23-Alu2';

reverse=0;

%-----------------------------------------------
%Debut calc.vi
%-----------------------------------------------

 %-----------------------------------------------
    %calcul sur les images déjà prises
    %-----------------------------------------------
%    sample='joaquim1';
%    load(sprintf('D:\\these\\expe\\fatigue\\%s',sample));
%     
%     %-----------------------------------------
%     %calcul sur un certain nombre d'images
%     %-----------------------------------------

% 
%     %------------------------------------------
% 
%      %pathdef=pathref;   
   fildef=sprintf('%s/%s%d.JPG',pathref,prefixe,images(iim));

    %-----------------------------------------------
    %calcul sur les images d'acquisition (uniquement dans labview)
    %-----------------------------------------------
     %fildef=sprintf('%s\\%s_%d.bmp',pathdef,filname,num);


    %-------------------

im1=double(imread(fildef)); 
im1=mean(im1,3);
if reverse==1
im1=rot90(im1,-1);
end

if iim>1
   load('finaldat','Udat'); 
end


        load(sprintf('%s/TMP/param',pathdat),'param');
        lpx=param.lpx;
        roi=param.roi;
        X=param.X_f;
        Y=param.Y_f;
        M=param.M;
        phidf=param.phidf;
        im0=param.im0;
        std0=param.std0;
        mean0=param.mean0;
        phix=param.phix;
        phiy=param.phiy;
%         E=param.E;
%         nu=param.nu;
        convmax=param.convergance_limit;
        maxiter=param.iter_max;

        sizeim=size(im0);      

% 
%         mu=0.5*E/(1+nu);
%         kappa=(3-nu)/(1+nu);
        
        %if iim==1
    imdef=im1(roi(1):roi(2),roi(3):roi(4));
    
    %------------------------------------
    %[Uo,Vo]=rbt2bis(im0,imdef);
    
    niveau_affichage_init = 4;

siz = size(im0);

%jmref=co_contract2(im0,siz);
%jmdef=co_contract2(imdef,siz);

newsiz=2.^floor(log2(siz+.5));
dec=floor((siz-newsiz)*.5);
jmref=im0(dec(1)+1:dec(1)+newsiz(1),dec(2)+1:dec(2)+newsiz(2));
jmdef=imdef(dec(1)+1:dec(1)+newsiz(1),dec(2)+1:dec(2)+newsiz(2));


%jmref = edge_blur(jmref);
%jmdef = edge_blur(jmdef);
%---------------------------------------------
isizex = size(jmref,1);
isizey = size(jmref,2);

vec1         = (jmref(1,:,:)+jmref(isizex,:,:))*.5;
jmref(1,:,:)      = vec1;
jmref(isizex,:,:) = vec1;
clear vec1
vec1         = (jmref(:,1,:)+jmref(:,isizey,:))*.5;

jmref(:,1,:)      = vec1;
jmref(:,isizey,:) = vec1;

%--------------------------------------------
isizex = size(jmdef,1);
isizey = size(jmdef,2);

vec1         = (jmdef(1,:,:)+jmdef(isizex,:,:))*.5;
jmdef(1,:,:)      = vec1;
jmdef(isizex,:,:) = vec1;
clear vec1
vec1         = (jmdef(:,1,:)+jmdef(:,isizey,:))*.5;
jmdef(:,1,:)      = vec1;
jmdef(:,isizey,:) = vec1;
%-----------------------------------------------


siz2=size(jmdef);
%
% Intercorrelation procedure
%
intcor = real(ifft2(conj(fft2(double(jmref))).*fft2(double(jmdef))));
mmax = max(intcor(:));
[imax,jmax] = find(intcor == mmax);
%
if (max(size(imax))>1)
   disp('numerous maxima...');
   
   Uo=0;%imax(1,1);
   Vo=0; %jmax(1,1);
else
   cx1 = mod(imax-2,siz2(1))+1;
   cy1 = mod(jmax-2,siz2(2))+1;
   cx3 = mod(imax,siz2(1))+1;
   cy3 = mod(jmax,siz2(2))+1;
   
   intercorred(1,1) = intcor(cx1,cy1);
   intercorred(1,2) = intcor(cx1,jmax);
   intercorred(1,3) = intcor(cx1,cy3);
   intercorred(2,1) = intcor(imax,cy1);
   intercorred(2,2) = intcor(imax,jmax);
   intercorred(2,3) = intcor(imax,cy3);
   intercorred(3,1) = intcor(cx3,cy1);
   intercorred(3,2) = intcor(cx3,jmax);
   intercorred(3,3) = intcor(cx3,cy3);
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %	INTERPOLATION
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   inter = intercorred/intercorred(2,2);          
   Cx = (-1:1)'*ones(1,3);Cy = ones(3,1)*(-1:1);
   coef = [ones(9,1) Cx(:) Cy(:) Cx(:).*Cy(:) Cx(:).*Cx(:) Cy(:).*Cy(:)]\inter(:);
   denom = coef(4)^2-4*coef(6)*coef(5);
   
   Uo = (2*coef(6)*coef(2)-coef(3)*coef(4))/denom ;
   Vo = (2*coef(5)*coef(3)-coef(2)*coef(4))/denom ;                         
   
   if (abs(Uo)>1)||(abs(Vo)>1)
      Uo = 0;
      Vo = 0;
      disp('sub pixel interpolation failed: I took the best pixel evaluation')
   end

end
Uo=Uo+imax(1)-1;
Vo=Vo+jmax(1)-1;
%
Uo=mod(Uo+siz2(1)/2,siz2(1))-siz2(1)/2;
Vo=mod(Vo+siz2(2)/2,siz2(2))-siz2(2)/2;

if (abs(Uo) > siz2(1)/2)||(abs(Vo)>siz2(2)/2)
   disp('Rigid body motion very large')
end

clear niveau_affichage_init;
    
    %--------------------------------------
U=zeros(size(phix,2),1);
U(1)=-Uo;
U(2)=-Vo;
%end%if iim=1
   res=1;
ii=1;
 while ( res>convmax && ii< 5)
   
    Xi=X+roi(1)-reshape(phix*U,sizeim);
    Yi=Y+roi(3)-reshape(phiy*U,sizeim);
    disc=interp2(im1,Yi,Xi,'*linear');
        
        mean1=mean(disc(:));
        std1=std(disc(:));
        disc=disc-mean1;
        st=std0/std1;
        disc=(im0-mean0-st*disc);
    F=phidf'*disc(:);
dU=-M\F;
    disp(sprintf('At iteration # %d',ii));
    if ii==1
        nU0=norm(U+dU);
    else
        res=norm(dU)/nU0;
        disp(sprintf('|dU|=%f',res));

    end
        U=U+dU;
    ii=ii+1;
    
 end


Uy=-((U(4)+U(2)));
Ux=-((U(1)+U(3)));
umap=reshape(phix*U,sizeim);


Udat(iim,:)=U;
save('finaldat','Udat')

            
            





end


