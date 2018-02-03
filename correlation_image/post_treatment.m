close all
clear all

scrsz = get(0,'ScreenSize');

wf=9/10;
hf=4/5;
figsize=[scrsz(3)*(1-wf)/2 scrsz(4)*(1-hf)/2  wf*scrsz(3) hf*scrsz(4)];

load('finaldat');
% Udat(117:119,:)=[Udat(116,:);Udat(116,:);Udat(116,:)];
% for k=1:10
% Udat(k,:)=Udat(165,:);
% end
eps=Udat(:,5);
Ux=Udat(:,1);
Uy=Udat(:,2);

% images=81:90;
% prefixe='essai3-';
% decx=0;
% decy=0;
% wroi=floor(1200-decy-(max(Uy)-min(Uy)))-10;
% hroi=floor(1600-decx-(max(Ux)-min(Ux)))-10;
% for k=1:length(images)
%     roi=round([decx-Ux(k),decx+hroi-Ux(k),decy-Uy(k),decy+wroi-Uy(k)]);
%    A=imread(sprintf('..\\images\\%s_%d.bmp',prefixe,images(k)));
%    A=A(roi(1):roi(2),roi(3):roi(4));
%    imwrite(A,sprintf('..\\images2\\%s_%d.bmp',prefixe,images(k)));
% end
% 
% k=1;
%     roi=round([decx,decx+hroi,decy,decy+wroi]);
%    A=imread(sprintf('..\\images\\%s_%d.bmp',prefixe,0));
%    A=A(roi(1):roi(2),roi(3):roi(4));
%    imwrite(A,sprintf('..\\images2\\%s_%d.bmp',prefixe,0));
% 


