function addNewEvent(obj,newEvent)
obj.RedrawEvtsSkip=true;
obj.Evts_=cat(1,obj.Evts_,newEvent);
count=0;
for i=1:length(obj.Axes)
    count=count+1;
    
    yl=get(obj.Axes(i),'Ylim');
    xl=get(obj.Axes(i),'XLim');
    x=obj.SRate*(newEvent{1}-obj.Time);
    
    EventLines(count)=line([x x],[0 1000],'parent',obj.Axes(i),'Color',newEvent{3});
    EventTexts(count)=text('Parent',obj.Axes(i),'position',[x+(xl(2)-xl(1))/400 yl(2)],'Color',newEvent{3},...
        'VerticalAlignment','Top','FontSize',12,'String',newEvent{2},'Editing','off','SelectionHighlight','on',...
        'ButtonDownFcn',@(src,evt)openText(obj,src,i));
    EventIndex(count)=size(obj.Evts_,1);
end

obj.EventLines=[obj.EventLines,reshape(EventLines,length(EventLines),1)];
obj.EventTexts=[obj.EventTexts,reshape(EventTexts,length(EventTexts),1)];
obj.EventDisplayIndex=[obj.EventDisplayIndex,reshape(EventIndex,length(EventIndex),1)];


obj.RedrawEvtsSkip=false;

end

