curvexy = [0 0;1 0;2 1;0 .5;0 0];
mapxy = [3 4;.5 .5;3 -1];
[xy,distance,t] = distance2curve(curvexy,mapxy,'linear');
% xy =
%                          2                         1
%          0.470588235294118         0.617647058823529
%                        1.5                       0.5
% distance =
%           3.16227766016838
%          0.121267812518166
%           2.12132034355964
% t =
%          0.485194315877587
%          0.802026225550702
%           0.34308419095021


plot(curvexy(:,1),curvexy(:,2),'k-o',mapxy(:,1),mapxy(:,2),'r*')
hold on
plot(xy(:,1),xy(:,2),'g*')
line([mapxy(:,1),xy(:,1)]',[mapxy(:,2),xy(:,2)]','color',[0 0 1])
axis equal

%%
% Solve for the nearest point on the curve of a 3-d quasi-elliptical
% arc (sampled and interpolated from 20 points) mapping a set of points
% along a surrounding circle onto the ellipse. This is the example
% used to generate the screenshot figure.
t = linspace(0,2*pi,20)';
curvexy = [cos(t) - 1,3*sin(t) + cos(t) - 1.25,(t/2 + cos(t)).*sin(t)];

s = linspace(0,2*pi,100)';
mapxy = 5*[cos(s),sin(s),sin(s)];
xy = distance2curve(curvexy,mapxy,'spline');

plot3(curvexy(:,1),curvexy(:,2),curvexy(:,3),'ko')
line([mapxy(:,1),xy(:,1)]',[mapxy(:,2),xy(:,2)]',[mapxy(:,3),xy(:,3)]','color',[0 0 1])
axis equal
axis square
box on
grid on
view(26,-6)