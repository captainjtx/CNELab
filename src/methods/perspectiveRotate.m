function  new_coor= perspectiveRotate(coor,origin,viewpos,ud,lr)
%Rotate V with respect to the perspective vector Vp
%ud, rad of up and down rotation, postive is up, negative is down
%lr, degree of left and right rotation, positive is right, negative is left

%Vp is usually defined as the camera location with respect to the center of
%the object

%By Tianxiao Jiang
%Apr-15-2016

center=mean(coor,1);

Vp=viewpos-origin;
V=center-origin;
R1=rot(Vp,lr);
V=V(:);
Vr=R1*V;
Vt=cross(Vp,V);

R2=rot(Vt,ud);
Vr=R2*Vr;

new_coor=coor-ones(size(coor,1),1)*center+ones(size(coor,1),1)*(Vr'+origin);

end


