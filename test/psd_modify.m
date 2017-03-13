a=gcf;

delete(findobj(a,'type','patch'));
a=patch('Faces',[1,2,3,4],'Vertices',[8,-45;32,-45;32,30;8,30],'facecolor',[195, 234, 165]/255,'facealpha',1,'edgecolor','none');
uistack(a,'bottom')
a=patch('Faces',[1,2,3,4],'Vertices',[60,-45;280,-45;280,30;60,30],'facecolor',[164, 234, 225]/255,'facealpha',1,'edgecolor','none');
uistack(a,'bottom')
a=patch('Faces',[1,2,3,4],'Vertices',[300,-45;800,-45;800,30;300,30],'facecolor',[237, 239, 127]/255,'facealpha',1,'edgecolor','none');
uistack(a,'bottom')

set(gcf,'color','w')
set(gca,'linewidth',2.5)
set(findobj(gca,'type','line'),'linewidth',2.5)

legend(findobj(gca,'type','line'),{'Movement','Baseline'})
set(gca,'fontsize',18)
axis tight
ylim([-50,30]);
xlim([0,1000]);
set(gca,'fontweight','bold')
ylabel('PSD (dB)')
title('');
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