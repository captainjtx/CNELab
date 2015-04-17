function SynchDataWithVideo(obj)

%The video must end before the data ends, otherwise we can not konw the
%total number of the video frame, all estimations wiil not hold

if isa(obj.WinVideo,'VideoWindow') && isvalid(obj.WinVideo)
    frame=obj.WinVideo.CurrentFrameNumber;
    if ~isempty(obj.VideoTimeFrame)
        if isempty(frame)
            dp=ceil(size(obj.VideoTimeFrame,1)*obj.WinVideo.CurrentPositionRatio);
            dp=min(max(1,dp),size(obj.VideoTimeFrame,1));
            t=obj.VideoTimeFrame(dp,1)+obj.VideoStartTime;
        else
            dp=min(max(1,frame),size(obj.VideoTimeFrame,1));
            t=obj.VideoTimeFrame(dp,1)+obj.VideoStartTime;
        end
    else
        if ~isempty(obj.VideoEndTime)
            t=(obj.VideoEndTime-obj.VideoStartTime)*obj.WinVideo.CurrentPositionRatio+obj.VideoStartTime;
        else
            t=obj.WinVideo.CurrentPosition+obj.VideoStartTime;
        end
    end
else
    t=obj.VideoLineTime+obj.VideoTimerPeriod*obj.PlaySpeed;
end
%stop if exceeds data length
if t>obj.DataTime
    PausePlay(obj);
    error('Data time exceeds video length');
end
if t<0
    obj.VideoLineTime=0;
%     set(obj,'Time',0);
    updateVideo(obj);
    return
end

obj.VideoLineTime=t;

if (t-obj.Time)>obj.WinLength
    set(obj,'Time',t);
elseif t<obj.Time
    set(obj,'Time',t)
end
end