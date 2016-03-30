function bmi_video_play()
[FileName,FilePath]=uigetfile('*.avi','select a video file');
% implay(fullfile(FilePath,FileName));
xyloObj = VideoReader(fullfile(FilePath,FileName));

nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;
videoHandle=figure;
status='pause';
setappdata(0,'status',status);
set(videoHandle,'KeyPressFcn',@keyPressFcn);
for k = 1 : nFrames
    status=getappdata(0,'status');
    if strcmpi(status,'pause')
        pause
    else
        frame = read(xyloObj,k);
        image(frame);
    end
end


end

function keyPressFcn(obj,eventData)
tmp=get(obj,'CurrentKey');
status=getappdata(0,'status');

switch tmp
    case 'space'
        if strcmpi(status,'pause')
            status='run';
        else
            status='pause';
        end
end
setappdata(0,'status',status);

end

