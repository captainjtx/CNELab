function timeControlPanel(obj,parent,position)
obj.TimePanel=uipanel(parent,'units','normalized','position',position);
obj.BtnPrevPage=uicontrol(obj.TimePanel,'Style','pushbutton','String','<<','units','normalized','position',[.01 .1 .1 .8],'Callback',@(src,evt) ChangeTime(obj,src));
obj.BtnPrevSec=uicontrol(obj.TimePanel,'Style','pushbutton','String','<','units','normalized','position',[.11 .1 .1 .8],'Callback',@(src,evt) ChangeTime(obj,src));
obj.EdtTime=uicontrol(obj.TimePanel,'Style','edit','String',0,'units','normalized','position',[.22 0.1 .26 .8],'BackgroundColor',[1 1 1],'Callback',@(src,evt) ChangeTime(obj,src));
obj.BtnNextSec=uicontrol(obj.TimePanel,'Style','pushbutton','String','>','units','normalized','position',[.49 0.1 .1 .8],'Callback',@(src,evt) ChangeTime(obj,src));
obj.BtnNextPage=uicontrol(obj.TimePanel,'Style','pushbutton','String','>>','units','normalized','position',[.60 0.1 .1 .8],'Callback',@(src,evt) ChangeTime(obj,src));
obj.BtnPlay=uicontrol(obj.TimePanel,'Style','pushbutton','String','Play','units','normalized','position',[.71 0.1 .28 .8],'Callback',@(src,evt) StartPlay(obj));
end