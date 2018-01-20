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

ecog = cell(120, 1);
for i = 1:120
    ecog{i} = ['C', num2str(i)];
end

ecog_ind = find(ismember(mat.channame, ecog));
% ecog_ind = find(ismember(mat.channame, S1_ERS_Squeeze));

% ecog_ind = 3:93;

[b1, a1]=butter(2,[8, 32]/(fs/2));
[b2, a2] = butter(2, [60, 200]/(fs/2));

wd = 512;
ov = 500;
trNum = size(data, 3);
% figure

numCol = round(sqrt(length(ecog_ind)));
numRow = ceil(length(ecog_ind)/numCol);
% data(:, ecog_ind, :) = data(:, ecog_ind, :)-mean(data(:, ecog_ind, :), 2);
%%
fid1 = fopen('/Users/tengi/Desktop/publication/Force/corr/S2_erd_corr_r_all.txt', 'w');
fid2 = fopen('/Users/tengi/Desktop/publication/Force/corr/S2_ers_corr_r_all.txt', 'w');
for channelIndex = 1:length(ecog_ind)
    tfm = [];
    for i = 1:trNum
        [tmp, tf_f, tf_t] = tfpower(squeeze(data(:, ecog_ind(channelIndex), i)), [], fs, wd, ov, []);
        tfm = cat(3, tfm, tmp);
    end
    
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
    
%     subplot(numRow, numCol, channelIndex)
%     scatter(force, ers, '*');
%     ylabel('ERS/ERD (dB)')
%     xlabel('Force')
%     xlim([min(force), max(force)])
%     hold on
%     scatter(force, erd);
%     title([num2str(r1(1,2), '%.2g'),' ', num2str(p1(1,2),'%.2g'), ', ', num2str(r2(1,2), '%.2g'), ' ',num2str(p2(1,2), '%.2g')]);
    [r1, p1] = corrcoef(force, ers);
    [r2, p2] = corrcoef(force, erd);
    
%     if (p1(1,2) < 0.05)
        fprintf(fid2,'%s,%f\n',mat.channame{ecog_ind(channelIndex)},r1(1,2));
%     end
%     if (p2(1,2) < 0.05)
        fprintf(fid1,'%s,%f\n',mat.channame{ecog_ind(channelIndex)},r2(1,2));
%     end
end

fclose(fid1);
fclose(fid2);
