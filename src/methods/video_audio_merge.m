function video_audio_merge(outfile,vfile,afile)
%video_audio_merge.m

%outfile: The merged output file name
%vfile: Video file name
%afile: Audio file name

%mmread and mmwrite library is required!
% video=mmread(vfile);
% [tmp,audio]=mmread(afile);
% 
% mmwrite('tmp.avi',video,audio);
% 
% ffmpegtranscode('tmp.avi',outfile,'VideoCodec','mpeg4');
!ffmpeg -i vfile -i afile -map 0:v -map 1:a outfile
end

