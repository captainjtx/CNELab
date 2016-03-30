function [new_stamp,new_text,RisingIdx,FallingIdx]=insert_depth(depth_data,fs,text,stamp)
% This function finds the depth values of the data, and returns new
% annotations. The conversion between pulse duration and depth value might
% be incorrect. The calculation was based on 'xltekdepthfind' function.
%
%depth_data: data vector or matrix.
%        fs: sampling frequency.
%      text: original annotation text of the depth data.                    
%     stamp: original timestamp vector of the depth data.
if size(depth_data,1)==1
    depth_data=depth_data';
end
[~,RisingIdx,FallingIdx]=extract_ac_trigger(depth_data,fs,1,50);
depth=FallingIdx-RisingIdx;
depth = (5*depth/fs)-5;
for i=1:length(depth)
    depth_txt=sprintf('%3.2f',depth(i));
    txt=sprintf('Depth %s',depth_txt);
    DepthAnno{i,1}=txt;
end
for i=1:length(DepthAnno)
    anno1{i,1}=RisingIdx(i)/fs;
    anno1{i,2}=DepthAnno{i};
end
for i=1:length(text)
    anno2{i,1}=stamp(i);
    anno2{i,2}=text{i};
end
ANNO=[anno1;anno2];
for i=1:length(ANNO)
    t(i,1)=ANNO{i,1};
end
[~,I]=sort(t);
ANNO=ANNO(I,:);
for i=1:length(ANNO)
    new_stamp(i)=ANNO{i,1};
    new_text{i}=ANNO{i,2};
end
end
% Written by Su Liu
% sliu31@uh.edu