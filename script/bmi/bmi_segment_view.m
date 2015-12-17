clc
clear

%user defined region=======================================================
%get segments seconds before onset and after onset
% Hand open close
% SBefore=2;
% SAfter=2;
% TMin=0;

% Finger
% SBefore=1;
% SAfter=1.5;
% TMin=0;

%Abduction
SBefore=2;
SAfter=2;
TMin=1;
%Rest
% SBefore=0;
% SAfter=30;
% TMin=0;

%exclude bad\syn\noisy channels if any
%var channels stores clean channel index

%Yaqiang Sun
% badChannels={'C21','C33','C34','C46','C58','C82','C94','C106','C109',...
%     'ECG+','ECG-','EMG+','EMG-','Synch','C126','C127','C128'};
badChannels={'ECG Bipolar','EMG Bipolar','Synch','C126','C127','C128'};
% Li Ma
%badChannels for Handopenclose
% badChannels={'C27','C64','C75','C76','C100',...
%     'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128'};
%badChannels for AbductionAdduction
% badChannels={'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128'};

% badChannels={'Trigger','Acceleration X','Acceleration Y', 'Acceleration Z','Roll','Pitch'};

%Xu Yun
% badChannels={'C37','C3','C4','C5','C15','C16','C2','C27','C28','C6',...
%     'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128','C41','C10','C11',...
%     'C78','C9'};

%movemnt type
% Hand open close
% movements={'Open','Close'};
% movements={'Relax'};

% Finger
% movements={'F1 start','F2 start','F3 start','F4 start','F5 start'};
% movements={'Rest start'};

%Abduction
movements={'Abd','Add'};
%if movements is 2*n, will extract the segments between the first row and
%second row
% movements={'Rest Start';'Rest End'};
%Rest
% movements={'Rest Start'};

save_seg=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

segments=bmi_segment_extract(SBefore,SAfter,TMin,badChannels,movements,save_seg);

baseline=[];

fs=segments.samplefreq;
montage=segments.montage;
channelnames=montage.channelnames;
channelindex=montage.channelindex;

% movements={'F1Start','F2Start'};

for i=1:length(movements)
    evts={};
    sdata=segments.(movements{i});
    data=[];
    for k=1:size(sdata,3)
        data=cat(1,data,sdata(:,:,k));
    end
    
    evts{1,1}=0;
    evts{1,2}=[movements{i},'1'];
    for j=2:size(sdata,3)
        evts{j,1}=evts{j-1,1}+size(sdata,1)/fs;
        evts{j,2}=num2str(j);
    end
    
    bsp=BioSigPlot(data,'Evts',evts,'SRate',fs,'ChanNames',channelnames);
end


