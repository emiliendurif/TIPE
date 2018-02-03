clear all
close all

prefixe='2016-02-23-Alu2-';
images=1:32;
vt=[];
for k=images
    data=imfinfo(sprintf('%s%d.jpg',prefixe,k));
    temps=data.FileModDate;
    seconde=str2num(temps(end-1:end));
    minute=str2num(temps(end-4:end-3));
    heure=str2num(temps(end-7:end-6));
    t=heure*3600+minute*60+seconde;
    vt=[vt,t];
end
vt=vt-vt(1);
plot(vt)