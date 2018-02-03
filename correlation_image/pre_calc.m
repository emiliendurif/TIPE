function [filref,pathref,vypo]=pre_calc(pathdat)

Klim=15;
Frate=1.333;
jumplim=0.3;
alim=8;


nlvl=40;
% load('fatigue20dat');
ref=0;
prefixe='2016-02-23-Alu2-';
pathref='2016-02-23-Alu2';
filref='2016-02-23-Alu2-1.jpg';
reverse=0;
ndiv=40;


param.reference_image=sprintf('%s/%s',pathref,filref);

im00=double(imread(param.reference_image));
%keyboard
im00=mean(im00,3);
if reverse==1
im00=rot90(im00,-1);
end

    %% define roi
roi=zeros(1,4);

imagesc(im00);colormap(gray);
title('Define Region of Interest');
axis image;
%
sizim=size(im00);
[y,x] = ginput(2);x=sort(round(x));y=sort(round(y));
roi(1:2) = max(min(x,sizim(1)),1);
roi(3:4) = max(min(y,sizim(2)),1);


%-----------------------------
%load('roi','roi');
save('roi','roi');
%----------------------------------


      rect1=rectangle;
      set(rect1,'position',[roi(3),roi(1),roi(4)-roi(3),roi(2)-roi(1)],...
         'EdgeColor','yellow',...
         'LineStyle','--',...
         'LineWidth',2)
                    
% %%define width
%                     title('Select two point defining thewidth of the sample');
%                     [ypco xpco]=ginput(2);
% 
%                     lpx=8/abs(ypco(2)-ypco(1));
                    lpx=0.0108;
                    
                    
                    
                    %----------------------
                    %Pour le calcul rapide
                    %----------------------

                            x_f=(roi(1):roi(2))-roi(1)+1;
                            y_f=(roi(3):roi(4))-roi(3)+1;
                            [Y_f,X_f]=meshgrid(y_f,x_f);




            
            
            [Y,X]=meshgrid(1:size(im00,2),1:size(im00,1));
            

            %save('fissure00','front','crack');



pix2m=lpx/1000;%taille du pixel



param.roi=roi;
param.analysis='correlation';
param.restart_image=1;%restart reference image loading
param.restart_gradient=1;%restart gradient computation
param.restart_basis=1;%restart functional basis computation
param.restart_geometry=1;%restart functional basis computation

param.opti_grad=1;%finite difference gradient
%param.opti_grad=2;%bi-spline gradient

%param.opti_dec=1;%linear interpolation
param.opti_dec=3;%bi-spline 

param.pixel_size=pix2m;
param.iter_max=20;
param.convergance_limit=1.e-6;
param.solver='lu';% lu chol or default or ''
param.nscale=1;



save(sprintf('%s/TMP/param',pathdat),'param');
im0=im00;
sizeim=size(im0);
save(sprintf('%s/TMP/sample0',pathdat),'im0','sizeim','roi');
im0=(im00(roi(1):roi(2),roi(3):roi(4)));
sizeim=size(im0);
save(sprintf('%s/TMP/sample0_0',pathdat),'im0','sizeim','roi');
% %%

%%
iscale=1;





                %------------------------
                %Generation des bases de fonctions pour le calcul simplifié
                %------------------------
                

                mean0=mean(im0(:));
                std0=std(im0(:));
                sizeim=size(im0);
inside=Y_f(:)<=roi(4);

                        
                        phi0x=zeros(numel(im0),3);
                        phi0y=zeros(numel(im0),3);
                        phi0x(:,1)=inside;
                        phi0y(:,2)=inside;
                        phi0x(:,3)=-Y_f(:).*inside/max(X_f(:));
                        phi0y(:,3)=X_f(:).*inside/max(X_f(:));
                phi0x=sparse(phi0x);
                phi0y=sparse(phi0y);
%                 xx=sparse((X_f)/max(X_f(:)));
                xx=sparse((X_f));
                yy=sparse((Y_f));


                

                phix=[phi0x,xx(:),sparse(prod(sizeim),1)];
                phiy=[phi0y,sparse(prod(sizeim),1),yy(:)];

                [gy,gx]=gradient(im0);
                gx=diag(sparse(gx(:)));
                gy=diag(sparse(gy(:)));
                phidf=gx*phix+gy*phiy;
                M=phidf'*phidf;

                
                                
                          

param.reverse=reverse;                                
param.lpx=lpx;
param.roi=roi;
param.X_f=X_f;
param.Y_f=Y_f;
param.Y=Y;
param.M=M;
param.phidf=phidf;
param.im0=im0;
param.std0=std0;
param.mean0=mean0;
param.phix=phix;
param.phiy=phiy;
param.reverse=reverse;
% param.E=E;
% param.nu=nu;
param.Frate=Frate; 
param.analysis='correlation';
param.restart_image=1;%restart reference image loading
param.restart_gradient=1;%restart gradient computation
param.restart_basis=1;%restart functional basis computation
param.restart_geometry=1;%restart functional basis computation
param.opti_grad=1;%finite difference gradient
param.pix2m=pix2m;
param.iter_max=20;
param.convergance_limit=1.e-6;
param.solver='lu';% lu chol or default or ''
param.opti_dec=3;%bi-spline  
%keyboard
save(sprintf('%s/TMP/param',pathdat),'param');
                 

%----------------------------------------
%Fin de pre_calc.m
%----------------------------------------

%                 if ~exist(sprintf('%s\\TMP',pathdat))
%                 mkdir(sprintf('%s\\TMP',pathdat));
%                 end
%save(sprintf('%s\\tmp\\pre_calc.mat',pathdat),'param');
                                
end



