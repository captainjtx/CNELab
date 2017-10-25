%maximum foce is defined as the maximum force after 3 seconds of onset
% decode force level / force trend
clear
clc

base_mat = load('/Users/tengi/Desktop/Projects/data/China/force/S1/squeeze.mat','-mat');
mat = load('/Users/tengi/Desktop/Projects/data/China/force/S1/relax.mat','-mat');
%%
base_data = base_mat.data;
data = mat.data;

emgName = {'Bipolar EMG'};
emg_ind = ismember(mat.channame, emgName);
forceName = {'Force'};
force_ind = ismember(mat.channame, forceName);

S1_ERS_Squeeze = {'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C29', 'C30', 'C42', 'C43', 'C55'};
S1_ERS_Relax = {'C2', 'C3', 'C14', 'C15', 'C18', 'C19', 'C30', 'C43'};
ecog_ind = find(ismember(mat.channame, S1_ERS_Relax));
fs = mat.fs;
%%

[b1, a1] = butter(2, 0.01/(fs/2), 'high');
[b2, a2] = butter(2, [50, 300]/(fs/2));
[b3, a3] = butter(2, 5/(fs/2), 'low');
lfb = [8, 32];
hfb = [60, 200];
wd = 512;
ov = 500;
wl = 128;

emg = filter_symmetric(b2, a2, squeeze(data(:, emg_ind, :)),[],0,'iir');

emg_env = mean(filter_symmetric(b3, a3, envelope(emg, wl ,'peak'), [], 0, 'iir'), 2);

rforce=filter_symmetric(b1, a1, squeeze(data(:, force_ind,:)),[],0,'iir');
force = mean(rforce, 2);

tfm = 0;
base_tfm = 0;
for i = 1:length(ecog_ind)
    [tmp, ~, ~] = tfpower(squeeze(base_data(:, ecog_ind(i), :)), [], fs, wd, ov, []);
    base_tfm = base_tfm+tmp;
    
    [tmp, tf_f, tf_t] = tfpower(squeeze(base_data(:, ecog_ind(i), :)), [], fs, wd, ov, []);
    tfm = tfm+tmp;
end
tfm = tfm/length(ecog_ind);
base_tfm = base_tfm/length(ecog_ind);
%%

lfb_ix = tf_f >= lfb(1) & tf_f <= lfb(2);
hfb_ix = tf_f >= hfb(1) & tf_f <= hfb(2);
base_ix = tf_t <= 0.5;
erd = mean(tfm(lfb_ix, :), 1)./mean(mean(base_tfm(lfb_ix, base_ix)));
ers = mean(tfm(hfb_ix, :), 1)./mean(mean(base_tfm(hfb_ix, base_ix)));
%%
figure('position',[100,100,600,450])
colorder = get(gca,'colororder');

t = tf_t-mat.ms_before/1000;
h1=plot(t,10*log10(erd),'-','Color',colorder(1,:),'LineWidth',7);
hold on
h2=plot(t,10*log10(ers),'-','Color',colorder(2,:),'LineWidth',7);

axis tight
ylim([-12,12])
a=gca;
a.FontSize = 22;
% a.Position = [0.12, 0.2, 0.76, 0.7];


ylabel('ERD/ERS (dB)','fontsize',22)

hold on

plot(a.XLim,[0,0],'--k','linewidth',5);
% ylabel('dB')
% xlabel('Time (ms)')
plot([0,0],a.YLim,':k','linewidth',5);

grid on

% ylabel('ERD/ERS (dB)');
set(gcf,'color','white');

% text(50,8.5,'Onset','FontSize',20)
% plot the force
hold on
yyaxis right
a.YColor=[0,0,0];
ylim([-100, 100]);
fforce = force-mean(force(end-400:end));% change to fdata(end-400:end, :) for offset
fforce = fforce/max(abs(fforce))*90;
h3=plot(linspace(-mat.ms_before/1000, mat.ms_after/1000,size(fforce,1)), fforce, 'Color', [0.5,0.8,0.1], 'linestyle', ':', 'linewidth', 5);

hold on
emg_env = emg_env-mean(emg_env(end-400:end));% change to fdata(end-400:end, :) for offset
emg_env = emg_env/max(abs(emg_env))*90;
h4=plot(linspace(-mat.ms_before/1000, mat.ms_after/1000,size(emg_env,1)), emg_env, 'Color', [0, 0, 0], 'linestyle','-.', 'linewidth', 5);
a.FontWeight='bold';
a.LineWidth=5;
xlim([min(t), max(t)]);
ylabel('Force/EMG (%)','rot',-90, 'fontsize', 22, 'VerticalAlignment','cap')
title(['P1 ', mat.event])
xlabel('Time (s)', 'fontsize', 22)

legend([h1, h2, h3, h4],{'ERD', 'ERS', 'Force', 'EMG'}, 'location','northeast');
legend('boxoff')
