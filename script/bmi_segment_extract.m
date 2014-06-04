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

% badChannels={'Trigger','Acceleration X','Acceleration Y', 'Acceleration Z','Roll','Pitch'};

%movemnt type
% movements={'Open','Close'};
movements={'Relax'};
% movements={'Apart','Together'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[FileName,FilePath]=uigetfile('*.medf','select task file');
task=load(fullfile(FilePath,FileName));

[FileName,FilePath]=uigetfile('*.mat','select annotations file');
annotations=load(fullfile(FilePath,FileName));

data=task.data;

chanNum=length(data.dataMat);

for i=1:chanNum
    dataMat(:,i)=data.dataMat{i};
    channelNames{i}=data.info{i}.name;
end

fs=data.info{1}.sampleRate;


channels=zeros(chanNum-length(badChannels),1);

count=1;
for i=1:chanNum
    if ~ismember(channelNames{i},badChannels)
        channels(count)=i;
        count=count+1;
    end
end

dataMat=dataMat(:,channels);
dataTS=data.info{1}.stamp;

movement_type_num=length(movements);
segNum=zeros(movement_type_num,1);

annoTS=annotations.stamp;
annoTXT=annotations.text;



mov_index=find(ismember(annoTXT,movements));
annoTS=annoTS(mov_index)-dataTS(1);
annoTXT=annoTXT(mov_index);

for i=2:length(annoTS)-1
    if (annoTS(i)-annoTS(i-1))>SBefore&&...
            (annoTS(i+1)-annoTS(i))>SAfter
        for j=1:movement_type_num
            if strcmpi(annoTXT{i},movements{j})
                segNum(j)=segNum(j)+1;
                iAnno  = round(annoTS(i)*fs+1);
                varname=genvarname(movements{j});
                segments.(varname)(:,:,segNum(j))=dataMat(iAnno-SBefore*fs:iAnno+SAfter*fs,:);
            end
        end
    end
end

segments.movements=movements;

segments.samplefreq=fs;

channelnames=cell(length(channels),1);
for i=1:length(channels)
    channelnames{i}=channelNames{channels(i)};
end

montage.channelnames=channelnames;
montage.channelindex=channels;
montage.badchannels=badChannels;

segments.montage=montage;

[FileName,FilePath]=uiputfile('*.mat','save your segment file','segments.mat');
save(fullfile(FilePath,FileName),'-struct','segments');
end





