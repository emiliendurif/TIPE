close all
clear all

scrsz = get(0,'ScreenSize');

wf=9/10;
hf=4/5;
figsize=[scrsz(3)*(1-wf)/2 scrsz(4)*(1-hf)/2  wf*scrsz(3) hf*scrsz(4)];
t=cputime;
%images=fliplr(images);

%load('fatigue20dat');
pathdat='DATA';
images=2:32;
if ~exist(sprintf('%s/TMP',pathdat))
    mkdir(sprintf('%s/TMP',pathdat));
end


[filref,pathref]=pre_calc(pathdat);




for iim=1:length(images)     
    tic

            calc(iim,pathdat,images);
            disp(sprintf('image %d',iim))
            toc          

end
 disp(sprintf('Total computational time %6.2f...',cputime-t));
%%


