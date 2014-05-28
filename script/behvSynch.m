function [behvMat,channelNames,videoStartTime,videoTimeFrame]=behvSynch(synch,neuroTimeStamp,sampleRate)
%This function synchronize the behavior data w.r.t the timestamp of neuro-system

%synch: synch signal from neuro-system
%sampling frequency of neuro system needs to be consistent (no jitter)

%cutoff frequency for highpass filter of synch signal from neuro-system
fc=5;
%order of the butter filter
order=2;

%threshould value to get a digital signal from envlope
thresh_neuro=2;
thresh_behv=0.5*10^-3;

%Synchronization impulse number to start
impulseStart=2;

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
behvTimeStamp=[];
timeFrame=[];

for i=1:length(trials)
    trigger=cat(2,trigger,trials(i).Trigger);
    acceleration=cat(2,acceleration,trials(i).Acceleration);
    fingers=cat(2,fingers,trials(i).Fingers);
    rollPitch=cat(2,rollPitch,trials(i).RollPitch);
    behvTimeStamp=cat(2,behvTimeStamp,trials(i).Time);
    timeFrame=cat(2,timeFrame,trials(i).Video);% raw 1: timestamp;raw 2: frame
end
behvTimeStamp=behvTimeStamp';
timeFrame=timeFrame';

trigger=detrend(trigger);

%high pass the synch signal from neuro-system
[b,a]=butter(order,fc/sampleRate*2,'high');
synch_f=filter_symmetric(b,a,synch,sampleRate,0,'iir');

%get the starting point of synch signal from neuro-system%%%%%%%%%%%%%%%%%%
env=abs(hilbert(synch_f));
thresh_neuro=90*median(env);
% thresh_neuro=mean(env);
denv=env>thresh_neuro;
diffenv=diff(denv);

figure
subplot(2,1,1)
plot(neuroTimeStamp,synch_f,'b');
hold on
plot(neuroTimeStamp,env,'r');
hold on
plot([neuroTimeStamp(1) neuroTimeStamp(length(env))],[thresh_neuro thresh_neuro],'-m');

startInd=find(diffenv==1)+1;
endInd=find(diffenv==-1)+1;

start_neuro=startInd(impulseStart);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get the ending point of synch signal from neuro-system%%%%%%%%%%%%%%%%%%%%
end_neuro=endInd(end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get the starting point of synch signal from behv-system%%%%%%%%%%%%%%%%%%%
env=abs(hilbert(trigger));
% plot(1:length(trigger),trigger,'b',1:length(env),env,'r');

thresh_behv=25*median(env);
% thresh_behv=mean(env);
denv=env>thresh_behv;
diffenv=diff(denv);

subplot(2,1,2)
plot(behvTimeStamp,trigger,'b');
hold on
plot(behvTimeStamp,env,'r');
hold on
plot([behvTimeStamp(1) behvTimeStamp(length(env))],[thresh_behv thresh_behv],'-m');

disp('Check the auto thresholding')
disp('Press any key to continue')
pause;

startInd=find(diffenv==1)+1;
endInd=find(diffenv==-1)+1;

start_behv=startInd(impulseStart);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get the ending point of synch signal from behv-system
end_behv=endInd(end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
behvMat=cat(1,trigger,acceleration,fingers,rollPitch);
% behvMat=cat(1,trigger,fingers);
behvMat=double(behvMat);

behvMatMiddle=behvMat(:,start_behv:end_behv);
%interpolate the behavior data according to neuro-system from start to end

behvTimeStampSE=behvTimeStamp(start_behv:end_behv)-behvTimeStamp(start_behv);
% behvTimeStamp=behvTimeStamp/behvTimeStamp(end);

neuroTimeStampSE=neuroTimeStamp(start_neuro:end_neuro)-neuroTimeStamp(start_neuro);
% neuroTimeStamp=neuroTimeStamp/neuroTimeStamp(end);

figure
neuro_diff=diff(abs(hilbert(synch_f(start_neuro:end_neuro)))>thresh_neuro);
behv_diff=diff(abs(hilbert(trigger(start_behv:end_behv)))>thresh_behv);

subplot(2,1,1)
plot(neuroTimeStampSE(2:end),neuro_diff,'b',behvTimeStampSE(2:end),behv_diff,'r');
title('start and end of the impulse train');
legend({'neuro pulse','behv pulse'})

deltaTimeStamp=neuroTimeStampSE(1+find(neuro_diff>0))-behvTimeStampSE(1+find(behv_diff>0));

subplot(2,1,2)
plot(deltaTimeStamp);
title('Timestamp difference at each pulse start')
disp('Make sure timestamp difference is within a resonable range !')
disp('If the differences are high, try to manually select different impulse start')
disp('press any key to continue')

pause


interpBehvMatMiddle=interp1(behvTimeStampSE,behvMatMiddle',neuroTimeStampSE);

chanNum=size(interpBehvMatMiddle,2);
behvMat=cat(2,zeros(chanNum,start_neuro-1),interpBehvMatMiddle',zeros(chanNum,length(synch)-end_neuro));


videoStartIndex=find(timeFrame(:,2)==1);

% videoStartTime=getfield(TriggerExeTimings,'Initial OneShot')

videoTimeFrame(:,1)=behvTimeStamp(1:size(timeFrame,1));
videoTimeFrame(:,2)=timeFrame(:,2);

videoStartTime=videoTimeFrame(videoStartIndex(1),1);

%behv task time shift according to neuro timestamp after zero padding
shiftTime=neuroTimeStamp(start_neuro)-behvTimeStamp(start_behv);

%Assuming the task started at time 0 (in consistent with bioSigPlot)
%The corresponding time for the start of the video

videoTimeFrame(:,1)=videoTimeFrame(:,1)-videoStartTime;

[frames,iframe,j]=unique(videoTimeFrame(:,2));

videoTimeFrame=videoTimeFrame(iframe,:);

ind=find(videoTimeFrame(:,2)>0);
videoTimeFrame=videoTimeFrame(ind,:);

videoTimeFrame(:,2)=1:size(videoTimeFrame,1);

videoStartTime=videoStartTime+shiftTime;


channelNames={'Trigger','Acceleration X','Acceleration Y', 'Acceleration Z',...
    'Finger 1','Finger 2','Finger 3','Finger 4','Finger 5',...
    'Roll','Pitch'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

