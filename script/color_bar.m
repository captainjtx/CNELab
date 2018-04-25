figure('position',[100,100,500,500]);

imagesc([5,0,-5,0])
axis off
colormap jet
colorbar('Fontsize',25,'Fontweight','Bold','Ticks',[-5,-2.5, 0, 2.5, 5],'Location','southoutside')
set(gcf,'color','w')