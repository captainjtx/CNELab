%Class for predefined event window
%Inspired by EventWindow.m
%Tianxiao Jiang @ CNEL
%tjiang3@uh.edu
classdef FastEventWindow  < handle
    properties
        EventTime
        Evts
        Fig
    end
    
    methods
        function obj=EventWindow(evts)
            obj.Fig=figure('MenuBar','none','position',[500 100 344 500],...
                'NumberTitle','off','Name','FastEvents',...
                'CloseRequestFcn',@(src,evts) delete(obj));
            
            for i=1:size(evts,1)
                s{i}=sprintf('%8.2f -%s',evts{i,1},evts{i,2});
            end
            uicontrol(obj.Fig,'Style','listbox','units','normalized','position',[0 0 1 1],'FontName','FixedWidth','String',s,'Callback',@(src,evt) click(obj,src));
            obj.Evts=evts;
        end
        
        function delete(obj)
            % Delete the figure
            h = obj.Fig;
            notify(obj,'EvtClosed');
            if ishandle(h)
                delete(h);
            else
                return
            end
        end
        
        function click(obj,src)
            obj.EventTime=obj.Evts{get(src,'value'),1};
            notify(obj,'EvtSelected');
        end
        
    end
    events
        FastEvtSelected
        FastEvtClosed
        FastEvtAdded
        FastEvtDeleted
    end
    
end
