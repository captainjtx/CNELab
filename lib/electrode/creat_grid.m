function [x,y,z]=creat_grid(col,row,curv,X,Y,Z,size)
%size is spacing
a = size;
b = size;
c = size;

curv=1/curv;

%[ s, t ] = meshgrid( 0 : pi/(curv*(col-1)) : pi*(row-1)/(curv*(col-1)), 0: pi/(curv*(col-1)) : pi/curv );


% 
 xx=0:pi/(col-1):pi;
 
 yy=0:pi/(col-1):(pi/(col-1))*(row-1);
 shift=round((col-row)/2)*(pi/(col-1));
 
 yy=yy+shift;
 [x,y]=meshgrid(xx,yy);
 z=sin(x)/(curv/1.2)+sin(y)/(curv/1.5);
 x=size*x;y=size*y;z=size*z;
% 
% x = a * cos(s) .* cos( t );
% y = b * cos(s) .* sin( t );
% z = c/curv * sin(s);

%[x,y,z] = meshgrid(1:10:80,1,1:10:80);


% z rotation
ang = pi/2;
%ang=0;
xt = x * cos( ang ) - y * sin( ang );
yt = x * sin( ang ) + y * cos( ang );

% x rotation
ang2 = pi/(3);
ang2=0;
yt = y * cos( ang2 ) - z * sin( ang2 );
zt = y * sin( ang2 ) + z * cos( ang2 );

% y rotation
ang3 = pi/(-3);
ang3=0;
xt = z * sin( ang3 ) + x * cos( ang3 );
zt = z * cos( ang3 ) - x * sin( ang3 );

% translation
shiftx = X;
shifty = Y;
shiftz = Z;
x = xt + shiftx;
y = yt + shifty;
z = zt  + shiftz;

x = x(:);
y = y(:);
z = z(:);

