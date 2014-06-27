function MouseUp(obj)
if obj.EditMode==1
    obj.EditMode=0;
    EventList=obj.Evts;
    for i=1:size(obj.EventDisplayIndex,2)
        EventList{obj.EventDisplayIndex(1,i),2}=get(obj.EventTexts(1,i),'String');
    end
    obj.Evts=EventList;
end

if ~isempty(obj.SelectedEvent)
    if obj.DragMode==2
        EventList=obj.Evts;
        EventList{obj.SelectedEvent,1}=obj.MouseTime;
        obj.Evts=EventList;
        
    end
end


obj.DragMode=0;

end