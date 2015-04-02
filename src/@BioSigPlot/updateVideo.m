function updateVideo(obj)

if isa(obj.WinVideo,'VideoWindow') && isvalid(obj.WinVideo)
    if ~strcmpi(obj.WinVideo.Status,'Playing')
        
        if ~isempty(obj.VideoTimeFrame)
            obj.WinVideo.CurrentPositionRatio=...
                interp1(obj.VideoTimeFrame(:,1),obj.VideoTimeFrame(:,2),(obj.VideoLineTime-obj.VideoStartTime))...
                /max(obj.VideoTimeFrame(:,2));
        else
            if isempty(obj.VideoEndTime)
                obj.WinVideo.CurrentPosition=obj.VideoLineTime-obj.VideoStartTime;
            else
                obj.WinVideo.CurrentPositionRatio=...
                    (obj.VideoLineTime-obj.VideoStartTime)/(obj.VideoEndTime-obj.VideoStartTime);
            end
        end
    end
end

end

