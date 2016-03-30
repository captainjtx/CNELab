clear
clc
fDir='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/fdata_3-200_500.mat';
badchannels=37;
fs=500;

obj=load(fDir,'-mat');
data=obj.data1;
data=data(:,1:120);
data(:,badchannels)=[];

data=data';

[icasig, A, W] = fastica(data,'verbose', 'off', 'displayMode', 'off','lastEig', 119, 'numOfIC', 119);
% 
% bsp=BioSigPlot({data',icasig'},'SRate',fs,...
%                                    'DispChans',30,...
%                                    'DataView','Vertical');
% bsp.Time=360;



%==========================================================================
%Apply on the whole data
noise_comp=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 18 22];

originalDir='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/data.mat';

obj=load(originalDir,'-mat');
data=obj.data1;
data=data(:,1:120);
data(:,badchannels)=[];

icaData=W*data';

SelectedICA=icaData;
SelectedICA(noise_comp,:)=0;

reconData=A*SelectedICA;

bsp=BioSigPlot({data,icaData',reconData'},'SRate',fs,...
                                   'DispChans',20,...
                                   'DataView','Vertical');