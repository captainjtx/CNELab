function [channelname,pos_x,pos_y,pos_z] = ReadPosition( filename )
%Montage file formats:
%ChannelName,x_pos,y_pos,z_pos(optional)
fileID = fopen(filename);
C = textscan(fileID,'%s%s%s',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);

channelname=[];
pos_x=[];
pos_y=[];
pos_z=[];

if length(C)<3
    return
elseif length(C)==3
    channelname=C{1};
    pos_x=C{2};
    pos_y=C{3};
else
    pos_z=C{3};
end

end

