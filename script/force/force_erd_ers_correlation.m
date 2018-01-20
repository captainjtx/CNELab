clear
clc
mat = load('/Users/tengi/Desktop/Projects/data/China/force/S1/squeeze.mat','-mat');

data = mat.data;
fs = mat.fs;

emgName = {'Bipolar EMG'};
emg_ind = ismember(mat.channame, emgName);
forceName = {'Force'};
force_ind = ismember(mat.channame, forceName);

force = squeeze(data(:, force_ind, :));
% force = force*16.45-0.118; % transform into kg 
% use relative force changes

force = (force-median(mean(force(1000:2000, :), 1)))*16.45;
max_force = max(force, [], 1);

S1_ERS_Squeeze = {'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C29', 'C30', 'C42', 'C43', 'C55'};
% S1_ERS_Relax = {'C2', 'C3', 'C14', 'C15', 'C18', 'C19', 'C30', 'C43'};

S2_ERS_Squeeze = {'C110', 'C109', 'C97', 'C86', 'C85', 'C75', 'C74', 'C73', 'C25'};
ecog_ind = find(ismember(mat.channame, S1_ERS_Squeeze));

[b1, a1]=butter(2,[8, 32]/(fs/2));
[b2, a2] = butter(2, [60, 200]/(fs/2));

tfm = [];

trNum = size(data, 3);
lfb = [];
hfb = [];
for i = 1:trNum
    lfb(:, :, i) = filter_symmetric(b1, a1, squeeze(data(:, ecog_ind, i)), 0, 0, 'iir');
    hfb(:, :, i) = filter_symmetric(b2, a2, squeeze(data(:, ecog_ind, i)), 0, 0, 'iir');
end

hfb = hfb.^2;
lfb = lfb.^2;

%%
tf_t = (1:size(data, 1))/fs-mat.ms_before/1000;
t_ix = tf_t >= -0.15 & tf_t <= 0.85;

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
title(['R: ', num2str(r2(1, 2), '%.2g'), ', P: ', num2str(p2(1, 2), '%.2g')])
xlim([0, max(max_force)*1.1])
ylim([0, 7])
set(gca, 'fontsize', 16)

subplot(2, 1, 2)
scatter(max_force, erd, 'sizedata', 50);

p = polyfit(max_force,erd,1);
hold on;
plot(x, p(1)*x+p(2), 'linewidth', 2)

title(['R: ', num2str(r1(1, 2), '%.2g'), ', P: ', num2str(p1(1, 2), '%.2g')])
ylabel('ERD (dB)')
xlabel('Force (kg)')
ylim([-15, 0])
xlim([0, max(max_force)*1.1])
set(gca, 'fontsize', 16)

set(gcf, 'color', 'w')
