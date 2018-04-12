function [pos_x,pos_y,r,width,height] = get_relative_chanpos(pos_x,pos_y,r,width,height)
pos_x=pos_x-min(pos_x);
pos_y=pos_y-min(pos_y);


dx=abs(pdist2(pos_x,pos_x));
dx=min(dx(dx~=0));
if isempty(dx)
    dx=1;
end

dy=abs(pdist2(pos_y,pos_y));
dy=min(dy(dy~=0));
if isempty(dy)
    dy=1;
end
pos_x=pos_x+dx/2;
pos_y=pos_y+dy*0.6;

x_len=max(pos_x)+dx/2;
y_len=max(pos_y)+dy*0.6;

if x_len<y_len
    height=round(width/x_len*y_len);
else
    width=round(height/y_len*x_len);
end
pos_x=pos_x/x_len;
pos_y=pos_y/y_len;
r=r/x_len;

end

