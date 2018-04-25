base_data = Onset.data;

mat = Onset;
data = Offset.data;

emgName = {'EMG'};
emg_ind = ismember(mat.channame, emgName);
forceName = {'Force'};
force_ind = ismember(mat.channame, forceName);

fs = mat.fs;

[b1, a1] = butter(2, 0.01/(fs/2), 'high');
[b2, a2] = butter(2, [50, 300]/(fs/2));
[b3, a3] = butter(2, 5/(fs/2), 'low');
wl = 128;

emg = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b2, a2, squeeze(data(:, emg_ind, :)),[],0,'iir');

emg_env = mean(cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b3, a3, envelope(emg, wl ,'peak'), [], 0, 'iir'), 2);

rforce=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b1, a1, squeeze(data(:, force_ind,:)),[],0,'iir');
force = mean(rforce, 2);

figure('position',[100,100,600,450])
colorder = get(gca,'colororder');

hold on

a=gca;
a.FontSize = 22;

grid on

% ylabel('ERD/ERS (dB)');
set(gcf,'color','white');
hold on
a.YColor=[0,0,0];
ylim([-100, 100]);
fforce = force-mean(force(end-400:end));
fforce = fforce/max(abs(fforce))*90;
h3=plot(linspace(-mat.ms_before/1000, mat.ms_after/1000,size(fforce,1)), fforce, 'Color', [0.5,0.8,0.1], 'linestyle', ':', 'linewidth', 5);

hold on
emg_env = emg_env-mean(emg_env(end-400:end));
emg_env = emg_env/max(abs(emg_env))*90;
h4=plot(linspace(-mat.ms_before/1000, mat.ms_after/1000,size(emg_env,1)), emg_env, 'Color', [0, 0, 0], 'linestyle','-.', 'linewidth', 5);
a.FontWeight='bold';
a.LineWidth=5;

legend([h3, h4],{'Force', 'EMG'}, 'location','northeast');
legend('boxoff')

title('Offset')



