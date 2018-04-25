%get psd from tfmap
clc
clear

subj = 's1';
s1_close=load('/Users/tengi/Desktop/Projects/data/Turkey/s1/Close.mat','-mat');
s2_close=load('/Users/tengi/Desktop/Projects/data/Turkey/s2/Close.mat','-mat');
close=s1_close;
s='';

% sm1=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_8-32_start-100_len500.smw']);
% lfb_chan=sm1.name(sm1.sig==-1);
% sm2=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_60-280_start-100_len500.smw']);
% hfb_chan=sm2.name(sm2.sig==1);
% sm3=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_300-800_start-100_len500.smw']);
% ufb_chan=sm3.name(sm3.sig==1);

% ers_chan = close.channame(~cellfun(@isempty,regexp(close.channame,'C*')));

% ers_chan=hfb_chan;
%S1
hfb_chan={'C9_L','C10_L','C11_L','C17_L','C18_L','C19_L','C20_L','C27_L',...
    'C66_S','C67_S','C68_S','C72_S','C73_S','C74_S','C80_S','C81_S','C88_S'};
%S2
% hfb_chan={'C16_L','C15_L','C14_L','C13_L','C24_L','C23_L','C22_L','C21_L','C32_L','C31_L','C30_L','C29_L','C40_L','C39_L','C38_L','C47_L',...
%   'C69_S','C78_S','C77_S','C76_S','C75_S','C85_S','C84_S','C83_S','C92_S','C91_S','C97_S'};

idx=ismember(close.channame,close.channame);


%close=s2_close.Close;
wd=1024;
ov=512;
nfft=1024;
fs=2400;

lfb=[8, 32];
hfb=[60, 280];
ufb=[300, 800];

fn=50;
fh=3;
% t=[0,1];%baseline
t=[1.4, 1.9];%movement

baseline=[0, 0.5];

t=round(t(1)*fs:t(2)*fs)+1;
baseline=round(baseline(1)*fs:baseline(2)*fs)+1;

% [b,a]=butter(2,1.5/(fs/2),'high');
% for i=1:size(close.data,3)
%     close.data(:,:,i)=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,close.data(:,:,i),fs,0,'iir');
% end

small_idx=~cellfun(@isempty,regexp(close.channame,'_S'));
small_idx=small_idx&ismember(close.channame,hfb_chan);
small_num=sum(small_idx);

large_idx=~cellfun(@isempty,regexp(close.channame,'_L'));
large_idx=large_idx&ismember(close.channame,hfb_chan);
large_num=sum(large_idx);

data=close.data(t,:,:);

freq_1=cell(small_num+large_num,1);
freq_2=freq_1;
freq_3=freq_1;
freq_4=freq_1;
[freq_1{:}]=deal('LFB');
[freq_2{:}]=deal('HFB');
[freq_3{:}]=deal('UFB');
freq=cat(1,freq_1, freq_2,freq_3);

contact_1=cell(small_num+large_num,1);
contact_2=contact_1;
contact_3=contact_1;
[contact_1{1:small_num}]=deal('Small');
[contact_1{small_num+1:small_num+large_num}]=deal('Large');
[contact_2{1:small_num}]=deal('Small');
[contact_2{small_num+1:small_num+large_num}]=deal('Large');
[contact_3{1:small_num}]=deal('Small');
[contact_3{small_num+1:small_num+large_num}]=deal('Large');

contact=cat(1,contact_1, contact_2,contact_3);

for i=1:size(data,3)
    [b1, a1] = butter(2, [8, 32]/(fs/2));
    [b2, a2] = butter(2, [60, 280]/(fs/2));
    [b3, a3] = butter(2, [300, 800]/(fs/2));
    [b4, a4] = butter(2, 800/(fs/2),'high');

    lfb_signal(:, :, i) = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b1, a1, close.data(:,:,i), [], 0, 'iir');
    hfb_signal(:, :, i) = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b2, a2, close.data(:,:,i), [], 0, 'iir');
    ufb_signal(:, :, i) = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b3, a3, close.data(:,:,i), [], 0, 'iir');
    rfb_signal(:, :, i) = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b4, a4, close.data(:,:,i), [], 0, 'iir');
    
%     [pxx_baseline,~]=pwelch(close.data(baseline,:,i),wd,ov,nfft,fs,'onesided');
%     [pxx_move,~]=pwelch(close.data(t,:,i),wd,ov,nfft,fs,'onesided');
    
    small_lfb(:, i) = mean(lfb_signal(t, small_idx, i).^2, 1);
    small_lfb_baseline(:, i)= mean(lfb_signal(baseline, small_idx, i).^2, 1);
    small_hfb(:, i) = mean(hfb_signal(t, small_idx, i).^2, 1);
    small_hfb_baseline(:, i)= mean(hfb_signal(baseline, small_idx, i).^2, 1);
    small_ufb(:, i) = mean(ufb_signal(t, small_idx, i).^2, 1);
    small_ufb_baseline(:, i)= mean(ufb_signal(baseline, small_idx, i).^2, 1);
    
    large_lfb(:, i) = mean(lfb_signal(t, large_idx, i).^2, 1);
    large_lfb_baseline(:, i)= mean(lfb_signal(baseline, large_idx, i).^2, 1);
    large_hfb(:, i) = mean(hfb_signal(t, large_idx, i).^2, 1);
    large_hfb_baseline(:, i)= mean(hfb_signal(baseline, large_idx, i).^2, 1);
    large_ufb(:, i) = mean(ufb_signal(t, large_idx, i).^2, 1);
    large_ufb_baseline(:, i)= mean(ufb_signal(baseline, large_idx, i).^2, 1);
end
%%
figure
small_lfb = 10*log10(mean(small_lfb, 2)./mean(small_lfb_baseline, 2));
large_lfb = 10*log10(mean(large_lfb, 2)./mean(large_lfb_baseline,2));
small_hfb = 10*log10(mean(small_hfb, 2)./mean(small_hfb_baseline, 2));
large_hfb = 10*log10(mean(large_hfb, 2)./mean(large_hfb_baseline,2));
small_ufb = 10*log10(mean(small_ufb, 2)./mean(small_ufb_baseline, 2));
large_ufb = 10*log10(mean(large_ufb, 2)./mean(large_ufb_baseline,2));


bp=boxplot(cat(1,...
    small_lfb,...
    large_lfb,...
    small_hfb,...
    large_hfb,...
    small_ufb,...
    large_ufb),...
    {cat(1, freq_1, freq_2, freq_3),cat(1, contact_1, contact_2, contact_3)},'labelverbosity','all','labelorientation','horizontal',...
    'OutlierSize',10,'positions',[1,2,3,4,5,6]);
hold on
scatter([1,2,3,4,5,6],[mean(small_lfb), mean(large_lfb), mean(small_hfb),mean(large_hfb), mean(small_ufb), mean(large_ufb)], 50, '*r')
ylabel('ERD/ERS (dB)')
set(gca,'fontsize',16);
set(findobj(gca,'type','text'),'fontsize',12)
set(gcf,'color','w');
% ylim([-10, 35]);
set(findobj(gca,'type','line'),'linewidth',2)


%%
[~, p1] = ttest2(small_lfb, large_lfb, 'tail', 'both')
[~, p2] = ttest2(small_hfb, large_hfb, 'tail', 'both')
[~, p3] = ttest2(small_ufb, large_ufb, 'tail', 'both')

%
set(gcf,'position',[424   154   350   280]);
%%
ylim([-13, 13])

hold on
plot([0, 7], [0, 0],'-.k','linewidth', 2)
box off

text_h = findobj(gca, 'Type', 'text');
for cnt = 1:length(text_h)
        yshift=get(text_h(cnt), 'Position');
        yshift(2)=yshift(2)-10;
%         yshift(1)=yshift(1)+5;
        set(text_h(cnt), 'Position', yshift, 'fontweight', 'bold');
end
set(gca, 'fontweight','bold')

