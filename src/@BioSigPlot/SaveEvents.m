function SaveEvents(obj)
%code: 0-normal 1-fast events 2-trigger events
%==========================================================================
obj.Time=obj.Time;

if isempty(obj.Evts_)
    return
end

EventsList=obj.Evts_(obj.Evts2Display,:);

if ~isempty(EventsList)
    EventsList=sortrows(EventsList,1);
else
    return
end


for i=1:size(EventsList,1)
    Events.stamp(i)=EventsList{i,1};
    Events.text{i}=EventsList{i,2};
    Events.color(i,:)=EventsList{i,3};
    Events.code(i)=EventsList{i,4};
end

if exist([obj.FileDir,'/events'],'dir')==7
    open_dir=[obj.FileDir,'/events'];
else
    open_dir=obj.FileDir;
end

if ~isempty(Events)
    [FileName,FilePath,FilterIndex]=uiputfile({'*.txt;*.csv;*.mat;*.evt','Event Files (*.txt;*.csv;*.mat;*.evt)';...
        '*.evt','Event File (*.evt)';
        '*.txt','Text File(*.txt)';
        '*.csv','Comma Separate File(*.csv)';
        '*.mat','Matlab Mat File (*.mat)'}...
        ,'save your Events',fullfile(open_dir,'untitled'));
    if FileName~=0
        
        if FilterIndex==1
            [pathstr, name, ext] = fileparts(FileName);
            if strcmpi(ext,'.txt')
                FilterIndex=3;
            elseif strcmpi(ext,'.csv')
                FilterIndex=4;
            elseif strcmpi(ext,'.mat')
                FilterIndex=5;
            elseif strcmpi(ext,'.evt')
                FilterIndex=2;
            end
        end
        
        filename=fullfile(FilePath,FileName);
        
        switch FilterIndex
            case 2
                writeheader(filename);
                cell2csv(filename,EventsList,',','a');
            case 3
                writeheader(filename);
                cell2csv(filename,EventsList,',','a');
            case 4
                writeheader(filename);
                cell2csv(filename,EventsList,',','a');
            case 5
                save(filename,'-struct','Events','-mat');
        end
        obj.IsEvtsSaved=true;
    end
end
end

function writeheader(filename)

fid=fopen(filename,'w');
fprintf(fid,'%s\n%s\n%s\n%s\n','%Rows commented by % will be ignored',...
    '%File needs to be comma(,) delimited',...
    '%File format: Time(s),Event,Color(RGB),Code',...
    '%{Color} and {Code} are optional:'...
    );
fclose(fid);
end
