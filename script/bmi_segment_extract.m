function segments=bmi_segment_extract()
%user defined region=======================================================
%get segments seconds before onset and after onset
SBefore=2;
SAfter=2;

%exclude bad\syn\noisy channels if any
%var channels stores clean channel index

%Yaqiang Sun
% badChannels={'C21','C33','C34','C46','C58','C82','C94','C106','C109',...
%     'ECG+','ECG-','EMG+','EMG-','Synch','C126','C127','C128'};

% Li Ma
badChannels={'C27','C64','C75','C76','C100',...
    'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128'};


%movemnt type
% movements={'Open','Close'};
movements={'Apart','Together'};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[FileName,FilePath]=uigetfile('*.mat','select task file');
taskfile=load(fullfile(FilePath,FileName));

task=taskfile.task;
data=task.data;
annotations=task.annotations;
montage=task.montage;
fs=task.samplefreq;
chanNum=task.channum;

channels=zeros(chanNum-length(badChannels),1);
count=1;
for i=1:chanNum
    if ~ismember(montage.channelnames{i},badChannels)
        channels(count)=i;
        count=count+1;
    end
end

dataMat=data.datamat(:,channels);
dataTS=data.timestamps;

movement_type_num=length(movements);
segNum=zeros(movement_type_num,1);

annoTS=annotations.timestamps;
annoTXT=annotations.text;

originalfreq=task.originalfreq;

mov_index=find(ismember(annoTXT,movements));
annoTS=annoTS(mov_index);
annoTXT=annoTXT(mov_index);

for i=2:length(annoTS)-1
    if (annoTS(i)-annoTS(i-1))>originalfreq*SBefore&&...
            (annoTS(i+1)-annoTS(i))>originalfreq*SAfter
        for j=1:movement_type_num
            if strcmpi(annoTXT{i},movements{j})
                segNum(j)=segNum(j)+1;
                iAnno  = find(dataTS==annoTS(i));
                varname=genvarname(movements{j});
                segments.(varname)(:,:,segNum(j))=dataMat(iAnno-SBefore*fs:iAnno+SAfter*fs,:);
            end
        end
    end
end

segments.movements=movements;

segments.samplefreq=fs;
segments.originalfreq=originalfreq;

channelnames=cell(length(channels),1);
for i=1:length(channels)
    channelnames{i}=montage.channelnames{channels(i)};
end
montage.channelnames=channelnames;
montage.channelindex=channels;
montage.badchannels=badChannels;

segments.montage=montage;

uisave('segments','segments.mat');
end





