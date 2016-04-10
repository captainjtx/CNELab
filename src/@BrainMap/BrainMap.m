classdef BrainMap < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties (Dependent)
        valid
        cnelab_path
    end
    
    properties
        fig
        axis_3d
        
        FileMenu
        LoadMenu
        LoadVolumeMenu
        LoadSurfaceMenu
        LoadElectrodeMenu
        
        SaveAsMenu
        SaveAsFigureMenu
        
        ViewPanel
        
        Toolbar
        JToolbar
        
        JRecenter
        
        JFileLoadTree
        JLight
        
        IconLightOn
        IconLightOff
        
        IconLoadSurface
        IconDeleteSurface
        IconNewSurface
        IconSaveSurface
        
        IconLoadVolume
        IconDeleteVolume
        IconNewVolume
        IconSaveVolume
        
        IconLoadElectrode
        IconDeleteElectrode
        IconNewElectrode
        IconSaveElectrode
        
        JLoadBtn
        JDeleteBtn
        JNewBtn
        JSaveBtn
        
        toolpane
        toolbtnpane
    end
    properties
        coor
        electrode
        curr_coor
        ini_coor
        elec_no
        alpha
        smooth
        elec_index
        color
        
        display_view
        curr_elec
        
        label
        light
        RotateTimer
        ZoomTimer
        loc
        self_center
        
        inView
        
        mapObj
        
        SelectEvt
    end
    
    methods
        function obj=BrainMap()
            
            obj.varinit();
            obj.buildfig();
        end
        
        function val=get.cnelab_path(obj)
            [val,~,~]=fileparts(which('cnelab.m'));
        end
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
            end
        end
        function varinit(obj)
            
            obj.coor=[];
            obj.electrode.coor=[];
            obj.electrode.col=[];
            obj.electrode.marker=[];
            obj.curr_coor=[];
            obj.ini_coor=[];
            obj.elec_no=0;
            obj.alpha=0.85;
            obj.smooth=0;
            obj.elec_index=0;
            obj.color=[0 0 1];
            
            obj.light=[];
            obj.curr_elec.side=[];
            obj.curr_elec.top=[];
            obj.curr_elec.stick=[];
            obj.inView=[];
            
            obj.mapObj=containers.Map;
            
            obj.SelectEvt.category='Volume';
        end
        
        function buildfig(obj)
            screensize=get(0,'ScreenSize');
            obj.fig=figure('Menubar','none','Name','BrainMap','units','pixels','position',[screensize(3)/2-450,screensize(4)/2-325,900,650],...
                'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),'resize','on','Dockcontrols','off',...
                'WindowButtonMotionFcn',@(src,evt)MouseMove(obj));
            
            obj.FileMenu=uimenu(obj.fig,'label','File');
            obj.LoadMenu=uimenu(obj.FileMenu,'label','Load');
            
            obj.LoadVolumeMenu=uimenu(obj.LoadMenu,'label','Volume','callback',@(src,evt) LoadVolume(obj),'Accelerator','o');
            obj.LoadSurfaceMenu=uimenu(obj.LoadMenu,'label','Surface','callback',@(src,evt) LoadSurface(obj),'Accelerator','u');
            obj.LoadElectrodeMenu=uimenu(obj.LoadMenu,'label','Electrode','callback',@(src,evt) LoadElectrode(obj),'Accelerator','e');
            
            obj.SaveAsMenu=uimenu(obj.FileMenu,'label','Save as');
            obj.SaveAsFigureMenu=uimenu(obj.SaveAsMenu,'label','Figuer','callback',@(src,evt) SaveAsFigure(obj),'Accelerator','p');
            
            obj.ViewPanel=uipanel(obj.fig,'units','normalized','position',[0,0.1,0.7,0.9],'backgroundcolor',[0,0,0]);
            
            obj.axis_3d=axes('parent',obj.ViewPanel,'units','normalized','position',[0,0,1,1],'visible','off','CameraViewAngle',10);
            
            obj.toolpane=uipanel(obj.fig,'units','normalized','position',[0.7,0.1,0.3,0.9]);
            
            view(3);
            daspect([1,1,1]);
            obj.light=camlight('headlight','infinite');
            
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
            
            [jh,gh]=javacomponent(obj.JFileLoadTree.span,[0,0,1,1],obj.toolpane);
            set(gh,'Units','Norm','Position',[0,0.8,1,0.2]);
            
            obj.toolbtnpane=uipanel(obj.toolpane,'units','normalized','position',[0,0.73,1,0.07]);
            
            obj.BuildIOBar();
        end
        function OnClose(obj)
            try
                delete(obj.fig);
            catch
            end
            try
                delete(obj.RotateTimer)
            catch
            end
        end
        
        function f=panon(obj)
            f=strcmp(get(pan(obj.fig),'Enable'),'on');
        end
        
        function MouseDown_View(obj)
            obj.loc = get(obj.fig,'CurrentPoint');    % get starting point
            start(obj.RotateTimer);
            set(obj.fig,'windowbuttonupfcn',@(src,evt) MouseUp_View(obj));
        end
        function f=isIn(obj,cursor,position)
            f=cursor(1)>position(1)&&cursor(1)<position(1)+position(3)&&cursor(2)>position(2)&&cursor(2)<position(2)+position(4);
        end
        function MouseMove(obj)
            position = getpixelposition(obj.ViewPanel);
            cursor=get(obj.fig,'CurrentPoint');
            in_view=obj.isIn(cursor,position);
            
            %within the view panel
            f=obj.panon();
            if ~f
                if in_view&&~obj.inView
                    set(obj.fig,'WindowButtonDownFcn',@(src,evt)MouseDown_View(obj));
                    set(obj.fig,'WindowScrollWheelFcn',@(src,evt)Scroll_View(obj,src,evt));
                    
                elseif ~in_view&&obj.inView
                    set(obj.fig,'WindowButtonDownFcn',[]);
                    set(obj.fig,'WindowScrollWheelFcn',[]);
                end
            end
            
            obj.inView=in_view;
        end
        
        function MouseUp_View(obj)
            %             set(obj.fig,'windowbuttonmotionfcn',[]);    % unassign windowbuttonmotionfcn
            set(obj.fig,'windowbuttonupfcn',[]);        % unassign windowbuttonupfcn
            stop(obj.RotateTimer);
        end
        
        function RotateTimerCallback(obj)
            locend = get(obj.fig, 'CurrentPoint'); % get mouse location
            dx = locend(1) - obj.loc(1);           % calculate difference x
            dy = locend(2) - obj.loc(2);           % calculate difference y
            factor = 2;                         % correction mouse -> rotation
            camorbit(obj.axis_3d,-dx/factor,-dy/factor);

            if ~isempty(obj.light)
                obj.light = camlight(obj.light,'headlight');        % adjust light
            end
            
            obj.loc=locend;
        end
        
        
        function Scroll_View(obj,src,evt)
            vt=evt.VerticalScrollCount;
            factor=1.05^vt;
            camzoom(factor);
        end
        
        function SaveAsFigure(obj)
            position=getpixelposition(obj.ViewPanel);
            figpos=get(obj.fig,'position');
            position(1)=position(1)+figpos(1);
            position(2)=position(2)+figpos(2);
            f=figure('Name','Axis 3D','Position',position,'visible','on','color',get(obj.ViewPanel,'BackgroundColor'));
            copyobj(obj.axis_3d,f);
            colormap(colormap(obj.axis_3d));
        end
        
        function RecenterCallback(obj)
            view(3);
            if ~isempty(obj.light)
                obj.light = camlight(obj.light,'headlight');        % adjust light
            end
            set(obj.axis_3d,'CameraViewAngle',10);
        end
        
        function TreeSelectionCallback(obj,src,evt)
            if ~strcmpi(obj.SelectEvt.category,evt.category)
                
                if strcmpi(evt.category,'Volume')
                    obj.JLoadBtn.setIcon(obj.IconLoadVolume);
                    obj.JLoadBtn.setToolTipText('Load volume');
                    
                    obj.JDeleteBtn.setIcon(obj.IconDeleteVolume);
                    obj.JDeleteBtn.setToolTipText('Delete volume');
                    
                    obj.JNewBtn.setIcon(obj.IconNewVolume);
                    obj.JNewBtn.setToolTipText('New volume');
                    
                    obj.JSaveBtn.setIcon(obj.IconSaveVolume);
                    obj.JSaveBtn.setToolTipText('Save volume');
                    
                    set(handle(obj.JLoadBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) LoadVolume(obj));
                    set(handle(obj.JDeleteBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) DeleteVolume(obj));
                    set(handle(obj.JNewBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) NewVolume(obj));
                    set(handle(obj.JSaveBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) SaveVolume(obj));
                elseif strcmpi(evt.category,'Surface')
                    obj.JLoadBtn.setIcon(obj.IconLoadSurface);
                    obj.JLoadBtn.setToolTipText('Load surface');
                    
                    obj.JDeleteBtn.setIcon(obj.IconDeleteSurface);
                    obj.JDeleteBtn.setToolTipText('Delete surface');
                    
                    obj.JNewBtn.setIcon(obj.IconNewSurface);
                    obj.JNewBtn.setToolTipText('New surface');
                    
                    obj.JSaveBtn.setIcon(obj.IconSaveSurface);
                    obj.JSaveBtn.setToolTipText('Save surface');
                    
                    set(handle(obj.JLoadBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) LoadSurface(obj));
                    set(handle(obj.JDeleteBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) DeleteSurface(obj));
                    set(handle(obj.JNewBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) NewSurface(obj));
                    set(handle(obj.JSaveBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) SaveSurface(obj));
                elseif strcmpi(evt.category,'Electrode')
                    obj.JLoadBtn.setIcon(obj.IconLoadElectrode);
                    obj.JLoadBtn.setToolTipText('Load electrode');
                    
                    obj.JDeleteBtn.setIcon(obj.IconDeleteElectrode);
                    obj.JDeleteBtn.setToolTipText('Delete electrode');
                    
                    obj.JNewBtn.setIcon(obj.IconNewElectrode);
                    obj.JNewBtn.setToolTipText('New electrode');
                    
                    obj.JSaveBtn.setIcon(obj.IconSaveElectrode);
                    obj.JSaveBtn.setToolTipText('Save electrode');
                    
                    set(handle(obj.JLoadBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) LoadElectrode(obj));
                    set(handle(obj.JDeleteBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) DeleteElectrode(obj));
                    set(handle(obj.JNewBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) NewElectrode(obj));
                    set(handle(obj.JSaveBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) SaveElectrode(obj));
                elseif strcmpi(evt.category,'Others')
                    
                end
            end         
            
%             disp(evt.filename)
%             disp(evt.ischecked)
%             disp(evt.level)
%             disp(evt.category)
            
            obj.SelectEvt=evt;
        end
        
        function CheckChangedCallback(obj,src,evt)
            
            mapval=obj.mapObj(char(evt.filename));
            if evt.ischecked
                set(mapval.handles,'visible','on');
            else
                set(mapval.handles,'visible','off');
            end
%             disp(evt.filename)
%             disp(evt.ischecked)
        end
        
        function LightOffCallback(obj)
            obj.JLight.setIcon(obj.IconLightOn);
            obj.JLight.setToolTipText('Light on');
            delete(findobj(obj.axis_3d,'type','light'));
            obj.light=[];
            set(handle(obj.JLight,'CallbackProperties'),'MousePressedCallback',@(h,e) LightOnCallback(obj));
        end
        
        function LightOnCallback(obj)
            obj.JLight.setIcon(obj.IconLightOff);
            obj.JLight.setToolTipText('Light off');
            obj.light=camlight('headlight','infinite');
            set(handle(obj.JLight,'CallbackProperties'),'MousePressedCallback',@(h,e) LightOffCallback(obj));
        end
        
        
        function DeleteSurface(obj)
            
        end
        
        function DeleteVolume(obj)
        end
        function DeleteElectrode(obj)
        end
        
        function NewElectrode(obj)
        end
        function NewSurface(obj)
        end
        function NewVolume(obj)
        end
        
        function SaveVolume(obj)
        end
        function SaveSurface(obj)
        end
        function SaveElectrode(obj)
        end
    end
    methods
        LoadSurface(obj)
        LoadElectrode(obj)
        BuildToolbar(obj)
        BuildIOBar(obj)
    end
end