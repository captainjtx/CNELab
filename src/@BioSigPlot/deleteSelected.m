function deleteSelected(obj)

obj.RedrawEvtsSkip=true;

if isempty(obj.SelectedEvent)
    return
end
if ~isempty(obj.Evts)
    obj.Evts_(obj.SelectedEvent,:)=[];
end

EventIndex=obj.EventDisplayIndex;
EventTexts=obj.EventTexts;
EventLines=obj.EventLines;
deletedInd=[];

for i=1:size(obj.EventDisplayIndex,1)*size(obj.EventDisplayIndex,2)
    if any(obj.EventDisplayIndex(i)==obj.SelectedEvent)
        delete(obj.EventLines(i));
        delete(obj.EventTexts(i));
        deletedInd=[deletedInd,i];
    end
end

EventLines(deletedInd)=[];
EventTexts(deletedInd)=[];
EventIndex(deletedInd)=[];

obj.EventLines=EventLines;
obj.EventTexts=EventTexts;
obj.EventDisplayIndex=EventIndex;

obj.SelectedEvent=[];
obj.SelectedLines=[];

obj.RedrawEvtsSkip=false;
end

