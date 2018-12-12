clear
clc

data_dir = 'E:\Google Drive\Force Paper\03282017\';
% data_dir = 'E:\Google Drive\Force Paper\05292018\force_pos3\';
% data_dir = 'E:\Google Drive\Force Paper\08302018\Force Task\';
% data_dir = 'E:\Google Drive\Force Paper\09112018\Force Task\Merged-interpolated Task\';
pid = 'P1';

mat = load([data_dir, 'squeeze.mat'],'-mat');

data = mat.data;
fs = mat.fs;

squeeze_id = fopen([data_dir, 'montage\squeeze_ers_posterior.txt']);
% relax_id = fopen([data_dir, 'montage\relax_ers.txt']);
out_filename = sprintf('E:\\Google Drive\\Force Paper\\pics\\corr\\%s_%s_posterior', pid, mat.event);

squeeze_chan = textscan(squeeze_id,'%s');
% relax_chan = textscan(relax_id,'%s');
fclose(squeeze_id);
% fclose(relax_id);

ERS_Squeeze = squeeze_chan{1};

emgName = {'Bipolar EMG', 'EMG', 'Extensor Digitorum'};
emg_ind = ismember(mat.channame, emgName);
forceName = {'Force'};
force_ind = ismember(mat.channame, forceName);

force = squeeze(data(:, force_ind, :));
% To transform from voltage (V) to Kg
% force = force*16.45-0.118; % transform into kg 
% use relative force changes

% To transform from teensy analog read (0-5 V to 0-1023) to Kg
% force = force/1023*5*16.45-intercept, 1kg = 12.4377

% by the new calibration 1kg = 16.8328 in measurement

force = (force-median(mean(force(1000:2000, :), 1)))/16.8328;

max_force = max(force(1.5*fs:2.5*fs, :), [], 1);

ecog_ind = find(ismember(mat.channame, ERS_Squeeze));

[b1, a1]=butter(2,[8, 32]/(fs/2));
[b2, a2] = butter(2, [60, 200]/(fs/2));

tfm = [];

trNum = size(data, 3);
lfb = [];
hfb = [];
for i = 1:trNum
    lfb(:, :, i) = cnelab_filter_symmetric(b1, a1, squeeze(data(:, ecog_ind, i)), 0, 0, 'iir');
    hfb(:, :, i) = cnelab_filter_symmetric(b2, a2, squeeze(data(:, ecog_ind, i)), 0, 0, 'iir');
end

hfb = hfb.^2;
lfb = lfb.^2;

%%
tf_t = (1:size(data, 1))/fs-mat.ms_before/1000;
t_ix = tf_t >= 0 & tf_t <= 0.8;

base_ix = tf_t <= -0.5 & tf_t >= -1;

erd = mean(mean(lfb(t_ix, :, :), 1), 2)./mean(mean(mean(lfb(base_ix, :, :), 1), 2));
ers = mean(mean(hfb(t_ix, :, :), 1), 2)./mean(mean(mean(hfb(base_ix, :, :), 1), 2));

erd = 10*log10(squeeze(erd));
ers = 10*log10(squeeze(ers));

%%
[r1, p1] = corrcoef(max_force, erd);
[r2, p2] = corrcoef(max_force, ers);
max_force = max_force(:);
figure('position', [100, 100, 300, 450])
subplot(2, 1, 1)
scatter(max_force, ers, '*', 'sizedata', 50);

p = polyfit(max_force,ers,1);
x = linspace(min(max_force), max(max_force), 100);
hold on;
plot(x, p(1)*x+p(2), 'linewidth', 2)


ylabel('ERS (dB)')
xlabel('Force (kg)')
title([pid, ': R=', num2str(r2(1, 2), '%.2g'), ', P=', num2str(p2(1, 2), '%.2g')])
xlim([min(max_force)/2, max(max_force)*1.1])
ylim([0, 6])
set(gca, 'fontsize', 16)

subplot(2, 1, 2)
scatter(max_force, erd, 'sizedata', 50);

p = polyfit(max_force,erd,1);
hold on;
plot(x, p(1)*x+p(2), 'linewidth', 2)

title([pid, ': R=', num2str(r1(1, 2), '%.2g'), ', P=', num2str(p1(1, 2), '%.2g')])
ylabel('ERD (dB)')
xlabel('Force (kg)')
ylim([-12, 0])
xlim([min(max_force)/2, max(max_force)*1.1])
set(gca, 'fontsize', 15)

set(gcf, 'color', 'w')

export_fig(gcf, '-png', '-opengl', '-nocrop', '-r300', [out_filename, '.png'])
saveas(gcf, [out_filename, '.fig'])