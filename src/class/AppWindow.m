classdef AppWindow < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        valid
        fig
    end
    
    methods
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isgraphics(obj.fig);
            catch 
                val=0;
            end
        end
    end
    
end

