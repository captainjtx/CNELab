function ExportEvents(obj)
%code: 0-normal 1-fast events 2-trigger events
%==========================================================================
obj.Time=obj.Time;

if isempty(obj.Evts_)
    return
end

EventsList=obj.Evts_{obj.Evts2Display,:};

if ~isempty(EventsList)
    EventsList=sortrows(EventsList,1);
else
    return
end


for i=1:size(obj.Evts,1)
    Events.stamp(i)=EventsList{i,1};
    Events.text{i}=EventsList{i,2};
    Events.color(i,:)=EventsList{i,3};
    Events.code(i)=EventsList{i,4};
end
if ~isempty(Events)
    [FileName,FilePath]=uiputfile({'*.mat;*.evt','Event Files (*.mat;*.evt)';...
        '*.mat','Matlab Mat file (*.mat)';
        '*.evt','Event File (*.evt)'}...
        ,'save your Events','untitled');
    if FileName~=0
        save(fullfile(FilePath,FileName),'-struct','Events','-mat');
        obj.IsEvtsSaved=true;
    end
end
end