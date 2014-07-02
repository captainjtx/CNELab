function scaleControlPanel(obj,parent,position)
obj.ScalePanel=uibuttongroup('Parent',parent,'units','normalized','position',position);

uicontrol(obj.ScalePanel,'Style','text','String','Gain ','units','normalized',...
    'position',[0 .2 0.24 .5],'HorizontalAlignment','right');

obj.EdtGain=uicontrol(obj.ScalePanel,'Style','edit','units','normalized',...
    'position',[.6 .1 .28 .8],'BackgroundColor',[1 1 1],'Callback',@(src,evt) ChangeGain(obj,src));

obj.BtnAddGain=uicontrol(obj.ScalePanel,'Style','pushbutton','String','+',...
    'units','normalized','position',[.88 0.55 .1 .35],'Callback',@(src,evt) ChangeGain(obj,src));

obj.BtnRemGain=uicontrol(obj.ScalePanel,'Style','pushbutton','String','-',...
    'units','normalized','position',[.88 0.1 .1 .35],'Callback',@(src,evt) ChangeGain(obj,src));
end
