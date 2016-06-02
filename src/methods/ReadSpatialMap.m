function sm = ReadSpatialMap( filename )
%READSPATIALMAP Summary of this function goes here
%   Detailed explanation goes here
fileID = fopen(filename);
C = textscan(fileID,'%s%f%d',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);

if length(C)<2
    sm=[];
    return
else
    sm.name=C{1};
    sm.val=C{2};
    sm.sig=zeros(length(C{1}),1);
    if length(C)>2
       sm.sig=C{3};
    end
    
end
end

