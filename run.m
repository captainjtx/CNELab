function run()
%RUN Summary of this function goes here
%   Detailed explanation goes here

[FileName,FilePath]=uigetfile('*.mat','select the neuro task file',[pwd '/db/demo/neuro.mat']);

task=load(fullfile(FilePath,FileName));


for i=1:30
    datamat(i,:)=task.data.dataMat{i};
end

sampleRate=task.data.info{1}.sampleRate;

annotations=task.annotations;


for i=1:length(annotations.text)
    events{i,1}=annotations.stamp(i)-annotations.stamp(1);
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


[FileName,FilePath]=uigetfile('*.mat','select the behv task file',[pwd '/db/demo/behv.mat']);

task=load(fullfile(FilePath,FileName));

maskChannels={'Trigger','Acceleration X','Acceleration Y', 'Acceleration Z','Roll','Pitch'};
count=0;
for i=1:length(task.data.dataMat)
    if ~ismember(task.data.info{i}.name,maskChannels)
        count=count+1;
        behvMat(count,:)=task.data.dataMat{i};
    end
end

bsp=BioSigPlot({datamat behvMat},'srate',sampleRate,'Evts',events);
assignin('base','bsp',bsp);
% bsp.Evts=events;
end

