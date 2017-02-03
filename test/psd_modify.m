a=gcf;
a=patch('Faces',[1,2,3,4],'Vertices',[8,-90;32,-90;32,-25;8,-25],'facecolor',[0,0.8,0.8],'facealpha',1,'edgecolor','none');
uistack(a,'bottom')
a=patch('Faces',[1,2,3,4],'Vertices',[60,-90;200,-90;200,-25;60,-25],'facecolor',[0.7,0.7,0],'facealpha',1,'edgecolor','none');

set(gcf,'color','w')
set(gca,'linewidth',2)
set(findobj(gca,'type','line'),'linewidth',3)
title('S2 power spectrum density')

legend(findobj(gca,'type','line'),{'Hand movement','Baseline'})
legend('boxoff')
set(gca,'fontsize',15)
axis tight
ylim([-100,-20]);
set(gca,'fontweight','bold')
uistack(a,'bottom')

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