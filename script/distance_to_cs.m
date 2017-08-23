subj='s1';
%%s1
cs=load([subj,'_central_sulcus.mat']);
ele=load([subj,'_electrode.mat']);
%ele=load('electrode_interp.mat');
sm1=ReadSpatialMap([subj,'_Close_8-32_start-100_len500.smw']);
lfb=sm1.name(sm1.sig==-1);
sm2=ReadSpatialMap([subj,'_Close_60-280_start-100_len500.smw']);
hfb=sm2.name(sm2.sig==1);
sm3=ReadSpatialMap([subj,'_Close_300-800_start-100_len500.smw']);
ufb=sm3.name(sm3.sig==1);

[xy,distance,t_a] = distance2curve(cs.coor,ele.coor,'linear');

lfb_ind=ismember(ele.channame,lfb);
hfb_ind=ismember(ele.channame,hfb);
ufb_ind=ismember(ele.channame,ufb);
lfb_group=cell(length(lfb),1);
[lfb_group{:}]=deal('LFB');
hfb_group=cell(length(hfb),1);
[hfb_group{:}]=deal('HFB');
ufb_group=cell(length(ufb),1);
[ufb_group{:}]=deal('UFB');

d=[distance(lfb_ind);distance(hfb_ind);distance(ufb_ind)];
g=cat(1,lfb_group,hfb_group,ufb_group);
figure('position',[100,100,300,400])
bp=boxplot(d,g,'labelverbosity','all','labelorientation','horizontal','OutlierSize',15);
drawnow;

hold on
scatter([1,2,3],[mean(distance(lfb_ind)),mean(distance(hfb_ind)),mean(distance(ufb_ind))],200,'*r')
[mean(distance(lfb_ind)),mean(distance(hfb_ind)),mean(distance(ufb_ind))]
[std(distance(lfb_ind)),std(distance(hfb_ind)),std(distance(ufb_ind))]
a=gca;
%ylim([-10,10])
a.FontSize=20;
a.FontWeight='bold';
title(subj)
ylim([0,45]);
ylabel('Distance to CS (mm)')
set(gcf,'color','w')
set(gca,'box','off')
set(findobj(gca,'type','line'),'linewidth',2)
%%
hold on
scatter([1,2],10*log10([mean(mean(trial_info_hfb(1).pow(:,logical(trial_info_hfb(1).ers_chan)),2));...
    mean(mean(trial_info_hfb(2).pow(:,logical(trial_info_hfb(2).ers_chan)),1))]),50,'*r')

scatter([3.5,4.5],10*log10([mean(mean(trial_info_lfb(1).pow(:,logical(trial_info_lfb(1).erd_chan)),2));...
    mean(mean(trial_info_lfb(2).pow(:,logical(trial_info_lfb(2).erd_chan)),1))]),50,'*r');


% set(findobj(gca,'type','text'),'fontweight','bold')

text(1,0,['n=' num2str(size(trial_info_hfb(1).pow,1))],'horizontalalignment','center','fontsize',18);

text(2,0,['n=' num2str(size(trial_info_hfb(2).pow,1))],'horizontalalignment','center','fontsize',18);

text(3.5,0,['n=' num2str(size(trial_info_lfb(1).pow,1))],'horizontalalignment','center','fontsize',18);

text(4.5,0,['n=' num2str(size(trial_info_lfb(2).pow,1))],'horizontalalignment','center','fontsize',18);

plot([-10,10],[0,0],'--k','linewidth',1)


% a.XTickLabel={['HFB ' trial_info_hfb(1).event],['HFB ' trial_info_hfb(2).event],['LFB ' trial_info_lfb(1).event], ['LFB ' trial_info_lfb(2).event]};
