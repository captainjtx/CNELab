classdef EventContextMenu < uicontextmenu
    %EVENTCONTEXTMENU Summary of this class goes here
    %   Detailed explanation goes here
    
    %EventContextMenu allow you to right click the event on the axes
    %followed by a pop up menu to edit or delete the event
    
    properties
        hcmenu
        editOption
        deleteOption
        caller
    end
    
    methods
        function obj=EventContextMenu(bsp)
            obj.hcmenu=uicontextmenu;
            EventLines=bsp.EventLines;
            EventTexts=bsp.EventTexts;
            
            EventDisplayIndex=bsp.EventDisplayIndex;
            
            if ~isempty(EventLines)
                for i=1:size(EventLines,1)*size(EventLines,2)
                    
                    eventIndex=EventDisplayIndex(i);
                    
                    obj.editOption    =    uimenu(obj.hcmenu,...
                        'Label',        'Edit',...
                        'Seperator',    'on',...
                        'callback',     {@EventEditWindow,bsp,eventIndex});
                    obj.deleteOption  =    uimenu(obj.hcmenu,...
                        'Label',        'Delete',...
                        'Seperator',    'on',...
                        'callback',     {@eventDelete,EventLines(i),bsp,eventIndex});
                    
                    set(EventLines(i),'uicontextmenu',obj.hcmenu);
                    set(EventTexts(i),'uicontextmenu',obj.hcmenu);
                end
            end
        end
        
        function delete(obj)
            h=obj.hcmenu;
            notify(obj,'MenuClose');
            if ishandle(h)
                delete(h);
            else
                return
            end
        end
        
        function eventDelete(src,evt,bsp,eventIndex)
            
        end
        
        
    end
    
    events
        MenuClose
    end
    
end

