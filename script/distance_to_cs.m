%%s1
cs=load('s1_central_sulcus.mat');
ele=load('s1_orignal_mri_ct_fixed.mat');
hfb={'C68_S','C67_S','C66_S','C10_L','C73_S','C72_S','C20_L','C19_L','C18_L','C81_S','C80_S','C27_L','C88_S'};
ufb={'C11_L','C74_S'};
%%
%s2
cs=load('s2_central_sulcus.mat');
ele=load('electrode_interp.mat');
hfb={'C16_L','C32_L','C15_L','C39_L','C78_S','C92_S','C77_S','C91_S','C14_L','C22_L','C30_L','C38_L','C76_S','C83_S','C13_L','C21_L','C29_L','C75_S'};
ufb={'C24_L','C23_L','C22_L','C31_L','C85_S','C84_S'};
lfb={'C16_L','C32_L','C15_L','C39_L','C78_S','C92_S','C77_S','C91_S','C14_L','C22_L','C30_L','C38_L','C76_S','C83_S','C13_L','C21_L','C29_L','C75_S',...
    'C97_S','C98_S','C99_S','C37_L','C38_L','C40_L','C90_S','C92_S','C69_S','C70_S','C71_S'};
%%
[xy,distance,t_a] = distance2curve(cs.coor,ele.coor,'linear');
%%
lfb_ind=ismember(ele.channame,lfb);
hfb_ind=ismember(ele.channame,hfb);
ufb_ind=ismember(ele.channame,ufb);
hfb_group=cell(length(hfb),1);
[hfb_group{:}]=deal('HFB');
ufb_group=cell(length(ufb),1);
[ufb_group{:}]=deal('UFB');

d=[distance(hfb_ind);distance(ufb_ind)];
g=cat(1,hfb_group,ufb_group);
bp=boxplot(d,g,'labelverbosity','all','labelorientation','horizontal','OutlierSize',10);
drawnow;
a=gca;
%ylim([-10,10])
a.FontSize=20;
title('S1')
ylabel('Distance to CS')
%%
hold on
scatter([1,2],10*log10([mean(mean(trial_info_hfb(1).pow(:,logical(trial_info_hfb(1).ers_chan)),2));...
    mean(mean(trial_info_hfb(2).pow(:,logical(trial_info_hfb(2).ers_chan)),1))]),50,'*r')

scatter([3.5,4.5],10*log10([mean(mean(trial_info_lfb(1).pow(:,logical(trial_info_lfb(1).erd_chan)),2));...
    mean(mean(trial_info_lfb(2).pow(:,logical(trial_info_lfb(2).erd_chan)),1))]),50,'*r');

set(findobj(gca,'type','line'),'linewidth',2)
% set(findobj(gca,'type','text'),'fontweight','bold')

text(1,0,['n=' num2str(size(trial_info_hfb(1).pow,1))],'horizontalalignment','center','fontsize',18);

text(2,0,['n=' num2str(size(trial_info_hfb(2).pow,1))],'horizontalalignment','center','fontsize',18);

text(3.5,0,['n=' num2str(size(trial_info_lfb(1).pow,1))],'horizontalalignment','center','fontsize',18);

text(4.5,0,['n=' num2str(size(trial_info_lfb(2).pow,1))],'horizontalalignment','center','fontsize',18);

plot([-10,10],[0,0],'--k','linewidth',1)

set(gcf,'color','w')
% a.XTickLabel={['HFB ' trial_info_hfb(1).event],['HFB ' trial_info_hfb(2).event],['LFB ' trial_info_lfb(1).event], ['LFB ' trial_info_lfb(2).event]};
