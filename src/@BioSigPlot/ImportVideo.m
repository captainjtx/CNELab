function ImportVideo(obj)

[FileName,FilePath]=uigetfile('*','select the video file',obj.FileDir);

if FileName~=0
    obj.WinVideo=VideoWindow(fullfile(FilePath,FileName),obj.VideoActxOpt); %VLC or WMPlayer
    addlistener(obj.WinVideo,'VideoChangeTime',@(src,evt) SynchDataWithVideo(obj));
    addlistener(obj.WinVideo,'VideoChangeState',@(src,ect) SynchVideoState(obj));
    addlistener(obj.WinVideo,'VideoClosed',@(src,evt) StopPlay(obj));
end

end