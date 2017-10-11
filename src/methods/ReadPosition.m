function [channelname,pos_x,pos_y,r] = ReadPosition( filename )
%Montage file formats:
%ChannelName,x_pos,y_pos,z_pos(optional)
fileID = fopen(filename);
C = textscan(fileID,'%s %f %f %f',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);

channelname=[];
pos_x=[];
pos_y=[];
r=[];

if length(C)<3
    return
elseif length(C)==3
    channelname=C{1};
    pos_x=C{2};
    pos_y=C{3};
else
    channelname=C{1};
    pos_x=C{2};
    pos_y=C{3};
    r=C{4};
end

channelname = channelname(:);
pos_x = pos_x(:);
pos_y = pos_y(:);
r = r(:);
end

