clear
clc

source_num=2;
chan_num=120;
fs=1000;
t=2;

c=8;

A=zeros(source_num,chan_num);
S=zeros(fs*t,source_num);

A(:,4)=[0.5;0.3];
A(:,5)=[0.6;0.2];
A(:,6)=[0.2;0.7];
A(:,7)=[0.6;0.5];
A(:,8)=[0.5;0.4];
A(:,17)=[0.5;0.7];
A(:,18)=[0.7;1];
A(:,19)=[0.9;1];
A(:,29)=[0.7;0.3];
A(:,30)=[0.3;1];
A(:,31)=[0.7;1];
A(:,42)=[0.7;0.5];
A(:,43)=[0.7,0.5];

Sx(:,1)=randn(fs*t,1);
Sx(:,2)=randn(fs*t,1);

Sy(:,1)=randn(fs*t,1)*0.1;
Sy(:,2)=randn(fs*t,1)*0.1;

X=Sx*A;
X=X+randn(size(X))*c;

Y=Sy*A;
Y=Y+randn(size(Y))*c;

Cx=cov(X);
% Cx=Cx/trace(Cx);
Cy=cov(Y);
% Cy=Cy/trace(Cy);

[W,Lmd]=eig(Cy,Cx);
Lmd=diag(Lmd);

[Lmd,ind]=sort(Lmd);
W=W(:,ind);

% for w=1:size(W,2)
%     if abs(max(W(:,w)))>abs(min(W(:,w)))
%         W(:,w)=-W(:,w);
%     end
% end

P=inv(W)';

len=size(P,2);
NF_oneside=3;



P=P(:,[1:NF_oneside,len-NF_oneside+1:len]);

F=W(:,[1:NF_oneside,len-NF_oneside+1:len]);

Lmd=Lmd([1:NF_oneside,len-NF_oneside+1:len]);

for p=size(P,2)
    P(:,p)=P(:,p)/(sum(P(:,p).^2))^0.5;
    
end

for f=size(F,2)
    F(:,f)=F(:,f)/(sum(F(:,f).^2))^0.5;
end

figpos=[0,0,1220,670];
dw=30;
dh=30;

interval=30;
channelindex=1:120;

h=figure('Position',figpos);

axe2_pattern=zeros(1,NF_oneside);
axe2_filter=zeros(1,NF_oneside);
clim2_pattern=[inf,-inf];
clim2_filter=[inf,-inf];

for m=1:NF_oneside
    %     count=2*NF_oneside-m+1;
    count=m;
    %         subplot(2,NF_oneside,m)
    
    axe2_pattern(m)=axes('Units','Pixels','Position',[(m-1)*(interval+dw*12)+interval/2,dh*10+interval*1.5,12*dw,10*dh]);
    [pmax,pmin]=gauss_interpolate_120_grid(axe2_pattern(m),P(:,count)/max(abs(P(:,count))),channelindex,dw,dh);
    title(['CSP ' num2str(-m),' Lambda: ',num2str(Lmd(count)),' Pattern'])
    
    if pmax>clim2_pattern(2)
        clim2_pattern(2)=pmax;
    end
    if pmin<clim2_pattern(1)
        clim2_pattern(1)=pmin;
    end
    
    %         subplot(2,NF_oneside,m+NF_oneside)
    axe2_filter(m)=axes('Units','Pixels','Position',[(m-1)*(interval+dw*12)+interval/2,interval/2,12*dw,10*dh]);
    [fmax,fmin]=gauss_interpolate_120_grid(axe2_filter(m),F(:,count)/max(abs(F(:,count))),channelindex,dw,dh);
    title(['CSP' num2str(-m),' Filter'])
    if fmax>clim2_filter(2)
        clim2_filter(2)=fmax;
    end
    if fmin<clim2_filter(1)
        clim2_filter(1)=fmin;
    end
end

for j=1:NF_oneside
    set(axe2_pattern(j),'CLim',[-1 1]);
    set(axe2_filter(j),'CLim',[-1 1]);
end

pos=get(axe2_pattern(3),'position');
axes(axe2_pattern(3));
cb=colorbar('Units','Pixels');
cbpos=get(cb,'position');
set(axe2_pattern(3),'position',pos);
set(cb,'position',[pos(1)+pos(3)+interval/2,cbpos(2),cbpos(3),cbpos(4)]);

pos=get(axe2_filter(3),'position');
axes(axe2_filter(3));
cb=colorbar('Units','Pixels');
cbpos=get(cb,'position');
set(axe2_filter(3),'position',pos);
set(cb,'position',[pos(1)+pos(3)+interval/2,cbpos(2),cbpos(3),cbpos(4)]);