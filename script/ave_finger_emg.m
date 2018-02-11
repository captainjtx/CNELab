%maximum foce is defined as the maximum force after 3 seconds of onset
% decode force level / force trend
% clear
clc
mat = load('/Users/tengi/Desktop/Projects/data/Turkey/s1/EMG_Glove.mat','-mat');
% mat = load('/Users/tengi/Desktop/Close.mat','-mat');
% mat = Close;
%%
data = mat.data;

emgName = {'Bipolar EMG', 'EMG'};
emg_ind = ismember(mat.channame, emgName);
gloveName = {'F1', 'F2', 'F3', 'F4', 'F5', 'Thumb', 'Index', 'Middle', 'Ring', 'Little'};
glove_ind = find(ismember(mat.channame, gloveName));

fs = mat.fs;
%%

[b1, a1] = butter(2, 0.01/(fs/2), 'high');
[b2, a2] = butter(2, [50, 300]/(fs/2));
[b3, a3] = butter(2, 5/(fs/2), 'low');

wl = 512;

% emg = filter_symmetric(b2, a2, squeeze(data(:, emg_ind, :)),[],0,'iir')5
emg = squeeze(data(:, emg_ind, :));
% emg_env = mean(filter_symmetric(b3, a3, envelope(emg), [], 0, 'iir'), 2);
% emg_env = mean(envelope(emg, wl, 'rms'),2);
% emg_env = mean(envelope(emg, wl, 'rms'), 2);
emg_env = emg;
glove = data(:, glove_ind, :);
glove = squeeze(mean(glove,3));
glove = mean(glove, 2);
%%
figure('position',[100,100,600,450])

a=gca;


plot([0,0],a.YLim,':k','linewidth',1);
grid on

colorder = get(gca,'colororder');

set(gcf,'color','white');

hold on


t= linspace(-mat.ms_before/1000, mat.ms_after/1000,size(glove,1));



% emg_envv = emg_env-mean(emg_env(1:1000));% change to fdata(end-400:end, :) for offset
emg_envv = abs(emg_env);
h4=plot(t, emg_envv, 'Color', [0.5, 0.5, 0.5], 'linestyle','-', 'linewidth', 1);
ylim([-40 , 600])
hold on
h1 =plot(t, squeeze(sqrt(mean(emg_envv.^2,2))), 'Color', colorder(2,:), 'linestyle','-', 'linewidth', 2);

yyaxis right

ylabel('Finger','rot',-90, 'fontsize', 20, 'VerticalAlignment','bottom')

a.FontWeight='bold';
a.LineWidth=5;
a.FontSize = 20;
title(['P2 ', mat.event])
xlabel('Time (s)', 'fontsize', 22)
a.YColor=[0,0,0];

hold on
h3=plot(t, glove-mean(glove(1:1000)), 'Color', colorder(1, :), 'linestyle', '-.', 'linewidth', 5);
ylabel('EMG Envelope (uV)', 'fontsize', 20);
ylim([-6, 80])
% legend([h3, h4],{'Finger', 'EMG Env'}, 'location','northeast');
% legend('boxoff')


