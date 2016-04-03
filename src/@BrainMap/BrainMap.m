classdef BrainMap < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties (Dependent)
        valid
    end
    
    properties
        fig
        axis_3d
        
        FileMenu
        LoadMenu
        LoadSurfaceMenu
        LoadElectrodeMenu
        
        SaveAsMenu
        SaveAsFigureMenu
        
        ViewPanel
        
        Toolbar
        JToolbar
        
        JRecenter
    end
    properties
        render
        head_center
        isrender
        overlay
        coor
        electrode
        curr_coor
        ini_coor
        elec_no
        alpha
        smooth
        elec_index
        color
        model
        display_view
        curr_model
        curr_elec
        head_plot
        label
        light
        RotateTimer
        ZoomTimer
        loc
        self_center
        position_bak
        
        inView
    end
    
    methods
        function obj=BrainMap()
            obj.varinit();
            obj.buildfig();
        end
        
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
            end
        end
        function varinit(obj)
            obj.render=[];
            obj.head_center=[];
            obj.isrender=[];
            obj.overlay=0;
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
            obj.model.vertices=[];
            obj.model.faces=[];
            obj.light=[];
            obj.curr_elec.side=[];
            obj.curr_elec.top=[];
            obj.curr_elec.stick=[];
            obj.position_bak.side=[];
            obj.position_bak.top=[];
            obj.position_bak.stick=[];
            obj.position_bak.coor=[];
            obj.inView=[];
            
        end
        
        function buildfig(obj)
            screensize=get(0,'ScreenSize');
            obj.fig=figure('Menubar','none','Name','BrainMap','units','pixels','position',[screensize(3)/2-400,screensize(4)/2-275,800,550],...
                'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),'resize','off','Dockcontrols','off',...
                'WindowButtonMotionFcn',@(src,evt)MouseMove(obj));
            
            obj.FileMenu=uimenu(obj.fig,'label','File');
            obj.LoadMenu=uimenu(obj.FileMenu,'label','Load');
            obj.LoadSurfaceMenu=uimenu(obj.LoadMenu,'label','Surface','callback',@(src,evt) LoadSurface(obj),'Accelerator','o');
            obj.LoadElectrodeMenu=uimenu(obj.LoadMenu,'label','Electrode','callback',@(src,evt) LoadElectrode(obj),'Accelerator','e');
            
            obj.SaveAsMenu=uimenu(obj.FileMenu,'label','Save as');
            obj.SaveAsFigureMenu=uimenu(obj.SaveAsMenu,'label','Figuer','callback',@(src,evt) SaveAsFigure(obj),'Accelerator','p');
            
            obj.ViewPanel=uipanel(obj.fig,'units','normalized','position',[0,0.15,0.7,0.85],'backgroundcolor',[0,0,0]);
            
            obj.axis_3d=axes('parent',obj.ViewPanel,'units','normalized','position',[0,0,1,1],'visible','off','CameraViewAngle',10);
            
            toolpanel=uipanel(obj.fig,'units','normalized','position',[0.7,0.15,0.3,0.85]);
            
            view(3);
            daspect([1,1,1]);
            obj.light=camlight('headlight','infinite');
            
            obj.RotateTimer=timer('TimerFcn',@ (src,evts) RotateTimerCallback(obj),'ExecutionMode','fixedRate','BusyMode','drop','period',0.1);
            %             obj.
            obj.inView=obj.isIn(get(obj.fig,'CurrentPoint'),getpixelposition(obj.ViewPanel));
            
            obj.BuildToolbar();

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
            if ~obj.isrender
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
            f=figure('Name','Axis 3D','Position',position,'visible','on','color','w');
            copyobj(obj.axis_3d,f);
            colormap(colormap(obj.axis_3d));
        end
        
        function RecenterCallback(obj)
            view(3);
            if ~obj.isrender
                obj.light = camlight(obj.light,'headlight');        % adjust light
            end
            set(obj.axis_3d,'CameraViewAngle',10);
        end
    end
    methods
        LoadSurface(obj)
        LoadElectrode(obj)
        BuildToolbar(obj)
    end
end