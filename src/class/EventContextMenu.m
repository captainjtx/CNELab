classdef EventContextMenu
    %EVENTCONTEXTMENU Summary of this class goes here
    %   Detailed explanation goes here
    
    %EventContextMenu allow you to right click the event on the axes
    %followed by a pop up menu to edit or delete the event
    
    properties
        editOption
        deleteOption
        addOption
        hcmenu
    end
    
    methods
        function obj=EventContextMenu(bsp)
            
            
            obj.hcmenu=uicontextmenu;
            
            obj.addOption     = uimenu(obj.hcmenu,...
                'Label',        'Add',...
                'callback',     {@eventAdd,bsp});
            
            obj.editOption    = uimenu(obj.hcmenu,...
                'Label',        'Edit',...
                'callback',     {@EventEditWindow,bsp});
            obj.deleteOption  = uimenu(obj.hcmenu,...
                'Label',        'Delete',...
                'callback',     {@eventDelete,bsp});
        end
        
        function update(obj,bsp)
            if ~isempty(bsp.EventLines)
                
                eventLines=bsp.EventLines;
                eventTexts=bsp.EventTexts;
                
                if ~isempty(eventLines)
                    
                    for j=1:size(eventLines,1)*size(eventLines,2)
                        set(eventLines(j),'uicontextmenu',obj.hcmenu);
                        set(eventTexts(j),'uicontextmenu',obj.hcmenu);
                    end
                end
            end
            
        end
    end
    
    methods(Static)
        function eventDelete(src,evt,bsp)
            eventIndex=bsp.SelectedEvent;
            eventList=bsp.Evts;
            eventList(eventIndex,:)=[];
            
            bsp.Evts=eventList;
        end
        
        function eventAdd(src,evt,bsp)
            eventList=bsp.Evts;
            newEvent{1,1}=bsp.MouseTime;
            newEvent{1,2}='';
            newEventList=cat(1,eventList,newEvent);
            
            [t,IX]=sort(newEventList(:,1),1);
            
            for i=1:size(newEventList,1)
                sortedNewEventList{i,1}=newEventList{IX(i),1};
                sortedNewEventList{i,2}=newEventList{IX(i),2};
                if IX(i)==size(newEventList,1)
                    newEventIndex=i;
                end
            end
            
            bsp.Evts=sortedNewEventList;
            bsp.SelectedEvent=newEventIndex;
            
            EventEditWindow(bsp);
        end
    end
    
end

