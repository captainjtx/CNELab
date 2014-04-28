classdef EventContextMenu < uicontextmenu
    %EVENTCONTEXTMENU Summary of this class goes here
    %   Detailed explanation goes here
    
    %EventContextMenu allow you to right click the event on the axes
    %followed by a pop up menu to edit or delete the event
    
    properties
        hcmenu
    end
    
    methods
        function obj=EventContextMenu()
            obj.hcmenu=uicontextmenu;
            editOption    =    uimenu(obj.hcmenu,...
                                        'Label',        'Edit',...
                                        'Seperator',    'on',...
                                        'callback',     @{});
            deleteOption  =    uimenu(obj.hcmenu,...
                                        'Label',        'Delete',...
                                        'Seperator',    'on',...
                                        'callback',     @{});
            
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
          
    end
    
    events
        MenuClose
    end
    
end

