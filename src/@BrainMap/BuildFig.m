function BuildFig(obj)
import javax.swing.JSlider;
import javax.swing.JSpinner;
import javax.swing.SpinnerNumberModel;
import javax.swing.JButton;
import java.awt.Color;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;

screensize=get(0,'ScreenSize');
obj.fig=figure('Menubar','none','Name','BrainMap','units','pixels','position',[screensize(3)/2-500,screensize(4)/2-325,1000,650],...
    'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),'resize','off','Dockcontrols','off',...
    'WindowButtonMotionFcn',@(src,evt)MouseMove(obj),'WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));

%==========================================================================

obj.FileMenu=uimenu(obj.fig,'label','File');
obj.LoadMenu=uimenu(obj.FileMenu,'label','Load');

obj.LoadVolumeMenu=uimenu(obj.LoadMenu,'label','Volume','callback',@(src,evt) LoadVolume(obj),'Accelerator','o');
obj.LoadSurfaceMenu=uimenu(obj.LoadMenu,'label','Surface','callback',@(src,evt) LoadSurface(obj),'Accelerator','u');
obj.LoadElectrodeMenu=uimenu(obj.LoadMenu,'label','Electrode','callback',@(src,evt) LoadElectrode(obj),'Accelerator','e');

obj.SettingsMenu=uimenu(obj.fig,'label','Settings');
obj.SettingsBackgroundColorMenu=uimenu(obj.SettingsMenu,'label','Canvas Color','callback',@(src,evt) ChangeCanvasColor(obj));

obj.SaveAsMenu=uimenu(obj.FileMenu,'label','Save as');
obj.SaveAsFigureMenu=uimenu(obj.SaveAsMenu,'label','Figuer','callback',@(src,evt) SaveAsFigure(obj),'Accelerator','p');

obj.ElectrodeMenu=uimenu(obj.fig,'label','Electrode');
%%
obj.ElectrodeRotateMenu=uimenu(obj.ElectrodeMenu,'label','Rotate');
obj.ElectrodeRotateLeftMenu=uimenu(obj.ElectrodeRotateMenu,...
    'label','<html> Left<span style="font-size:10"> left arrow</span></html>',...
    'callback',@(src,evt) MoveElectrode(obj,src));

obj.ElectrodeRotateRightMenu=uimenu(obj.ElectrodeRotateMenu,...
    'label','<html> Right<span style="font-size:10"> right arrow</span></html>',...
    'callback',@(src,evt) MoveElectrode(obj,src));

obj.ElectrodeRotateUpMenu=uimenu(obj.ElectrodeRotateMenu,...
    'label','<html> Up<span style="font-size:10"> up arrow</span></html>',...
    'callback',@(src,evt) MoveElectrode(obj,src));

obj.ElectrodeRotateDownMenu=uimenu(obj.ElectrodeRotateMenu,...
    'label','<html> Down<span style="font-size:10"> down arrow</span></html>',...
    'callback',@(src,evt) MoveElectrode(obj,src));
%%
obj.ElectrodePushPullMenu=uimenu(obj.ElectrodeMenu,'label','Push/Pull');
obj.ElectrodePushInMenu=uimenu(obj.ElectrodePushPullMenu,...
    'label','<html>Inward<span style="font-size:10;"> Cmd + down arrow</span></html>',...
    'callback',@(src,evt) MoveElectrode(obj,src));

obj.ElectrodePullOutMenu=uimenu(obj.ElectrodePushPullMenu,...
    'label','<html> Outward<span style="font-size:10"> Cmd + up arrow</span></html>',...
    'callback',@(src,evt) MoveElectrode(obj,src));
%%
obj.ElectrodeSpinMenu=uimenu(obj.ElectrodeMenu,'label','Spin');
obj.ElectrodeSpinClockwiseMenu=uimenu(obj.ElectrodeSpinMenu,...
    'label','<html> Clockwise<span style="font-size:10"> Cmd + right arrow</span></html>',...
    'callback',@(src,evt) MoveElectrode(obj,src));

obj.ElectrodeSpinAntiClockwiseMenu=uimenu(obj.ElectrodeSpinMenu,...
    'label','<html> Anti-clockwise<span style="font-size:10"> Cmd + left arrow</span></html>',...
    'callback',@(src,evt) MoveElectrode(obj,src));

%==========================================================================
obj.ViewPanel=uipanel(obj.fig,'units','normalized','position',[0,0.1,0.7,0.9],'backgroundcolor',[0,0,0]);
obj.InfoPanel=uipanel(obj.fig,'units','normalized','position',[0,0,1,0.1]);

obj.axis_3d=axes('parent',obj.ViewPanel,'units','normalized','position',[0,0,1,1],'visible','off','CameraViewAngle',10);

obj.sidepane=uipanel(obj.fig,'units','normalized','position',[0.7,0.1,0.3,0.9]);

view(3);
daspect([1,1,1]);
obj.light=camlight('headlight','infinite');
material dull;

obj.RotateTimer=timer('TimerFcn',@ (src,evts) RotateTimerCallback(obj),'ExecutionMode','fixedRate','BusyMode','drop','period',0.1);
%             obj.
obj.inView=obj.isIn(get(obj.fig,'CurrentPoint'),getpixelposition(obj.ViewPanel));

obj.BuildToolbar();

obj.JFileLoadTree=javaObjectEDT(src.java.checkboxtree.FileLoadTree());
obj.JFileLoadTree.buildfig();

jh=obj.JFileLoadTree;
set(handle(jh,'CallbackProperties'),'TreeSelectionCallback',@(src,evt) TreeSelectionCallback(obj,src,evt));
set(handle(jh,'CallbackProperties'),'CheckChangedCallback',@(src,evt) CheckChangedCallback(obj,src,evt));
%             set(handle(obj.JFileLoadTree.span,'CallbackProperties'),'KeyTypedCallback',@(src,evt) KeyTypedCallback(obj,src,evt));

[jh,gh]=javacomponent(obj.JFileLoadTree.span,[0,0,1,1],obj.sidepane);
set(gh,'Units','Norm','Position',[0,0.8,1,0.2]);

obj.toolbtnpane=uipanel(obj.sidepane,'units','normalized','position',[0,0.73,1,0.07]);

obj.BuildIOBar();
%%
%suface tool pane==========================================================
obj.surfacetoolpane=uipanel(obj.sidepane,'units','normalized','position',[0,0,1,0.73],'visible','off');
%%
%surface opacity
uicontrol('parent',obj.surfacetoolpane,'style','text','units','normalized','position',[0,0.92,0.25,0.06],...
    'string','Opacity(%)','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
obj.JSurfaceAlphaSlider=javaObjectEDT(JSlider(JSlider.HORIZONTAL,0,100,90));
[jh,gh]=javacomponent(obj.JSurfaceAlphaSlider,[0,0,1,1],obj.surfacetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.9,0.45,0.1]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) SurfaceAlphaSliderCallback(obj));

model = javaObjectEDT(SpinnerNumberModel(90,0,100,10));  
obj.JSurfaceAlphaSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JSurfaceAlphaSpinner,[0,0,1,1],obj.surfacetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.92,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) SurfaceAlphaSpinnerCallback(obj));
%%
%volume tool pane==========================================================

obj.volumetoolpane=uipanel(obj.sidepane,'units','normalized','position',[0,0,1,0.73],'visible','on');

%%
%volume colormap
uicontrol('parent',obj.volumetoolpane,'style','text','units','normalized','position',[0,0.92,0.25,0.06],...
    'string','Colormap','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
obj.VolumeColorMapPopup = colormap_popup('Parent',obj.volumetoolpane,'units','normalized','position',[0.25,0.9,0.75,0.08]);
set(obj.VolumeColorMapPopup,'Value',1,'Callback',@(src,evt)VolumeColormapCallback(obj));
%%
%volume color data limit
uicontrol('parent',obj.volumetoolpane,'style','text','units','normalized','position',[0,0.84,0.2,0.06],...
    'string','Min','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmin),[],java.lang.Double(1),java.lang.Double(0.1)));  
obj.JVolumeMinSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JVolumeMinSpinner,[0,0,1,1],obj.volumetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.84,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) VolumeScaleSpinnerCallback(obj));

uicontrol('parent',obj.volumetoolpane,'style','text','units','normalized','position',[0.5,0.84,0.2,0.06],...
    'string','Max','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmax),java.lang.Double(0),[],java.lang.Double(0.1)));
obj.JVolumeMaxSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JVolumeMaxSpinner,[0,0,1,1],obj.volumetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.84,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) VolumeScaleSpinnerCallback(obj));
%%
%volume smooth
uicontrol('parent',obj.volumetoolpane,'style','text','units','normalized','position',[0,0.74,0.5,0.06],...
    'string','Gaussian smooth kernel','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.smooth_sigma),java.lang.Double(0),java.lang.Double(10),java.lang.Double(0.1)));
obj.JVolumeSmoothSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JVolumeSmoothSpinner,[0,0,1,1],obj.volumetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.74,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) VolumeSmoothSpinnerCallback(obj));

%%
%electrode tool pane=======================================================
obj.electrodetoolpane=uipanel(obj.sidepane,'units','normalized','position',[0,0,1,0.73],'visible','off');
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.92,0.25,0.06],...
    'string','Color','horizontalalignment','left','fontunits','normalized','fontsize',0.5);

obj.JElectrodeColorBtn = javaObjectEDT(JButton());
obj.JElectrodeColorBtn.setBorder(BorderFactory.createLineBorder(Color.black));
obj.JElectrodeColorBtn.setBackground(Color(1,0.8,0.6));
obj.JElectrodeColorBtn.setOpaque(true);
[jh, hContainer] = javacomponent(obj.JElectrodeColorBtn, [0,0,1,1], obj.electrodetoolpane);
set(hContainer, 'Units','norm','position',[0.3,0.93,0.15,0.05]);
set(handle(jh,'CallbackProperties'),'MousePressedCallback',@(h,e) ElectrodeColorCallback(obj));

%%
%radius and thickness
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.84,0.22,0.06],...
    'string','Radius','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(0.5,0,10,0.1));  
obj.JElectrodeRadiusSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JElectrodeRadiusSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.84,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ElectrodeRadiusSpinnerCallback(obj));

uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0.5,0.84,0.22,0.06],...
    'string','Thickness','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(0.4,0,10,0.1));  
obj.JElectrodeThicknessSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JElectrodeThicknessSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.84,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ElectrodeThicknessSpinnerCallback(obj));
%%
%radius and thickness percentage
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.74,0.22,0.06],...
    'string','%','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Integer(100),java.lang.Integer(10),java.lang.Integer(500),java.lang.Integer(10)));  
obj.JElectrodeRadiusRatioSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JElectrodeRadiusRatioSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.74,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ElectrodeRadiusRatioSpinnerCallback(obj));

uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0.5,0.74,0.22,0.06],...
    'string','%','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Integer(100),java.lang.Integer(10),java.lang.Integer(500),java.lang.Integer(10)));  
obj.JElectrodeThicknessRatioSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JElectrodeThicknessRatioSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.74,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ElectrodeThicknessRatioSpinnerCallback(obj));
%%
%map colormap
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.62,0.25,0.06],...
    'string','Colormap','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
obj.MapColorMapPopup = colormap_popup('Parent',obj.electrodetoolpane,'units','normalized','position',[0.25,0.6,0.75,0.08]);
set(obj.MapColorMapPopup,'Value',4,'Callback',@(src,evt)MapColormapCallback(obj));
%%
%map color data limit
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.54,0.22,0.06],...
    'string','Min','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(-6),[],[],java.lang.Double(1)));  
obj.JMapMinSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JMapMinSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.54,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) MapSpinnerCallback(obj));

uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0.5,0.54,0.22,0.06],...
    'string','Max','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(6),[],[],java.lang.Double(1))); 
obj.JMapMaxSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JMapMaxSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.54,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) MapSpinnerCallback(obj));
%%
%map opacity
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.45,0.25,0.06],...
    'string','Opacity(%)','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
obj.JMapAlphaSlider=javaObjectEDT(JSlider(JSlider.HORIZONTAL,0,100,90));
[jh,gh]=javacomponent(obj.JMapAlphaSlider,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.43,0.45,0.1]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) MapAlphaSliderCallback(obj));

model = javaObjectEDT(SpinnerNumberModel(80,0,100,10));  
obj.JMapAlphaSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JMapAlphaSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.45,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) MapAlphaSpinnerCallback(obj));
%%
%map interpolation
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.35,0.5,0.06],...
    'string','Map interpolation level','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Integer(10),java.lang.Integer(0),java.lang.Integer(20),java.lang.Integer(1)));  
obj.JMapInterpolationSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JMapInterpolationSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.35,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) MapInterpolationCallback(obj));

%%
obj.TextInfo=uicontrol('parent',obj.InfoPanel,'units','normalized','position',[0,0,1,1],...
    'style','Text','String','','HorizontalAlignment','left','fontweight','bold','fontsize',14);
end
%%
function h=colormap_popup(varargin)
cmapList = {'Gray','Bone', 'Copper','Jet', 'HSV', 'Hot', 'Cool', 'Spring', 'Summer', 'Autumn', ...
                 'Winter', 'Pink', 'Lines'}';
varargin=cat(2,varargin,{'style','popup','String',cmapList,'FontName','Courier','BackgroundColor','w'});
             
h=uicontrol(varargin{:});
allLength = cellfun(@numel,cmapList);
maxLength = max(allLength);
cmapHTML = [];
for i = 1:numel(cmapList)
    arrow = [repmat('-',1,maxLength-allLength(i)+1) '>'];
    cmapFun = str2func(['@(x) ' lower(cmapList{i}) '(x)']);
    cData = cmapFun(16);
    curHTML = ['<html>' cmapList{i} '<font color="#FFFFFF">' arrow '</font>'];
    for j = 1:16
        HEX = rgb2hex(cData(j,:));
        curHTML = [curHTML '<font bgcolor="' HEX '" color="' HEX '">_</font>'];
    end
    curHTML = [curHTML '</html>'];
    cmapHTML = [cmapHTML; {curHTML}];
end

set(h,'String',cmapHTML);
set(h,'UserData',cmapList);
end


