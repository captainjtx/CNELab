figure('position',[100,100,300,300])
%*************************************
%based on channel
% freq_1=cell(sum(s1_hfb_ave(1).ers_chan),1);
% [freq_1{:}]=deal('HFB');
% 
% freq_2=cell(sum(s1_hfb_ave(2).ers_chan),1);
% [freq_2{:}]=deal('HFB');
% 
% freq_3=cell(sum(s1_lfb_ave(1).erd_chan),1);
% [freq_3{:}]=deal('LFB');
% 
% freq_4=cell(sum(s1_lfb_ave(2).erd_chan),1);
% [freq_4{:}]=deal('LFB');
% 
% freq=cat(1,freq_1,freq_2,freq_3,freq_4);
% 
% event_1=cell(sum(s1_hfb_ave(1).ers_chan),1);
% [event_1{:}]=deal(s1_hfb_ave(1).event);
% 
% event_2=cell(sum(s1_hfb_ave(2).ers_chan),1);
% [event_2{:}]=deal(s1_hfb_ave(2).event);
% 
% event_3=cell(sum(s1_lfb_ave(1).erd_chan),1);
% [event_3{:}]=deal(s1_lfb_ave(1).event);
% 
% event_4=cell(sum(s1_lfb_ave(2).erd_chan),1);
% [event_4{:}]=deal(s1_lfb_ave(2).event);
% 
% event=cat(1,event_1,event_2,event_3,event_4);
%***********************************
%based on trial
freq_1=cell(size(s1_hfb_ave(1).pow,1),1);
[freq_1{:}]=deal('HFB');

freq_2=cell(size(s1_hfb_ave(2).pow,1),1);
[freq_2{:}]=deal('HFB');

freq_3=cell(size(s1_lfb_ave(1).pow,1),1);
[freq_3{:}]=deal('LFB');

freq_4=cell(size(s1_lfb_ave(2).pow,1),1);
[freq_4{:}]=deal('LFB');

freq=cat(1,freq_1,freq_2,freq_3,freq_4);

event_1=cell(size(s1_hfb_ave(1).pow,1),1);
[event_1{:}]=deal(s1_hfb_ave(1).event);

event_2=cell(size(s1_hfb_ave(2).pow,1),1);
[event_2{:}]=deal(s1_hfb_ave(2).event);

event_3=cell(size(s1_lfb_ave(1).pow,1),1);
[event_3{:}]=deal(s1_lfb_ave(1).event);

event_4=cell(size(s1_lfb_ave(2).pow,1),1);
[event_4{:}]=deal(s1_lfb_ave(2).event);

event=cat(1,event_1,event_2,event_3,event_4);

group_1=mean(s1_hfb_ave(1).pow(:,logical(s1_hfb_ave(1).ers_chan)),2);
group_2=mean(s1_hfb_ave(2).pow(:,logical(s1_hfb_ave(2).ers_chan)),2);
group_3=mean(s1_lfb_ave(1).pow(:,logical(s1_lfb_ave(1).erd_chan)),2);
group_4=mean(s1_lfb_ave(2).pow(:,logical(s1_lfb_ave(2).erd_chan)),2);

boxplot(10*log10(cat(1,group_1(:),...
    group_2(:),...
    group_3(:),...
    group_4(:))),...
    {freq,event},'labelverbosity','all','labelorientation','horizontal',...
    'positions',[1,2,3.5,4.5]);

hold on
scatter([1,2],10*log10([mean(mean(s1_hfb_ave(1).pow(:,logical(s1_hfb_ave(1).ers_chan)),2));...
    mean(mean(s1_hfb_ave(2).pow(:,logical(s1_hfb_ave(2).ers_chan)),1))]),'*r')

scatter([3.5,4.5],10*log10([mean(mean(s1_lfb_ave(1).pow(:,logical(s1_lfb_ave(1).erd_chan)),2));...
    mean(mean(s1_lfb_ave(2).pow(:,logical(s1_lfb_ave(2).erd_chan)),1))]),'*r');
a=gca;
ylim([-10,10])

a.FontSize=15;

set(findobj(gca,'type','line'),'linewidth',1)
set(findobj(gca,'type','text'),'fontweight','bold','fontsize',10,'horizontalalignment','center')

text(1,0,['n=' num2str(size(s1_hfb_ave(1).pow,1))],'fontweight','bold','horizontalalignment','center');

text(2,0,['n=' num2str(size(s1_hfb_ave(2).pow,1))],'fontweight','bold','horizontalalignment','center');

text(3.5,0,['n=' num2str(size(s1_lfb_ave(1).pow,1))],'fontweight','bold','horizontalalignment','center');

text(4.5,0,['n=' num2str(size(s1_lfb_ave(2).pow,1))],'fontweight','bold','horizontalalignment','center');

plot([-10,10],[0,0],'--k','linewidth',1)
% a.XTickLabel={['HFB ' s1_hfb_ave(1).event],['HFB ' s1_hfb_ave(2).event],['LFB ' s1_lfb_ave(1).event], ['LFB ' s1_lfb_ave(2).event]};
