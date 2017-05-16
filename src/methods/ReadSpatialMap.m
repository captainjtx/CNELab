function sm = ReadSpatialMap( filename )
%READSPATIALMAP Summary of this function goes here
%   Detailed explanation goes here
fileID = fopen(filename);
C = textscan(fileID,'%s%f%d%f%f%f',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);

sm.name=C{1};
sm.val=C{2};
sm.sig=zeros(length(C{1}),1);
if ~any(isempty(C{3}))
    sm.sig=C{3};
end

end

