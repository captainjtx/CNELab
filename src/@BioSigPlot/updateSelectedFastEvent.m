function updateSelectedFastEvent(obj,x)

if isempty(obj.SelectedFastEvt)||isempty(obj.FastEvts)
    newEvent={[],'New Event',obj.EventDefaultColors(1,:),0};
else
    newEvent={[],obj.FastEvts{obj.SelectedFastEvt,1},obj.FastEvts{obj.SelectedFastEvt,2},1};
end

for i=1:length(obj.Axes)
    yl=get(obj.Axes(i),'ylim');
    xl=get(obj.Axes(i),'xlim');
    set(obj.LineMeasurer(i),'XData',[x x],'Color',newEvent{3});
    
    if ~isempty(obj.TxtFastEvent)&&ishandle(obj.TxtFastEvent(i))
        set(obj.TxtFastEvent(i),'Position',[x+(xl(2)-xl(1))/400 yl(2)],'Color',newEvent{3},...
            'string',newEvent{2})
    end
end

end

