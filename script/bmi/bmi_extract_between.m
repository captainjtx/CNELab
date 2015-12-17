clc
clear
%user defined region=======================================================

%exclude bad\syn\noisy channels if any
%var channels stores clean channel index

%Yaqiang Sun
% badChannels={'C21','C33','C34','C46','C58','C82','C94','C106','C109',...
%     'ECG+','ECG-','EMG+','EMG-','Synch','C126','C127','C128'};

% Li Ma
% badChannels={'C27','C64','C75','C76','C100',...
%     'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128'};
badChannels={'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128'};

% badChannels={'Trigger','Acceleration X','Acceleration Y', 'Acceleration Z','Roll','Pitch'};

%Xu Yun
% badChannels={'C37','C3','C4','C5','C15','C16','C2','C27','C28','C6',...
%     'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128','C41','C10','C11',...
%     'C78','C9'};

%Annotation type
Anno_start='Rest Start';
Anno_end='Rest End';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cds=CommonDataStructure;

if ~cds.import()
    return
end

if isempty(cds.Data.Annotations)
    [FileName,FilePath]=uigetfile('*.evt','select annotations file');
    annotations=load(fullfile(FilePath,FileName),'-mat');
    
    annoTS_old=annotations.stamp;
    annoTX_oldT=annotations.text;
else
    annoTS_old=cell2mat(cds.Data.Annotations(:,1));
    annoTXT_old=cds.Data.Annotations(:,2);
end

chanNum=length(cds.Montage.ChannelNames);

dataMat=cds.Data.Data;
channelNames=cds.Montage.ChannelNames;

fs=cds.Data.SampleRate;


count=1;
for i=1:chanNum
    if ~ismember(channelNames{i},badChannels)
        channels(count)=i;
        count=count+1;
    end
end

dataMat=dataMat(:,channels);
dataTS=cds.Data.TimeStamps;


start_index=find(ismember(annoTXT_old,Anno_start));
annoTS=annoTS_old(start_index)-dataTS(1);
annoTXT=annoTXT_old(start_index);

end_index=find(ismember(annoTXT_old,Anno_end));
annoTS_end=annoTS_old(end_index)-dataTS(1);
annoTXT_end=annoTXT_old(end_index);

varname=matlab.lang.makeValidName(Anno_start);
for i=1:length(annoTS)
    iAnno  = round(annoTS(i)*fs+1);
    iAnno_end=round(annoTS_end(i)*fs+1);
    segments.(varname)(:,:,i)=dataMat(iAnno:iAnno_end,:);
end

segments.movements={Anno_start};

segments.samplefreq=fs;

channelnames=cell(length(channels),1);
for i=1:length(channels)
    channelnames{i}=channelNames{channels(i)};
end

montage.channelnames=channelnames;
montage.channelindex=channels;
montage.badchannels=badChannels;

segments.montage=montage;

[FileName,FilePath]=uiputfile('*.mat','save your segment file',fileparts(cds.Data.FileName));
save(fullfile(FilePath,FileName),'-struct','segments');





