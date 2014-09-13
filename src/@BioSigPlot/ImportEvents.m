function ImportEvents(obj)

if isempty(obj.Evts)
    choice='Replace';
else
    default='Replace';
    choice=questdlg('Do you want to overwrite or overlap the existed events?','warning',...
        'Replace','Append','Cancel',default);
end

if strcmpi(choice,'Cancel')
    return
end

[FileName,FilePath]=uigetfile({'*.mat;*.evt','Event Files (*.mat;*.evt)';...
    '*.mat','Matlab Mat File (*.mat)';
    '*.evt','Event File (*.evt)'},...
    'select your events file');
if FileName~=0
    Events=load(fullfile(FilePath,FileName),'-mat');
    
    if isfield(Events,'stamp')&&isfield(Events,'text')
        NewEventList=cell(length(Events.stamp),4);
        
        for i=1:length(Events.stamp)
            NewEventList{i,1}=Events.stamp(i);
            NewEventList{i,2}=Events.text{i};
            if ~isfield(Events,'color')
                NewEventList{i,3}=[0 0 0];
            else
                NewEventList{i,3}=Events.color(i,:);
            end
            
            if ~isfield(Events,'code')
                NewEventList{i,4}=0;
            else
                NewEventList{i,4}=Events.code(i);
            end
        end
        
        if ~isfield(Events,'color')
            NewEventList=obj.assignEventColor(NewEventList);
        end
    else
        return
    end
    if iscell(NewEventList)
        if size(NewEventList,2)==4
            switch choice
                case 'Replace'
                    obj.Evts=NewEventList;
                    obj.IsEvtsSaved=true;
                case 'Append'
                    obj.Evts=cat(1,obj.Evts_,NewEventList);
                    obj.IsEvtsSaved=false;
                case 'Cancel'
            end
        end
    end
end
end