%maximum foce is defined as the maximum force after 3 seconds of onset
% decode force level / force trend
clear
clc

squeeze_mat = load('/Users/tengi/Desktop/Projects/data/China/force/S2/squeeze.mat','-mat');
relax_mat = load('/Users/tengi/Desktop/Projects/data/China/force/S2/relax.mat','-mat');
%%
squeeze_data = squeeze_mat.data;
% squeeze_data(:, :, [1, 2, 27]) = [];

relax_data = relax_mat.data;

S1_ERS_Squeeze = {'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C29', 'C30', 'C42', 'C43', 'C55'};
% S1_ERS_Relax = {'C2', 'C3', 'C14', 'C15', 'C18', 'C19', 'C30', 'C43'};
s1_bad_hold_trial = [4, 15, 18, 24];
S2_ERS_Squeeze = {'C110', 'C109', 'C97', 'C86', 'C85', 'C75', 'C74', 'C73', 'C25'};
s2_bad_hold_trial = [5, 13];
ecog_ind = find(ismember(relax_mat.channame, S2_ERS_Squeeze));

fs = relax_mat.fs;

emgName = {'Bipolar EMG'};
emg_ind = ismember(squeeze_mat.channame, emgName);
forceName = {'Force'};
force_ind = ismember(squeeze_mat.channame, forceName);

force = squeeze(squeeze_data(:, force_ind, :));
force = force-mean(force(1000:2000, :), 1);
max_force = max(force, [], 1);

%%
trNum = size(squeeze_data, 3);
squeeze_lfb = [];
squeeze_hfb = [];
[b1, a1]=butter(2,[8, 32]/(fs/2));
[b2, a2] = butter(2, [60, 200]/(fs/2));

for i = 1:trNum
    squeeze_lfb(:, :, i) = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b1, a1, squeeze(squeeze_data(:, ecog_ind, i)), 0, 0, 'iir');
    squeeze_hfb(:, :, i) = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b2, a2, squeeze(squeeze_data(:, ecog_ind, i)), 0, 0, 'iir');
end

squeeze_hfb = squeeze_hfb.^2;
squeeze_lfb = squeeze_lfb.^2;

%%
trNum = size(relax_data, 3);
relax_lfb = [];
relax_hfb = [];
for i = 1:trNum
    relax_lfb(:, :, i) = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b1, a1, squeeze(relax_data(:, ecog_ind, i)), 0, 0, 'iir');
    relax_hfb(:, :, i) = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b2, a2, squeeze(relax_data(:, ecog_ind, i)), 0, 0, 'iir');
end

relax_hfb = relax_hfb.^2;
relax_lfb = relax_lfb.^2;

tf_t = (1:size(squeeze_hfb, 1))/fs-squeeze_mat.ms_before/1000;

%%

base_ix = tf_t <= -0.5 & tf_t >= -1;
squeeze_ix = tf_t >= -0.15 & tf_t <= 0.85;
hold_ix = tf_t >= 1 & tf_t <= 1.8;
relax_ix = tf_t >= 0 & tf_t <= 0.8;

lfb_base = 10*log10(squeeze(mean(mean(squeeze_lfb(base_ix, :, :), 2), 1)));
hfb_base = 10*log10(squeeze(mean(mean(squeeze_hfb(base_ix, :, :), 2), 1)));

lfb_squeeze = 10*log10(squeeze(mean(mean(squeeze_lfb(squeeze_ix, :, :), 2), 1)));
hfb_squeeze = 10*log10(squeeze(mean(mean(squeeze_hfb(squeeze_ix, :, :), 2), 1)));

lfb_hold = 10*log10(squeeze(mean(mean(squeeze_lfb(hold_ix, :, :), 2), 1)));
hfb_hold = 10*log10(squeeze(mean(mean(squeeze_hfb(hold_ix, :, :), 2), 1)));

lfb_relax = 10*log10(squeeze(mean(mean(relax_lfb(relax_ix, :, :), 2), 1)));
hfb_relax = 10*log10(squeeze(mean(mean(relax_hfb(relax_ix, :, :), 2), 1)));
%%
x0 = hfb_base(:);
x1 = hfb_squeeze(:);
x2 = hfb_hold(:);
x3 = hfb_relax(:);

y0 = lfb_base(:);
y1 = lfb_squeeze(:);
y2 = lfb_hold(:);
y3 = lfb_relax(:);

[r0, p0] = corrcoef(x0, y0);
[r1, p1] = corrcoef(x1, y1);
[r2, p2] = corrcoef(x2, y2);
[r3, p3] = corrcoef(x3, y3);


figure('position',[100,100,350,700])
subplot(4, 1, 1)

scatter(x0, y0, '*', 'sizedata', 50);
p = polyfit(x0, y0, 1);
x = linspace(min(x0), max(x0), 100);
hold on;
plot(x, p(1)*x+p(2), 'linewidth', 2)
% hold on
% xl = get(gca, 'xlim')
% yl = get(gca, 'ylim')
% min_xy = min(xl(1), yl(1));
% max_xy = max(xl(2), xl(2));
% plot([min_xy, max_xy], [min_xy, max_xy], '--');
ylabel('LFB (dB)')
xlabel('HFB (dB)')
title(['Baseline, R: ', num2str(r0(1, 2), '%.2g'), ', P: ', num2str(p0(1, 2), '%.2g')])
set(gca, 'fontsize', 16)

subplot(4, 1, 2)
scatter(x1, y1, '*', 'sizedata', 50);
p = polyfit(x1, y1, 1);
x = linspace(min(x1), max(x1), 100);
hold on;
plot(x, p(1)*x+p(2), 'linewidth', 2)

% hold on
% xl = get(gca, 'xlim')
% yl = get(gca, 'ylim')
% min_xy = min(xl(1), yl(1));
% max_xy = max(xl(2), xl(2));
% plot([min_xy, max_xy], [min_xy, max_xy], '--');
ylabel('LFB (dB)')
xlabel('HFB (dB)')
title(['Squeeze, R: ', num2str(r1(1, 2), '%.2g'), ', P: ', num2str(p1(1, 2), '%.2g')])
set(gca, 'fontsize', 16)

subplot(4, 1,3)
scatter(x2, y2, '*', 'sizedata', 50);
p = polyfit(x2, y2, 1);
x = linspace(min(x2), max(x2), 100);
hold on;
plot(x, p(1)*x+p(2), 'linewidth', 2)

% hold on
% xl = get(gca, 'xlim')
% yl = get(gca, 'ylim')
% min_xy = min(xl(1), yl(1));
% max_xy = max(xl(2), xl(2));
% plot([min_xy, max_xy], [min_xy, max_xy], '--');
ylabel('LFB (dB)')
xlabel('HFB (dB)')
title(['Hold, R: ', num2str(r2(1, 2), '%.2g'), ', P: ', num2str(p2(1, 2), '%.2g')])
set(gca, 'fontsize', 16)


subplot(4, 1,4)
scatter(x3, y3, '*', 'sizedata', 50);
p = polyfit(x3, y3, 1);
x = linspace(min(x3), max(x3), 100);
hold on;
plot(x, p(1)*x+p(2), 'linewidth', 2)

% hold on
% xl = get(gca, 'xlim')
% yl = get(gca, 'ylim')
% min_xy = min(xl(1), yl(1));
% max_xy = max(xl(2), xl(2));
% plot([min_xy, max_xy], [min_xy, max_xy], '--');
ylabel('LFB (dB)')
xlabel('HFB (dB)')
title(['Relax, R: ', num2str(r2(1, 2), '%.2g'), ', P: ', num2str(p2(1, 2), '%.2g')])
set(gca, 'fontsize', 16)
