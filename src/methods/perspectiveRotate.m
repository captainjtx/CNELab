function  Vr= perspectiveRotate(V,Vp,ud,lr)
%Rotate V with respect to the perspective vector Vp
%ud, rad of up and down rotation, postive is up, negative is down
%lr, degree of left and right rotation, positive is right, negative is left

%Vp is usually defined as the camera location with respect to the center of
%the object

%By Tianxiao Jiang
%Apr-15-2016

R1=rot(Vp,lr);
V=V(:);
Vr=R1*V;

Vt=cross(Vp,V);

R2=rot(Vt,ud);
Vr=R2*Vr;
end


