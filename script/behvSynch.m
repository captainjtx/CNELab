function [behvMat,channelNames]=behvSynch(synch,stamp,sampleRate)
%synch: synch signal from neuro-system
%sampling frequency of synch needs to be the same

%cutoff frequency for highpass filter of synch signal from neuro-system
fc=5;
%order of the butter filter
order=2;

%threshould value to get a digital signal from envlope
thresh_neuro=2;
thresh_behv=0.5*10^-3;
%debug variable

% sampleRate=500;

[FileName,FilePath]=uigetfile('*.mat','select the behavior data file',[pwd '/db/demo/behv.mat']);
behv=load(fullfile(FilePath,FileName));

trials=behv.trials;
settings=behv.settings;
TriggerExeTimings=behv.TriggerExeTimings;

trigger=[];
acceleration=[];
fingers=[];
rollPitch=[];
timeStamp=[];

for i=1:length(trials)
    trigger=cat(2,trigger,trials(i).Trigger);
    acceleration=cat(2,acceleration,trials(i).Acceleration);
    fingers=cat(2,fingers,trials(i).Fingers);
    rollPitch=cat(2,rollPitch,trials(i).RollPitch);
    timeStamp=cat(2,timeStamp,trials(i).Time);
end

trigger=detrend(trigger);


% task=load('/Users/tengi/Desktop/SuperViewer/db/demo/LiMa_Neuro.mat');
% task=load([pwd '/db/demo/neuro.mat']);
% neuroSynchName='Sound'; %synch channel name in task file
% 
% 
% for i=1:length(task.data.info)
%     if strcmpi(task.data.info{i}.name,neuroSynchName)
%         synch=task.data.dataMat{i};
%         stamp=task.data.info{i}.stamp;
%     end
% end



% subplot(2,1,1)
% plot(synch)
% title('neuro system synch channel');

% subplot(2,1,2)
% plot(trigger);
% title('behavior system synch channel');
%high pass the synch signal from neuro-system
[b,a]=butter(order,fc/sampleRate*2,'high');
synch_f=filter_symmetric(b,a,synch,sampleRate,0,'iir');

% subplot(2,1,2)
% plot(synch)
% title('filtered synch channel')

%get the starting point of synch signal from neuro-system%%%%%%%%%%%%%%%%%%
env=abs(hilbert(synch_f));
denv=env>thresh_neuro;
ind=find(denv);

start_neuro=ind(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get the ending point of synch signal from neuro-system%%%%%%%%%%%%%%%%%%%%
end_neuro=ind(end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get the starting point of synch signal from behv-system%%%%%%%%%%%%%%%%%%%
env=abs(hilbert(trigger));
% plot(1:length(trigger),trigger,'b',1:length(env),env,'r');
ind=find(env>thresh_behv);

start_behv=ind(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get the ending point of synch signal from behv-system
end_behv=ind(end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
behvMat=cat(1,trigger,acceleration,fingers,rollPitch);
behvMat=double(behvMat);

behvMatMiddle=behvMat(:,start_behv:end_behv);
%interpolate the behavior data according to neuro-system from start to end
behvTimeStamp=timeStamp(start_behv:end_behv)-timeStamp(start_behv);
% behvTimeStamp=behvTimeStamp/behvTimeStamp(end);

neuroTimeStamp=stamp(start_neuro:end_neuro)-stamp(start_neuro);
% neuroTimeStamp=neuroTimeStamp/neuroTimeStamp(end);


interpBehvMatMiddle=interp1(behvTimeStamp,behvMatMiddle',neuroTimeStamp);

chanNum=size(interpBehvMatMiddle,2);
behvMat=cat(2,zeros(chanNum,start_neuro-1),interpBehvMatMiddle',zeros(chanNum,length(synch)-end_neuro));


channelNames={'Trigger','Acceleration X','Acceleration Y', 'Acceleration Z',...
    'Finger 1','Finger 2','Finger 3','Finger 4','Finger 5',...
    'Roll','Pitch'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

