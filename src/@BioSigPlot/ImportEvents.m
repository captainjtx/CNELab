function ImportEvents(obj)

if isempty(obj.Evts)
    choice='overwrite';
else
    default='overwrite';
    choice=questdlg('Do you want to overwrite or overlap the existed events?','warning',...
        'overwrite','overlap','cancel',default);
end

if strcmpi(choice,'cancel')
    return
end

[FileName,FilePath]=uigetfile({'*.mat;*.evt','Event Files (*.mat;*.evt)';...
    '*.mat','Matlab Mat File (*.mat)';
    '*.evt','Event File (*.evt)'},...
    'select your events file');
if FileName~=0
    Events=load(fullfile(FilePath,FileName),'-mat');
    
    if isfield(Events,'stamp')&&isfield(Events,'text')
        NewEventList=cell(length(Events.stamp),3);
        
        for i=1:length(Events.stamp)
            NewEventList{i,1}=Events.stamp(i);
            NewEventList{i,2}=Events.text{i};
            if ~isfield(Events,'color')
                NewEventList{i,3}=obj.EventDefaultColor;
            else
                NewEventList{i,3}=Events.color(i,:);
            end
            
            if ~isfield(Events,'code')
                NewEventList{i,4}=0;
            else
                NewEventList{i,4}=Events.code(i);
            end
        end
    end
    if iscell(NewEventList)
        if size(NewEventList,2)==4
            switch choice
                case 'overwrite'
                    obj.Evts=NewEventList;
                    obj.IsEvtsSaved=true;
                case 'overlap'
                    obj.Evts=cat(1,obj.Evts_,NewEventList);
                    obj.IsEvtsSaved=false;
                case 'cancel'
            end
        end
    end
end
end