function openText(obj,src,axenum)
% set(src,'Selected','on');

if strcmpi(get(obj.Fig,'SelectionType'),'open')
    set(src,'Editing','on');
    obj.EditMode=1;
elseif strcmpi(get(obj.Fig,'SelectionType'),'normal')
    EventTexts=obj.EventTexts(axenum,:);
    count=find(src==EventTexts);
    newSelect=obj.EventDisplayIndex(length(obj.Axes)*(count-1)+axenum);
    Modifier=get(obj.Fig,'CurrentModifier');
    
    if ~isempty(Modifier)
        if length(Modifier)==1
            if ismember('control',Modifier)||ismember('command',Modifier)
                if ~isempty(obj.SelectedEvent)
                    if any(newSelect==obj.SelectedEvent)
                        obj.SelectedEvent(newSelect==obj.SelectedEvent)=[];
                        
                    else
                        obj.SelectedEvent=cat(1,obj.SelectedEvent,newSelect);
                    end
                else
                    obj.SelectedEvent=newSelect;
                end
                obj.DragMode=1;
                return
            end
        end
    else
        obj.SelectedEvent=newSelect;
        obj.DragMode=1;
    end
end

end