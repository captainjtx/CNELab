function video_synch_test()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% video=mmread('/Users/tengi/Desktop/SuperViewer/db/demo/behv.avi');

videoobj=VideoReader('/Users/tengi/Desktop/SuperViewer/db/demo/behv.avi');

behv=load('behvRaw.mat');

trials=behv.trials;

trigger=[];
acceleration=[];
fingers=[];
rollPitch=[];
timeStamp=[];
timeFrame=[];

TriggerExeTimings=behv.TriggerExeTimings;

for i=1:length(trials)
    trigger=cat(2,trigger,trials(i).Trigger);
    acceleration=cat(2,acceleration,trials(i).Acceleration);
    fingers=cat(2,fingers,trials(i).Fingers);
    rollPitch=cat(2,rollPitch,trials(i).RollPitch);
    timeStamp=cat(2,timeStamp,trials(i).Time);
    timeFrame=cat(2,timeFrame,trials(i).Video);% raw 1: timestamp;raw 2: frame
end
timeStamp=timeStamp';
timeFrame(1,:)=timeFrame(1,:);

timeFrame=timeFrame';

% getfield(TriggerExeTimings,'Initial OneShot');

h=figure();

% dataAxes=axes('Parent',h,'Units','normalized','Position',[0.05 0.7 0.9,0.2]);
% 
% imageAxes=axes('Parent',h,'Units','normalized','Position',[0.05 0.05 0.6 0.5]);

num=1:20000;

fingerChannel=3;

data=-(fingers(fingerChannel,num));
trigger=trigger(num);

subplot(2,1,1)
plot(timeStamp(num),data,'b');
ylim([min(data) max(data)]);
xlim([timeStamp(1),timeStamp(num(end))]);
hold on;

videoLine=plot([-1 -1],[min(data) max(data)],'r');

subplot(2,1,2)
plot(timeStamp(num),trigger,'b');
ylim([min(trigger) max(trigger)]);
xlim([timeStamp(1), timeStamp(num(end))]);

hold on;

videoLine1=plot([-1 -1],[min(trigger) max(trigger)],'r');

img=figure;
for i=1:size(timeFrame,1)
    
    t=timeFrame(i,1);
    frameNum=timeFrame(i,2);
    
    if frameNum==0
        frameNum=1;
    end
    
    
    set(videoLine,'XData',[t t]);
    set(videoLine1,'XData',[t t]);
    figure(img)
    imshow(read(videoobj,frameNum));
%     image(video.frames(frameNum).cdata);
%     drawnow
    
%     pause(0.01)
    
   
end
end

