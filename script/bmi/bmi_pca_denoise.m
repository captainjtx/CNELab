clear
clc
%This script will perform pca to denoise the data according to noise
%annoation
fs=500;

fl=180;
% fh=250;

% annofile='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/anno_artifact.evt';
% datafile='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/neuro.cds';
% rawfile='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/neuro.cds';
annofile='/Users/tengi/Desktop/Projects/data/BMI/fingers/Xuyun/anno_Artifact.evt';
datafile='/Users/tengi/Desktop/Projects/data/BMI/fingers/Xuyun/neuro.medf';
rawfile='/Users/tengi/Desktop/Projects/data/BMI/fingers/Xuyun/neuro.medf';

noiseSampleBefore=10;
noiseSampleAfter=50;

noiseComp=[1,2];

%First extract the noise segments
rawcds=CommonDataStructure;
rawcds.import(datafile);
noiseSegs=[];
data=rawcds.Data.Data;
data=data(:,1:120);


data(:,[9,37])=[];

order=2;
[b,a]=butter(order,fl/(fs/2),'high');
ext=2*fs;
phs=0;
ftyp='iir';
data=filter_symmetric(b,a,data,ext,phs,ftyp);

anno=load(annofile,'-mat');

time_total=anno.stamp(strcmp(anno.text,'A'));

var=0;
time=time_total(1:round(length(time_total)/2));
for i=1:length(time)
    smp=round(time(i)*fs);
    tmp=data(smp-noiseSampleBefore:smp+noiseSampleAfter,:);
    noiseSegs(:,:,i)=tmp;
    var=tmp'*tmp+var;
end
var=var/length(time);

[V,D]=eig(var);
[e,ID]=sort(diag(D),'descend');
SV=V(:,ID);

cds=CommonDataStructure;
cds.import(rawfile);
datamat=cds.Data.Data;
datamat=datamat(:,1:120);
datamat(:,[9,37])=[];


subspaceData=datamat*SV;
subspaceData(:,noiseComp)=0;
reconData=subspaceData*SV';
data=reconData;

time=time_total(round(length(time_total)/2):end);
for i=1:length(time)
    smp=round(time(i)*fs);
    tmp=data(smp-noiseSampleBefore:smp+noiseSampleAfter,:);
    noiseSegs(:,:,i)=tmp;
    var=tmp'*tmp+var;
end
var=var/length(time);

[V,D]=eig(var);
[e,ID]=sort(diag(D),'descend');
SV1=V(:,ID);


datamat=data;
subspaceData=datamat*SV1;
subspaceData(:,noiseComp)=0;
reconData=subspaceData*SV1';
noiseSegs_pca=zeros(size(noiseSegs));
noiseSegs_recon=zeros(size(noiseSegs));

for i=1:size(noiseSegs,3)
    d=noiseSegs(:,:,i);
    subdata=d*SV;
    
    noiseSegs_pca(:,:,i)=subdata;
    
    subdata(:,noiseComp)=0;
    
    noiseSegs_recon(:,:,i)=subdata*SV';
end
catNoise=[];
catPCA=[];
catRecon=[];
for i=1:size(noiseSegs,3)
    catNoise=cat(1,catNoise,noiseSegs(:,:,i));
    catPCA=cat(1,catPCA,noiseSegs_pca(:,:,i));
    catRecon=cat(1,catRecon,noiseSegs_recon(:,:,i));
    
end
    


figure
plot(e,'--rs','LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'MarkerSize',10)
xlabel('Subspace Dimension')
ylabel('Subspace Weight')



BioSigPlot({catNoise,catPCA,catRecon},'SRate',fs,'WinLength',1);

%apply it to the whole data


% bsp=BioSigPlot({cds.Data.Data,reconData},'SRate',fs,'Gain',25);


