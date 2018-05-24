%maximum foce is defined as the maximum force after 3 seconds of onset
% decode force level / force trend
clear
clc
% mat = load('/Users/tengi/Desktop/Projects/data/China/force/S2/relax.mat','-mat');

mat = load('/Users/tengi/Desktop/Projects/data/MDAnderson/03282017/squeeze_long.mat','-mat');

%%
data = mat.data;

emgName = {'Bipolar EMG', 'EMG'};
emg_ind = ismember(mat.channame, emgName);
forceName = {'Force'};
force_ind = ismember(mat.channame, forceName);

S1_ERS_Squeeze = {'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C29', 'C30', 'C42', 'C43', 'C55'};
% S1_ERS_Relax = {'C2', 'C3', 'C14', 'C15', 'C18', 'C19', 'C30', 'C43'};
S1_Force_Duration = [10.84-6.21 14.84-12.75 20.13-18.27 34.72-32.6 40.25-36.75 47.77-44.97 53.24-50.49 60.27-56.24 68.12-65.81 79.98-78.32 85.97-83.75 99.26-92.76 104.03-101.17 134.52-131.56 139.08-136.94 147.71-140.87 154.20-151.11 159.92-157.38 176.25-173.06 181.27-178.49 193.55-188.43 199.45-196.43 236.15-227.69 224.90-218.14 211.09-202.82];

S2_ERS_Squeeze = {'C110', 'C109', 'C97', 'C86', 'C85', 'C75', 'C74', 'C73', 'C25'};
S2_Force_Duration = [14.59-12.52 19.15-16.75 22.81-21.16 94.80-93.14 102.35-100.46 106.06-103.96 110.61-108.45 114.95-113.24 129.26-127.29 162.18-160.26 175.24-171.84 186.82-184.55 198.55-196.63 223.69-221.84 229.75-227.95 235.05-233.23 239.47-237.68 249.25-247.06];

S3_ERS_Squeeze = {'C5', 'C19', 'C20', 'C21', 'C36', 'C37', 'C54', 'C55', 'C68', 'C69', 'C70', 'C85', 'C86', 'C101', 'C102', 'C117', 'C118'};
S3_Force_Duration = [1064.44-1061.02, 1076.04-1073.75 1083.87-1081.34 1089.97-1085.59 1096.72-1093.48 1110.58-1108.22 1116.25-1113.34 1147.6-1145.55 1153.58-1150.75 1160.12-1156.97 1167.34-1164.76 1173.90-1171.03 1187.77-1185.41 1199.72-1195.41 1205.73-1203.31 1223.02-1220.04 1253.35-1251.17 1260.32-1258.01 1266.25-1263.87];
ecog_ind = find(ismember(mat.channame, S3_ERS_Squeeze));
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

emg = cnelab_filter_symmetric(b2, a2, squeeze(data(:, emg_ind, :)),[],0,'iir');

emg_env = mean(cnelab_filter_symmetric(b3, a3, envelope(emg, wl ,'rms'), [], 0, 'iir'), 2);

force=cnelab_filter_symmetric(b1, a1, squeeze(data(:, force_ind,:)),[],0,'iir');

tfm = 0;

base_psd = [];

for i = 1:length(ecog_ind)
    [tmp, tf_f, tf_t] = tfpower(squeeze(data(:, ecog_ind(i), :)), [], fs, wd, ov, []);
    base_ix = tf_t <= mat.ms_before/1000-0.5 & tf_t >= mat.ms_before/1000-1;
    base_psd = cat(2, base_psd, mean(tmp(:, base_ix), 2));
end

lfb_ix = tf_f >= lfb(1) & tf_f <= lfb(2);
hfb_ix = tf_f >= hfb(1) & tf_f <= hfb(2);

%%
figure('position',[100,100,600,450])
colorder = get(gca,'colororder');
t = tf_t-mat.ms_before/1000;

erd = zeros(length(tf_t), length(ecog_ind), size(data, 3));
ers = erd;
for i = 1:size(data, 3)
    % i trial
    clf
    for j = 1:length(ecog_ind)
        [tmp, ~, ~] = tfpower(squeeze(data(:, ecog_ind(j), i)), [], fs, wd, ov, []);
        erd(:, j, i) = mean(tmp(lfb_ix, :), 1)./mean(base_psd(lfb_ix, j));
        ers(:, j, i) = mean(tmp(hfb_ix, :), 1)./mean(base_psd(hfb_ix, j));
    end

    plot(repmat(t(:), 1, length(ecog_ind)), 10*log10(erd(:, :, i)),'-','Color',colorder(1,:),'LineWidth',2);
    hold on
    plot(repmat(t(:), 1, length(ecog_ind)), 10*log10(ers(:, :, i)),'-','Color',colorder(2,:),'LineWidth',2);
    
    axis tight
    ylim([-14,14])
    a=gca;
    a.FontSize = 22;
    ylabel('ERD/ERS (dB)','fontsize',22)
    hold on

    plot(a.XLim,[0,0],'--k','linewidth',3);
    plot([0,0],a.YLim,':k','linewidth',3);
    grid on
    set(gcf,'color','white');
    
    hold on
    yyaxis right
    a.YColor=[0,0,0];
    ylim([-2, 2]);
    fforce = force(:, i)-mean(force(1:2000, i));
    fforce_scale = fforce/18.58;% scale it
    plot(linspace(-mat.ms_before/1000, mat.ms_after/1000, length(fforce_scale)), fforce_scale, 'Color', [0, 0, 0], 'linestyle', '-.', 'linewidth', 2);
    xlim([-0.5, t(end)]);
    ylabel('Force (kg)','rot',-90, 'fontsize', 22, 'VerticalAlignment','cap')
    xlabel('Time (s)', 'fontsize', 22)
    pause;
end




