classdef BrainMap < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties (Dependent)
        valid
    end
        
    properties
        fig
        axe_3d
        
        File_Menu
        Load_Menu
        Load_Surface_Menu
        
    end
    
    methods
        function obj=BrainMap()
            
            obj.buildfig();
        end
        
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
            end
        end
        
        function buildfig(obj)
            screensize=get(0,'ScreenSize');
            obj.fig=figure('Menubar','none','Name','electrode','units','pixels','position',[screensize(3)/2-500,screensize(4)/2-350,1000,700],...
                'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),'resize','off','Dockcontrols','off');
            
            obj.File_Menu=uimenu(obj.fig,'label','File');
            obj.Load_Menu=uimenu(obj.File_Menu,'label','Load');
            obj.Load_Surface_Menu=uimenu(obj.Load_Menu,'label','Surface','callback',@(src,evt) LoadSurface(obj));
            
            view_p=uipanel(obj.fig,'units','normalized','position',[0,0.15,0.7,0.85],'BorderType','none','backgroundcolor','white');
            
            obj.axe_3d=axes(view_p,'units','normalized','position',[0,0,1,1]);
            axis off
            
            
            toolpanel=uipanel(obj.fig,'units','normalized','position',[0.7,0.15,0.3,0.85]);
        end
        
        function OnClose(obj)
            if ishandle(obj.fig)
                delete(obj.fig);
            end
        end
        
        function LoadSurface(obj)
            
        end
    end
    
end