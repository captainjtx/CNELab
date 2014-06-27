function KeyRelease(obj,src,evt)

if ~isempty(evt.Modifier)
    if (strcmpi(evt.Modifier{1},'command')&&strcmpi(evt.Key,'backspace'))...
            ||(strcmpi(evt.Modifier{1},'shift')&&strcmpi(evt.Key,'d'))
        
        %delete the drag selected event
        if ~isempty(obj.SelectedEvent)
            EventList=obj.Evts;
            EventList(obj.SelectedEvent,:)=[];
            
            obj.SelectedEvent=[];
            obj.SelectedLines=[];
            
            obj.Evts=EventList;
            return
        end
    end
    
    if (strcmpi(evt.Modifier{1},'command')||...
            strcmpi(evt.Modifier{1},'control'))
        if ismember(evt.Key,{'1','2','3','4','5','6','7','8','9'})
            
            return
        end
    end
end

if strcmpi(evt.Key,'return')
    if ~isempty(obj.SelectedEvent)
        for i=1:length(obj.Axes)
            if gca==obj.Axes(i)
                obj.EditMode=1;
                set(obj.EventTexts(obj.SelectedLines(i)),'Editing','on');
            end
        end
        return
    end
end
end