function ImportVideo(obj)
formats=VideoReader.getFileFormats();
filterSpec=getFilterSpec(formats);
[FileName,FilePath]=uigetfile(filterSpec,'select the video file','behv.avi');

if FileName~=0
    [video,audio]=mmread(fullfile(FilePath,FileName),1);
    if ~isempty(video)
        videoTotalTime=video.totalDuration;
        obj.VideoFile=fullfile(FilePath,FileName);
        
        dataTime=floor((size(obj.Data{1},2)-1)/obj.SRate);
        
        h = waitbar(0,'Video loading...');
        
        obj.VideoTotalTime=videoTotalTime;
        if isempty(obj.VideoTimeFrame)
            
            if obj.VideoStartTime>0
                videoEndTime=dataTime-obj.VideoStartTime;
                if videoEndTime>videoTotalTime
                    videoEndTime=videoTotalTime;
                end
                [obj.VideoObj,obj.AudioObj]=mmread(fullfile(FilePath,FileName),[],[0,videoEndTime]);
            else
                videoEndTime=abs(obj.VideoStartTime)+dataTime;
                if videoEndTime>videoTotalTime
                    videoEndTime=videoTotalTime;
                end
                [obj.VideoObj,obj.AudioObj]=mmread(fullfile(FilePath,FileName),[],[abs(obj.VideoStartTime),videoEndTime]);
            end
            timeframe(:,1)=reshape(obj.VideoObj.times,length(obj.VideoObj.times),1);
            timeframe(:,2)=(1:length(obj.VideoObj.times))';
            
            %make sure the first frame start at time 0
            timeframe(:,1)=timeframe(:,1)-timeframe(1,1);
            obj.VideoTimeFrame=timeframe;
        else
            [obj.VideoObj,obj.AudioObj]=mmread(fullfile(FilePath,FileName));
        end
        
        obj.VideoTimerPeriod=round(1/obj.VideoObj.rate*1000)/1000;
        obj.TotalVideoFrame=length(obj.VideoObj.frames);
        obj.VideoFrame=1;
        ind=find(obj.VideoTimeFrame(:,2)==1);
        obj.VideoFrameInd=ind(1);
        obj.VideoLineTime=0;
        
        
%         if ~isempty(obj.AudioObj.data)
%             obj.MAudioPlayer=audioplayer(obj.AudioObj.data,length(obj.AudioObj.data)/...
%                 ((length(obj.VideoObj.frames)-1)*obj.VideoTimerPeriod));
%         end
        
        
        steps = 100;
        for step = 1:steps
            % computations take place here
            waitbar(step / steps)
        end
        close(h)
        
        figure(obj.VideoFig);
        obj.VideoHandle=imagesc(video.frames(1).cdata);
        
        obj.Time=obj.VideoStartTime;
        drawnow
        
    else
        error('Cannot import the selected video');
    end
end
end