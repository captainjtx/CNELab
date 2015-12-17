clc
clear
%This function convert the behv data into standard task file format
%Workflow:
%1................synchronize the behv data with neuro data
%2................extract the task file according to neuro annotations

%user defined region=======================================================
%study name
studyName='HandRelexionExtension';
% studyName='Fingers';
% studyName='HandAdductionAbduction';

%synch channel name in neuro task file
defaultSynchNames={'Sound','Synch','Trigger'};
synchName=[];

impulseStart=1;
startEdge='rise';

impulseEnd=1;
endEdge='fall';
%==========================================================================

cds=CommonDataStructure;

[FileName,FilePath]=uigetfile({'*.medf;*.cds'},'select the related neuro task file',pwd);

if ~FileName
    return
end

cds.load(fullfile(FilePath,FileName));

sampleRate=cds.Data.SampleRate;
%GUI for synch channel name of neuro system********************************
while (1)
    synch=[];
    for i=1:length(cds.Montage.ChannelNames)
        if isempty(synchName)
            if ismember(cds.Montage.ChannelNames{i},defaultSynchNames)
                synch=cds.Data.Data(:,i);
            end
        else
            if strcmpi(cds.Montage.ChannelNames{i},synchName)
                synch=cds.Data.Data(:,i);
            end
        end
    end
    
    if isempty(synch)
        cprintf('Errors','[Error]\n')
        cprintf('Errors','Cannot find synch channel in neuro task file. Please check the channel name.\n')
        cprintf('SystemCommands','Do you want to change the name of the synch channel ?[Y/N]\n')
        s=input('','s');
        
        if strcmpi(s,'n')
            return
        else
            
            prompt = {'Name of the synch channel in neuro-system'};
            dlg_title = 'ok-continue cancel-reak';
            num_lines = 1;
            def = {'synch'};
            
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            if ~isempty(answer)
                synchName=answer{1};
            else
                return
            end
        end
    else
        break
    end
    
end
%==========================================================================

stamp=cds.Data.TimeStamps;

[FileName,FilePath]=uigetfile('*.mat','select the original behavior data file',pwd);
if ~FileName
    return
end
behv=load(fullfile(FilePath,FileName),'-mat');

trials=behv.trials;
% settings=behv.settings;
% TriggerExeTimings=behv.TriggerExeTimings;

behvSynch=[];
acceleration=[];
fingers=[];
rollPitch=[];
behvTimeStamp=[];
behvVideoTimeFrame=[];

for i=1:length(trials)
    behvSynch=cat(2,behvSynch,trials(i).Trigger);
    acceleration=cat(2,acceleration,trials(i).Acceleration);
    fingers=cat(2,fingers,trials(i).Fingers);
    rollPitch=cat(2,rollPitch,trials(i).RollPitch);
    behvTimeStamp=cat(2,behvTimeStamp,trials(i).Time);
    behvVideoTimeFrame=cat(2,behvVideoTimeFrame,trials(i).Video);% raw 1: timestamp;raw 2: frame
end
behvTimeStamp=behvTimeStamp';
behvVideoTimeFrame=behvVideoTimeFrame';
behvMat=cat(1,behvSynch,acceleration,fingers,rollPitch);
behvMat=double(behvMat);
% behvMat=detrend(behvMat')';

[behvMat,videoStartTime,timeFrame]=neuroBehvSynch(synch,stamp,sampleRate,...
    behvMat,behvSynch,behvTimeStamp,behvVideoTimeFrame,...
    impulseStart,startEdge,impulseEnd,endEdge);

channelNames={'Trigger','Acceleration X','Acceleration Y', 'Acceleration Z',...
    'Finger 1','Finger 2','Finger 3','Finger 4','Finger 5',...
    'Roll','Pitch'};

for i=1:size(behvMat,1)
    task.data.dataMat{i}=detrend(behvMat(i,:));
    task.data.info{i}.sampleRate=sampleRate;
    task.data.info{i}.unit=[];
    task.data.info{i}.name=channelNames{i};
    task.data.info{i}.stamp=[];cne
end
task.data.info{1}.stamp=stamp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

task.info.studyName=studyName;
task.info.location=[];
task.info.device='Lenovo';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

task.info.video.startTime=0;
timeFrame(:,1)=timeFrame(:,1)+videoStartTime;
task.info.video.timeFrame=timeFrame;

[FileName,FilePath]=uiputfile('*.medf','save your behv task file','behv.medf');
save(fullfile(FilePath,FileName),'-struct','task','-mat');




