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
    
    for k=1:size(obj.EventDisplayIndex,1)
        for i=1:size(obj.EventDisplayIndex,2)
            if any(obj.EventDisplayIndex(k,i)==obj.SelectedEvent)
                delete(obj.EventLines(k,i));
                delete(obj.EventTexts(k,i));
                deletedInd=[deletedInd,i];
            end
        end
    end
    deletedInd=unique(deletedInd);
    EventLines(:,deletedInd)=[];
    EventTexts(:,deletedInd)=[];
    EventIndex(:,deletedInd)=[];
    
%     evts=obj.Evts_;
%     t=obj.Time;
%     dt=obj.WinLength;
%     
%     for k=1:length(obj.Axes)
%         count=0;
%         tmp=[];
%         for i=1:size(evts,1)
%             if evts{i,1}>=t && evts{i,1}<=t+dt
%                 count=count+1;
%                 tmp(count)=i;
%             end
%         end
%         if ~isempty(tmp)
%             EventIndex(k,:)=tmp;
%         end
%     end
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
                    set(obj.EventTexts(k,i),'String',newName);
                end
            end
        end 
    end
end

obj.RedrawEvtsSkip=false;
end

