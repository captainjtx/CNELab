function infoControlPanel(obj,parent,position)
obj.InfoPanel=uipanel(parent,'units','normalized','position',position);
obj.TxtY=uicontrol(obj.InfoPanel,'Style','text','units','normalized','position',[0 0.68 1 .32],...
    'HorizontalAlignment','Left','String','Data: 1 ; Chan: - ; Gain -');

obj.TxtTime=uicontrol(obj.InfoPanel,'Style','text','units','normalized','position',[0 .35 1 .32],...
    'HorizontalAlignment','Left','String','Time : 0:00:00.00 ; Value 0 ');

obj.TxtFilter=uicontrol(obj.InfoPanel,'Style','text','units','normalized','position',[0 0.02 1 .29],...
    'HorizontalAlignment','Left','String','SR: - ; FL: - FH: - ; FN1: - FN2: - ');
end