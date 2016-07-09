function LoadEvents(obj)

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


if exist([obj.FileDir,'/events'],'dir')==7
    open_dir=[obj.FileDir,'/events'];
else
    open_dir=obj.FileDir;
end
            
[FileName,FilePath,FilterIndex]=uigetfile({'*.txt;*.csv;*.mat;*.evt','Event Files (*.txt;*.csv;*.mat;*.evt)';...
    '*.txt;*csv;*.evt','Text File (*.txt;*csv;*.evt)';
    '*.mat','Matlab Mat File (*.mat)'},...
    'select your events file',...
    open_dir);
if FileName~=0
    evt=CommonDataStructure.scanEventFile(FilePath,FileName);
end
for i=1:length(evt)
    cond=cellfun(@isnan,evt{i}(:,3),'UniformOutput',true)||cellfun(@isempty,evt{i}(:,3),'UniformOutput',true);
    evt{i}(cond,:)=obj.assignEventColor(evt{i}(cond,:));
end
end