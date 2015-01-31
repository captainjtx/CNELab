function SynchDataWithVideo(obj)
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
        t=obj.WinVideo.CurrentPosition+obj.VideoStartTime;
    end
else
    t=obj.VideoLineTime+obj.VideoTimerPeriod*obj.PlaySpeed;
end
%stop if exceeds data length
if abs(t)>obj.DataTime
    PausePlay(obj);
    error('Data time exceeds video length');
end
if t<0
    obj.WinVideo.CurrentPosition=-obj.VideoStartTime;
    t=0;
end

obj.VideoLineTime=t;

if (t-obj.Time)>obj.WinLength
    set(obj,'Time',t);
elseif t<obj.Time
    set(obj,'Time',t)
end
end