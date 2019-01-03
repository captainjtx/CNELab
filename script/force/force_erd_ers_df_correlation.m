%%
clear
clc
close all

google_drive_dir = '/Users/tengi/Google Drive/';
% google_drive_dir = 'E:\Google Drive'

data_dir = fullfile(google_drive_dir, 'Force Paper/03282017/');
% data_dir = fullfile(google_drive_dir, 'Force Paper/05292018/force_pos3/');
% data_dir = fullfile(google_drive_dir, 'Force Paper/08302018/Force Task/');
% data_dir = fullfile(google_drive_dir, 'Force Paper/09112018/Force Task/Merged-interpolated Task/');
pid = 'P1';

mat = load([data_dir, 'squeeze.mat'],'-mat');
mat.event = 'Squeeze';

data = mat.data;
fs = mat.fs;

squeeze_id = fopen(fullfile(data_dir, 'montage/squeeze_ers.txt'));
% relax_id = fopen([data_dir, 'montage\relax_ers.txt']);
out_filename = sprintf(fullfile(google_drive_dir, 'Force Paper/pics/df/%s_%s_'), pid, mat.event);

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
[b4, a4] = butter(2,[0.01, 5]/(fs/2));
force=cnelab_filter_symmetric(b4, a4, force,[],0,'iir');

% To transform from voltage (V) to Kg
% force = force*16.45-0.118; % transform into kg 
% use relative force changes

% To transform from teensy analog read (0-5 V to 0-1023) to Kg
% force = force/1023*5*16.45-intercept, 1kg = 12.4377

% by the new calibration 1kg = 16.8328 in measurement

force = force/16.8328;
dF = zeros(size(force));
for tr = 1:size(dF, 2)
    dF(:, tr) = gradient(force(:, tr));
    force(:, tr) = force(:, tr) - mean(force(1:2000, tr));
end

ecog_ind = find(ismember(mat.channame, ERS_Squeeze));

[b1, a1]=butter(2,[8, 32]/(fs/2));
[b2, a2] = butter(2, [60, 200]/(fs/2));

tfm = [];

trNum = size(data, 3);
lfb_o = [];
hfb_o = [];
for i = 1:trNum
    lfb_o(:, :, i) = cnelab_filter_symmetric(b1, a1, squeeze(data(:, ecog_ind, i)), 0, 0, 'iir');
    hfb_o(:, :, i) = cnelab_filter_symmetric(b2, a2, squeeze(data(:, ecog_ind, i)), 0, 0, 'iir');
end

hfb = hfb_o.^2;
lfb = lfb_o.^2;

hfb = squeeze(mean(hfb, 2));
lfb = squeeze(mean(lfb, 2));

tf_t = (1:size(data, 1))/fs-mat.ms_before/1000;

base_ix = tf_t <= -1 & tf_t >= -1.5;

for i = 1:trNum
    lfb(:, i) = lfb(:, i)./mean(lfb(base_ix, i));
    hfb(:, i) = hfb(:, i)./mean(hfb(base_ix, i));
end

erd_raw = 10*log10(lfb);
ers_raw = 10*log10(hfb);

ers = smoothdata(ers_raw, 1, 'movmean', 256);
erd = smoothdata(erd_raw, 1, 'movmean', 256);

onset_ix = tf_t >= -1  & tf_t <= 1.5;

ers_r = zeros(size(dF, 2), 1);
ers_lag = ers_r;

erd_r = ers_r;
erd_lag = ers_r;

ers_lags = cell(size(dF, 2));
ers_bounds = cell(size(dF, 2));
ers_rs = cell(size(dF, 2));

erd_lags = cell(size(dF, 2));
erd_bounds = cell(size(dF, 2));
erd_rs = cell(size(dF, 2));

for tr = 1:size(dF, 2)
    [r, lags, bounds] = crosscorr(ers(onset_ix, tr), dF(onset_ix, tr), fs);
    [ers_r(tr), max_ind] = max(r);
    ers_lag(tr) = lags(max_ind);
    
    ers_lags{tr} = lags;
    ers_bounds{tr} = bounds;
    ers_rs{tr} = r;
    
    [r, lags, bounds] = crosscorr(erd(onset_ix, tr), dF(onset_ix, tr), fs);
    [erd_r(tr), min_ind] = min(r);
    erd_lag(tr) = lags(min_ind);
    
    erd_lags{tr} = lags;
    erd_bounds{tr} = bounds;
    erd_rs{tr} = r;
end
%%
% [~, max_tr] = max(ers_r);
% figure('position', [100, 100, 450, 250])
% colorder = get(gca,'colororder');
% 
% h1 = plot(tf_t, erd(:, max_tr), 'color', colorder(1, :), 'linewidth', 2);
% hold on
% h2 = plot(tf_t, ers(:, max_tr), 'color', colorder(2, :), 'linewidth', 2);
% a = gca;
% 
% a.Position = [0.13, 0.19, 0.7, 0.7];
% 
% if strcmpi(pid, 'P1')
%     ylim([-12, 12]);
% else
%     ylim([-12, 12])
% end
% 
% ylabel('ERS/ERD (dB)')
% grid on
% hold on
% yyaxis right
% 
% label_obj = ylabel('dForce (kg/s)','rot',-90, 'VerticalAlignment','cap');
% pos = get(label_obj, 'position');
% set(label_obj, 'position', [1.9, pos(2), pos(3)])
% 
% a.YColor=[0,0,0];
% h3 = plot(tf_t, dF(:, max_tr)*fs, '', 'linewidth', 2, 'linestyle', '-.');
% 
% if strcmpi(pid, 'P1')
%     ylim([-10, 10]);
% elseif strcmpi(pid, 'P2')
%     ylim([-120, 120]);
% else
%     ylim([-80, 80]);
% end
% 
% hold on
% plot(a.XLim,[0,0],'--k','linewidth',2);
% 
% plot([0,0],a.YLim,':k','linewidth',2);
% legend([h1, h2, h3],{'ERD', 'ERS', 'dForce'}, 'location','northeast');
% legend('boxoff')
% 
% % hold on
% % plot(tf_t, force(:, max_tr))
% xlim([-1, 1.5])
% 
% set(gca, 'fontsize', 15, 'fontweight', 'bold')
% title([pid, ' ', mat.event, ' Trial  ', num2str(max_tr)], 'fontsize', 20)
% set(gcf,'color','w')
% xlabel('Time (s)')
% a.LineWidth=2;
% 
% export_fig(gcf, '-png', '-opengl', '-nocrop', '-r300', [out_filename, '_signal.png'])
% saveas(gcf, [out_filename, '_signal.fig'])
% 
% figure('position', [100, 100, 450, 200])
% h1 = stem(erd_lags{max_tr}(1:100:end)/fs, erd_rs{max_tr}(1:100:end),'filled', 'color', colorder(1, :));
% hold on
% h2 = stem(ers_lags{max_tr}(1:100:end)/fs, ers_rs{max_tr}(1:100:end),'filled', 'color', colorder(2, :));
% xlim([-0.5, 0.5])
% hold on
% plot(ers_lags{max_tr}/fs,[ers_bounds{max_tr}(1);ers_bounds{max_tr}(2)]*ones(size(ers_lags{max_tr}))','r', 'linewidth', 1)
% hold off
% ylim([-1, 1])
% xlabel('Lags (s)')
% ylabel('Corrcoef')
% grid on
% pos = get(gca, 'position');
% 
% set(gca, 'fontsize', 15, 'fontweight', 'bold', 'linewidth', 2, 'position', [0.13, 0.22, 0.7, 0.65])
% title(['MAX R_{ers}: ', num2str(max(ers_rs{max_tr}), '%1.2f'), '  MIN R_{erd}: ', num2str(min(erd_rs{max_tr}), '%1.2f')])
% 
% xlim([-1, 1])
% 
% set(gcf, 'color', 'w')
% 
% legend([h1, h2],{'ERD vs dF', 'ERS vs dF'}, 'location','northeast');
% legend('boxoff')
% 
% export_fig(gcf, '-png', '-opengl', '-nocrop', '-r300', [out_filename, '_xcorr.png'])
% saveas(gcf, [out_filename, '_xcorr.fig'])

%%
figure('Position', [100, 100, 300, 300])
set(gcf, 'color', 'w')

h1 = scatter(erd_lag/fs*100, erd_r, 'o', 'sizedata', 100, 'linewidth', 2);
hold on
h2 = scatter(ers_lag/fs*100, ers_r, '*', 'sizedata', 100, 'linewidth', 2);
a = gca;
hold on 
xlim([-120, 120])
ylim([-1, 1])
plot(a.XLim,[0,0],'--k','linewidth',2);
plot([0,0],a.YLim,':k','linewidth',2);


xlabel('Lags (ms)')
ylabel('Corrcoef')

title(pid)

a.FontSize = 22;
a.LineWidth = 2;
a.FontWeight = 'bold';

% legend([h1, h2],{'ERD vs dF', 'ERS vs dF'}, 'location','northeast');
% legend('boxoff')
export_fig(gcf, '-png', '-opengl', '-nocrop', '-r300', [out_filename, '_all.png'])
saveas(gcf, [out_filename, '_all.fig'])