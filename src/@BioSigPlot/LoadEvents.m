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
    
    if FilterIndex==1
        [pathstr, name, ext] = fileparts(FileName);
        if strcmpi(ext,'.txt')||strcmpi(ext,'.csv')||strcmpi(ext,'.evt')
            FilterIndex=2;
        elseif strcmpi(ext,'.mat')
            FilterIndex=3;
        end
    end
    
    filename=fullfile(FilePath,FileName);
    
    switch FilterIndex
        case 2
            fileID = fopen(filename);
            C = textscan(fileID,'%s%s%s%s',...
                'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
            fclose(fileID);
            
            time=cellfun(@str2double,C{1},'UniformOutput',false);
            time=reshape(time,length(time),1);
            
            text=C{2};
            text=reshape(text,length(text),1);
            
            col=[];
            code=[];
            if length(C)>=3
                col=cellfun(@str2num,C{3},'UniformOutput',false);
                col=reshape(col,length(col),1);
            end
            if length(C)>=4
                code=cellfun(@str2double,C{4},'UniformOutput',false);
                code=reshape(code,length(code),1);
            end
            NewEventList=cat(2,time,text,col,code);
        case 3
            NewEventList=ReadEventFromMatFile(obj,filename);
        case 4
            NewEventList=ReadEventFromMatFile(obj,filename);
    end
    
    if isempty(NewEventList)
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

function NewEventList=ReadEventFromMatFile(obj,filename)
Events=load(filename,'-mat');

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
    NewEventList=[];
    return
end
end