%PCA projection based on SVD

%Written by Tianxiao Jiang
%tjiang3@uh.edu
clc
clear

fDir='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/fdata_3-200_500.mat';
obj=load(fDir,'-mat');
data=obj.data1;

badchannels=37;
data=data(:,1:120);
data(:,badchannels)=[];

fs=500;


sample_before=20;
sample_after=50;

eventDir='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/anno_artifact.evt';
evts=load(eventDir,'-mat');


sample_artifact_pos=round(evts.stamp(strcmpi(evts.text,'A'))*fs);

pcadata=cell(length(sample_artifact_pos),1);
rawdata=cell(length(sample_artifact_pos),1);
recondata=cell(length(sample_artifact_pos),1);
scalpdata=cell(length(sample_artifact_pos),1);

evts=cell(length(sample_artifact_pos),2);

noise_comp=[1 2 3 5 6];
ave_rawdata=0;
for i=1:length(sample_artifact_pos)
    pos=sample_artifact_pos(i);
    dataseg=data(pos-sample_before:pos+sample_after,:);
    
    evts{i,1}=(i-1)*(sample_before+sample_after+1)/fs;
    evts{i,2}=num2str(i);
    ave_rawdata=ave_rawdata+dataseg;
    rawdata{i}=dataseg;
    
    %     [U,S,V]=svd(dataseg);
    %     pcadata{i}=dataseg*V;
    %     rawdata{i}=dataseg;
    %     for j=1:length(noise_comp)
    %         S(noise_comp(j),noise_comp(j))=0;
    %     end
    %     recondata{i}=U*S*V';
    %
    %
    %     SS=zeros(size(S));
    %     SS(noise_comp(1),noise_comp(1))=1;
    %     scalpdata{i}=U*SS*V';
end

ave_rawdata=ave_rawdata/length(sample_artifact_pos);
[U,S,V]=svd(ave_rawdata);
%==========================================================================
%**************************************************************************
% for i=1:length(sample_artifact_pos)
%     pcadata{i}=rawdata{i}*V;
%     us=pcadata{i};
%     us(:,noise_comp)=zeros(size(us,1),length(noise_comp));
%     recondata{i}=us*V';
%     
%     uss=zeros(size(pcadata{i}));
%     uss(:,noise_comp(1))=pcadata{i}(:,noise_comp(1));
%     scalpdata{i}=uss*V';
% end

% Visualize the segments

%concatenate the segments
% pdata=[];
% rdata=[];
% cdata=[];
% sdata=[];
% for i=1:length(pcadata)
%     rdata=cat(1,rdata,rawdata{i});
%     pdata=cat(1,pdata,pcadata{i});
%     cdata=cat(1,cdata,recondata{i});
%     sdata=cat(1,sdata,scalpdata{i});
% end

% bsp=BioSigPlot({rdata,pdata,cdata},'SRate',fs,...
%                                    'Winlength',(sample_before+sample_after+1)/fs*10,...
%                                    'Evts',evts,...
%                                    'DispChans',30,...
%                                    'Gain',2.5,...
%                                    'DataView','Horizontal');
%==========================================================================

%Apply on the whole data
originalDir='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/data.mat';

obj=load(originalDir,'-mat');
data=obj.data1;
data=data(:,1:120);
data(:,badchannels)=[];

pcaData=data*V;
US=pcaData;
US(:,noise_comp)=0;
reconData=US*V';

bsp=BioSigPlot({data,reconData},'SRate',fs,...
                                   'DispChans',30,...
                                   'Gain',1.8,...
                                   'DataView','Vertical');