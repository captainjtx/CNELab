function redrawEvts(obj)
if ~obj.IsInitialize
    EventLines=[];
    EventTexts=[];
    EventIndex=[];
    %Clear all the events displayed
    for i=1:size(obj.EventLines,1)*size(obj.EventLines,2)
        if ishandle(obj.EventLines(i))
            delete(obj.EventLines(i))
        end
    end
    
    for i=1:size(obj.EventTexts,1)*size(obj.EventTexts,2)
        if ishandle(obj.EventTexts(i))
            delete(obj.EventTexts(i))
        end
    end
    
    for i=1:length(obj.Axes)
        if obj.EventsDisplay
            [Elines,Etexts,Eindex]=DrawEvts(obj.Axes(i),obj.Evts,obj.Time,obj.WinLength,...
                obj.SRate,obj.EventColors{i},obj.SelectedEvent,obj.EventSelectColor);
            if ~isempty(Elines)
                EventLines(i,:)=Elines;
                EventTexts(i,:)=Etexts;
                EventIndex(i,:)=Eindex;
            end
        end
    end
    
    obj.EventLines=EventLines;
    obj.EventTexts=EventTexts;
    obj.EventDisplayIndex=EventIndex;
    
end
end

function [EventLines,EventTexts,EventIndex]=DrawEvts(axe,evts,t,dt,SRate,colors,SelectedEvent,SelectedColor)
EventLines=[];
EventTexts=[];
EventIndex=[];
yl=get(axe,'Ylim');
count=0;

for i=1:size(evts,1)
    if evts{i,1}>=t && evts{i,1}<=t+dt
        count=count+1;
        x=SRate*(evts{i,1}-t);
        EventLines(count)=line([x x],[0 1000],'parent',axe,'Color',colors(i,:));
        EventTexts(count)=text('Parent',axe,'position',[x yl(2)],'BackgroundColor',colors(i,:),'EdgeColor',colors(i,:),...
            'VerticalAlignment','Top','Margin',1,'FontSize',12,'String',evts{i,2},'Editing','off');
        EventIndex(count)=i;
    end
    
    if count
        if i==SelectedEvent
            set(EventLines(count),'Color',SelectedColor);
            set(EventTexts(count),'EdgeColor',SelectedColor,'BackgroundColor',SelectedColor);
        end
    end
end

end