function MouseUp(obj)

if ~isempty(obj.SelectedEvent)
    if obj.DragMode==2
        EventList=obj.Evts;
        EventList{obj.SelectedEvent,1}=obj.MouseTime;
        obj.Evts=EventList;
        
    end
end


obj.DragMode=0;

end