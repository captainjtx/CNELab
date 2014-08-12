clc
clear

fDir='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/fdata_3-200_500.mat';
obj=load(fDir,'-mat');
data=obj.data1;

fs=500;


sample_before=20;
sample_after=50;

eventDir='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/anno_artifact.evt';
evts=load(eventDir,'-mat');


sample_artifact_pos=round(evts.stamp(strcmpi(evts.text,'A'))*fs);

pcadata=cell(length(sample_artifact_pos),1);
rowdata=cell(length(sample_artifact_pos),1);
evts=cell(length(sample_artifact_pos),2);
for i=1:length(sample_artifact_pos)
    pos=sample_artifact_pos(i);
    dataseg=data(pos-sample_before:pos+sample_after,:);
    [W,e,D]=pcaWeights(dataseg);
    tmp=dataseg*W;
    pcadata{i}=tmp;
    rowdata{i}=dataseg;
    evts{i,1}=(i-1)*(sample_before+sample_after+1)/fs;
    evts{i,2}=['Segment',num2str(i)];
end

%concatenate the segments
pdata=[];
rdata=[];
for i=1:length(pcadata)
    rdata=cat(1,rdata,rowdata{i});
    pdata=cat(1,pdata,pcadata{i});
end

% bsp=BioSigPlot({rdata,pdata});
% bsp.SRate=fs;
% bsp.WinLength=(sample_before+sample_after+1)/fs;
% bsp.Evts=evts;

bsp=BioSigPlot({rdata,pdata},'SRate',fs,'Winlength',(sample_before+sample_after+1)/fs,'Evts',evts);

