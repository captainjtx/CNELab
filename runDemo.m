function runDemo()
%RUN Summary of this function goes here
%   Detailed explanation goes here

%neuro task file loading+++++++++++++++++++++++++++++++++++++++++++++++++++
[FileName,FilePath]=uigetfile('*.mat','select the neuro task file',[pwd '/db/demo/neuro.mat']);
if ~FileName
    exit
end
neuroTask=load(fullfile(FilePath,FileName));

TaskFiles{1}=fullfile(FilePath,FileName);

for i=1:60
    datamat(i,:)=neuroTask.data.dataMat{i};
end

sampleRate=neuroTask.data.info{1}.sampleRate;

startTime=neuroTask.data.info{1}.stamp(1);


neuroSynchName='Sound'; %synch channel name in task file


for i=1:length(neuroTask.data.info)
    if strcmpi(neuroTask.data.info{i}.name,neuroSynchName)
        synch=neuroTask.data.dataMat{i};
    end
end

% datamat=cat(1,datamat,synch');

%behvaior task file loading++++++++++++++++++++++++++++++++++++++++++++++++
[FileName,FilePath]=uigetfile('*.mat','select the behv task file',[pwd '/db/demo/behv.mat']);

if ~FileName
    exit
end

behvTask=load(fullfile(FilePath,FileName));

TaskFiles{2}=fullfile(FilePath,FileName);

maskChannels={'Acceleration X','Acceleration Y', 'Acceleration Z','Roll','Pitch'};
count=0;
for i=1:length(behvTask.data.dataMat)
    if ~ismember(behvTask.data.info{i}.name,maskChannels)
        count=count+1;
        behvMat(count,:)=behvTask.data.dataMat{i};
    end
end

behvMat(1,:)=behvMat(1,:)*1000;

%Annotation file loading+++++++++++++++++++++++++++++++++++++++++++++++++++
[FileName,FilePath]=uigetfile('*.mat','select the annotations file',[pwd '/db/demo/anno.mat']);
if ~FileName
    exit
end

annotations=load(fullfile(FilePath,FileName));

for i=1:length(annotations.text)
    events{i,1}=annotations.stamp(i)-startTime;
    events{i,2}=annotations.text{i};
end

bsp=BioSigPlot({datamat behvMat},'srate',sampleRate,'Evts',events,'TaskFiles',TaskFiles,...
    'VideoStartTime',behvTask.info.video.startTime);

assignin('base','bsp',bsp);
% assignin('base','startTime',startTime);
% bsp.Evts=events;
end

