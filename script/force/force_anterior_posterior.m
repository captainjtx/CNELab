%maximum foce is defined as the maximum force after 3 seconds of onset
% decode force level / force trend
clear
clc

% data_dir = 'E:\Google Drive\Force Paper\03282017\';
% data_dir = 'E:\Google Drive\Force Paper\05292018\force_pos3\';
% data_dir = 'E:\Google Drive\Force Paper\08302018\Force Task\';
data_dir = 'E:\Google Drive\Force Paper\09112018\Force Task\Merged-interpolated Task\';
pid = 'P4';

bad_hold_trial = [];

squeeze_mat = load([data_dir, 'squeeze.mat'],'-mat');
relax_mat = load([data_dir, 'relax.mat'],'-mat');

squeeze_data = squeeze_mat.data;
relax_data = relax_mat.data;

squeeze_anterior_id = fopen([data_dir, 'montage\squeeze_ers_anterior.txt']);
relax_anterior_id = fopen([data_dir, 'montage\relax_ers_anterior.txt']);

squeeze_posterior_id = fopen([data_dir, 'montage\squeeze_ers_posterior.txt']);
relax_posterior_id = fopen([data_dir, 'montage\relax_ers_posterior.txt']);

squeeze_id = fopen([data_dir, 'montage\squeeze_ers.txt']);
relax_id = fopen([data_dir, 'montage\relax_ers.txt']);

squeeze_anterior_chan = textscan(squeeze_anterior_id,'%s');
squeeze_anterior_chan = squeeze_anterior_chan{1};

relax_anterior_chan = textscan(relax_anterior_id,'%s');
relax_anterior_chan = relax_anterior_chan{1};

squeeze_posterior_chan = textscan(squeeze_posterior_id,'%s');
squeeze_posterior_chan = squeeze_posterior_chan{1};

relax_posterior_chan = textscan(relax_posterior_id,'%s');
relax_posterior_chan = relax_posterior_chan{1};

squeeze_chan = textscan(squeeze_id,'%s');
squeeze_chan = squeeze_chan{1};

relax_chan = textscan(relax_id,'%s');
relax_chan = relax_chan{1};

fclose(squeeze_anterior_id);
fclose(relax_anterior_id);
fclose(squeeze_posterior_id);
fclose(relax_posterior_id);
fclose(squeeze_id);
fclose(relax_id);

fs = relax_mat.fs;
%%
lfb = [8, 32];
hfb = [60, 200];
wd = 512;
ov = 500;

relax_tfm_anterior = [];
squeeze_tfm_anterior = [];
relax_tfm_posterior = [];
squeeze_tfm_posterior = [];

sr_tfm_anterior = [];
sr_tfm_posterior = [];

squeeze_ind = find(ismember(relax_mat.channame, squeeze_chan));
relax_ind = find(ismember(relax_mat.channame, relax_chan));
squeeze_anterior_ind = find(ismember(relax_mat.channame, squeeze_anterior_chan));
squeeze_posterior_ind = find(ismember(relax_mat.channame, squeeze_posterior_chan));
relax_anterior_ind = find(ismember(relax_mat.channame, relax_anterior_chan));
relax_posterior_ind = find(ismember(relax_mat.channame, relax_posterior_chan));

squeeze_tr_num = size(squeeze_data, 3);

for tr = 1:squeeze_tr_num
    [tmp, ~, tf_sq] = tfpower(squeeze(squeeze_data(:, squeeze_anterior_ind, tr)), [], fs, wd, ov, []);
    squeeze_tfm_anterior = cat(3, squeeze_tfm_anterior, tmp);
end

for tr = 1:squeeze_tr_num
    [tmp, ~, tf_sq] = tfpower(squeeze(squeeze_data(:, squeeze_posterior_ind, tr)), [], fs, wd, ov, []);
    squeeze_tfm_posterior = cat(3, squeeze_tfm_posterior, tmp);
end

for tr = 1:squeeze_tr_num
    [tmp, ~, tf_sq] = tfpower(squeeze(squeeze_data(:, relax_anterior_ind, tr)), [], fs, wd, ov, []);
    sr_tfm_anterior = cat(3, sr_tfm_anterior, tmp);
end

for tr = 1:squeeze_tr_num
    [tmp, ~, tf_sq] = tfpower(squeeze(squeeze_data(:, relax_posterior_ind, tr)), [], fs, wd, ov, []);
    sr_tfm_posterior = cat(3, sr_tfm_posterior, tmp);
end

relax_tr_num = size(relax_data, 3);
for tr = 1:relax_tr_num
    [tmp, tf_f, tf_relax] = tfpower(squeeze(relax_data(:, relax_anterior_ind, tr)), [], fs, wd, ov, []);
    relax_tfm_anterior = cat(3, relax_tfm_anterior, tmp);
end

for tr = 1:relax_tr_num
    [tmp, tf_f, tf_relax] = tfpower(squeeze(relax_data(:, relax_posterior_ind, tr)), [], fs, wd, ov, []);
    relax_tfm_posterior = cat(3, relax_tfm_posterior, tmp);
end
%%
lfb_ix = tf_f >= lfb(1) & tf_f <= lfb(2);
hfb_ix = tf_f >= hfb(1) & tf_f <= hfb(2);
base_ix = tf_relax <= squeeze_mat.ms_before/1000-0.5 & tf_relax >= squeeze_mat.ms_before/1000-1;

squeeze_ix = tf_sq >= squeeze_mat.ms_before/1000 & tf_sq <= squeeze_mat.ms_before/1000+0.8;
hold_ix = tf_sq >= squeeze_mat.ms_before/1000+1 & tf_sq <= squeeze_mat.ms_before/1000+1.8;
relax_ix = tf_relax >= relax_mat.ms_before/1000+0 & tf_relax <= relax_mat.ms_before/1000+0.8;

lfb_squeeze_anterior = 10*log10(squeeze(mean(mean(squeeze_tfm_anterior(lfb_ix, squeeze_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm_anterior(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_squeeze_anterior = 10*log10(squeeze(mean(mean(squeeze_tfm_anterior(hfb_ix, squeeze_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm_anterior(hfb_ix, base_ix, :), 3), 2), 1)));

lfb_hold_anterior = 10*log10(squeeze(mean(mean(squeeze_tfm_anterior(lfb_ix, hold_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm_anterior(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_hold_anterior = 10*log10(squeeze(mean(mean(squeeze_tfm_anterior(hfb_ix, hold_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm_anterior(hfb_ix, base_ix, :), 3), 2), 1)));

lfb_relax_anterior = 10*log10(squeeze(mean(mean(relax_tfm_anterior(lfb_ix, relax_ix, :), 2), 1)./mean(mean(mean(sr_tfm_anterior(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_relax_anterior = 10*log10(squeeze(mean(mean(relax_tfm_anterior(hfb_ix, relax_ix, :), 2), 1)./mean(mean(mean(sr_tfm_anterior(hfb_ix, base_ix, :), 3), 2), 1)));

lfb_squeeze_posterior = 10*log10(squeeze(mean(mean(squeeze_tfm_posterior(lfb_ix, squeeze_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm_posterior(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_squeeze_posterior = 10*log10(squeeze(mean(mean(squeeze_tfm_posterior(hfb_ix, squeeze_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm_posterior(hfb_ix, base_ix, :), 3), 2), 1)));

lfb_hold_posterior = 10*log10(squeeze(mean(mean(squeeze_tfm_posterior(lfb_ix, hold_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm_posterior(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_hold_posterior = 10*log10(squeeze(mean(mean(squeeze_tfm_posterior(hfb_ix, hold_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm_posterior(hfb_ix, base_ix, :), 3), 2), 1)));

lfb_relax_posterior = 10*log10(squeeze(mean(mean(relax_tfm_posterior(lfb_ix, relax_ix, :), 2), 1)./mean(mean(mean(sr_tfm_posterior(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_relax_posterior = 10*log10(squeeze(mean(mean(relax_tfm_posterior(hfb_ix, relax_ix, :), 2), 1)./mean(mean(mean(sr_tfm_posterior(hfb_ix, base_ix, :), 3), 2), 1)));
%%

squeeze_state = cell(2*squeeze_tr_num,1);
[squeeze_state{:}]=deal('On');

hold_state = cell(2*squeeze_tr_num,1);
[hold_state{:}]=deal('Hold');

relax_state = cell(2*relax_tr_num,1);
[relax_state{:}]=deal('Off');

squeeze_ap = cell(2*squeeze_tr_num,1);
[squeeze_ap{1:squeeze_tr_num}]=deal('A');
[squeeze_ap{squeeze_tr_num+1:2*squeeze_tr_num}]=deal('P');

hold_ap = cell(2*squeeze_tr_num,1);
[hold_ap{1:squeeze_tr_num}]=deal('A');
[hold_ap{squeeze_tr_num+1:2*squeeze_tr_num}]=deal('P');

relax_ap = cell(2*relax_tr_num,1);
[relax_ap{1:relax_tr_num}]=deal('A');
[relax_ap{relax_tr_num+1:2*relax_tr_num}]=deal('P');

state = cat(1, squeeze_state, hold_state, relax_state);
ap = cat(1, squeeze_ap, hold_ap, relax_ap);
for k = 1:2
    pp = zeros(6, 1);
    if k==1
        x1 = hfb_squeeze_anterior(:);
        x2 = hfb_hold_anterior(:);
        x3 = hfb_relax_anterior(:);
        y1 = hfb_squeeze_posterior(:);
        y2 = hfb_hold_posterior(:);
        y3 = hfb_relax_posterior(:);
        
        fig_name = [pid, ' HFB'];
        txt_ypos = -3;
        t_ypos = -7;
        out_filename = sprintf('E:\\Google Drive\\Force Paper\\pics\\ap\\%s_%s', pid, 'HFB');
        yl = [-9, 9];
        
        [~, pp(1)] = ttest(x1, 0, 'tail', 'right');
        [~, pp(2)] = ttest(y1, 0, 'tail', 'right');
        [~, pp(3)] = ttest(x2, 0, 'tail', 'right');
        [~, pp(4)] = ttest(y2, 0, 'tail', 'right');
        [~, pp(5)] = ttest(x3, 0, 'tail', 'right');
        [~, pp(6)] = ttest(y3, 0, 'tail', 'right');
    else
        x1 = lfb_squeeze_anterior(:);
        x2 = lfb_hold_anterior(:);
        x3 = lfb_relax_anterior(:);
        y1 = lfb_squeeze_posterior(:);
        y2 = lfb_hold_posterior(:);
        y3 = lfb_relax_posterior(:);
        fig_name = [pid, ' LFB'];
        txt_ypos = 7;
        t_ypos = 15;
        out_filename = sprintf('E:\\Google Drive\\Force Paper\\pics\\ap\\%s_%s', pid, 'LFB');
        yl = [-18, 18];
        
        [~, pp(1)] = ttest(x1, 0, 'tail', 'left');
        [~, pp(2)] = ttest(y1, 0, 'tail', 'left');
        [~, pp(3)] = ttest(x2, 0, 'tail', 'left');
        [~, pp(4)] = ttest(y2, 0, 'tail', 'left');
        [~, pp(5)] = ttest(x3, 0, 'tail', 'left');
        [~, pp(6)] = ttest(y3, 0, 'tail', 'left');
    end
   
    figure('position',[100,100,400,267])
    dat = cat(1,x1(:), y1(:), x2(:), y2(:), x3(:), y3(:));
    bp=boxplot(dat,...
        {state,ap},'labelverbosity','all','labelorientation','horizontal',...
        'positions',[1, 2, 3, 4, 5, 6],'OutlierSize',10, 'width', 0.3);
    drawnow;
    
    a=gca;
    ylim(yl)
    a.FontSize=18;
    
    txt=findobj(gca,'type','text');
    for i=1:length(txt)
        p=txt(i).Position;
        set(txt(i),'FontSize',12);
        set(txt(i),'VerticalAlignment','cap', 'fontweight', 'bold');
    end
    hold on
    
    % scatter([1, 2, 3],[mean(lfb_squeeze), mean(hfb_squeeze), mean(lfb_hold), mean(hfb_hold), mean(lfb_relax), mean(hfb_relax)],50,'*r')
    
    set(findobj(gca,'type','line'),'linewidth',2)
    % set(findobj(gca,'type','text'),'fontweight','bold')
    
    [h1, p1] = ttest(x1, y1);
    if p1 < 0.005
        str = 'p<0.005';
    elseif p1 < 0.05
        str = 'p<0.05';
    else
        str = ['p=' num2str(p1, '%1.2f')];
    end
        
    text(1.5, txt_ypos, str,'horizontalalignment','center','fontsize',16);
    
    
    [h2, p2] = ttest(x2, y2);
    
    if p2 < 0.005
        str = 'p<0.005';
    elseif p2 < 0.05
        str = 'p<0.05';
    else
        str = ['p=' num2str(p2, '%1.2f')];
    end
    text(3.5, txt_ypos,str,'horizontalalignment','center','fontsize',16);
    
    [h3, p3] = ttest(x3, y3);
    if p3 < 0.005
        str = 'p<0.005';
    elseif p3 < 0.05
        str = 'p<0.05';
    else
        str = ['p=' num2str(p3, '%1.2f')];
    end
    text(5.5, txt_ypos,str,'horizontalalignment','center','fontsize',16);
    
    plot([-10,10],[0,0],'--k','linewidth',1)
    
    for ppi = 1:6
        if pp(ppi) > 0.05
            ss = 'ns';
            display([num2str(k), ':', num2str(ppi), ':' num2str(pp(ppi))])
        elseif pp(ppi) < 0.00005
            ss = '****';
        elseif pp(ppi) < 0.0005
            ss = '***';
        elseif pp(ppi) < 0.005
            ss = '**';
        else
            ss = '*';
        end
        
        text(ppi, t_ypos, ss, 'horizontalalignment','center','fontsize',16);
    end
    title(fig_name)
    ylabel('dB')
    set(gcf,'color','w')
    box off
    
    export_fig(gcf, '-png', '-opengl', '-nocrop', '-r300', [out_filename, '.png'])
    saveas(gcf, [out_filename, '.fig'])
end