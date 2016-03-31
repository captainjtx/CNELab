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
        
        head_plot
        
        light
        Timer
        loc
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
        end
        function buildfig(obj)
            screensize=get(0,'ScreenSize');
            obj.fig=figure('Menubar','none','Name','BrainMap','units','pixels','position',[screensize(3)/2-400,screensize(4)/2-275,800,550],...
                'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),'resize','off','Dockcontrols','off',...
                'WindowButtonDownFcn',@(src,evt)mousedown(obj));
            
            obj.FileMenu=uimenu(obj.fig,'label','File');
            obj.LoadMenu=uimenu(obj.FileMenu,'label','Load');
            obj.LoadSurfaceMenu=uimenu(obj.LoadMenu,'label','Surface','callback',@(src,evt) LoadSurface(obj),'Accelerator','o');
            obj.LoadElectrodeMenu=uimenu(obj.LoadMenu,'label','Electrode','callback',@(src,evt) LoadElectrode(obj),'Accelerator','e');
            
            view_p=uipanel(obj.fig,'units','normalized','position',[0,0.15,0.7,0.85],'BorderType','none','backgroundcolor','white');
            
            obj.axis_3d=axes('parent',view_p,'units','normalized','position',[0,0,1,1]);
            axis off
            
            
            toolpanel=uipanel(obj.fig,'units','normalized','position',[0.7,0.15,0.3,0.85]);
            
            view(3);
            daspect([1,1,1]);
            obj.light=camlight('headlight');
            
            obj.Timer=timer('TimerFcn',@ (src,evts) TimerCallback(obj),'ExecutionMode','fixedRate','BusyMode','queue','period',0.1);
        end
        
        function OnClose(obj)
            try
                delete(obj.fig);
            catch
            end
            try
                delete(obj.Timer)
            catch
            end
        end
        
        function mousedown(obj)
            obj.loc = get(0,'PointerLocation');    % get starting point
            start(obj.Timer);
%             set(obj.fig,'windowbuttonmotionfcn',@(src,evt) rotationcallback(obj,loc,az,el));
            set(obj.fig,'windowbuttonupfcn',@(src,evt) donecallback(obj));
        end
%         function rotationcallback(obj,loc,az,el)
%             locend = get(obj.fig, 'CurrentPoint'); % get mouse location
%             dx = locend(1) - loc(1);           % calculate difference x
%             dy = locend(2) - loc(2);           % calculate difference y
%             factor = 2;                         % correction mouse -> rotation
%             newaz=az-dx/factor;
%             newel=el-dy/factor;
%             newel=min(max(newel,-90),90);
%             view(obj.axis_3d,newaz,newel);
%             if ~obj.isrender
%                 obj.light = camlight(obj.light,'headlight');        % adjust light
%             end
%         end
        
        function donecallback(obj)
%             set(obj.fig,'windowbuttonmotionfcn',[]);    % unassign windowbuttonmotionfcn
            set(obj.fig,'windowbuttonupfcn',[]);        % unassign windowbuttonupfcn
            stop(obj.Timer);
        end
        
        function TimerCallback(obj)
            locend = get(0, 'PointerLocation'); % get mouse location
            dx = locend(1) - obj.loc(1);           % calculate difference x
            dy = locend(2) - obj.loc(2);           % calculate difference y
            factor = 2;                         % correction mouse -> rotation
            camorbit(obj.axis_3d,-dx/factor,-dy/factor);
            if ~obj.isrender
                obj.light = camlight(obj.light,'headlight');        % adjust light
            end
            obj.loc=locend;
        end
    end
    methods
        LoadSurface(obj)
        LoadElectrode(obj)
        
    end
    
end