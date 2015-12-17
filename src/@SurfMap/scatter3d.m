function [H,H2,H3]=scatter3d(lx,ly,lz,color,msize,alpha,type,plot,hc)
if nargin<7
    type=1;
    plot=1;
end
if nargin<8
    plot=1;
    hc=[];
end
N=length(lx);
alpha=1;
X=[];
Y=[];
Z=[];
x2=[];
y2=[];
z2=[];

orig_msize=msize;

tp=[mean(lx) mean(ly) max(lz)];%top of the sphere
e=12;
switch type
    case 1
        msize=2.5;
    case 2
        msize=4;
    case 3
        msize=1.5;
    case 4
        msize=0.8;
        [xs,ys,zs]=cylinder(msize-0.1,e);
        zzs=[zs(1,:);zs(2,:)*90-1];
        Pr=rot3d([xs(:),ys(:),zzs(:)],[0 0 0],[0 1 0],pi/2);
        xs=reshape(Pr(:,1),2,e+1);
        ys=reshape(Pr(:,2),2,e+1);
        zzs=reshape(Pr(:,3),2,e+1);
        XS=xs+lx(1)-3;
        YS=ys+ly(1);
        ZS=zzs+lz(1);
    case 5
        msize=2.5;
        %[ tp, ~, ~, ~ ] = ellipsoid_fit([lx ly lz],3);
        %tp=tp';
        tp=hc;
end

if ~isempty(orig_msize)
    msize=orig_msize;
end

na=nan(2,1);
na2=nan(e,1);


if size(color,1)==1
    color=repmat(color,N,1);
elseif size(color,2)==1
    cmap=colormap;
    [~,A]=sort(color);
    color=cmap(A,:);
end
for i=1:N
    cx=lx(i);
    cy=ly(i);
    cz=lz(i);
    r=msize;
    %[x,y,z]=sphere(15);
    [x,y,z]=cylinder(r,e-1);
    rr=1;
    t=linspace(0,2*pi,e);
    %di=t(2)-t(1);
    %t=t-di;
    rt=linspace(0,r,e);
    [t,rt]=meshgrid(t,rt);
    if type==4
        zz=[z(1,:);z(2,:)*4-1];%contact length = cylinder hight
        Pr=rot3d([x(:),y(:),zz(:)],[0 0 0],[0 1 0],pi/2);
        x=reshape(Pr(:,1),2,e);
        y=reshape(Pr(:,2),2,e);
        zz=reshape(Pr(:,3),2,e);
        X=[X x*rr+cx na];
        Y=[Y y*rr+cy na];
        Z=[Z zz+cz na];
        h=cz;
        xx2=rt.*cos(t);
        yy2=rt.*sin(t);
        zz2=ones(size(rt));
        Pr=rot3d([xx2(:),yy2(:),zz2(:)],[0 0 0],[0 1 0],pi/2);
        xx2=reshape(Pr(:,1),e,e);
        yy2=reshape(Pr(:,2),e,e);
        zz2=reshape(Pr(:,3),e,e);
        x2=[x2 xx2+cx na2];
        y2=[y2 yy2+cy na2];
        z2=[z2 zz2+cz na2];

    else
        %%%%%%%%%%%rotate each individual contacts%%%%%%%%%%%%%%%%%
        if type==5
            angle=-1.2*(pi/2+asin((tp(3)-cz)/norm(tp-[cx cy cz])));
        else
            if N>=32
                angle=-1.5*asin((tp(3)-cz)/norm(tp-[cx cy cz]));
            else
                angle=-0.5*asin((tp(3)-cz)/norm(tp-[cx cy cz]));
            end
        end
        xx=x+cx;
        yy=y+cy;
        zz=z+cz;
        Pr=rot3d([xx(:),yy(:),zz(:)],[cx cy cz],[-(tp(2)-cy) tp(1)-cx tp(3)-cz],angle);
        xx=reshape(Pr(:,1),2,e);
        yy=reshape(Pr(:,2),2,e);
        zz=reshape(Pr(:,3),2,e);
        Z=[Z zz na];
        X=[X xx na];
        Y=[Y yy na];
        %h=z+1.05;
        %h=max(max(z))+1.05;
        xx2=rt.*cos(t)+cx;
        yy2=rt.*sin(t)+cy;
        zz2=(cz+1)*ones(size(rt));
        Pr=rot3d([xx2(:),yy2(:),zz2(:)],[cx cy cz],[-(tp(2)-cy) tp(1)-cx tp(3)-cz],angle);
        xx2=reshape(Pr(:,1),e,e);
        yy2=reshape(Pr(:,2),e,e);
        zz2=reshape(Pr(:,3),e,e);
        x2=[x2 xx2 na2];
        y2=[y2 yy2 na2];
        z2=[z2 zz2 na2];
        %end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Z=[Z z*rr+cz na];
%         X=[X x*rr+cx na];
%         Y=[Y y*rr+cy na];
%         h=z+1.05;
%         x2=[x2 rt.*cos(t)+cx na2];
%         y2=[y2 rt.*sin(t)+cy na2];
%         z2=[z2 (cz+1)*ones(size(rt)) na2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot==1
    H=surf(X,Y,Z,'facecolor',color(i,:),'LineStyle','none','facealpha',alpha);
    hold on
    H2=surf(x2,y2,z2,'facecolor',color(i,:),'LineStyle','none','facealpha',alpha);
    if type==4
        H3=surf(XS,YS,ZS,'facecolor',[0 0 0],'facealpha',0.3,...
        'LineStyle','none');
    else
        H3=[];
    end
    hold off
else
    H=surf2patch(X,Y,Z);
    H2=surf2patch(x2,y2,z2);
    if type==4
        H3=surf2patch(XS,YS,ZS);
    else
        H3=[];
    end
end
