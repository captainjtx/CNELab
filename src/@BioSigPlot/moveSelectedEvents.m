function moveSelectedEvents(obj,val)
obj.RedrawEvtsSkip=true;
step=cell(length(obj.SelectedEvent),1);
[step{:}]=deal(val);

obj.Evts_(obj.SelectedEvent,1)=cellfun(@plus,obj.Evts_(obj.SelectedEvent,1),step,'uniformoutput',false);


EventLines=obj.EventLines;
EventTexts=obj.EventTexts;
EventIndex=obj.EventDisplayIndex;

SelectedEvent=obj.SelectedEvent;

for i=1:size(EventIndex,1)*size(EventIndex,2)
    if any(EventIndex(i)==SelectedEvent)
        x=(obj.Evts{EventIndex(i),1}-obj.Time)*obj.SRate;
        set(EventLines(i),'XData',[x x]);
        
        pos=get(EventTexts(i),'position');
        set(EventTexts(i),'Position',[x pos(2)]);
        
    end
end

obj.RedrawEvtsSkip=false;

end

