figure('position',[100,100,350,300])
%*************************************
%based on channel
% freq_1=cell(sum(trial_info_hfb(1).ers_chan),1);
% [freq_1{:}]=deal('HFB');
% 
% freq_2=cell(sum(trial_info_hfb(2).ers_chan),1);
% [freq_2{:}]=deal('HFB');
% 
% freq_3=cell(sum(trial_info_lfb(1).erd_chan),1);
% [freq_3{:}]=deal('LFB');
% 
% freq_4=cell(sum(trial_info_lfb(2).erd_chan),1);
% [freq_4{:}]=deal('LFB');
% 
% freq=cat(1,freq_1,freq_2,freq_3,freq_4);
% 
% event_1=cell(sum(trial_info_hfb(1).ers_chan),1);
% [event_1{:}]=deal(trial_info_hfb(1).event);
% 
% event_2=cell(sum(trial_info_hfb(2).ers_chan),1);
% [event_2{:}]=deal(trial_info_hfb(2).event);
% 
% event_3=cell(sum(trial_info_lfb(1).erd_chan),1);
% [event_3{:}]=deal(trial_info_lfb(1).event);
% 
% event_4=cell(sum(trial_info_lfb(2).erd_chan),1);
% [event_4{:}]=deal(trial_info_lfb(2).event);
% 
% event=cat(1,event_1,event_2,event_3,event_4);
%***********************************
%based on trial
freq_1=cell(size(trial_info_hfb(1).pow,1),1);
[freq_1{:}]=deal('HFB');

freq_2=cell(size(trial_info_hfb(2).pow,1),1);
[freq_2{:}]=deal('HFB');

freq_3=cell(size(trial_info_lfb(1).pow,1),1);
[freq_3{:}]=deal('LFB');

freq_4=cell(size(trial_info_lfb(2).pow,1),1);
[freq_4{:}]=deal('LFB');

freq=cat(1,freq_1,freq_2,freq_3,freq_4);

event_1=cell(size(trial_info_hfb(1).pow,1),1);
[event_1{:}]=deal(trial_info_hfb(1).event);

event_2=cell(size(trial_info_hfb(2).pow,1),1);
[event_2{:}]=deal(trial_info_hfb(2).event);

event_3=cell(size(trial_info_lfb(1).pow,1),1);
[event_3{:}]=deal(trial_info_lfb(1).event);

event_4=cell(size(trial_info_lfb(2).pow,1),1);
[event_4{:}]=deal(trial_info_lfb(2).event);

event=cat(1,event_1,event_2,event_3,event_4);

group_1=mean(trial_info_hfb(1).pow(:,logical(trial_info_hfb(1).ers_chan)),2);
group_2=mean(trial_info_hfb(2).pow(:,logical(trial_info_hfb(2).ers_chan)),2);
group_3=mean(trial_info_lfb(1).pow(:,logical(trial_info_lfb(1).erd_chan)),2);
group_4=mean(trial_info_lfb(2).pow(:,logical(trial_info_lfb(2).erd_chan)),2);

bp=boxplot(10*log10(cat(1,group_1(:),...
    group_2(:),...
    group_3(:),...
    group_4(:))),...
    {freq,event},'labelverbosity','all','labelorientation','horizontal',...
    'positions',[1,2,3.5,4.5],'OutlierSize',10);
drawnow;
a=gca;
ylim([-10,10])
a.FontSize=20;

txt=findobj(gca,'type','text');

for i=1:length(txt)
    p=txt(i).Position;

    set(txt(i),'position',[p(1),p(2)-10,p(3)]);
%     ext=txt(i).Extent;
%     txt(i).Extent=[ext(1),ext(2)-20,ext(3),ext(4)];
    set(txt(i),'FontSize',15);
    
    if ismember(i,[3,7])
        set(txt(i),'position',[p(1)-6,p(2)-10,p(3)]);
    end
    
    if ismember(i,[2,6])
        set(txt(i),'position',[p(1)-15,p(2)-10,p(3)]);
    end
    if ismember(i,[1,5])
        set(txt(i),'position',[p(1)-18,p(2)-10,p(3)]);
    end
end
% set(findobj(gca,'type','line'),'linewidth',10)

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
title('S1')
ylabel('dB')
set(gcf,'color','w')
% a.XTickLabel={['HFB ' trial_info_hfb(1).event],['HFB ' trial_info_hfb(2).event],['LFB ' trial_info_lfb(1).event], ['LFB ' trial_info_lfb(2).event]};
