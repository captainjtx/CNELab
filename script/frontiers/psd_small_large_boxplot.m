%get psd from tfmap
clear
clc

subj = 's1';

close=load(['/Users/tengi/Desktop/Projects/data/Turkey/', subj, '/Close.mat'],'-mat');
s='';

% sm1=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_8-32_start-100_len500.smw']);
% lfb_chan=sm1.name(sm1.sig==-1);
% sm2=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_60-280_start-100_len500.smw']);
% hfb_chan=sm2.name(sm2.sig==1);
% sm3=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_300-800_start-100_len500.smw']);
% ufb_chan=sm3.name(sm3.sig==1);

%S1
hfb_chan={'C9_L','C10_L','C11_L','C17_L','C18_L','C19_L','C20_L','C27_L',...
    'C66_S','C67_S','C68_S','C72_S','C73_S','C74_S','C80_S','C81_S','C88_S'};
%S2
% hfb_chan={'C16_L','C15_L','C14_L','C13_L','C24_L','C23_L','C22_L','C21_L','C32_L','C31_L','C30_L','C29_L','C40_L','C39_L','C38_L','C47_L',...
%   'C69_S','C78_S','C77_S','C76_S','C75_S','C85_S','C84_S','C83_S','C92_S','C91_S','C97_S'};

small_idx=~cellfun(@isempty,regexp(close.channame,'_S'));
small_idx=small_idx&ismember(close.channame,hfb_chan);
large_idx=~cellfun(@isempty,regexp(close.channame,'_L'));
large_idx=large_idx&ismember(close.channame,hfb_chan);
small_num=sum(small_idx);
large_num=sum(large_idx);

%close=s2_close.Close;
wd=512;
ov=500;
nfft=1024;
fs=2400;

lfb=[8,32];
hfb=[60,280];
ufb=[300,800];

% t=[0,1];%baseline
t=[1.4,1.9];%movement

baseline=[0,0.5];

t=round(t(1)*fs:t(2)*fs)+1;
baseline=round(baseline(1)*fs:baseline(2)*fs)+1;

baseline_pxx=0;
move_pxx=0;

for i=1:size(close.data,3)
    [pxx_baseline, f]=pwelch(close.data(baseline, :, i),wd,ov,nfft,fs,'onesided');
    [pxx_move, f]=pwelch(close.data(t, :, i),wd,ov,nfft,fs,'onesided');
    
    baseline_pxx=baseline_pxx+pxx_baseline;
    move_pxx=move_pxx+pxx_move;
end

baseline_pxx = baseline_pxx/size(close.data, 3);
move_pxx = move_pxx/size(close.data, 3);

lfb_idx = f >= lfb(1) & f <= lfb(2);
hfb_idx = f >= hfb(1) & f <= hfb(2);
ufb_idx = f >= ufb(1) & f <= ufb(2);
nf_idx = f >= 800 & f <= 1000;

resp4800=[2.25 2.25 2.24 2.16 2 1.83 1.6 1.35 1.0 0.54 0.385 0.27 0.175 0.115 0.07 0.035 0.02 0.01]/2.25;
f4800=[0 100 200 400 600 800 1000 1200 1500 2000 2200 2400 2600 2800 3000 3250 3500 4000];
f2400 = f4800/2;
H = interp1(f2400,resp4800, f, 'pchip');
H = H(:);

baseline_pxx = baseline_pxx./(abs(H(1:length(f))).^2);
move_pxx = move_pxx./(abs(H(1:length(f))).^2);

baseline_lfb_small = sum(baseline_pxx(lfb_idx, small_idx), 1);
move_lfb_small = sum(move_pxx(lfb_idx, small_idx), 1);

baseline_hfb_small = sum(baseline_pxx(hfb_idx, small_idx), 1);
move_hfb_small = sum(move_pxx(hfb_idx, small_idx), 1);

baseline_ufb_small = sum(baseline_pxx(ufb_idx, small_idx), 1);
move_ufb_small = sum(move_pxx(ufb_idx, small_idx), 1);

baseline_nf_small = sum(baseline_pxx(nf_idx, small_idx), 1);
move_nf_small = sum(move_pxx(nf_idx, small_idx), 1);


baseline_lfb_large = sum(baseline_pxx(lfb_idx, large_idx), 1);
move_lfb_large = sum(move_pxx(lfb_idx, large_idx), 1);

baseline_hfb_large = sum(baseline_pxx(hfb_idx, large_idx), 1);
move_hfb_large = sum(move_pxx(hfb_idx, large_idx), 1);

baseline_ufb_large = sum(baseline_pxx(ufb_idx, large_idx), 1);
move_ufb_large = sum(move_pxx(ufb_idx, large_idx), 1);

baseline_nf_large = sum(baseline_pxx(nf_idx, large_idx), 1);
move_nf_large = sum(move_pxx(nf_idx, large_idx), 1);

freq_1=cell(small_num+large_num,1);
freq_2=freq_1;
freq_3=freq_1;
freq_4=freq_1;
[freq_1{:}]=deal('LFB');
[freq_2{:}]=deal('HFB');
[freq_3{:}]=deal('UFB');
[freq_4{:}]=deal('NF');

contact_1=cell(small_num+large_num,1);
contact_2=contact_1;
contact_3=contact_1;
contact_4=contact_1;
[contact_1{1:small_num}]=deal('Small');
[contact_1{small_num+1:small_num+large_num}]=deal('Large');
[contact_2{1:small_num}]=deal('Small');
[contact_2{small_num+1:small_num+large_num}]=deal('Large');
[contact_3{1:small_num}]=deal('Small');
[contact_3{small_num+1:small_num+large_num}]=deal('Large');
[contact_4{1:small_num}]=deal('Small');
[contact_4{small_num+1:small_num+large_num}]=deal('Large');
%%

% lfb_small = move_lfb_small(:)./move_nf_small(:);
% lfb_large = move_lfb_large(:)./move_nf_large(:);
% hfb_small = move_hfb_small(:)./move_nf_small(:);
% hfb_large = move_hfb_large(:)./move_nf_large(:);
% ufb_small = move_ufb_small(:)./move_nf_small(:);
% ufb_large = move_ufb_large(:)./move_nf_large(:);
% rfb_small = move_nf_small(:)./move_nf_small(:);
% rfb_large = move_nf_large(:)./move_nf_large(:);

lfb_small = move_lfb_small(:);
lfb_large = move_lfb_large(:);
hfb_small = move_hfb_small(:);
hfb_large = move_hfb_large(:);
ufb_small = move_ufb_small(:);
ufb_large = move_ufb_large(:);
rfb_small = move_nf_small(:);
rfb_large = move_nf_large(:);

% lfb_small = baseline_lfb_small(:)./baseline_nf_small(:);
% lfb_large = baseline_lfb_large(:)./baseline_nf_large(:);
% hfb_small = baseline_hfb_small(:)./baseline_nf_small(:);
% hfb_large = baseline_hfb_large(:)./baseline_nf_large(:);
% ufb_small = baseline_ufb_small(:)./baseline_nf_small(:);
% ufb_large = baseline_ufb_large(:)./baseline_nf_large(:);
% rfb_small = baseline_nf_small(:)./baseline_nf_small(:);
% rfb_large = baseline_nf_large(:)./baseline_nf_large(:);

% lfb_small = baseline_lfb_small(:);
% lfb_large = baseline_lfb_large(:);
% hfb_small = baseline_hfb_small(:);
% hfb_large = baseline_hfb_large(:);
% ufb_small = baseline_ufb_small(:);
% ufb_large = baseline_ufb_large(:);
% rfb_small = baseline_nf_small(:);
% rfb_large = baseline_nf_large(:);

lfb_small = 10*log10(lfb_small);
lfb_large = 10*log10(lfb_large);
hfb_small = 10*log10(hfb_small);
hfb_large = 10*log10(hfb_large);
ufb_small = 10*log10(ufb_small);
ufb_large = 10*log10(ufb_large);
rfb_small = 10*log10(rfb_small);
rfb_large = 10*log10(rfb_large);

figure
subplot(1, 2, 1)
bp=boxplot(cat(1,...
    lfb_small,...
    lfb_large,...
    hfb_small,...
    hfb_large),...
    {cat(1, freq_1, freq_2),cat(1, contact_1, contact_2)},'labelverbosity','all','labelorientation','horizontal',...
    'OutlierSize',10,'positions',[1,2,3,4]);
hold on
scatter([1, 2, 3, 4],[mean(lfb_small), mean(lfb_large),...
    mean(hfb_small), mean(hfb_large)], 50, '*r')
ylabel('Power (dB)')
set(gca,'fontsize',16);
set(findobj(gca,'type','text'),'fontsize',12)
set(findobj(gca,'type','line'),'linewidth',2)

subplot(1, 2, 2)
bp=boxplot(cat(1,...
    ufb_small,...
    ufb_large,...
    rfb_small,...
    rfb_large),...
    {cat(1, freq_3, freq_4),cat(1, contact_3, contact_4)},'labelverbosity','all','labelorientation','horizontal',...
    'OutlierSize',10,'positions',[1,2,3,4]);
hold on
scatter([1, 2, 3, 4],[mean(ufb_small), mean(ufb_large),...
    mean(rfb_small), mean(rfb_large)], 50, '*r')
ylabel('Power (dB)')
set(gca,'fontsize',16);
set(findobj(gca,'type','text'),'fontsize',12)
set(findobj(gca,'type','line'),'linewidth',2)
%%
[p1, h1] = ranksum(lfb_small, lfb_large)
[p2, h2] = ranksum(hfb_small, hfb_large)
[p3, h3] = ranksum(ufb_small, ufb_large)
[p4, h4] = ranksum(rfb_small, rfb_large)