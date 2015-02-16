function cnelab()
cds=[];
while(1)
    tmp=CommonDataStructure.multiImport();
    if ~isempty(tmp)
        cds=[cds,tmp];
    end
    
    choice=questdlg('Do you want to select more dataset?','CNELab','Yes','No','No');
    
    if strcmpi(choice,'No')
        break;
    end
end
if isempty(cds)
    return;
end

fs=cds{1}.Data.SampleRate;

for i=2:length(cds)
    
    if cds{i}.Data.SampleRate~=cds{i-1}.Data.SampleRate
        fs=1;
        msgbox(['Sampling frequency in data set ' num2str(i-1) ' and ' num2str(i) ' is not the same!'],'run','error');
    else
        fs=cds{i}.Data.SampleRate;
    end
    
end

data=cell(1,length(cds));
fnames=cell(1,length(cds));
for i=1:length(cds)
    data{i}=cds{i}.Data.Data;
    
    [pathstr,fnames{i},ext]=fileparts(cds{i}.Data.FileName);
end
[FileDir,name,ext] = fileparts(cds{1}.Data.FileName);
%==========================================================================
if isempty(fs)||(fs==0)
    fs=256;
end

%==========================================================================
%**************************************************************************
ChanNames=cell(1,length(cds));
for i=1:length(cds)
    if ~isempty(cds{i}.Montage.ChannelNames)
        ChanNames{i}=cds{i}.Montage.ChannelNames;
    else
        ChanNames{i}=[];
    end
end

GroupNames=cell(1,length(cds));
for i=1:length(cds)
    if ~isempty(cds{i}.Montage.GroupNames)
        GroupNames{i}=cds{i}.Montage.GroupNames;
    else
        GroupNames{i}=[];
    end
end
%==========================================================================
%**************************************************************************
VideoStartTime=0;
VideoTimeFrame=[];

for i=1:length(cds)
    if ~isempty(cds{i}.Data.Video.StartTime)
        VideoStartTime=cds{i}.Data.Video.StartTime;
    end
    
    if ~isempty(cds{i}.Data.Video.TimeFrame)
        VideoTimeFrame=cds{i}.Data.Video.TimeFrame;
    end
end

%VideoTimeFrame Must Contain All Frame Information
%BioSigPlot will internally interpolate uneven frame
%==========================================================================
%**************************************************************************
Units=cell(length(cds),1);
for i=1:length(cds)
    if iscell(cds{i}.Data.Units)
        if length(cds{i}.Data.Units)==size(cds{i}.Data.Data,2)
            Units{i}=cds{i}.Data.Units;
        end
    elseif ischar(cds{i}.Data.Units)
        Units{i}=cell(1,size(cds{i}.Data.Data,2));
        [Units{i}{:}]=deal(cds{i}.Data.Units);
    end
end
%==========================================================================
bsp=BioSigPlot(data,'Title',fnames,...
                    'SRate',fs,...
                    'ChanNames',ChanNames,...
                    'GroupNames',GroupNames,...
                    'VideoStartTime',VideoStartTime,...
                    'VideoTimeFrame',VideoTimeFrame,...
                    'Units',Units,...
                    'FileDir',FileDir);
set(bsp.Fig,'Visible','off');
%==========================================================================
%**************************************************************************

startTime=0;
for i=1:length(cds)
    if ~isempty(cds{i}.Data.TimeStamps)
        startTime=cds{i}.Data.TimeStamps(1);
        break;
    end
end
evts=[];
for i=1:length(cds)
    if ~isempty(cds{i}.Data.Annotations)
        evts=cat(1,evts,cds{i}.Data.Annotations);
        evts(:,1)=num2cell(cell2mat(evts(:,1))-startTime);
        code=cell(size(evts,1),1);
        [code{:}]=deal(0);
        evts=bsp.assignEventColor(evts);
        evts=cat(2,evts,code);
    else
        evts=[];
    end
    
    if isfield(cds{i}.Data,'TriggerCodes')
        for r=1:size(cds{i}.Data.TriggerCodes,1)
            center_hold_time=cds{i}.Data.TriggerCodes(r,1)/fs;
            show_cue_time=cds{i}.Data.TriggerCodes(r,2)/fs;
%             fill_target_time=cds{i}.Data.TriggerCodes(r,3)/fs;
            
            errorCode=cds{i}.Data.TriggerCodes(r,end);
            
            if ~errorCode
                color=bsp.TriggerEventDefaultColor;
            else
                color=[0.8 0 0];
            end
            
            for c=1:6
                if show_cue_time-center_hold_time<2.8%...
%                         ||fill_target_time-show_cue_time<0.8...
%                         ||fill_target_time-show_cue_time>1.7
                    color=[0.5 0.5 0.5];
                    evts=cat(1,evts,{cds{i}.Data.TriggerCodes(r,c)/fs,['0-' num2str(c)],color,2});
                else
                    evts=cat(1,evts,{cds{i}.Data.TriggerCodes(r,c)/fs,num2str(c),color,2});
                end
            end
        end
    end
end

bsp.Evts=evts;
%==========================================================================
assignin('base','bsp',bsp);
set(bsp.Fig,'Visible','on')
end

