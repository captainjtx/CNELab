function KeyRelease(obj,src,evt)

if ~isempty(evt.Modifier)
    if length(evt.Modifier)==1
        if strcmpi(evt.Modifier{1},'command')||strcmpi(evt.Modifier{1},'control')
            if strcmpi(evt.Key,'d')||strcmpi(evt.Key,'backspace')
                %delete the drag selected event
                if ~isempty(obj.SelectedEvent)
                    deleteSelected(obj);
                    return
                end
            end
        end
    end
else
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

