classdef EventWindow  < handle
    properties
        EventTime
        uilist
        Evts_
        bsp
    end
    properties (Dependent=true)
        Evts
    end
    
    methods
        function obj=EventWindow(bsp,evts)
    
            obj.bsp=bsp;
            
            obj.uilist=uicontrol(bsp.EventPanel,'Style','listbox','units','normalized','position',[0 0 1 1],'FontName','FixedWidth','Callback',@(src,evt) click(obj,src));
            obj.Evts=evts;
        end
        
        function click(obj,src)
            obj.EventTime=obj.Evts{get(src,'value'),1};
            notify(obj,'EvtSelected');
        end
        function val=get.Evts(obj)
            val=obj.Evts_;
        end
        function set.Evts(obj,evts)
            
            if ~isempty(evts)
                evts=sortrows(evts,1);
            end
            
            s=cell(size(evts,1),1);
            for i=1:size(evts,1)
                s{i}=sprintf('%8.2f -%s',evts{i,1},evts{i,2}); %#ok<AGROW>
                s{i}=obj.colorEvent(s{i},evts{i,3});
            end
            obj.Evts_=evts;
            
            set(obj.uilist,'String',s);
        end
        
    end
    methods (Static=true)
        
        function cs=colorEvent(text,color)
            color=round(255*color);
            colorstr=sprintf('rgb(%d,%d,%d)',color(1),color(2),color(3));
            cs=sprintf('<HTML><FONT bgcolor="%s">%s</FONT></HTML>',colorstr,text);
        end
    end
    events
        EvtSelected
    end
    
end