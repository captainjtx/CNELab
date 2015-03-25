function KeyRelease(obj,src,evt)

if ~isempty(evt.Modifier)
    if length(evt.Modifier)==1
        if strcmpi(evt.Modifier{1},'command')||strcmpi(evt.Modifier{1},'control')
            if strcmpi(evt.Key,'d')||strcmpi(evt.Key,'backspace')
                %delete the drag selected event
                if ~isempty(obj.SelectedEvent)
                    modifySelectedEvent(obj,'delete');
                    return
                end
            end
        end
    end
else
    
end

