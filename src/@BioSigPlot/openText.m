function openText(obj,src,axenum,count)
% set(src,'Selected','on');

if strcmpi(get(obj.Fig,'SelectionType'),'open')
    set(src,'Editing','on');
    obj.EditMode=1;
elseif strcmpi(get(obj.Fig,'SelectionType'),'normal')
    
    obj.SelectedLines=[obj.SelectedLines length(obj.Axes)*(count-1)+axenum];
    
    obj.SelectedEvent=obj.EventDisplayIndex(length(obj.Axes)*(count-1)+axenum);
    obj.DragMode=1;
end

end