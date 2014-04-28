function run()
%RUN Summary of this function goes here
%   Detailed explanation goes here

[FileName,FilePath]=uigetfile('*.mat','select the task file',[pwd '/db/demo/neuro.mat']);

task=load(fullfile(FilePath,FileName));


for i=1:30
    datamat(i,:)=task.data.dataMat{i};
end

sampleRate=task.data.info{1}.sampleRate;

annotations=task.annotations;

startTime=task.data.info{1}.stamp(1);

for i=1:length(annotations.text)
    events{i,1}=annotations.stamp(i)-startTime;
    events{i,2}=annotations.text{i};
end

neuroSynchName='Sound'; %synch channel name in task file


for i=1:length(task.data.info)
    if strcmpi(task.data.info{i}.name,neuroSynchName)
        synch=task.data.dataMat{i};
        stamp=task.data.info{i}.stamp;
    end
end

datamat=cat(1,datamat,synch');

[behvMat,channelNames]=behvSynch(synch,stamp,sampleRate);

for i=1:size(behvMat,1)
    behvMat(i,:)=behvMat(i,:)/max(behvMat(i,:));
end

behvMat(1,:)=behvMat(1,:)*0.1;

behvMat(2:end,:)=behvMat(2:end,:)*0.25;

bsp=BioSigPlot({datamat behvMat},'srate',sampleRate);
bsp.Evts=events;
end

