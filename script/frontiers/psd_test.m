%get psd from tfmap
subj = 's2';

s1_close=load('/Users/tengi/Desktop/Projects/data/Turkey/s1/Close.mat','-mat');
s2_close=load('/Users/tengi/Desktop/Projects/data/Turkey/s2/Close.mat','-mat');
close=s2_close.Close;
s='';

sm1=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_8-32_start-100_len500.smw']);
lfb_chan=sm1.name(sm1.sig==-1);
sm2=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_60-280_start-100_len500.smw']);
hfb_chan=sm2.name(sm2.sig==1);
sm3=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_300-800_start-100_len500.smw']);
ufb_chan=sm3.name(sm3.sig==1);

ers_chan = close.channame(~cellfun(@isempty,regexp(close.channame,'C*')));

% ers_chan=close.channame;
%S1
% ers_chan={'C88_S','C27_L','C80_S','C81_S','C18_L','C19_L','C20_L','C72_S','C73_S',...
%    'C74_S','C10_L','C11_L','C66_S','C67_S','C68_S'};
% ers_chan = close.channame;
% hfb_chan={'C68_S','C67_S','C66_S','C10_L','C73_S','C72_S','C20_L','C19_L',...
%     'C18_L','C81_S','C80_S','C27_L','C88_S'};
% ufb_chan={'C11_L','C74_S'};
%S2
% ers_chan={'C38_L','C39_L','C91_S','C92_S','C29_L','C30_L','C31_L','C32_L',...
%     'C83_S','C84_S','C85_S','C21_L','C22_L','C23_L','C24_L','C75_S','C76_S',...
%     'C77_S','C78_S','C13_L','C14_L','C15_L','C16_L'};

% hfb_chan={'C16_L','C32_L','C15_L','C39_L','C78_S','C92_S','C77_S','C91_S',...
%     'C14_L','C22_L','C30_L','C38_L','C76_S','C83_S','C13_L','C21_L','C29_L','C75_S'};
% ufb_chan={'C24_L','C23_L','C22_L','C31_L','C85_S','C84_S'};

idx=ismember(close.channame,close.channame);


%close=s2_close.Close;
wd=1024;
ov=512;
nfft=1024;
fs=2400;

lfb=[8,32];
hfb=[60,280];
ufb=[300,800];

fn=50;
fh=3;
% t=[0,1];%baseline
t=[1.4,1.9];%movement

baseline=[0,0.5];

t=round(t(1)*fs:t(2)*fs)+1;
baseline=round(baseline(1)*fs:baseline(2)*fs)+1;

% [b,a]=butter(2,1.5/(fs/2),'high');
% for i=1:size(close.data,3)
%     close.data(:,:,i)=filter_symmetric(b,a,close.data(:,:,i),fs,0,'iir');
% end

small_idx=~cellfun(@isempty,regexp(close.channame,'_S'));
small_idx=small_idx&ismember(close.channame,ers_chan);
small_num=sum(small_idx);

large_idx=~cellfun(@isempty,regexp(close.channame,'_L'));
large_idx=large_idx&ismember(close.channame,ers_chan);
large_num=sum(large_idx);

data=close.data(t,:,:);

small_lfb=zeros(small_num,size(data,3));
small_lfb_baseline=small_lfb;
small_hfb=zeros(small_num,size(data,3));
small_hfb_baseline=small_hfb;
small_ufb=zeros(small_num,size(data,3));
small_ufb_baseline=small_ufb;

large_lfb=zeros(large_num,size(data,3));
large_lfb_baseline=large_lfb;
large_hfb=zeros(large_num,size(data,3));
large_hfb_baseline=large_hfb;
large_ufb=zeros(large_num,size(data,3));
large_ufb_baseline=large_ufb;

freq_1=cell(small_num+large_num,1);
freq_2=freq_1;
freq_3=freq_1;
[freq_1{:}]=deal('LFB');
[freq_2{:}]=deal('HFB');
[freq_3{:}]=deal('UFB');
freq=cat(1,freq_1,freq_2,freq_3);

contact_1=cell(small_num+large_num,1);
contact_2=contact_1;
contact_3=contact_1;
[contact_1{1:small_num}]=deal('Small');
[contact_1{small_num+1:small_num+large_num}]=deal('Large');
[contact_2{1:small_num}]=deal('Small');
[contact_2{small_num+1:small_num+large_num}]=deal('Large');
[contact_3{1:small_num}]=deal('Small');
[contact_3{small_num+1:small_num+large_num}]=deal('Large');

contact=cat(1,contact_1,contact_2,contact_3);

baseline_pxx=0;
move_pxx=0;

for i=1:size(data,3)
    %trial
    trial=data(:,:,i);
    
    [pxx,f]=pwelch(trial,wd,ov,nfft,fs,'onesided');
    
    [pxx_baseline,~]=pwelch(close.data(baseline,:,i),wd,ov,nfft,fs,'onesided');
    [pxx_move,~]=pwelch(close.data(t,:,i),wd,ov,nfft,fs,'onesided');
    
    small_lfb(:,i)=sum(pxx(f>=lfb(1)&f<=lfb(2),small_idx),1)';
    small_lfb_baseline(:,i)=sum(pxx_baseline(f>=lfb(1)&f<=lfb(2),small_idx),1)';
    small_hfb(:,i)=sum(pxx(f>=hfb(1)&f<=hfb(2),small_idx),1)';
    small_hfb_baseline(:,i)=sum(pxx_baseline(f>=hfb(1)&f<=hfb(2),small_idx),1)';
    small_ufb(:,i)=sum(pxx(f>=ufb(1)&f<=ufb(2),small_idx),1)';
    small_ufb_baseline(:,i)=sum(pxx_baseline(f>=ufb(1)&f<=ufb(2),small_idx),1)';
    
    
    large_lfb(:,i)=sum(pxx(f>=lfb(1)&f<=lfb(2),large_idx),1)';
    large_lfb_baseline(:,i)=sum(pxx_baseline(f>=lfb(1)&f<=lfb(2),large_idx),1)';
    large_hfb(:,i)=sum(pxx(f>=hfb(1)&f<=hfb(2),large_idx),1)';
    large_hfb_baseline(:,i)=sum(pxx_baseline(f>=hfb(1)&f<=hfb(2),large_idx),1)';
    large_ufb(:,i)=sum(pxx(f>=ufb(1)&f<=ufb(2),large_idx),1)';
    large_ufb_baseline(:,i)=sum(pxx_baseline(f>=ufb(1)&f<=ufb(2),large_idx),1)';
    
    baseline_pxx=baseline_pxx+pxx_baseline;
    move_pxx=move_pxx+pxx_move;
end
baseline_pxx=sum(10*log10(baseline_pxx/size(data,3)),2)/sum(idx);
move_pxx=sum(10*log10(move_pxx/size(data,3)),2)/sum(idx);

figure

for i=1:round(fs/2/fn)
    baseline_pxx(fn*i-fh<f&f<fn*i+fh)=nan;
    move_pxx(fn*i-fh<f&f<fn*i+fh)=nan;
end
plot([f(:),f(:)],[baseline_pxx(:),move_pxx(:)]);
hold on
set(gcf,'position',[0,0,350,280]);
legend('Baseline','Movement');
set(gca,'fontsize',16);
ylabel('PSD (dB)');
xlabel('Frequency (Hz)');
ylim([-50,30]);
title(s);
xlim([0,1000]);
set(gcf,'color','w')
set(gca,'fontweight','bold')
set(findobj(gca,'type','line'),'linewidth',2)
set(gca,'linewidth',1)
% xticks([8,32,60,200,300,800])
% xticklabels('')
a=patch('Faces',[1,2,3,4],'Vertices',[8,-50;32,-50;32,30;8,30],'facecolor',[0,0.8,0.8],'facealpha',1,'edgecolor','none');
uistack(a,'bottom')
a=patch('Faces',[1,2,3,4],'Vertices',[60,-50;200,-50;200,30;60,30],'facecolor',[0.7,0.7,0],'facealpha',1,'edgecolor','none');
uistack(a,'bottom')
a=patch('Faces',[1,2,3,4],'Vertices',[300,-50;800,-50;800,30;300,30],'facecolor',[0.75,0.6,0.75],'facealpha',1,'edgecolor','none');
uistack(a,'bottom')
%%
figure
bp=boxplot(10*log10(cat(1,mean(small_lfb,2)./mean(small_lfb_baseline,2),...
    mean(large_lfb,2)./mean(large_lfb_baseline,2),...
    mean(small_hfb,2)./mean(small_hfb_baseline,2),...
    mean(large_hfb,2)./mean(large_hfb_baseline,2),...
    mean(small_ufb,2)./mean(small_ufb_baseline,2),...
    mean(large_ufb,2)./mean(large_ufb_baseline,2))),...
    {freq,contact},'labelverbosity','all','labelorientation','horizontal',...
    'OutlierSize',10,'positions',[1,2,3,4,5,6]);

[h1,p1]=ttest2(10*log10(mean(small_lfb,2)./mean(small_lfb_baseline,2)),10*log10(mean(large_lfb,2)./mean(large_lfb_baseline,2)),'tail','right')
[h2,p2]=ttest2(10*log10(mean(small_hfb,2)./mean(small_hfb_baseline,2)),10*log10(mean(large_hfb,2)./mean(large_hfb_baseline,2)),'tail','right')
[h3,p3]=ttest2(10*log10(mean(small_ufb,2)./mean(small_ufb_baseline,2)),10*log10(mean(large_ufb,2)./mean(large_ufb_baseline,2)),'tail','right')
title(s);
%
hold on
scatter([1,2,3,4,5,6],[mean(10*log10(mean(small_lfb,2)./mean(small_lfb_baseline,2))),mean(10*log10(mean(large_lfb,2)./mean(large_lfb_baseline,2))),...
    mean(10*log10(mean(small_hfb,2)./mean(small_hfb_baseline,2))),mean(10*log10(mean(large_hfb,2)./mean(large_hfb_baseline,2))),...
    mean(10*log10(mean(small_ufb,2)./mean(small_ufb_baseline,2))),mean(10*log10(mean(large_ufb,2)./mean(large_ufb_baseline,2)))],50,'*r')

set(gcf,'position',[500   299   350   280]);
set(gca,'fontsize',16,'fontweight','bold');
set(findobj(gca,'type','text'),'fontsize',12,'fontweight','bold')
set(gcf,'color','w');
ylim([-12,12]);
plot([-10,10],[0,0],'k-.');
set(findobj(gca,'type','line'),'linewidth',2)
ylabel('ERD/ERS (dB)')
hold on

%%
figure
% small_lfb = small_lfb_baseline;
% large_lfb = large_lfb_baseline;
% small_hfb = small_hfb_baseline;
% large_hfb = large_hfb_baseline;
% small_ufb = small_ufb_baseline;
% large_ufb = large_ufb_baseline;

bp=boxplot(10*log10(cat(1,mean(small_lfb,2),...
    mean(large_lfb,2),...
    mean(small_hfb,2),...
    mean(large_hfb,2),...
    mean(small_ufb,2),...
    mean(large_ufb,2))),...
    {freq,contact},'labelverbosity','all','labelorientation','horizontal',...
    'OutlierSize',10,'positions',[1,2,3,4,5,6]);

ttest2(10*log10(mean(small_lfb,2)),10*log10(mean(large_lfb,2)))
ttest2(10*log10(mean(small_hfb,2)),10*log10(mean(large_hfb,2)))
ttest2(10*log10(mean(small_ufb,2)),10*log10(mean(large_ufb,2)))
title(s);
%
hold on
scatter([1,2,3,4,5,6],10*log10([mean(mean(small_lfb)),mean(mean(large_lfb)),...
    mean(mean(small_hfb)),mean(mean(large_hfb)),...
    mean(mean(small_ufb)),mean(mean(large_ufb))]),50,'*r')

set(gcf,'position',[500   299   350   280]);
set(gca,'fontsize',16);
set(findobj(gca,'type','text'),'fontsize',12)
set(gcf,'color','w');
ylim([-10,35]);
set(findobj(gca,'type','line'),'linewidth',2)
ylabel('Power (dB)')
