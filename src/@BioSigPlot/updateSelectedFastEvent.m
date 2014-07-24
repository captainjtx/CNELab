function updateSelectedFastEvent(obj,x)

if isempty(obj.SelectedFastEvt)||isempty(obj.FastEvts)
    newEvent={[],'New Event',obj.EventDefaultColor,0};
else
    newEvent={[],obj.FastEvts{obj.SelectedFastEvt,1},obj.FastEvts{obj.SelectedFastEvt,2},1};
end

for i=1:length(obj.Axes)
    yl=get(obj.Axes(i),'ylim');
    set(obj.LineMeasurer(i),'XData',[x x],'Color',newEvent{3});
    set(obj.TxtFastEvent(i),'Position',[x yl(2)],'BackgroundColor',newEvent{3},'EdgeColor',newEvent{3},...
        'string',newEvent{2})
end

end

