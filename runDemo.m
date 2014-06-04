function runDemo()
%RUN Summary of this function goes here
%   Detailed explanation goes here

%neuro task file loading+++++++++++++++++++++++++++++++++++++++++++++++++++

[FileName,FilePath]=uigetfile({'*.medf';'*.mat'},'select the neuro task file',[pwd '../data']);
if ~FileName
    return
end
neuroTask=load(fullfile(FilePath,FileName),'-mat');

TaskFiles{1}=fullfile(FilePath,FileName);
chanIndex=1:60;
for i=1:length(chanIndex)
    datamat(chanIndex(i),:)=(neuroTask.data.dataMat{chanIndex(i)})';
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
[FileName,FilePath]=uigetfile({'*.medf';'*.mat'},'select the behv task file',[pwd '../data']);

if ~FileName
    return
end

behvTask=load(fullfile(FilePath,FileName),'-mat');

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
[FileName,FilePath]=uigetfile('*.evt','select the annotations file',[pwd '../data']);
if ~FileName
    return
end

annotations=load(fullfile(FilePath,FileName),'-mat');

if isfield(annotations,'text')&&isfield(annotations,'stamp')
    for i=1:length(annotations.text)
        events{i,1}=annotations.stamp(i)-startTime;
        events{i,2}=annotations.text{i};
    end
else
    events=annotations;
    for i=1:size(events,1)
        events{i,1}=events{i,1}-startTime;
    end
end
%==========================================================================
bsp=BioSigPlot({datamat behvMat},'srate',sampleRate,'Evts',events,'TaskFiles',TaskFiles,...
    'VideoStartTime',behvTask.info.video.startTime);

if isfield(behvTask.info.video,'timeFrame')
    if ~isempty(behvTask.info.video.timeFrame)
        bsp.VideoTimeFrame=behvTask.info.video.timeFrame;
    end
end
assignin('base','bsp',bsp);
% assignin('base','startTime',startTime);
% bsp.Evts=events;
end
