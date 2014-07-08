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

obj.EventPanel=uipanel(obj.Fig,'units','pixels','position',[0 ctrlsize(2) 180 pos(4)-ctrlsize(2)],'BorderType','none');
obj.MainPanel=uipanel(obj.Fig,'units','pixels','position',[180 ctrlsize(2) ctrlsize(1)-180 pos(4)-ctrlsize(2)],'BorderType','none');
obj.ControlPanel=uipanel(obj.Fig,'units','pixels','position',[0 0 ctrlsize(1) ctrlsize(2)],'BorderType','none');
obj.Toolbar=uitoolbar(obj.Fig);


obj.makeControls();
obj.makeToolbar();
obj.makeMenu();

obj.WinEvts=EventWindow(obj,obj.Evts_);
addlistener(obj.WinEvts,'EvtSelected',@(src,evtdat) set(obj,'Time',round(src.EventTime-obj.WinLength/2)));

end