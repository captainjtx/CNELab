function SynchVideoWithData(obj)

if isa(obj.WinVideo,'VideoWindow') && isvalid(obj.WinVideo)
    if ~strcmpi(obj.WinVideo.Status,'Playing')
        obj.WinVideo.NotifyVideoChangeTime=false;
        if ~isempty(obj.VideoTimeFrame)
            %Assume the media player will play the vide in a constant frame
            %rate, which is the case for VLC and WMP activex by our
            %observation. Need to verify !
            
            obj.WinVideo.CurrentPositionRatio=obj.VideoStampFrame...
                (min(max(1,floor((obj.VideoLineTime-obj.VideoStartTime)*obj.SRate)),length(obj.VideoStampFrame)))...
                /obj.NumberOfFrame;
%             obj.WinVideo.CurrentPositionRatio=obj.VideoStampFrame...
%                 (min(max(1,floor(obj.VideoLineTime*obj.SRate)),length(obj.VideoStampFrame)))...
%                 /obj.WinVideo.TotalFrameNumber;
        else
            %If no timeframe if present, will try to align the video by
            %video start and end time. Assume that the video's playblack
            %will reflect the real-timing during recording by playing back
            %at inconsistant frame rate which may be achieved by burning the
            %system time into the video when the video is recorded. This
            %system time burning technique is optimal compared to the
            %time-frame recording technique. We need to find if VLC and WMP
            %activex can support that system-time feature. And how to
            %burn system into the video when we record the video
            if isempty(obj.VideoEndTime)
                obj.WinVideo.CurrentPosition=obj.VideoLineTime-obj.VideoStartTime;
            else
                obj.WinVideo.CurrentPositionRatio=...
                    (obj.VideoLineTime-obj.VideoStartTime)/(obj.VideoEndTime-obj.VideoStartTime);
            end
        end
    end
    obj.WinVideo.NotifyVideoChangeTime=true;
end
end

