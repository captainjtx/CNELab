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

%%
squeeze_data = squeeze_mat.data;
relax_data = relax_mat.data;

squeeze_id = fopen([data_dir, 'montage\squeeze_ers.txt']);
relax_id = fopen([data_dir, 'montage\relax_ers.txt']);

squeeze_chan = textscan(squeeze_id,'%s');
relax_chan = textscan(relax_id,'%s');
fclose(squeeze_id);
fclose(relax_id);

ERS_Squeeze = union(squeeze_chan{1}, relax_chan{1});

ecog_ind = find(ismember(relax_mat.channame, ERS_Squeeze));

fs = relax_mat.fs;
%%
lfb = [8, 32];
hfb = [60, 200];
wd = 512;
ov = 500;

relax_tfm = [];
squeeze_tfm = [];

squeeze_tr_num = size(squeeze_data,3);
for tr = 1:squeeze_tr_num
    [tmp, ~, tf_t_sq] = tfpower(squeeze(squeeze_data(:, ecog_ind, tr)), [], fs, wd, ov, []);
    squeeze_tfm = cat(3, squeeze_tfm, tmp);
end

hold_tfm = squeeze_tfm(:,:,setdiff(1:squeeze_tr_num, bad_hold_trial));
hold_tr_num = size(hold_tfm, 3);

relax_tr_num = size(relax_data,3);
for tr = 1:relax_tr_num
    [tmp, tf_f, tf_t_relax] = tfpower(squeeze(relax_data(:, ecog_ind, tr)), [], fs, wd, ov, []);
    relax_tfm = cat(3, relax_tfm, tmp);
end
%%
lfb_ix = tf_f >= lfb(1) & tf_f <= lfb(2);
hfb_ix = tf_f >= hfb(1) & tf_f <= hfb(2);
base_ix = tf_t_sq <= squeeze_mat.ms_before/1000-0.5 & tf_t_sq >= squeeze_mat.ms_before/1000-1;

squeeze_ix = tf_t_sq >= squeeze_mat.ms_before/1000 & tf_t_sq <= squeeze_mat.ms_before/1000+0.8;
hold_ix = tf_t_sq >= squeeze_mat.ms_before/1000+1 & tf_t_sq <= squeeze_mat.ms_before/1000+1.8;
relax_ix = tf_t_relax >= relax_mat.ms_before/1000+0 & tf_t_relax <= relax_mat.ms_before/1000+0.8;

lfb_squeeze = 10*log10(squeeze(mean(mean(squeeze_tfm(lfb_ix, squeeze_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_squeeze = 10*log10(squeeze(mean(mean(squeeze_tfm(hfb_ix, squeeze_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(hfb_ix, base_ix, :), 3), 2), 1)));

lfb_hold = 10*log10(squeeze(mean(mean(hold_tfm(lfb_ix, hold_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_hold = 10*log10(squeeze(mean(mean(hold_tfm(hfb_ix, hold_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(hfb_ix, base_ix, :), 3), 2), 1)));

lfb_relax = 10*log10(squeeze(mean(mean(relax_tfm(lfb_ix, relax_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_relax = 10*log10(squeeze(mean(mean(relax_tfm(hfb_ix, relax_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(hfb_ix, base_ix, :), 3), 2), 1)));
%%
for k = 1:2
    if k==1
        x1 = hfb_squeeze(:);
        x2 = hfb_hold(:);
        x3 = hfb_relax(:);
        fig_name = [pid, ' HFB'];
        txt_ypos = -4;
        out_filename = sprintf('E:\\Google Drive\\Force Paper\\pics\\boxplot\\%s_%s', pid, 'HFB');
        yl = [-12, 12];
    else
        x1 = lfb_squeeze(:);
        x2 = lfb_hold(:);
        x3 = lfb_relax(:);
        fig_name = [pid, ' LFB'];
        txt_ypos = 4;
        out_filename = sprintf('E:\\Google Drive\\Force Paper\\pics\\boxplot\\%s_%s', pid, 'LFB');
        yl = [-12, 12];
    end
    
    squeeze_state = cell(squeeze_tr_num,1);
    [squeeze_state{:}]=deal('Onset');
    
    hold_state = cell(hold_tr_num,1);
    [hold_state{:}]=deal('Hold');
    
    relax_state = cell(relax_tr_num,1);
    [relax_state{:}]=deal('Offset');
    
    state = cat(1, squeeze_state, hold_state, relax_state);
    
    figure('position',[100,100,400,267])
    bp=boxplot(cat(1,x1(:), x2(:), x3(:)),...
        state,'labelverbosity','all','labelorientation','horizontal',...
        'positions',[1, 2, 3],'OutlierSize',10, 'width', 0.3);
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
    
    text(1, txt_ypos,['n=' num2str(squeeze_tr_num)],'horizontalalignment','center','fontsize',16);
    
    text(2, txt_ypos,['n=' num2str(hold_tr_num)],'horizontalalignment','center','fontsize',16);
    
    text(3, txt_ypos,['n=' num2str(relax_tr_num)],'horizontalalignment','center','fontsize',16);
    
    plot([-10,10],[0,0],'--k','linewidth',1)
    hold on
    plot([1,2,3], [mean(x1), mean(x2), mean(x3)], '-^k', 'linewidth', 2, 'markeredgecolor', 'k', 'markersize', 8);
    title(fig_name)
    ylabel('dB')
    set(gcf,'color','w')
    box off
    
    export_fig(gcf, '-png', '-opengl', '-nocrop', '-r300', [out_filename, '.png'])
    saveas(gcf, [out_filename, '.fig'])
end