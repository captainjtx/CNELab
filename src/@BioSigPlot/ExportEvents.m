
function ExportEvents(obj)
%==========================================================================
obj.Time=obj.Time;
for i=1:size(obj.Evts,1)
    Events.stamp(i)=obj.Evts{i,1};
    Events.text{i}=obj.Evts{i,2};
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