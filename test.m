function test()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tic
[video,audio]=mmread('/Users/tengi/Desktop/SuperViewer/db/demo/neuro.avi',[],[0 1]);
toc
assignin('base','video',video);
assignin('base','audio',audio);

end

