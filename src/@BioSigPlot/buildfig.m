function buildfig(obj)
% Designing of all figure controls
screensize=get(0,'ScreenSize');
obj.Fig=figure('MenuBar','none','ToolBar','none','DockControls','off','NumberTitle','off','Renderer','opengl','RendererMode','manual',...
    'CloseRequestFcn',@(src,evts) delete(obj),'WindowScrollWheelFcn',@(src,evts) ChangeSliders(obj,src,evts),...
    'WindowButtonMotionFcn',@(src,evt) MouseMovement(obj),'WindowButtonDownFcn',@(src,evt) MouseDown(obj),...
    'WindowButtonUpFcn',@(src,evt) MouseUp(obj),'Renderer','painters','ResizeFcn',@(src,evt) resize(obj),...
    'WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),'WindowKeyReleaseFcn',@(src,evt) KeyRelease(obj,src,evt),'Units','Pixels','Visible','on',...
    'position',[screensize(3)/2-400,screensize(4)/2-300,800,600],'Name','Loading GUI components ...');

% logo_icon=javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),filesep,'db',filesep,'icon',filesep,'cnel_large.png']));
% logo_label=javaObjectEDT(javax.swing.JLabel());
% logo_label.setIcon(logo_icon);
% logo_label.setHorizontalAlignment(javax.swing.JLabel.CENTER);
% logo_label.setOpaque(false);
% [jh,gh]=javacomponent(logo_label,[0,0,1,1],obj.Fig);
% set(gh,'Units','Norm','Position',[0,0,1,1],'visible','on');

obj.PanObj=pan(obj.Fig);
set(obj.PanObj,'Motion','vertical','ActionPostCallback',@(src,evts) ChangeSliders(obj,src,evts))
obj.VideoTimer = timer('TimerFcn',@ (src,evts) SynchDataWithVideo(obj),'ExecutionMode','fixedRate','BusyMode','queue');

% Panel declaration

makeEventPanel(obj);

obj.AdjustPanel=uipanel(obj.Fig,'units','pixels','BorderType','etchedout',...
    'ButtonDownFcn',@(src,evt) AdjustPanelClick(obj,'visible','off'));
obj.MainPanel=uipanel(obj.Fig,'units','pixels','BorderType','none','visible','off');
obj.ControlPanel=uipanel(obj.Fig,'units','pixels','BorderType','none','visible','off');

makeControls(obj);
obj.makeMenu();

obj.WinEvts=EventWindow(obj);
obj.Toolbar=uitoolbar(obj.Fig);
drawnow
obj.JToolbar=get(get(obj.Toolbar,'JavaContainer'),'ComponentPeer');
obj.makeToolbar();
if isempty(regexp(computer,'WIN','ONCE'))
    set(obj.MenuLoadVideo,'Enable','off');
    obj.JTogVideo.setEnabled(false);
end

set(findobj(obj.Fig,'type','uipanel'),'visible','on');

enableDisableFig(obj.Fig,false);
end
function makeEventPanel(obj)
obj.EventPanel=uipanel(obj.Fig,'units','pixels','BorderType','none','position',[0,0,obj.EventPanelWidth,100],'visible','off');

obj.BtnPrevEvent=uicontrol(obj.EventPanel,'Style','pushbutton','String','<<',...
    'units','normalized','position',[0.02 0.96 0.12 0.03],'Callback',@(src,evt) ChangeTime(obj,src),...
    'TooltipString','previous event of same type    ctrl+shift left');

obj.BtnPrevEvent1=uicontrol(obj.EventPanel,'Style','pushbutton','String','<',...
    'units','normalized','position',[0.15 0.96 0.12 0.03],'Callback',@(src,evt) ChangeTime(obj,src),...
    'TooltipString','previous event');

obj.EventInfo=uicontrol(obj.EventPanel,'String','#|','Style','text',...
    'units','normalized','position',[0.28 0.965 0.44 0.03],...
    'HorizontalAlignment','center','FontUnits','normalized','FontSize',0.8);

obj.BtnNextEvent1=uicontrol(obj.EventPanel,'Style','pushbutton','String','>',...
    'units','normalized','position',[0.73 0.96 0.12 0.03],'Callback',@(src,evt) ChangeTime(obj,src),...
    'TooltipString','next event');

obj.BtnNextEvent=uicontrol(obj.EventPanel,'Style','pushbutton','String','>>',...
    'units','normalized','position',[0.86 0.96 0.12 0.03],'Callback',@(src,evt) ChangeTime(obj,src),...
    'TooltipString','next event of sampe type    ctrl+shift right');

end
function makeControls(obj)

obj.infoControlPanel(obj.ControlPanel,[0.58 0 .42 1]);

obj.timeControlPanel(obj.ControlPanel,[0.42 0 .16 1]);

obj.filterControlPanel(obj.ControlPanel,[0 0 .42 1]);

end

function AdjustPanelClick(obj)
obj.ResizeMode=true;
end