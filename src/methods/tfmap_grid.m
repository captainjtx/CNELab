function tfmap_grid(t,f,tf,pos,dw,dh,channame,sl,sh)
%TFMAP_GRID Summary of this function goes here
%   Detailed explanation goes here
%Orign of postion is top left corner
x=pos(1)-dw/2;
y=1-(pos(2)+dh/2);

text(x+dw/2,y+dh+0.008,channame,'FontSize',8,'HorizontalAlignment','center','Interpreter','none');

axes('Position',[x,y,dw,dh],'Tag',['TFMapAxes-' channame]);

imagesc(t,f,10*log10(tf),[sl sh]);

colormap(jet);
axis xy;
axis off;

end

