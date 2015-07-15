function cnelab()

cds=[];
while(1)
    tmp=CommonDataStructure.multiload();
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
FileNames=cell(1,length(cds));
fnames=cell(1,length(cds));
fpaths=cell(1,length(cds));

for i=1:length(cds)
    data{i}=cds{i}.Data.Data;
    
    FileNames{i}=cds{i}.Data.FileName;
    [fpaths{i},fnames{i}]=fileparts(cds{i}.Data.FileName);
end

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
NumberOfFrame=[];
for i=1:length(cds)
    if ~isempty(cds{i}.Data.Video.StartTime)
        VideoStartTime=cds{i}.Data.Video.StartTime;
    end
    
    if ~isempty(cds{i}.Data.Video.TimeFrame)
        VideoTimeFrame=cds{i}.Data.Video.TimeFrame;
    end
end

for i=1:length(cds)
    if isfield(cds{i}.Data.Video,'NumberOfFrame')
        NumberOfFrame=cds{i}.Data.Video.NumberOfFrame;
    end
end

if isempty(NumberOfFrame)
    if ~isempty(VideoTimeFrame)
        NumberOfFrame=max(VideoTimeFrame(:,2));
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
%**************************************************************************
StartTime=0;
for i=1:length(cds)
    if ~isempty(cds{i}.Data.TimeStamps)
        StartTime=cds{i}.Data.TimeStamps(1);
        break;
    end
end
%==========================================================================
%**************************************************************************
NextFiles=cell(1,length(cds));
for i=1:length(cds)
    if isfield(cds{i}.Data,'NextFile')
        NextFiles{i}=cds{i}.Data.NextFile;
    else
        NextFiles{i}=[];
    end
end
PrevFiles=cell(1,length(cds));
for i=1:length(cds)
    if isfield(cds{i}.Data,'PrevFile')
        PrevFiles{i}=cds{i}.Data.PrevFile;
    else
        PrevFiles{i}=[];
    end
end
%==========================================================================
%**************************************************************************        
bsp=BioSigPlot(data,'Title',fnames,...
                    'SRate',fs,...
                    'ChanNames',ChanNames,...
                    'GroupNames',GroupNames,...
                    'VideoStartTime',VideoStartTime,...
                    'VideoTimeFrame',VideoTimeFrame,...
                    'NumberOfFrame',NumberOfFrame,...
                    'Units',Units,...
                    'FileNames',FileNames,...
                    'StartTime',StartTime,...
                    'NextFiles',NextFiles,...
                    'PrevFiles',PrevFiles);
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
        tmp_evts=cds{i}.Data.Annotations;
        tmp_evts(:,1)=num2cell(cell2mat(tmp_evts(:,1))-startTime);
        code=cell(size(tmp_evts,1),1);
        [code{:}]=deal(0);
        tmp_evts=bsp.assignEventColor(tmp_evts);
        tmp_evts=cat(2,tmp_evts,code);
    else
        tmp_evts=[];
    end
    evts=cat(1,evts,tmp_evts);
    
    if isfield(cds{i}.Data,'TriggerCodes')
        for r=1:size(cds{i}.Data.TriggerCodes,1)
            center_hold_time=cds{i}.Data.TriggerCodes(r,1)/fs;
            show_cue_time=cds{i}.Data.TriggerCodes(r,2)/fs;
%             fill_target_time=cds{i}.Data.TriggerCodes(r,3)/fs;
            
            errorCode=cds{i}.Data.TriggerCodes(r,end);
            
            if ~errorCode
                color=bsp.AdvanceEventDefaultColor;
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
    
%check if the event is duplicated==========================================
if ~isempty(evts)
    [tmp,itime,ic]=unique([evts{:,1}]);
    [tmp,itxt,ic]=unique(evts(:,2));
    imerge=unique(cat(1,itime,itxt));
    evts=evts(imerge,:);
end
bsp.Evts=evts;
%scan for montage file folder==============================================
montage=cell(length(fnames),1);
if length(fnames)==1
    if isdir(fullfile(fpaths{1},'montage'))
        montage{1}=CommonDataStructure.scanMontageFile(bsp.ChanNames,fullfile(fpaths{1},'montage'));
    end
else
    for i=1:length(fnames)
        if isdir(fullfile(fpaths{i},'montage',fnames{i}))
            montage{i}=CommonDataStructure.scanMontageFile(bsp.ChanNames,fullfile(fpaths{i},'montage',fnames{i}));
        end
    end
end

for i=1:length(fnames)
    for j=1:length(montage{i})
        num=length(bsp.Montage{i});
        bsp.Montage_{i}(num+1).name=montage{i}{j}.name;
        bsp.Montage_{i}(num+1).channames=montage{i}{j}.channames;
        bsp.Montage_{i}(num+1).mat=montage{i}{j}.mat;
        bsp.Montage_{i}(num+1).groupnames=montage{i}{j}.groupnames;
    end
end
remakeMontageMenu(bsp);
%scan for video============================================================
%check if this is a right system 
%video feature is only supported in windows system as activex is required
%currently only one video is supported
if ~isempty(regexp(computer,'WIN','ONCE'))
    for i=1:length(cds)
        if ~isempty(cds{i}.Data.VideoName)
            videofile=[];
           if exist(cds{i}.Data.VideoName,'file')==2
               videofile=cds{i}.Data.VideoName;
           elseif exist(fullfile(fpaths{i},cds{i}.Data.VideoName),'file')==2
               videofile=fullfile(fpaths{i},cds{i}.Data.VideoName);
           end
           if ~isempty(videofile)
               bsp.WinVideo=VideoWindow(videofile,bsp.VideoActxOpt); %VLC or WMPlayer
               addlistener(bsp.WinVideo,'VideoChangeTime',@(src,evt) SynchDataWithVideo(bsp));
               addlistener(bsp.WinVideo,'VideoChangeState',@(src,ect) SynchVideoState(bsp));
               addlistener(bsp.WinVideo,'VideoClosed',@(src,evt) StopPlay(bsp));
               
               bsp.VideoFile=videofile;
               break;
           end
        end
    end
end
%put mask==================================================================
for i=1:length(cds)
    if isfield(cds{i}.Montage,'MaskChanNames')&&~isempty(cds{i}.Montage.MaskChanNames)
        bsp.Mask{i}=~ismember(ChanNames{i},cds{i}.Montage.MaskChanNames);
    end
end
%==========================================================================
assignin('base','bsp',bsp);
set(bsp.Fig,'Visible','on')
end

