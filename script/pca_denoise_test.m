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

noise_comp=[1 2];

aveVar=0;

for i=1:length(sample_artifact_pos)
    pos=sample_artifact_pos(i);
    dataseg=data(pos-sample_before:pos+sample_after,:);
    
    evts{i,1}=(i-1)*(sample_before+sample_after+1)/fs;
    evts{i,2}=num2str(i);

    rawdata{i}=dataseg;
    
    aveVar=aveVar+dataseg'*dataseg;
end

%=======================================================================PCA
%**************************************************************************
aveVar=aveVar/length(sample_artifact_pos);

[V,D]=eig(aveVar);

[e,ID]=sort(diag(D),'descend');

SV=V(:,ID);

%==========================================================================
%**************************************************************************
% for i=1:length(sample_artifact_pos)
%     pcadata{i}=rawdata{i}*SV;
%     
%     selectedPCA=pcadata{i};
%     selectedPCA(:,noise_comp)=0;
%     
%     recondata{i}=selectedPCA*SV';
% end
% 
% % Visualize the segments
% % concatenate the segments
% pdata=[];
% rdata=[];
% cdata=[];
% 
% for i=1:length(pcadata)
%     rdata=cat(1,rdata,rawdata{i});
%     pdata=cat(1,pdata,pcadata{i});
%     cdata=cat(1,cdata,recondata{i});
% end
% 
% bsp=BioSigPlot({rdata,pdata,cdata},'SRate',fs,...
%                                    'Winlength',(sample_before+sample_after+1)/fs*10,...
%                                    'Evts',evts,...
%                                    'DispChans',30,...
%                                    'Gain',2.5,...
%                                    'DataView','Horizontal');
%                                
% figure
% 
% plot(e(1:20),'--rs','LineWidth',2,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','g',...
%                 'MarkerSize',10)
%==========================================================================
%Apply on the whole data
originalDir='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/data.mat';

obj=load(originalDir,'-mat');
data=obj.data1;
data=data(:,1:120);
data(:,badchannels)=[];

pcaData=data*SV;
US=pcaData;
US(:,noise_comp)=0;
reconData=US*SV';

bsp=BioSigPlot({data,pcaData,reconData},'SRate',fs,...
                                   'DispChans',20,...
                                   'Gain',1.8,...
                                   'DataView','Vertical');