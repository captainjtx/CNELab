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
csp_max_min='max';%CSP--Move/Rest

%alpha band
% lc=8;
% hc=13;
%beta band
% lc=13;
% hc=30;

%alpha&beta band
% lc=8;
% hc=30;
% csp_max_min='min';%CSP--Move/Rest

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
NF=1;
%Desired sparsity of the filter
SpL=[1:6,8,10,12,16,20,30,40,60,80,120];
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

%======================================================================

hf=figure('Name',[csp_max_min,' ',movements{1},' QR']);

Lmd=zeros(size(SpL));
for f=1:length(SpL)
    if strcmpi(csp_max_min,'max')
        [~,Lmd(f)]=recursive_eliminate(Cx,Cy,SpL(f),1);
    else
        [~,Lmd(f)]=recursive_eliminate(Cy,Cx,SpL(f),1);
    end
end

plot(SpL,Lmd/max(Lmd),'-o','linewidth',2,'MarkerSize',8);
xlabel('Cardinality')
ylabel('Normalized RQ')
set(gca,'Fontsize',14)
ylim([0,1])
export_fig(hf,'-png','-r300',['/Users/tengi/Desktop/publication/grand/scsp dis/s2 hfb ' get(hf,'Name')]);
close(hf)

