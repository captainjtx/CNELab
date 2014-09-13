function  timestamp_test( frames,trials)
figure

Video=[];
Time=[];
data=[];

for i=1:length(trials)
    Video=cat(2,Video,trials(i).Video);
    Time=cat(2,Time,trials(i).Time);
    data=cat(2,data,trials(i).Fingers(2,:));
end

for i=1:length(Time)
    frameNum=Video(2,i);
    frameNum=max(1,frameNum);
    
    subplot(2,1,1)
    
    plot(Time(1:i),data(1:i));
    xlim([Time(1) 20]);
    ylim([-max(data) max(data)])
    subplot(2,1,2)
    
    imagesc(frames(frameNum).cdata);
    disp(['frame num: ' num2str(frameNum) '  time: ' num2str(Time(i))])% ...
%         '  time estimated by rate:' num2str(1/rate*(timeFrame(2,i)-1)+timeFrame(1,2)),...
%         '  time estimated by mmread:' num2str(videoTime(frameNum)+timeFrame(1,2)-videoTime(1))]);
    pause
end


end

