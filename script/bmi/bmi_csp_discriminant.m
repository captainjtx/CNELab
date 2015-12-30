%CSP test
clc
clear
% fname1='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/Close.mat';
% fname2='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/Open.mat';

fname1='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/Close.mat';
fname2='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/Open.mat';

% fname1='/Users/tengi/Desktop/Projects/data/BMI/abduction/lima/Abd.mat';
% fname2='/Users/tengi/Desktop/Projects/data/BMI/abduction/lima/Add.mat';

movements={'Close','Open'};
% movements={'Abd','Add'};


segments{1}=load(fname1);
segments{2}=load(fname2);

fs=segments{1}.(movements{1}).fs;
channelnames=segments{1}.(movements{1}).channame;

for i=1:length(channelnames)
    t=channelnames{i};
    channelindex(i)=str2double(t(2:end));
end

% csp_max_min='max','min';

%up-gamma band
lc=60;
hc=200;

%alpha band
% lc=8;
% hc=13;
%beta band
% lc=13;
% hc=30;

%alpha&beta band
% lc=8;
% hc=30;

%all band
% lc=8;
% hc=200;

% baseline_time=[0 1.7];
baseline_time=[0.6 1.3];
% baseline_time=[1.3,1.7];
baseline_sample=round(baseline_time(1)*fs+1):round(baseline_time(2)*fs);
move_time=[1.3 2];
% move_time=[1.7 2.5];
move_sample=round(move_time(1)*fs):round(move_time(2)*fs);

%CSP parameters
NF=2;
%Desired sparsity of the filter
SpL=5;
%**************************************************************************

%Filter the data===========================================================
for i=1:length(movements)
    seg=segments{i}.(movements{i}).data;
    for j=1:size(seg,3)
        [b,a]=butter(2,[lc hc]/(fs/2));
        segments{i}.(movements{i}).data(:,:,j)=filter_symmetric(b,a,seg(:,:,j),fs,0,'iir');
    end
end
%==========================================================================
seg=cell(2,1);
seg{1}=segments{1}.(movements{1}).data;
seg{2}=segments{2}.(movements{2}).data;
X=[];
Y=[];
%Rest
%     for k=1:size(seg,3)
%         for m=1:size(seg,2)
%             Y(:,m,k)=abs(hilbert(seg(baseline_sample,m,k)));
%         end
%     end

Y=seg{2}(move_sample,:,:);
%Move


%     for k=1:size(seg,3)
%         for m=1:size(seg,2)
%             X(:,m,k)=abs(hilbert(seg(move_sample,m,k)));
%         end
%     end
X=seg{1}(move_sample,:,:);

Cx=0;
Cy=0;

for t=1:size(seg{1},3)
    ctmp=cov(X(:,:,t));
    
    Cx=Cx+ctmp/trace(ctmp);
end
for t=1:size(seg{2},3)
    ctmp=cov(Y(:,:,t));
    
    Cy=Cy+ctmp/trace(ctmp);
end

Cx=Cx/size(seg{1},3);
Cy=Cy/size(seg{2},3);

%Sparse CSP, recursive weight elimination


% [F{1},Lmd{1}]=recursive_eliminate(Cx,Cy,SpL,NF);
% 
% [F{2},Lmd{2}]=recursive_eliminate(Cy,Cx,SpL,NF);
% Original CSP
%**********************************************************************
%Generalized Eigen-Value problem
%See Simultaneous Diagonalization
%Lmd=Move/Rest

[W{1},Lmd{1}]=eig(Cx,Cy);

[Lmd{1},id]=sort(diag(Lmd{1}),'descend');

Wf{1}=W{1}(:,id);

NF_ind=1:NF;

W{1}=Wf{1}(:,NF_ind);
P{1}=inv(Wf{1})';
P{1}=P{1}(:,NF_ind);
F{1}=W{1};

Lmd{1}=Lmd{1}(NF_ind);
channames=cell(1,length(NF_ind));

for n=1:length(NF_ind)
    channames{n}=['CSP ' num2str(NF_ind(n))];
end


[W{2},Lmd{2}]=eig(Cx,Cy);

[Lmd{2},id]=sort(diag(Lmd{2}),'descend');

Wf{2}=W{2}(:,id);


len=size(Wf{2},2);

NF_ind=len:-1:len-NF+1;

W{2}=Wf{2}(:,NF_ind);
P{2}=inv(Wf{2})';
P{2}=P{2}(:,NF_ind);
F{2}=W{2};

Lmd{2}=Lmd{2}(NF_ind);
channames=cell(1,length(NF_ind));

for n=1:length(NF_ind)
    channames{n}=['CSP ' num2str(NF_ind(n))];
end
%**********************************************************************


%visualize the transformed data****************************************
%     data=[];
%     evts={};
%     rdata=[];
%     for s=1:size(seg,3)
%
%         evts=cat(1,evts,{size(data,1)/fs,'Rest'});
%         d1=Y(:,:,s)*W;
%         data=cat(1,data,d1);
%
%         rdata=cat(1,rdata,Y(:,:,s));
%
%         evts=cat(1,evts,{size(data,1)/fs,movements{i}});
%
%         d2=X(:,:,s)*W;
%         data=cat(1,data,d2);
%
%         rdata=cat(1,rdata,X(:,:,s));
%     end

%     bsp=BioSigPlot(data,'Evts',evts,'SRate',fs,'ChanNames',channames,'Title',movements{i},...
%         'WinLength',14,'Position',[0,0,600,200],'Gain',0.24);
%     BioSigPlot(rdata,'Evts',evts,'SRate',fs,'Title',movements{i});
%**********************************************************************
dw=30;
dh=30;

interval=30;
figpos=[0,0,400*NF,335*2];
%======================================================================
chan_order=channelindex;

axe1_pattern=zeros(1,NF);
axe1_filter=zeros(1,NF);
clim1_pattern=[inf,-inf];
clim1_filter=[inf,-inf];

hf=figure('Name',['Max ',movements{1}],'Position',figpos);

for m=1:NF
    axe1_pattern(m)=axes('Parent',hf,'Units','Pixels','Position',[(m-1)*(interval+dw*12)+interval/2,interval/2+335,12*dw,10*dh]);
    [pmax,pmin]=gauss_interpolate_120_grid(axe1_pattern(m),P{1}(:,m),chan_order,[],dw,dh);
    title(['CSP ' num2str(m), '  Lambda: ',num2str(Lmd{1}(m)),' Pattern'])
    if pmax>clim1_pattern(2)
        clim1_pattern(2)=pmax;
    end
    if pmin<clim1_pattern(1)
        clim1_pattern(1)=pmin;
    end
    axe1_filter(m)=axes('Parent',hf,'Units','Pixels','Position',[(m-1)*(interval+dw*12)+interval/2,interval/2,12*dw,10*dh]);
    [fmax,fmin]=gauss_interpolate_120_grid(axe1_filter(m),F{1}(:,m),chan_order,[],dw,dh);
    title(['CSP' num2str(m),' Filter'])
    if fmax>clim1_filter(2)
        clim1_filter(2)=fmax;
    end
    if fmin<clim1_filter(1)
        clim1_filter(1)=fmin;
    end
end

export_fig(hf,'-png','-r300',get(hf,'Name'));
close(hf)

hf=figure('Name',['Max ',movements{2}],'Position',figpos);

for m=1:NF
    axe1_pattern(m)=axes('Parent',hf,'Units','Pixels','Position',[(m-1)*(interval+dw*12)+interval/2,interval/2+335,12*dw,10*dh]);
    [pmax,pmin]=gauss_interpolate_120_grid(axe1_pattern(m),P{2}(:,m),chan_order,[],dw,dh);
    title(['CSP ' num2str(m), '  Lambda: ',num2str(Lmd{2}(m)),' Pattern'])
    if pmax>clim1_pattern(2)
        clim1_pattern(2)=pmax;
    end
    if pmin<clim1_pattern(1)
        clim1_pattern(1)=pmin;
    end
    axe1_filter(m)=axes('Parent',hf,'Units','Pixels','Position',[(m-1)*(interval+dw*12)+interval/2,interval/2,12*dw,10*dh]);
    [fmax,fmin]=gauss_interpolate_120_grid(axe1_filter(m),F{2}(:,m),chan_order,[],dw,dh);
    title(['CSP' num2str(m),' Filter'])
    if fmax>clim1_filter(2)
        clim1_filter(2)=fmax;
    end
    if fmin<clim1_filter(1)
        clim1_filter(1)=fmin;
    end
end

export_fig(hf,'-png','-r300',get(hf,'Name'));
close(hf)


