function buildfig(obj)
% Designing of all figure controls

obj.Fig=figure('MenuBar','none','ToolBar','none','DockControls','off','NumberTitle','off',...
    'CloseRequestFcn',@(src,evts) delete(obj),'WindowScrollWheelFcn',@(src,evts) ChangeSliders(obj,src,evts),...
    'WindowButtonMotionFcn',@(src,evt) MouseMovement(obj),'WindowButtonDownFcn',@(src,evt) MouseDown(obj),...
    'WindowButtonUpFcn',@(src,evt) MouseUp(obj),'Renderer','painters','ResizeFcn',@(src,evt) resize(obj),...
    'WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),'WindowKeyReleaseFcn',@(src,evt) KeyRelease(obj,src,evt));

obj.PanObj=pan(obj.Fig);
set(obj.PanObj,'Motion','vertical','ActionPostCallback',@(src,evts) ChangeSliders(obj,src,evts))
obj.MainTimer = timer('TimerFcn',@(src ,evts) PlayTime(obj),'ExecutionMode','fixedRate','BusyMode','queue');
obj.VideoTimer = timer('TimerFcn',@ (src,evts) UpdateVideo(obj),'ExecutionMode','fixedRate','BusyMode','queue');

% Panel declaration
set(obj.Fig,'Units','pixels')
pos=get(obj.Fig,'position');

set(obj.Fig,'position',[0,0 pos(3) pos(4)]);
ctrlsize=obj.ControlBarSize;
eventwidth=obj.EventPanelWidth;
adjustWidth=obj.AdjustWidth;

obj.EventPanel=uipanel(obj.Fig,'units','pixels','position',[0 ctrlsize(2) eventwidth-adjustWidth pos(4)-ctrlsize(2)],'BorderType','none');
obj.BtnPrevEvent=uicontrol(obj.EventPanel,'Style','pushbutton','String','<<',...
    'units','normalized','position',[0.02 0.96 0.12 0.03],'Callback',@(src,evt) ChangeTime(obj,src),...
    'TooltipString','previous event of same type    ctrl+shift left');

obj.BtnPrevEvent1=uicontrol(obj.EventPanel,'Style','pushbutton','String','<',...
    'units','normalized','position',[0.15 0.96 0.12 0.03],'Callback',@(src,evt) ChangeTime(obj,src),...
    'TooltipString','previous event');

obj.EventInfo=uicontrol(obj.EventPanel,'String','#|','Style','text',...
    'units','normalized','position',[0.28 0.965 0.44 0.02],...
    'HorizontalAlignment','center','FontUnits','normalized','FontSize',1);

obj.BtnNextEvent1=uicontrol(obj.EventPanel,'Style','pushbutton','String','>',...
    'units','normalized','position',[0.73 0.96 0.12 0.03],'Callback',@(src,evt) ChangeTime(obj,src),...
    'TooltipString','next event');

obj.BtnNextEvent=uicontrol(obj.EventPanel,'Style','pushbutton','String','>>',...
    'units','normalized','position',[0.86 0.96 0.12 0.03],'Callback',@(src,evt) ChangeTime(obj,src),...
    'TooltipString','next event of sampe type    ctrl+shift right');

obj.AdjustPanel=uipanel(obj.Fig,'units','pixels','position',[eventwidth-adjustWidth ctrlsize(2) 10 pos(4)-ctrlsize(2)],'BorderType','etchedout',...
    'ButtonDownFcn',@(src,evt) AdjustPanelClick(obj));
obj.MainPanel=uipanel(obj.Fig,'units','pixels','position',[eventwidth ctrlsize(2) ctrlsize(1)-eventwidth pos(4)-ctrlsize(2)],'BorderType','none');
obj.ControlPanel=uipanel(obj.Fig,'units','pixels','position',[0 0 ctrlsize(1) ctrlsize(2)],'BorderType','none');
obj.Toolbar=uitoolbar(obj.Fig);


makeControls(obj);
obj.makeToolbar();
obj.makeMenu();

obj.WinEvts=EventWindow(obj);

obj.TFMapFig=figure('Name','TFMap','Visible','off','NumberTitle','off');

obj.VideoFig=figure('Name','Video','Visible','off','NumberTitle','off');

end

function makeControls(obj)

obj.filterControlPanel(obj.ControlPanel,[0.58 0 .42 1]);

obj.timeControlPanel(obj.ControlPanel,[0.42 0 .16 1]);

obj.infoControlPanel(obj.ControlPanel,[0 0 .42 1]);

end

function AdjustPanelClick(obj)
obj.ResizeMode=true;
end