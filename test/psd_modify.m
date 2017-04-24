a=gcf;

delete(findobj(a,'type','patch'));
a=patch('Faces',[1,2,3,4],'Vertices',[8,-95;32,-95;32,30;8,30],'facecolor',[165, 234, 165]/255,'facealpha',1,'edgecolor','none');
uistack(a,'bottom')

a=patch('Faces',[1,2,3,4],'Vertices',[60,-95;200,-95;200,30;60,30],'facecolor',[164, 234, 225]/255,'facealpha',1,'edgecolor','none');
uistack(a,'bottom')

set(gcf,'color','w')
set(gca,'linewidth',2.5)
set(findobj(gca,'type','line'),'linewidth',2.5)

legend(findobj(gca,'type','line'),{'Flexion','Baseline'})
set(gca,'fontsize',18)
axis tight
ylim([-100,-20]);
xlim([0,250]);
set(gca,'fontweight','bold')
ylabel('PSD (dB)')
title('S2 Flexion C63');
%%
set(gcf,'position',[100,100,500,400])
set(gca,'position',[0.13,0.15,0.75,0.78])
%%
title('S1 time-frequency map')
hold on
plot([-1.5,1.5],[8,8],'k:','linewidth',2)
hold on
plot([-1.5,1.5],[32,32],'k:','linewidth',2)
hold on
plot([-1.5,1.5],[60,60],'k:','linewidth',2)
hold on
plot([-1.5,1.5],[200,200],'k:','linewidth',2)
set(gca,'ytick',[8,32,60,200])
set(gca,'yticklabel',{'8','32','60','200'})

%%
set(gcf,'position',[100,100,500,380])
set(gca,'fontsize',18)
set(gca,'fontweight','bold')
