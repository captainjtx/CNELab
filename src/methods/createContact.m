function [top,side] = createContact(x,y,z,Vn,r,d)
%create a 3d contact at specified locations

%creating the polygon face of contact
%Using n polygon to simulate circle
n=32;

if Vn(1)~=0
    Vp=[-Vn(2),Vn(1),0];
elseif Vn(2)~=0
    Vp=[-Vn(2),Vn(1),0];
else
    Vp=[0,Vn(3),-Vn(2)];
end

Vn=Vn/norm(Vn);
Vp=Vp/norm(Vp);

top.vertices=zeros(n,3);

side.vertices=zeros(n*4,3);
side.faces=zeros(n,4);

R=r*tan(2*pi/n);
for i=1:n
    top.vertices(i,:)=[x,y,z]+Vp*r;
    %Tangent direction
    Vt=cross(Vp,Vn);
%     Vt(1) = Vp(2) * Vn(3) - Vp(3) * Vn(2);
%     Vt(2) = Vp(3) * Vn(1) - Vp(1) * Vn(3);
%     Vt(3) = Vp(1) * Vn(2) - Vp(2) * Vn(1);
    Vt=Vt/norm(Vt);
    
    Vp=Vp+Vt*R;
    Vp=Vp/norm(Vp);
    
    preVert=top.vertices(i,:);
    newVert=[x,y,z]+Vp*r;
    
    side.vertices((i-1)*4+1,:)=preVert;
    side.vertices((i-1)*4+2,:)=newVert;
    
    side.vertices((i-1)*4+3,:)=newVert+d*(-Vn);
    side.vertices((i-1)*4+4,:)=preVert+d*(-Vn);
    
    side.faces(i,:)=[(i-1)*4+1,(i-1)*4+2,(i-1)*4+3,(i-1)*4+4];
end

top.faces=1:n;
end

