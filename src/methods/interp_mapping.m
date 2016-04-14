function s = interp_mapping(coor, map)
%   Generates interpolated color map
%   location: the N by 3 coordinates of the grid contacts
%   map:      the activation/event distribution matrix
%   By Su Liu 
%   Modified by Tianxiao Jiang Apr 14 2016
in = interp2(map,4,'cubic');
%colormap jet
C = colormap;
L = size(C,1);
ins = round(interp1(linspace(min(in(:)),max(in(:)),L),1:L,in));
ins=ins';
H = reshape(C(ins,:),[size(ins) 3]);
x = coor(:,1);
y = coor(:,2);
z = coor(:,3);
a = size(map,1);
b = size(map,2);
xx=reshape(x,a,b);
yy=reshape(y,a,b);
zz=reshape(z,a,b);
xx=interp2(xx,4,'cubic');
yy=interp2(yy,4,'cubic');
zz=interp2(zz,4,'cubic');
s=surf(xx,yy,zz,'edgecolor','none','CData',H);