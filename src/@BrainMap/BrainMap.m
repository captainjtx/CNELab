classdef BrainMap < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fig
    end
    
    methods
        function obj=BrainMap()
            
        
        end
        
        function buildfig(obj)
            obj.fig=figure('Menubar','none','Name','electrode','units','pixels','position',[50,50,400,400],...
                'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),'resize','off','Dockcontrols','off');
            
        end
        
        function OnClose(obj)
        end
    end
    
end