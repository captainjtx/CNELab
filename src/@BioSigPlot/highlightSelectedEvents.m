function highlightSelectedEvents(obj)
EventLines=obj.EventLines;
EventTexts=obj.EventTexts;
EventIndex=obj.EventDisplayIndex;
colors=obj.Evts_(:,3);
SelectedEvent=obj.SelectedEvent;
SelectedColor=obj.EventSelectColor;

for i=1:size(EventIndex,1)*size(EventIndex,2)
    if EventIndex(i)==SelectedEvent
        set(EventLines(i),'Color',SelectedColor);
        set(EventTexts(i),'EdgeColor',SelectedColor,'BackgroundColor',SelectedColor);
    else
        set(EventLines(i),'Color',colors{EventIndex(i)});
        set(EventTexts(i),'EdgeColor',colors{EventIndex(i)},'BackgroundColor',colors{EventIndex(i)});
    end
end


end
