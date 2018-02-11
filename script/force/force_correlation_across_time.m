clear
clc
mat = load('/Users/tengi/Desktop/Projects/data/China/force/S1/squeeze.mat','-mat');

data = mat.data;
%remove some trials
% data(:, :, [1, 2, 27]) = [];
fs = mat.fs;

emgName = {'Bipolar EMG'};
emg_ind = ismember(mat.channame, emgName);
forceName = {'Force'};
force_ind = ismember(mat.channame, forceName);


force = squeeze(data(:, force_ind, :));
force = force-mean(force(1:2000, :), 1);
max_force = max(force, [], 1);

S1_ERS_Squeeze = {'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C29', 'C30', 'C42', 'C43', 'C55'};
% S1_ERS_Relax = {'C2', 'C3', 'C14', 'C15', 'C18', 'C19', 'C30', 'C43'};

S2_ERS_Squeeze = {'C110', 'C109', 'C97', 'C86', 'C85', 'C75', 'C74', 'C73', 'C25'};
ecog_ind = find(ismember(mat.channame, S1_ERS_Squeeze));

[b1, a1]=butter(2,[8, 32]/(fs/2));
[b2, a2] = butter(2, [60, 200]/(fs/2));

tfm = [];

wd = 512;
ov = 500;

trNum = size(data, 3);
lfb = [];
hfb = [];
for i = 1:trNum
    lfb(:, :, i) = filter_symmetric(b1, a1, squeeze(data(:, ecog_ind, i)), 0, 0, 'iir');
    hfb(:, :, i) = filter_symmetric(b2, a2, squeeze(data(:, ecog_ind, i)), 0, 0, 'iir');
end

hfb = hfb.^2;
lfb = lfb.^2;

tf_t = (1:size(data, 1))/fs-mat.ms_before/1000;
base_ix = tf_t <= -1 & tf_t >= -1.5;

erd_corr = [];
ers_corr = [];
erd_p = [];
ers_p = [];
for ti = -1:0.1:1.5
    t_ix = tf_t >= ti-0.5 & tf_t <= ti;
%     erd = mean(mean(lfb(t_ix, :, :), 1), 2)./mean(mean(mean(lfb(base_ix, :, :), 1), 2));
%     ers = mean(mean(hfb(t_ix, :, :), 1), 2)./mean(mean(mean(hfb(base_ix, :, :), 1), 2));
    
    erd = mean(mean(lfb(t_ix, :, :), 1), 2);
    ers = mean(mean(hfb(t_ix, :, :), 1), 2);
    
    erd = 10*log10(squeeze(erd));
    ers = 10*log10(squeeze(ers));
    
    [r1, p1] = corrcoef(max_force, erd);
    [r2, p2] = corrcoef(max_force, ers);
    
    erd_p = cat(1, erd_p, p1(1,2));
    ers_p = cat(1, ers_p, p2(1,2));
    erd_corr = cat(1, erd_corr, r1(1,2));
    ers_corr = cat(1, ers_corr, r2(1,2));
    
end
%%
t = -1:0.1:1.5;
figure()
subplot(2,2,1)
plot(t, ers_corr, 'linewidth', 2)
hold on
plot([-1, 1.5], [0, 0],'--', 'linewidth', 1)
hold on
plot([0, 0], [-1, 1],'-.','linewidth', 1)
box off
ylim([-1, 1])
xlabel('Time (s)')
ylabel('ERS Correlation')


subplot(2,2,2)
plot(t, erd_corr, 'linewidth', 2)
hold on
plot([-1, 1.5], [0, 0],'--', 'linewidth', 1)
hold on
plot([0, 0], [-1, 1],'-.', 'linewidth', 1)
ylabel('ERD Correlation')
ylim([-1, 1])
box off

subplot(2,2,3)
plot(t, log10(ers_p), 'linewidth', 2)
hold on
plot([-1, 1.5], [-2, -2],'--', 'linewidth', 1)
hold on
plot([0, 0], [-8, 0],'-.', 'linewidth', 1)
ylim([-8, 0])
ylabel(' ERS p-value (dB)')
box off

subplot(2,2,4)
plot(t, log10(erd_p), 'linewidth', 2)
hold on
plot([-1, 1.5], [-2, -2],'--', 'linewidth', 1)
hold on
plot([0, 0], [-8, 0],'-.', 'linewidth', 1)
ylim([-8, 0])
ylabel(' ERD p-value (dB)')
box off

set(gcf, 'color', 'w')

