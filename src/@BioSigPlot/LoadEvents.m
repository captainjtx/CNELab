function LoadEvents(obj)

if exist([obj.FileDir,'/events'],'dir')==7
    open_dir=[obj.FileDir,'/events'];
else
    open_dir=obj.FileDir;
end
            
[FileName,FilePath,~]=uigetfile({'*.txt;*.csv;*.mat;*.evt','Event Files (*.txt;*.csv;*.mat;*.evt)';...
    '*.txt;*csv;*.evt','Text File (*.txt;*csv;*.evt)';
    '*.mat','Matlab Mat File (*.mat)'},...
    'select your event file',...
    open_dir);
if FileName~=0
    [evt,name]=CommonDataStructure.scanEventFile(FilePath,{FileName});
end

cond=cellfun(@anyNaN,evt{1}(:,3),'UniformOutput',true)|cellfun(@isempty,evt{1}(:,3),'UniformOutput',true);
evt{1}(cond,:)=obj.assignEventColor(evt{1}(cond,:));
if ~isempty(evt{1})&&size(evt{1},2)==4
    num=length(obj.Evts__);
    obj.Evts__(num+1).name=name{1};
    obj.Evts__(num+1).event=evt{1};
    obj.EventRef=num+1;
    obj.Evts=evt{1};
    remakeEventMenu(obj);
end



end

function bool=anyNaN(input)
bool=any(isnan(input));
end