function MouseUp(obj)

if ~isempty(obj.SelectedEvent)
    if obj.DragMode==2
        step=obj.MouseTime-obj.Evts{obj.SelectedEvent,1};
        moveSelectedEvents(obj,step);
    end
end


obj.DragMode=0;

end