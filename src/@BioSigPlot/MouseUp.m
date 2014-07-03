function MouseUp(obj)

if ~isempty(obj.SelectedEvent)
    if obj.DragMode==2
        EventList=obj.Evts;
        EventList{obj.SelectedEvent,1}=obj.MouseTime;
        obj.Evts=EventList;
        
    end
end


obj.DragMode=0;
for i=1:length(obj.Axes)
    set(obj.LineMeasurer(i),'XData',[-1 -1],'Color',[0 0.7 0],'LineStyle','-.');
end

end