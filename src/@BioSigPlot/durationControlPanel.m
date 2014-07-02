function durationControlPanel(obj,parent,position)
obj.DurationPanel=uibuttongroup('Parent',parent,'units','normalized','position',position);

uicontrol(obj.DurationPanel,'Style','text','String','Width(s) ','units','normalized',...
    'position',[0 .2 0.4 .5],'HorizontalAlignment','right');

obj.EdtDuration=uicontrol(obj.DurationPanel,'Style','edit','units','normalized',...
    'position',[.45 .1 .4 .8],'BackgroundColor',[1 1 1],'Callback',@(src,evt) ChangeDuration(obj,src));

obj.BtnAddDuration=uicontrol(obj.DurationPanel,'Style','pushbutton','String','+',...
    'units','normalized','position',[.86 0.55 .1 .35],'Callback',@(src,evt) ChangeDuration(obj,src));

obj.BtnRemDuration=uicontrol(obj.DurationPanel,'Style','pushbutton','String','-',...
    'units','normalized','position',[.86 0.1 .1 .35],'Callback',@(src,evt) ChangeDuration(obj,src));
end
