function [behvMat,videoStartTime,videoTimeFrame]=neuroBehvSynch(neuroSynch,neuroTimeStamp,...
    sampleRate,behvMat,behvSynch,behvTimeStamp,behvVideoTimeFrame,impulseStart,startEdge,impulseEnd,endEdge)
%This function synchronize the behavior data w.r.t the timestamp of neuro-system

%synch: synch signal from neuro-system
%sampling frequency of neuro system needs to be consistent (no jitter)



%Synchronization impulse number to start
if nargin<=7
    impulseStart=1;
    startEdge='rise';
    
    impulseEnd=1;
    endEdge='fall';
elseif nargin==9
    impulseEnd=1;
    endEdge='fall';
end

%cutoff frequency for highpass filter of synch signal from neuro-system
fc=5;
%order of the butter filter
order=2;

%threshould value to get a digital signal from envlope
thresh_neuro=2;
thresh_behv=0.5*10^-3;

%debug variable

% sampleRate=500;

behvSynch=detrend(behvSynch);

%high pass the synch signal from neuro-system
[b,a]=butter(order,fc/sampleRate*2,'high');
synch_f=filter_symmetric(b,a,neuroSynch,sampleRate,0,'iir');

%get the starting point of synch signal from neuro-system%%%%%%%%%%%%%%%%%%
neuroEnv=abs(hilbert(synch_f));
thresh_neuro=90*median(neuroEnv);
% thresh_neuro=mean(env);
neuroDenv=neuroEnv>thresh_neuro;
neuroDiffenv=diff(neuroDenv);

figure
subplot(2,1,1)
plot(neuroTimeStamp,synch_f,'b');
xlabel('s')
title('neuro system')
hold on
plot(neuroTimeStamp,neuroEnv,'r');
hold on
plot([neuroTimeStamp(1) neuroTimeStamp(length(neuroEnv))],[thresh_neuro thresh_neuro],'-m');

riseInd=find(neuroDiffenv==1)+1;
fallInd=find(neuroDiffenv==-1)+1;

switch startEdge
    case 'rise'
        start_neuro=riseInd(impulseStart);
    case 'fall'
        start_neuro=fallInd(impulseStart);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get the ending point of synch signal from neuro-system%%%%%%%%%%%%%%%%%%%%
switch endEdge
    case 'rise'
        end_neuro=riseInd(end+1-impulseEnd);
    case 'fall'
        end_neuro=fallInd(end+1-impulseEnd);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get the starting point of synch signal from behv-system%%%%%%%%%%%%%%%%%%%
behvEnv=abs(hilbert(behvSynch));
% plot(1:length(trigger),trigger,'b',1:length(env),env,'r');

thresh_behv=25*median(behvEnv);
% thresh_behv=mean(env);
behvDenv=behvEnv>thresh_behv;
behvDiffenv=diff(behvDenv);

subplot(2,1,2)
plot(behvTimeStamp,behvSynch,'b');
xlabel('s');

title('behv system')
hold on
plot(behvTimeStamp,behvEnv,'r');
hold on
plot([behvTimeStamp(1) behvTimeStamp(length(behvEnv))],[thresh_behv thresh_behv],'-m');

cprintf('Yellow','[Caution]')
cprintf('Blue','Check the auto thresholding')
cprintf('Orange','Press any key to continue')
pause;

riseInd=find(behvDiffenv==1)+1;
fallInd=find(behvDiffenv==-1)+1;

switch startEdge
    case 'rise'
        start_behv=riseInd(impulseStart);
    case 'fall'
        start_behv=fallInd(impulseStart);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get the ending point of synch signal from behv-system
switch endEdge
    case 'rise'
        end_behv=riseInd(end+1-impulseEnd);
    case 'fall'
        end_behv=fallInd(end+1-impulseEnd);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

behvMatMiddle=behvMat(:,start_behv:end_behv);
%interpolate the behavior data according to neuro-system from start to end

behvTimeStampSE=behvTimeStamp(start_behv:end_behv)-behvTimeStamp(start_behv);
% behvTimeStamp=behvTimeStamp/behvTimeStamp(end);

neuroTimeStampSE=neuroTimeStamp(start_neuro:end_neuro)-neuroTimeStamp(start_neuro);
% neuroTimeStamp=neuroTimeStamp/neuroTimeStamp(end);

% interpolate the data=====================================================
interpBehvMatMiddle=interp1(behvTimeStampSE,behvMatMiddle',neuroTimeStampSE);

%timestamp shift check=====================================================

figure

subplot(2,1,1)
neuro_diff=neuroDiffenv(start_neuro-1:end_neuro-1);

behv_diff=behvDiffenv(start_behv-1:end_behv-1);

plot(neuroTimeStampSE,neuro_diff,'b',behvTimeStampSE,behv_diff,'r');
title('digital rising and falling edge of impulse train before interpolation');
legend({'neuro pulse','behv pulse'});

deltaTimeStamp=neuroTimeStampSE(find(neuro_diff>0))-behvTimeStampSE(find(behv_diff>0));

subplot(2,1,2)
plot(deltaTimeStamp);

ylabel('s');

ylim([-0.2 0.2]);
title('Timestamp difference at rising edge of pulse train before interpolation')

cprintf('Yellow','[Caution]')
cprintf('Blue','Make sure the timestamp difference is within a resonable range! Otherwise, try to change impulse start and end. ')
cprintf('Orange','Press any key to continue')

pause



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chanNum=size(interpBehvMatMiddle,2);
behvMat=cat(2,zeros(chanNum,start_neuro-1),interpBehvMatMiddle',zeros(chanNum,length(neuroSynch)-end_neuro));


videoStartIndex=find(behvVideoTimeFrame(:,2)==1);

videoTimeFrame(:,1)=behvTimeStamp(1:size(behvVideoTimeFrame,1));
videoTimeFrame(:,2)=behvVideoTimeFrame(:,2);

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

