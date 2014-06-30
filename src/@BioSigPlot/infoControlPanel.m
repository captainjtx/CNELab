function infoControlPanel(obj,parent,position)
obj.InfoPanel=uipanel(parent,'units','normalized','position',position);
obj.TxtY=uicontrol(obj.InfoPanel,'Style','text','units','normalized','position',[0 0.65 1 .3],...
    'HorizontalAlignment','Left','String','Data: 1 ; Chan: - ; Gain - ; SR: - ');

obj.TxtTime=uicontrol(obj.InfoPanel,'Style','text','units','normalized','position',[0 .35 1 .3],...
    'HorizontalAlignment','Left','String','Time : 0:00:00.00 ; Value 0 ');

obj.TxtFilter=uicontrol(obj.InfoPanel,'Style','text','units','normalized','position',[0 0.05 1 0.3],...
    'HorizontalAlignment','Left','String','FL: 0 FH: 0 ; FN1: 0 FN2: 0 ');
end