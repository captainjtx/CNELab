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
        begin
        head_plot
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
        end
        function buildfig(obj)
            screensize=get(0,'ScreenSize');
            obj.fig=figure('Menubar','none','Name','BrainMap','units','pixels','position',[screensize(3)/2-400,screensize(4)/2-275,800,550],...
                'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),'resize','off','Dockcontrols','off');
            
            obj.FileMenu=uimenu(obj.fig,'label','File');
            obj.LoadMenu=uimenu(obj.FileMenu,'label','Load');
            obj.LoadSurfaceMenu=uimenu(obj.LoadMenu,'label','Surface','callback',@(src,evt) LoadSurface(obj),'Accelerator','o');
            obj.LoadElectrodeMenu=uimenu(obj.LoadMenu,'label','Electrode','callback',@(src,evt) LoadElectrode(obj),'Accelerator','e');
            
            view_p=uipanel(obj.fig,'units','normalized','position',[0,0.15,0.7,0.85],'BorderType','none','backgroundcolor','white');
            
            obj.axis_3d=axes('parent',view_p,'units','normalized','position',[0,0,1,1]);
            axis off
            
            
            toolpanel=uipanel(obj.fig,'units','normalized','position',[0.7,0.15,0.3,0.85]);
        end
        
        function OnClose(obj)
            if ishandle(obj.fig)
                delete(obj.fig);
            end
        end
        
    end
    methods
        LoadSurface(obj)
        LoadElectrode(obj)
        
    end
    
end