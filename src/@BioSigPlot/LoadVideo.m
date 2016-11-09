function LoadVideo(obj)

dd=obj.DisplayedData;
pathstr=fileparts(obj.FileNames{dd(1)});
[FileName,FilePath]=uigetfile('*.avi;*.mp4','select the video file',pathstr);

if FileName~=0
    obj.WinVideo=VideoWindow(fullfile(FilePath,FileName)); %VLC or WMPlayer
    addlistener(obj.WinVideo,'VideoChangeTime',@(src,evt) SynchDataWithVideo(obj));
    addlistener(obj.WinVideo,'VideoChangeState',@(src,ect) SynchVideoState(obj));
    addlistener(obj.WinVideo,'VideoClosed',@(src,evt) StopPlay(obj));
    
    obj.VideoFile=fullfile(FilePath,FileName);
end

end