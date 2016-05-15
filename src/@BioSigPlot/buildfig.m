function buildfig(obj)
% Designing of all figure controls
screensize=get(0,'ScreenSize');
obj.Fig=figure('MenuBar','none','ToolBar','none','DockControls','off','NumberTitle','off','RendererMode','manual',...
    'CloseRequestFcn',@(src,evts) delete(obj),'WindowScrollWheelFcn',@(src,evts) ChangeSliders(obj,src,evts),...
    'WindowButtonMotionFcn',@(src,evt) MouseMovement(obj),'WindowButtonDownFcn',@(src,evt) MouseDown(obj),...
    'WindowButtonUpFcn',@(src,evt) MouseUp(obj),'ResizeFcn',@(src,evt) resize(obj),...
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
    'ButtonDownFcn',@(src,evt) AdjustPanelClick(obj));
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
import src.java.PushButton;
btn_d=javaObjectEDT(java.awt.Dimension());

obj.EventPanel=uipanel(obj.Fig,'units','pixels','BorderType','none','position',[0,0,obj.EventPanelWidth,100],'visible','off');

position = getpixelposition(obj.EventPanel);
btn_d.width=position(3)*0.12;
btn_d.height=position(4)*0.03;

col=get(obj.EventPanel,'BackgroundColor');
col=javaObjectEDT(java.awt.Color(col(1),col(2),col(3)));

obj.JBtnPrevEvent=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/prev_page.png'],btn_d,char('previous event of same name (ctrl + shift left)'),col));
set(handle(obj.JBtnPrevEvent,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeTime(obj,-4));

[jh,gh]=javacomponent(obj.JBtnPrevEvent,[0.02 0.96 0.12 0.03],obj.EventPanel);
set(gh,'Units','Norm','Position',[0.02 0.96 0.12 0.03]);

obj.JBtnPrevEvent1=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/prev_sec.png'],btn_d,char('previous event'),col));
set(handle(obj.JBtnPrevEvent1,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeTime(obj,-3));

[jh,gh]=javacomponent(obj.JBtnPrevEvent1,[0.15 0.96 0.12 0.03],obj.EventPanel);
set(gh,'Units','Norm','Position',[0.15 0.96 0.12 0.03]);

%%
obj.EventInfo=uicontrol(obj.EventPanel,'String','#|','Style','text',...
    'units','normalized','position',[0.28 0.965 0.44 0.03],...
    'HorizontalAlignment','center','FontUnits','normalized','FontSize',0.8);
%%
obj.JBtnNextEvent1=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/next_sec.png'],btn_d,char('next event'),col));
set(handle(obj.JBtnNextEvent1,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeTime(obj,3));

[jh,gh]=javacomponent(obj.JBtnNextEvent1,[0.73 0.96 0.12 0.03],obj.EventPanel);
set(gh,'Units','Norm','Position',[0.73 0.96 0.12 0.03]);

obj.JBtnNextEvent=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/next_page.png'],btn_d,char('next event of same name (ctrl + shift right)'),col));
set(handle(obj.JBtnNextEvent,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeTime(obj,4));

[jh,gh]=javacomponent(obj.JBtnNextEvent,[0.86 0.96 0.12 0.03],obj.EventPanel);
set(gh,'Units','Norm','Position',[0.86 0.96 0.12 0.03]);

end
function makeControls(obj)

obj.infoControlPanel(obj.ControlPanel,[0.58 0 .42 1]);

obj.timeControlPanel(obj.ControlPanel,[0.42 0 .16 1]);

obj.filterControlPanel(obj.ControlPanel,[0 0 .42 1]);

end

function AdjustPanelClick(obj)
obj.ResizeMode=true;
end