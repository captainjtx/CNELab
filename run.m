function run()
%RUN Summary of this function goes here
%   Detailed explanation goes here

%neuro task file loading+++++++++++++++++++++++++++++++++++++++++++++++++++
[FileName,FilePath]=uigetfile('*.mat','select the neuro task file',[pwd '/db/demo/neuro.mat']);

task=load(fullfile(FilePath,FileName));

TaskFiles{1}=fullfile(FilePath,FileName);

for i=1:30
    datamat(i,:)=task.data.dataMat{i};
end

sampleRate=task.data.info{1}.sampleRate;

startTime=task.data.info{1}.stamp(1);


neuroSynchName='Sound'; %synch channel name in task file


for i=1:length(task.data.info)
    if strcmpi(task.data.info{i}.name,neuroSynchName)
        synch=task.data.dataMat{i};
        stamp=task.data.info{i}.stamp;
    end
end

datamat=cat(1,datamat,synch');

%behvaior task file loading++++++++++++++++++++++++++++++++++++++++++++++++
[FileName,FilePath]=uigetfile('*.mat','select the behv task file',[pwd '/db/demo/behv.mat']);

task=load(fullfile(FilePath,FileName));

TaskFiles{2}=fullfile(FilePath,FileName);

maskChannels={'Acceleration X','Acceleration Y', 'Acceleration Z','Roll','Pitch'};
count=0;
for i=1:length(task.data.dataMat)
    if ~ismember(task.data.info{i}.name,maskChannels)
        count=count+1;
        behvMat(count,:)=task.data.dataMat{i};
    end
end

behvMat(1,:)=behvMat(1,:)*1000;

%Annotation file loading+++++++++++++++++++++++++++++++++++++++++++++++++++
[FileName,FilePath]=uigetfile('*.mat','select the annotations file',[pwd '/db/demo/anno.mat']);
annotations=load(fullfile(FilePath,FileName));

for i=1:length(annotations.text)
    events{i,1}=annotations.stamp(i)-startTime;
    events{i,2}=annotations.text{i};
end

BioSigPlot({datamat behvMat},'srate',sampleRate,'Evts',events,'StartTime',startTime,'TaskFiles',TaskFiles);

% assignin('base','bsp',bsp);
% assignin('base','startTime',startTime);
% bsp.Evts=events;
end

