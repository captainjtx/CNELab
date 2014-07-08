function ExportEvents(obj)
%==========================================================================
obj.Time=obj.Time;
if ~isempty(obj.Evts_)
    EventsList=sortrows(obj.Evts_,1);
else
    EventsList=[];
end
for i=1:size(obj.Evts,1)
    Events.stamp(i)=EventsList{i,1};
    Events.text{i}=EventsList{i,2};
    Events.color(i,:)=EventsList{i,3};
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