clear
clc
mat = load('/Users/tengi/Desktop/Projects/data/China/force/S2/squeeze.mat','-mat');

data = mat.data;
fs = mat.fs;

emgName = {'Bipolar EMG'};
emg_ind = ismember(mat.channame, emgName);
forceName = {'Force'};
force_ind = ismember(mat.channame, forceName);

force = squeeze(data(:, force_ind, :));
force = force-mean(force(1:2000, :), 1);
force = max(force, [], 1);

S1_ERS_Squeeze = {'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C29', 'C30', 'C42', 'C43', 'C55'};
% S1_ERS_Relax = {'C2', 'C3', 'C14', 'C15', 'C18', 'C19', 'C30', 'C43'};

S2_ERS_Squeeze = {'C110', 'C109', 'C97', 'C86', 'C85', 'C75', 'C74', 'C73', 'C25'};
ecog_ind = find(ismember(mat.channame, S2_ERS_Squeeze));

[b1, a1]=butter(2,[8, 32]/(fs/2));
[b2, a2] = butter(2, [60, 200]/(fs/2));

tfm = [];

wd = 512;
ov = 500;
trNum = size(data, 3);

chans = cell(length(mat.channame),1);
for i=1:150
    chans{i} = ['C', num2str(i)]; 
end

CHi = ismember(mat.channame, chans);
data = data(:, ecog_ind, :);

%%
fdata = data;
for i=1:size(data,3)
    fdata(:,:,i)=filter_symmetric(b2, a2, data(:,:,i),[],0,'iir');
end

baseline = round(0.5*fs : 1.25*fs);
move = round((mat.ms_before/1000-0.15)*fs : (mat.ms_before/1000+0.6)*fs);
X = fdata(baseline, :, :);
Y = fdata(move, :, :);
CHi = 1:size(X, 2);
[W,Lmd,CSP,cx,cy]=csp_weights(Y, X, CHi, 1, (force-min(force))/(max(force)-min(force)));
vec = W(:, end); %pca vector corresponds to maximize HFB variance

proj = zeros(size(data,1),size(data,3));

for i=1:size(fdata, 3)
    proj(:,i) = squeeze(fdata(:,:,i))*vec;
end

for i = 1:trNum
    [tmp, tf_f, tf_t] = tfpower(squeeze(proj(:, i)), [], fs, wd, ov, []);
    tfm = cat(3, tfm, tmp);
end
%%
t_ix = tf_t >= mat.ms_before/1000-0.1 & tf_t <= mat.ms_before/1000+0.4;
lfb = [8, 32];
hfb = [60, 200];

lfb_ix = tf_f >= lfb(1) & tf_f <= lfb(2);
hfb_ix = tf_f >= hfb(1) & tf_f <= hfb(2);
base_ix = tf_t <= mat.ms_before/1000-0.5 & tf_t >= mat.ms_before/1000-1;

erd = mean(mean(tfm(lfb_ix, t_ix, :), 1), 2)./mean(mean(mean(tfm(lfb_ix, base_ix, :), 1), 2));
ers = mean(mean(tfm(hfb_ix, t_ix, :), 1), 2)./mean(mean(mean(tfm(hfb_ix, base_ix, :), 1), 2));

erd = 10*log10(squeeze(erd));
ers = 10*log10(squeeze(ers));

[~, p1] = corrcoef(force, erd);
[~, p2] = corrcoef(force, ers);
%%
figure
subplot(2, 1, 1)
scatter(force, ers, '*');
ylabel('ERS (dB)')
xlabel('Force')

title(['P-Val:', num2str(p2(1, 2), '%.3g')])
xlim([min(force), max(force)])
subplot(2, 1, 2)
scatter(force, erd);
title(['P-Val:', num2str(p1(1, 2), '%.3g')])
ylabel('ERD (dB)')
xlabel('Force')
xlim([min(force), max(force)])



