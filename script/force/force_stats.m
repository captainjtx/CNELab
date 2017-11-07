%maximum foce is defined as the maximum force after 3 seconds of onset
% decode force level / force trend
clear
clc

squeeze_mat = load('/Users/tengi/Desktop/Projects/data/China/force/S1/squeeze.mat','-mat');
relax_mat = load('/Users/tengi/Desktop/Projects/data/China/force/S1/relax.mat','-mat');
%%
squeeze_data = squeeze_mat.data;
relax_data = relax_mat.data;

S1_ERS_Squeeze = {'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C29', 'C30', 'C42', 'C43', 'C55'};
% S1_ERS_Relax = {'C2', 'C3', 'C14', 'C15', 'C18', 'C19', 'C30', 'C43'};
s1_bad_hold_trial = [4, 15, 18, 24];
S2_ERS_Squeeze = {'C110', 'C109', 'C97', 'C86', 'C85', 'C75', 'C74', 'C73', 'C25'};
s2_bad_hold_trial = [5, 13];
ecog_ind = find(ismember(relax_mat.channame, S1_ERS_Squeeze));

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
    [tmp, ~, ~] = tfpower(squeeze(squeeze_data(:, ecog_ind, tr)), [], fs, wd, ov, []);
    squeeze_tfm = cat(3, squeeze_tfm, tmp);
end

hold_tfm = squeeze_tfm(:,:,setdiff(1:squeeze_tr_num, s1_bad_hold_trial));
hold_tr_num = size(hold_tfm, 3);

relax_tr_num = size(relax_data,3);
for tr = 1:relax_tr_num
    [tmp, tf_f, tf_t] = tfpower(squeeze(relax_data(:, ecog_ind, tr)), [], fs, wd, ov, []);
    relax_tfm = cat(3, relax_tfm, tmp);
end
%%
lfb_ix = tf_f >= lfb(1) & tf_f <= lfb(2);
hfb_ix = tf_f >= hfb(1) & tf_f <= hfb(2);
base_ix = tf_t <= squeeze_mat.ms_before/1000-0.5 & tf_t >= squeeze_mat.ms_before/1000-1;

squeeze_ix = tf_t >= squeeze_mat.ms_before/1000-0.15 & tf_t <= squeeze_mat.ms_before/1000+0.85;
hold_ix = tf_t >= squeeze_mat.ms_before/1000+1 & tf_t <= squeeze_mat.ms_before/1000+1.8;
relax_ix = tf_t >= relax_mat.ms_before/1000 & tf_t <= relax_mat.ms_before/1000+0.8;

lfb_squeeze = 10*log10(squeeze(mean(mean(squeeze_tfm(lfb_ix, squeeze_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_squeeze = 10*log10(squeeze(mean(mean(squeeze_tfm(hfb_ix, squeeze_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(hfb_ix, base_ix, :), 3), 2), 1)));

lfb_hold = 10*log10(squeeze(mean(mean(hold_tfm(lfb_ix, hold_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_hold = 10*log10(squeeze(mean(mean(hold_tfm(hfb_ix, hold_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(hfb_ix, base_ix, :), 3), 2), 1)));

lfb_relax = 10*log10(squeeze(mean(mean(relax_tfm(lfb_ix, relax_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(lfb_ix, base_ix, :), 3), 2), 1)));
hfb_relax = 10*log10(squeeze(mean(mean(relax_tfm(hfb_ix, relax_ix, :), 2), 1)./mean(mean(mean(squeeze_tfm(hfb_ix, base_ix, :), 3), 2), 1)));
%%

x1 = lfb_squeeze(:);
x2 = lfb_hold(:);
x3 = lfb_relax(:);

squeeze_state = cell(squeeze_tr_num,1);
[squeeze_state{:}]=deal('Onset');

hold_state = cell(hold_tr_num,1);
[hold_state{:}]=deal('Hold');

relax_state = cell(relax_tr_num,1);
[relax_state{:}]=deal('Offset');

state = cat(1, squeeze_state, hold_state, relax_state);

figure('position',[100,100,300,200])
bp=boxplot(cat(1,x1(:), x2(:), x3(:)),...
    state,'labelverbosity','all','labelorientation','horizontal',...
    'positions',[1, 2, 3],'OutlierSize',10, 'width', 0.3);
drawnow;

a=gca;
ylim([-14,14])
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

text(1,0,['n=' num2str(squeeze_tr_num)],'horizontalalignment','center','fontsize',16);

text(2,0,['n=' num2str(hold_tr_num)],'horizontalalignment','center','fontsize',16);

text(3,0,['n=' num2str(relax_tr_num)],'horizontalalignment','center','fontsize',16);

plot([-10,10],[0,0],'--k','linewidth',1)
hold on
plot([1,2,3], [mean(x1), mean(x2), mean(x3)], '-^k', 'linewidth', 2, 'markeredgecolor', 'k', 'markersize', 8);
title('P2 LFB')
ylabel('dB')
set(gcf,'color','w')
box off
