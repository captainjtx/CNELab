function SynchDataWithVideo(obj)
if isa(obj.WinVideo,'VideoWindow') && obj.WinVideo.valid
    frame=obj.WinVideo.CurrentFrameNumber;
    if ~isempty(obj.VideoTimeFrame)
        if isempty(frame)
            %Estimate Current Frame
            %The TotalFrameNumber get from VideoReader seems to be
            %inaccurate, Video must be stopped before the recording to get
            %the exact number of frames recorded !
            dp=ceil(obj.NumberOfFrame*obj.WinVideo.CurrentPositionRatio);
            dp=min(max(1,dp),size(obj.VideoTimeFrame,1));
%             dp=ceil(obj.WinVideo.TotalFrameNumber*obj.WinVideo.CurrentPositionRatio);
%             dp=min(max(1,dp),size(obj.VideoTimeFrame,1));
            
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
if (t < 0 && obj.PlaySpeed <= 0) || (t > obj.TotalTime && obj.PlaySpeed >= 0)
    obj.PausePlay();
end

t = min(max(t,0), obj.TotalTime);

obj.VideoLineTime=t;

if (t-obj.Time)>obj.WinLength || t<obj.Time
    set(obj,'Time',t)
end

end