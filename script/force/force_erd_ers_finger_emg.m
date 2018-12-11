%maximum foce is defined as the maximum force after 3 seconds of onset
% decode force level / force trend
clear
clc
% base_mat = load('/Users/tengi/Desktop/Projects/data/China/force/S2/squeeze.mat','-mat');
% mat = load('/Users/tengi/Desktop/Projects/data/China/force/S2/relax.mat','-mat');
%data_dir = 'E:\Google Drive\Force Paper\03282017\';
% data_dir = 'E:\Google Drive\Force Paper\05292018\force_pos3\';
data_dir = 'E:\Google Drive\Force Paper\08302018\Force Task\';
% data_dir = 'E:\Google Drive\Force Paper\09112018\Force Task\Merged-interpolated Task\';
pid = 'P3';

base_mat = load([data_dir, 'squeeze.mat'],'-mat');
mat = load([data_dir, 'relax.mat'],'-mat');

squeeze_id = fopen([data_dir, 'montage\squeeze_ers.txt']);
relax_id = fopen([data_dir, 'montage\relax_ers.txt']);

squeeze_chan = textscan(squeeze_id,'%s');
relax_chan = textscan(relax_id,'%s');
fclose(squeeze_id);
fclose(relax_id);

ERS_Squeeze = union(squeeze_chan{1}, relax_chan{1});
%%



out_filename = sprintf('E:\\Google Drive\\Force Paper\\pics\\erds\\%s_%s', pid, mat.event);
if strcmpi(mat.event, 'squeeze')
    t_start = -1;
    fig_width = 620;
else
    t_start = -1;
    fig_width = 620;
end
%%
base_data = base_mat.data;
data = mat.data;

emgName = {'Bipolar EMG', 'EMG', 'Extensor Digitorum'};
emg_ind = ismember(mat.channame, emgName);
forceName = {'Force'};
force_ind = ismember(mat.channame, forceName);

%S1_ERS_Squeeze = {'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C29', 'C30', 'C42', 'C43', 'C55'};
% S1_ERS_Relax = {'C2', 'C3', 'C14', 'C15', 'C18', 'C19', 'C30', 'C43'};

%S2_ERS_Squeeze = {'C110', 'C109', 'C97', 'C86', 'C85', 'C75', 'C74', 'C73', 'C25'};

P1_ERS_Squeeze = {'5', '19', '20', '21', '36', '37', '54', '55', '68', '69', '70', '85', '86', '101', '102', '117', '118'};

ecog_ind = find(ismember(mat.channame, ERS_Squeeze));

fs = mat.fs;
%%

[b1, a1] = butter(2, 0.01/(fs/2), 'high');
[b2, a2] = butter(2, [50, 300]/(fs/2));
[b3, a3] = butter(2, 5/(fs/2), 'low');

[b4, a4] = butter(2,[0.01, 5]/(fs/2));

lfb = [8, 32];
hfb = [60, 200];
wd = 512;
ov = 500;
wl = 128;

emg = cnelab_filter_symmetric(b2, a2, squeeze(data(:, emg_ind, :)),[],0,'iir');

emg_env = mean(cnelab_filter_symmetric(b3, a3, envelope(emg, wl ,'rms'), [], 0, 'iir'), 2);

rforce=cnelab_filter_symmetric(b4, a4, squeeze(data(:, force_ind,:)),[],0,'iir');
force = mean(rforce, 2);

tfm = 0;
base_tfm = 0;
for i = 1:length(ecog_ind)
    [tmp, ~, ~] = tfpower(squeeze(base_data(:, ecog_ind(i), :)), [], fs, wd, ov, []);
    base_tfm = base_tfm+tmp;
    
    [tmp, tf_f, tf_t] = tfpower(squeeze(data(:, ecog_ind(i), :)), [], fs, wd, ov, []);
    tfm = tfm+tmp;
end
tfm = tfm/length(ecog_ind);
base_tfm = base_tfm/length(ecog_ind);
%%

lfb_ix = tf_f >= lfb(1) & tf_f <= lfb(2);
hfb_ix = tf_f >= hfb(1) & tf_f <= hfb(2);
base_ix = tf_t <= mat.ms_before/1000-0.5 & tf_t >= mat.ms_before/1000-1;
erd = mean(tfm(lfb_ix, :), 1)./mean(mean(base_tfm(lfb_ix, base_ix)));
ers = mean(tfm(hfb_ix, :), 1)./mean(mean(base_tfm(hfb_ix, base_ix)));
%%
% figure('position',[100,100,600,450])
figure('position',[100,100,fig_width,450])
colorder = get(gca,'colororder');
shift_force = 0;
% shift_force = 50;

t = tf_t-mat.ms_before/1000;
h1=plot(t,10*log10(erd),'-','Color',colorder(1,:),'LineWidth',7);
hold on
h2=plot(t,10*log10(ers),'-','Color',colorder(2,:), 'LineWidth',7);

axis tight
ylim([-14,14])
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
pos = get(gca, 'position');
set(gca, 'position', [0.14, pos(2), 0.74, pos(4)])
% text(50,8.5,'Onset','FontSize',20)
% plot the force
hold on
yyaxis right
a.YColor=[0,0,0];

if strcmpi(pid, 'P1')
    ylim([-2, 2]);
else
    ylim([-40, 40]);
end
if strcmpi(mat.event, 'squeeze')
    fforce = force-mean(force(1:2000));
else
    fforce = force-mean(force(end-2000:end));
end

% To transform from voltage (V) to Kg
% force = force*16.45-0.118; % transform into kg 
% use relative force changes

% To transform from teensy analog read (0-5 V to 0-1023) to Kg
% force = force/1023*5*16.45-intercept

fforce_scale = fforce/18.58;% scale it

x_f = linspace(-mat.ms_before/1000+shift_force/1000, mat.ms_after/1000+shift_force/1000,size(fforce,1));
h3=plot(x_f, fforce_scale, 'Color', [0, 0, 0], 'linestyle', '-', 'linewidth', 5);
hold on

h4 = plot(x_f(2:end), 600*diff(fforce_scale), 'Color', [0, 176, 80]/255, 'linestyle', '-.', 'linewidth', 5);
hold on
emg_envv = emg_env-mean(emg_env(end-1000:end));% change to fdata(end-400:end, :) for offset
emg_env_scale = emg_envv*3300;
% h4=plot(linspace(-mat.ms_before/1000, mat.ms_after/1000,size(emg_env,1)), emg_env_scale, 'Color', [0, 0, 0], 'linestyle','-.', 'linewidth', 5);
a.FontWeight='bold';
a.LineWidth=5;
xlim([t_start, 1.39]);
label_obj = ylabel('Force (kg)','rot',-90, 'fontsize', 22, 'VerticalAlignment','cap');
pos = get(label_obj, 'position');
set(label_obj, 'position', [1.75, pos(2), pos(3)])

%title([pid, ' ', mat.event])
xlabel('Time (s)', 'fontsize', 22)

if strcmpi(mat.event, 'squeeze')
    %legend([h1, h2, h3, h4],{'ERD', 'ERS', 'Force', 'dForce'}, 'location','northwest');
else
    legend([h1, h2, h3, h4],{'ERD', 'ERS', 'Force', 'dForce'}, 'location','northeast');
    legend('boxoff')
end


export_fig(gcf, '-png', '-opengl', '-nocrop', '-r300', [out_filename, '.png'])
saveas(gcf, [out_filename, '.fig'])