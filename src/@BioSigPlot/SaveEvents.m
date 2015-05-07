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
if ~isempty(Events)
    [FileName,FilePath,FilterIndex]=uiputfile({'*.txt;*.csv;*.mat;*.evt','Event Files (*.txt;*.csv;*.mat;*.evt)';...
        '*.txt','Text File(*.txt)';
        '*.csv','Comma Separate File(*.csv)';
        '*.mat','Matlab Mat File (*.mat)';
        '*.evt','Event File (*.evt)'}...
        ,'save your Events',fullfile(obj.FileDir,'untitled'));
    if FileName~=0
        
        if FilterIndex==1
            [pathstr, name, ext] = fileparts(FileName);
            if strcmpi(ext,'.txt')
                FilterIndex=2;
            elseif strcmpi(ext,'.csv')
                FilterIndex=3;
            elseif strcmpi(ext,'.mat')
                FilterIndex=4;
            elseif strcmpi(ext,'.evt')
                FilterIndex=5;
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
                save(filename,'-struct','Events','-mat');
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
    '%The format should be as follows, {Color} and {Code} columns are not necessary for event file import:',...
    '%Time(Second),Event,Color(RGB),Code');
fclose(fid);
end
