clc
clear

%user defined region=======================================================
%study name
% studyName='HandRelexionExtension';
% studyName='Finger Abdution';
% studyName='Individual Finger Movement';
studyName='S2';

%task start name
% task_start_name='HandOpenRelaxClose Start';
% task_start_name='HandOpenCloseRelax Start';
% task_start_name='Individual finger movement start';
% task_start_name='Rest Start';
% task_start_name='FingerAbduction Start';
% task_start_name='Individual Finger Start';
task_start_name='Start Recording';
%task end name
% task_end_name='HandOpenRelaxClose End';
% task_end_name='HandOpenCloseRelax End';
% task_end_name='Individual finger movement end';
% task_end_name='Rest End';
% task_end_name='FingerAbduction End';
% task_end_name='Individual Finger End';
task_end_name='Stop Recording';

%seconds before the task
sBefore=0;

%seconds after the task
sAfter=0;

%low pass filter order
order=2;
%downsample number

downsample=1;
% downsample=4;

%==========================================================================

%Hand open relax close extration
[FileName,FilePath]=uigetfile('*.eeg','select the eegfile');
EEGFilePath=[FilePath(1:end-1) '.eeg'];
eegfile=xltekreadeegfile(EEGFilePath);
GUID=FileName(1:end-4);


%ignore deleted notes
entfile=xltekreadentfile([FilePath(1:end-1),'.ent']);
count=1;
for i=1:length(entfile)
    if ~(isempty(entfile(i).Type)||isfield(entfile(i).Data,'Deleted'))
        newentfile(count)=entfile(i);
        count=count+1;
    end
end
entfile=newentfile;

for i=1:length(entfile)
    if strcmpi(entfile(i).Text,task_start_name)
        Anno_start=i;
        task_start=str2double(entfile(i).Stamp);
    elseif strcmpi(entfile(i).Text,task_end_name)
        task_end=str2double(entfile(i).Stamp);
        Anno_end=i;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%
flag=1;
count=1;
datamat=[];
timestamps=[];
erdfiles=dir([FilePath,GUID,'*.erd']);
erdfile_names=sort({erdfiles.name});

%To work around filename bug that is out of order
%%
ts=[];
for n=1:length(erdfile_names)
    [~,~,TS,~]=xltekreaderdfile(fullfile(FilePath,erdfile_names{n}));
    ts=[ts,min(TS)];
end
[~,new_order]=sort(ts);

erdfile_names=erdfile_names(new_order);

for n=1:length(erdfile_names)
    [DATA,CH,TS,INFO]=xltekreaderdfile(fullfile(FilePath,erdfile_names{n}));
    erdfile.data=DATA;
    erdfile.channels=CH;
    erdfile.timestamps=TS;
    erdfile.info=INFO;
    
    erd_start=min(erdfile.timestamps);
    erd_end=max(erdfile.timestamps);
    erd_len=length(erdfile.timestamps);
    
    fs=erdfile.info.SampleRate;
    
    if task_start<=erd_end
        if task_start>=erd_start
            i_start=find(erdfile.timestamps==task_start);
            if i_start-fs*sBefore<1
                i_start=1;
            else
                i_start=i_start-fs*sBefore;
            end
            
            if task_end<=erd_end
                i_end=find(erdfile.timestamps==task_end);
                if i_end+fs*sAfter>erd_len
                    i_end=erd_len;
                else
                    i_end=i_end+fs*sAfter;
                end
                flag=0;
            else
                i_end=erd_len;
            end
        else
            i_start=1;
            if task_end<=erd_end
                i_end=find(erdfile.timestamps==task_end);
                if i_end+fs*sAfter>erd_len
                    i_end=erd_len;
                else
                    i_end=i_end+fs*sAfter;
                end
                flag=0;
            else
                i_end=erd_len;
            end
        end
        
        i_datamat=erdfile.data(i_start:i_end,:);
        i_timestamps=erdfile.timestamps(i_start:i_end);
        
        datamat=cat(1,datamat,i_datamat);
        timestamps=cat(1,timestamps,i_timestamps);
    end
    count=count+1;
    if ~flag
        break;
    end
end

dataTime=timestamps(1:downsample:end);
fs=fs/downsample;
%%%%%%%%%%%%%%%%%%%down sample by 4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if downsample==4
    %low pass filtering the data first
    %band pass filter
    % fc=fs/downsample/2;
    % [b,a]=butter(order,fc*2/fs,'low');
    % datamat=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,datamat,fs,0,'iir');
    
    fir_lowpass_220_2000=load('FIR_LowPass_Filter_220Hz_Fs_2000Hz');
    a=1;
    b=fir_lowpass_220_2000.hL;
    datamat=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,datamat,fs,0,'fir');
    
    %down sampling the data
    datamat=datamat(1:downsample:end,:);
    
    
    %notch filter
    fir_notch_50_500=load('FIR_NotchFilterBank_50_100_150_200_Fs_500');
    a=1;
    notchFilters=fir_notch_50_500.notchFilter;
    
    for i=1:length(notchFilters)
        b=notchFilters(i).hNotch;
        datamat=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,datamat,fs,0,'fir');
    end
    

    % data.timestamps=timestamps;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count=1;
annoTime=0;
for i=Anno_start:Anno_end
    text{count}=entfile(i).Text;
    annoTime(count)=str2double(entfile(i).Stamp);
    count=count+1;
end
%trim the timestamps of annotation to match downsample

k=dsearchn(dataTime,annoTime');
annoTime=dataTime(k);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

events.text=text;

events.stamp=(annoTime-dataTime(1))/fs/downsample;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(entfile)
    if isfield(entfile(i).Data,'ChanNames')
        if ~isempty(entfile(i).Data.ChanNames)
            channelnames=entfile(i).Data.ChanNames;
            break;
        end
    end
end

cds=CommonDataStructure;
cds.Data=datamat;
cds.fs=fs;
cds.DataInfo.Units='mV';
cds.Montage.ChannelNames=channelnames;
ts=dataTime/fs/downsample;
cds.DataInfo.TimeStamps=ts-ts(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cds.save

[FileName,FilePath]=uiputfile('*.txt','save your events file','anno.txt');
fid=fopen(fullfile(FilePath,'events',FileName),'w');
for i=1:length(events.text)
    fprintf(fid,'%f,%s\n',events.stamp(i),events.text{i});
end
% save(fullfile(FilePath,'events',FileName),'-struct','events','-mat');

