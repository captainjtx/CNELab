function modifySelectedEvent(obj,opt)

obj.RedrawEvtsSkip=true;

if isempty(obj.SelectedEvent)
    return
end

if nargin<2
    opt='delete';
end

if strcmpi(opt,'delete')
    if ~isempty(obj.Evts)
        obj.Evts_(obj.SelectedEvent,:)=[];
    end
    EventIndex=obj.EventDisplayIndex;
    EventTexts=obj.EventTexts;
    EventLines=obj.EventLines;
    
    deletedInd=[];
    
    for i=1:length(obj.SelectedEvent)
        del=find(obj.EventDisplayIndex(1,:)==obj.SelectedEvent(i));
        if ~isempty(del)
            delete(obj.EventLines(:,del));
            delete(obj.EventTexts(:,del));
            deletedInd=[deletedInd,del];
            %decrease the index of displayed event after deletion
            for col=1:size(EventIndex,2)
                if EventIndex(1,col)>obj.SelectedEvent(i)
                    EventIndex(:,col)=EventIndex(:,col)-1;
                end
            end
        end
    end
    deletedInd=unique(deletedInd);
    EventLines(:,deletedInd)=[];
    EventTexts(:,deletedInd)=[];
    EventIndex(:,deletedInd)=[];
    

    obj.EventLines=EventLines;
    obj.EventTexts=EventTexts;
    obj.EventDisplayIndex=EventIndex;
    
    obj.SelectedEvent=[];
    
elseif strcmpi(opt,'rename')
    newName=inputdlg('Rename ','Event: ',1,{'Text'});
    if ~isempty(newName)
        newName=newName{1};
        
        if ~isempty(obj.Evts)
            for i=1:length(obj.SelectedEvent)
                obj.Evts_{obj.SelectedEvent(i),2}=newName;
            end
        end
        
        for k=1:size(obj.EventDisplayIndex,1)
            for i=1:size(obj.EventDisplayIndex,2)
                if any(obj.EventDisplayIndex(k,i)==obj.SelectedEvent)
                    set(obj.EventTexts(k,i),'String',[' ' newName]);
                end
            end
        end 
    end
end

obj.RedrawEvtsSkip=false;
end

