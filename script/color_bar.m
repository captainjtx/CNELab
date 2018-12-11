figure('position',[100,100,400,400]);

imagesc([6,0,-6,0])
axis off
colormap jet
colorbar('Fontsize',35,'Fontweight','Bold','Ticks',[-6,-3, 0, 3, 6], 'location', 'eastoutside')
set(gcf,'color','w')