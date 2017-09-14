function h=signalmap_grid(fig,axe,t,sig,pos,dw,dh,channame,yl)
%TFMAP_GRID Summary of this function goes here
%   Detailed explanation goes here
%Orign of postion is top left corner
x=pos(1)-dw/2;
y=1-(pos(2)+dh/2);

text(x+dw/2,y+dh,channame,...
    'fontsize',max(8,60*dh),'horizontalalignment','center','parent',axe,'interpreter','none','tag','names','FontWeight','bold');

h=axes('parent',fig,'units','normalized','Position',[x,y,dw,dh*0.9],'Visible','off');

line(t,sig,'LineStyle','-','color','k','linewidth',1,'Parent',h);

if ~isempty(yl)
    set(h,'YLim',yl);
end

set(h,'XLim',[min(t) max(t)]);
set(h,'Tag',['SignalMapAxes-' channame]);
drawnow
end

