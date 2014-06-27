function infoControlPanel(obj,parent,position)
obj.InfoPanel=uipanel(parent,'units','normalized','position',position);
obj.TxtTime=uicontrol(obj.InfoPanel,'Style','text','units','normalized','position',[0 .5 1 .4],'HorizontalAlignment','Left','String','Time : 0:00:00.00 - sample 0');
obj.TxtY=uicontrol(obj.InfoPanel,'Style','text','units','normalized','position',[0 0 1 .4],'HorizontalAlignment','Left','String','Chan :  - value 0');
end