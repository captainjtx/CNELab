classdef EventWindow  < handle
    properties
        EventTime
        uilist
        Evts_
        bsp
        EvtIndex
    end
    properties (Dependent=true)
        Evts
    end
    
    methods
        function obj=EventWindow(bsp)
            
            obj.bsp=bsp;
            
            obj.uilist=uicontrol(bsp.EventPanel,'Style','listbox','units','normalized',...
                'position',[0 0 1 0.95],'FontName','FixedWidth','Callback',@(src,evt) click(obj,src),...
                'Max',10,'Min',1);
            
            eventListMenu=uicontextmenu('Visible','on');
            uimenu(eventListMenu,'Label','Rename','Callback',@(src,evt)bsp.modifySelectedEvent('rename'));
            uimenu(eventListMenu,'Label','Group Rename','Callback',@(src,evt)bsp.groupModifySelectedEvent('rename'));
            uimenu(eventListMenu,'Label','Delete','Callback',@(src,evt) bsp.modifySelectedEvent('delete'));
            uimenu(eventListMenu,'Label','Group Delete','Callback',@(src,evt) bsp.groupModifySelectedEvent('delete'));
            set(obj.uilist,'uicontextMenu',eventListMenu);
            
            
        end
        
        function click(obj,src)
            val=get(src,'value');
            if ~isempty(val)
                obj.bsp.SelectedEvent=obj.EvtIndex(val);
                obj.EventTime=obj.Evts{val(1),1};
                
                if obj.EventTime<obj.bsp.Time||obj.EventTime>obj.bsp.Time+obj.bsp.WinLength
                    obj.bsp.Time=obj.EventTime;
                end
                
            end
        end
        
        
        function val=get.Evts(obj)
            val=obj.Evts_;
        end
        
        
        function set.Evts(obj,evts)
            evts=evts(obj.bsp.Evts2Display,:);
            
            if ~isempty(evts)
                [evts,evtIndex]=sortrows(evts,1);
                obj.EvtIndex=obj.bsp.Evts2Display(evtIndex);
            else
                obj.EvtIndex=[];
            end
            s=cell(size(evts,1),1);
            
%             [ind,num]=obj.findIndexOfEvent(evts(:,2),[evts{:,1}]);
            
            for i=1:size(evts,1)
%                 s{i}=sprintf('%8.2f - %s ---- #%d|%d',evts{i,1},evts{i,2},ind(i),num(i));
                s{i}=sprintf('%8.2f - %s    ',evts{i,1},evts{i,2});
                s{i}=obj.colorEvent(s{i},evts{i,3});
            end
            obj.Evts_=evts;
            val=get(obj.uilist,'Value');
            if isempty(val)
                val=[];
            else
                val(val>length(s))=[];
            end
            
            set(obj.uilist,'String',s);
            set(obj.uilist,'Value',val);
            
        end
        
    end
    methods (Static=true)
        
        function cs=colorEvent(text,color)
            color=round(255*color);
            colorstr=sprintf('rgb(%d,%d,%d)',color(1),color(2),color(3));
            cs=sprintf('<HTML><FONT bgcolor="%s">%s</FONT></HTML>',colorstr,text);
        end
        
        function [ind,num]=findIndexOfEvent(txt,time)
            %assume the time is already increasing sorted
            ind=zeros(length(txt),1);
            num=zeros(length(txt),1);
            
            for i=1:length(txt)
                
                tmp=strcmpi(txt,txt{i});
                subtime=time(tmp);
                
                ind(i)=sum(time(i)>=subtime);
                num(i)=sum(tmp);
            end
            
        end
    end
    
end