function BuildFig(obj)
import javax.swing.JSlider;
import javax.swing.JSpinner;
import javax.swing.SpinnerNumberModel;
import javax.swing.JButton;
import java.awt.Color;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;

screensize=get(0,'ScreenSize');
obj.fig=figure('Menubar','none','Name','BrainMap','units','pixels','position',[screensize(3)/2-450,screensize(4)/2-325,900,650],...
    'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),'resize','on','Dockcontrols','off',...
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

%==========================================================================
obj.ViewPanel=uipanel(obj.fig,'units','normalized','position',[0,0.1,0.7,0.9],'backgroundcolor',[0,0,0]);

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

%suface tool pane==========================================================
obj.surfacetoolpane=uipanel(obj.sidepane,'units','normalized','position',[0,0,1,0.73],'visible','off');

uicontrol('parent',obj.surfacetoolpane,'style','text','units','normalized','position',[0,0.9,0.25,0.08],...
    'string','Opacity(%)','FontSize',12,'horizontalalignment','left');
obj.JSurfaceAlphaSlider=javaObjectEDT(JSlider(JSlider.HORIZONTAL,0,100,90));
[jh,gh]=javacomponent(obj.JSurfaceAlphaSlider,[0,0,1,1],obj.surfacetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.9,0.55,0.1]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) SurfaceAlphaSliderCallback(obj));

model = javaObjectEDT(SpinnerNumberModel(90,0,100,10));  
obj.JSurfaceAlphaSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JSurfaceAlphaSpinner,[0,0,1,1],obj.surfacetoolpane);
set(gh,'Units','Norm','Position',[0.8,0.92,0.2,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) SurfaceAlphaSpinnerCallback(obj));
%volume tool pane==========================================================
cmapList = {'Gray','Bone', 'Copper','Jet', 'HSV', 'Hot', 'Cool', 'Spring', 'Summer', 'Autumn', ...
                 'Winter', 'Pink', 'Lines'}';
obj.volumetoolpane=uipanel(obj.sidepane,'units','normalized','position',[0,0,1,0.73],'visible','on');

uicontrol('parent',obj.volumetoolpane,'style','text','units','normalized','position',[0,0.9,0.25,0.08],...
    'string','Colormap','FontSize',12,'horizontalalignment','left');
obj.ColorMapPopup = uicontrol('Style','popup','Parent',obj.volumetoolpane,'String',cmapList,...
    'units','normalized','position',[0.25,0.9,0.75,0.08],'FontName','Courier','BackgroundColor','w');
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
set(obj.ColorMapPopup,'Value',1,'String',cmapHTML,'Callback',@(src,evt)ColormapCallback(obj));

uicontrol('parent',obj.volumetoolpane,'style','text','units','normalized','position',[0,0.84,0.2,0.06],...
    'string','Min','FontSize',12,'horizontalalignment','left');
model = javaObjectEDT(SpinnerNumberModel(obj.cmin,0,255,5));  
obj.JVolumeMinSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JVolumeMinSpinner,[0,0,1,1],obj.volumetoolpane);
set(gh,'Units','Norm','Position',[0.22,0.84,0.25,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) VolumeScaleSpinnerCallback(obj));

uicontrol('parent',obj.volumetoolpane,'style','text','units','normalized','position',[0.5,0.84,0.2,0.06],...
    'string','Max','FontSize',12,'horizontalalignment','left');
model = javaObjectEDT(SpinnerNumberModel(obj.cmax,0,255,5));  
obj.JVolumeMaxSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JVolumeMaxSpinner,[0,0,1,1],obj.volumetoolpane);
set(gh,'Units','Norm','Position',[0.72,0.84,0.25,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) VolumeScaleSpinnerCallback(obj));
%electrode tool pane=======================================================
obj.electrodetoolpane=uipanel(obj.sidepane,'units','normalized','position',[0,0,1,0.73],'visible','off');
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.9,0.25,0.08],...
    'string','Color','FontSize',12,'horizontalalignment','left');

obj.JElectrodeColorBtn = javaObjectEDT(JButton());
obj.JElectrodeColorBtn.setBorder(BorderFactory.createLineBorder(Color.black));
obj.JElectrodeColorBtn.setBackground(Color(0.8549,0.6471,0.1255));
obj.JElectrodeColorBtn.setOpaque(true);
[jh, hContainer] = javacomponent(obj.JElectrodeColorBtn, [0,0,1,1], obj.electrodetoolpane);
set(hContainer, 'Units','norm','position',[0.3,0.93,0.15,0.05]);
set(handle(jh,'CallbackProperties'),'MousePressedCallback',@(h,e) ElectrodeColorCallback(obj));

uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.84,0.22,0.06],...
    'string','Radius','FontSize',12,'horizontalalignment','left');
model = javaObjectEDT(SpinnerNumberModel(0.5,0,10,0.1));  
obj.JElectrodeRadiusSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JElectrodeRadiusSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.22,0.84,0.25,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ElectrodeSpinnerCallback(obj));

uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0.5,0.84,0.22,0.06],...
    'string','Thickness','FontSize',12,'horizontalalignment','left');
model = javaObjectEDT(SpinnerNumberModel(0.4,0,10,0.1));  
obj.JElectrodeThicknessSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JElectrodeThicknessSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.72,0.84,0.25,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ElectrodeSpinnerCallback(obj));

uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.84,0.22,0.06],...
    'string','Radius','FontSize',12,'horizontalalignment','left');

end


