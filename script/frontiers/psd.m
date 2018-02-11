%get psd from tfmap
clear
clc

subj = 's1';

close=load(['/Users/tengi/Desktop/Projects/data/Turkey/', subj, '/Close.mat'],'-mat');
s='';

sm1=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_8-32_start-100_len500.smw']);
lfb_chan=sm1.name(sm1.sig==-1);
sm2=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_60-280_start-100_len500.smw']);
hfb_chan=sm2.name(sm2.sig==1);
sm3=ReadSpatialMap(['/Users/tengi/Desktop/publication/Frontiers-2017/onset/',subj,'_Close_300-800_start-100_len500.smw']);
ufb_chan=sm3.name(sm3.sig==1);

% ers_chan = close.channame(~cellfun(@isempty,regexp(close.channame,'C*')));

% ers_chan=hfb_chan;
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

ufb_idx = ismember(close.channame, ufb_chan);
hfb_idx = ismember(close.channame, hfb_chan);

%close=s2_close.Close;
wd=1024;
ov=512;
nfft=1024;
fs=2400;

lfb=[8,32];
hfb=[60,280];
ufb=[300,800];

fn=50;
fh=3.5;
% t=[0,1];%baseline
t=[1.4,1.9];%movement

baseline=[0,0.5];

t=round(t(1)*fs:t(2)*fs)+1;
baseline=round(baseline(1)*fs:baseline(2)*fs)+1;

% [b,a]=butter(2,1.5/(fs/2),'high');
% for i=1:size(close.data,3)
%     close.data(:,:,i)=filter_symmetric(b,a,close.data(:,:,i),fs,0,'iir');
% end

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

for i=1:round(fs/2/fn)
    baseline_pxx(fn*i-fh<f&f<fn*i+fh, :)=nan;
    move_pxx(fn*i-fh<f&f<fn*i+fh, :)=nan;
end

baseline_pxx_hfb = mean(baseline_pxx(:, hfb_idx & ~ufb_idx), 2);
move_pxx_hfb = mean(move_pxx(:, hfb_idx & ~ufb_idx), 2);

baseline_pxx_ufb = mean(baseline_pxx(:, ufb_idx), 2);
move_pxx_ufb = mean(move_pxx(:, ufb_idx), 2);

h=ones(16,1)/16;
[H, fw]=freqz(h, 1, nfft*8, 38400);

resp4800=[2.25 2.25 2.24 2.16 2 1.83 1.6 1.35 1.0 0.54 0.385 0.27 0.175 0.115 0.07 0.035 0.02 0.01]/2.25;
f4800=[0 100 200 400 600 800 1000 1200 1500 2000 2200 2400 2600 2800 3000 3250 3500 4000];
f2400 = f4800/2;
H = interp1(f2400,resp4800, f, 'pchip');

baseline_pxx_hfb_corrected = baseline_pxx_hfb./(abs(H(1:length(f))).^2);
move_pxx_hfb_corrected = move_pxx_hfb./(abs(H(1:length(f))).^2);

baseline_pxx_ufb_corrected = baseline_pxx_ufb./(abs(H(1:length(f))).^2);
move_pxx_ufb_corrected = move_pxx_ufb./(abs(H(1:length(f))).^2);

%%
figure
h = plot([f(:),f(:)],10*log10([baseline_pxx_ufb_corrected(:), move_pxx_ufb_corrected(:)]));

hold on
set(gcf,'position',[0,0,360,280]);
set(gca,'fontsize',16);
ylabel('PSD (dB)');
xlabel('Frequency (Hz)');
ylim([-35,35]);
title(s);
xlim([0,1000]);
set(gcf,'color','w')
set(gca,'fontweight','bold')
set(findobj(gca,'type','line'),'linewidth',2)
set(gca,'linewidth',1)
% xticks([8,32,60,200,300,800])
% xticklabels('')
box off
yl = get(gca, 'ylim');
yl = [-30, 30];
a=patch('Faces',[1,2,3,4],'Vertices',[8,yl(1);32,yl(1);32,yl(2);8, yl(2)],'facecolor',[0.7647    0.9176    0.6471],'facealpha',1,'edgecolor','none');
uistack(a,'bottom')
a=patch('Faces',[1,2,3,4],'Vertices',[60,yl(1);280,yl(1);280,yl(2);60,yl(2)],'facecolor',[0.6431    0.9176    0.8824],'facealpha',1,'edgecolor','none');
uistack(a,'bottom')
a=patch('Faces',[1,2,3,4],'Vertices',[300,yl(1);800,yl(1);800,yl(2);300,yl(2)],'facecolor',[0.9294    0.9373    0.4980],'facealpha',1,'edgecolor','none');
uistack(a,'bottom')
legend(h, {'Baseline','Movement'});