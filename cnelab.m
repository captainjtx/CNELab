function cnelab()

cds=[];
while(1)
    tmp=CommonDataStructure.multiload();
    if ~isempty(tmp)
        cds=[cds,tmp];
    end
    
    choice=questdlg('Do you want to select more datasets?','CNELab','Yes','No','No');
    
    if strcmpi(choice,'No')
        break;
    end
end
if isempty(cds)
    return;
end

fs=cds{1}.DataInfo.SampleRate;

for i=2:length(cds)
    
    if cds{i}.DataInfo.SampleRate~=cds{i-1}.DataInfo.SampleRate
        fs=1;
        msgbox(['Sampling frequency in data set ' num2str(i-1) ' and ' num2str(i) ' is not the same!'],'run','error');
    else
        fs=cds{i}.DataInfo.SampleRate;
    end
end


% cdsmatfiles=cell(1,length(cds));
data=cell(1,length(cds));
FileNames=cell(1,length(cds));
fnames=cell(1,length(cds));
fpaths=cell(1,length(cds));

for i=1:length(cds)
    data{i}=cds{i}.Data;
    
    FileNames{i}=cds{i}.DataInfo.FileName;
    [fpaths{i},fnames{i}]=fileparts(cds{i}.DataInfo.FileName);
    
    %get the first mat file
    
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

ChanPosition=cell(1,length(cds));
for i=1:length(cds)
    if isfield(cds{i}.Montage,'ChannelPosition')&&~isempty(cds{i}.Montage.ChannelPosition)
        ChanPosition{i}=cds{i}.Montage.ChannelPosition;
    else
        ChanPosition{i}=[];
    end
end
%==========================================================================
%**************************************************************************
VideoStartTime=0;
VideoTimeFrame=[];
NumberOfFrame=[];
for i=1:length(cds)
    if ~isempty(cds{i}.DataInfo.Video.StartTime)
        VideoStartTime=cds{i}.DataInfo.Video.StartTime;
    end
    
    if ~isempty(cds{i}.DataInfo.Video.TimeFrame)
        VideoTimeFrame=cds{i}.DataInfo.Video.TimeFrame;
    end
end

for i=1:length(cds)
    if isfield(cds{i}.DataInfo.Video,'NumberOfFrame')
        NumberOfFrame=cds{i}.DataInfo.Video.NumberOfFrame;
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
    if iscell(cds{i}.DataInfo.Units)
        if length(cds{i}.DataInfo.Units)==size(cds{i}.Data,2)
            Units{i}=cds{i}.DataInfo.Units;
        end
    elseif ischar(cds{i}.DataInfo.Units)
        Units{i}=cell(1,size(cds{i}.Data,2));
        [Units{i}{:}]=deal(cds{i}.DataInfo.Units);
    end
end
%==========================================================================
%**************************************************************************
StartTime=0;
for i=1:length(cds)
    if ~isempty(cds{i}.DataInfo.TimeStamps)
        StartTime=cds{i}.DataInfo.TimeStamps(1);
        break;
    end
end
%==========================================================================
%**************************************************************************
NextFiles=cell(1,length(cds));
for i=1:length(cds)
    if isfield(cds{i}.Data,'NextFile')
        NextFiles{i}=cds{i}.DataInfo.NextFile;
    else
        NextFiles{i}=[];
    end
end
PrevFiles=cell(1,length(cds));
for i=1:length(cds)
    if isfield(cds{i}.Data,'PrevFile')
        PrevFiles{i}=cds{i}.DataInfo.PrevFile;
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
    'ChanPosition',ChanPosition,...
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
%Enumerate all files for events
% while(1)
    startTime=0;
    for i=1:length(cds)
        if ~isempty(cds{i}.DataInfo.TimeStamps)
            startTime=cds{i}.DataInfo.TimeStamps(1);
            break;
        end
    end
    evts=[];
    for i=1:length(cds)
        if ~isempty(cds{i}.DataInfo.Annotations)
            tmp_evts=cds{i}.DataInfo.Annotations;
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
            for r=1:size(cds{i}.DataInfo.TriggerCodes,1)
                center_hold_time=cds{i}.DataInfo.TriggerCodes(r,1)/fs;
                show_cue_time=cds{i}.DataInfo.TriggerCodes(r,2)/fs;
                %             fill_target_time=cds{i}.DataInfo.TriggerCodes(r,3)/fs;
                
                errorCode=cds{i}.DataInfo.TriggerCodes(r,end);
                
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
                        evts=cat(1,evts,{cds{i}.DataInfo.TriggerCodes(r,c)/fs,['0-' num2str(c)],color,2});
                    else
                        evts=cat(1,evts,{cds{i}.DataInfo.TriggerCodes(r,c)/fs,num2str(c),color,2});
                    end
                end
            end
        end
    end
    
    %check if the event is duplicated==========================================
    duplicate=[];
    
    if ~isempty(evts)
        for i=1:size(evts,1)
            t=evts{i,1};
            txt=evts{i,2};
            
            ind1=find(t==[evts{:,1}]);
            ind1(ind1<=i)=[];
            
            ind2=find(strcmpi(txt,evts(:,2)));
            ind2(ind2<=i)=[];
            
            if ~isempty(intersect(ind1,ind2))
                duplicate=cat(1,duplicate,i);
            end
            
        end
        non_dup=1:size(evts,1);
        
        non_dup(duplicate)=[];
        evts=evts(non_dup,:);
    end
% end

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
        if ~isempty(cds{i}.DataInfo.VideoName)
            videofile=[];
            if exist(cds{i}.DataInfo.VideoName,'file')==2
                videofile=cds{i}.DataInfo.VideoName;
            elseif exist(fullfile(fpaths{i},cds{i}.DataInfo.VideoName),'file')==2
                videofile=fullfile(fpaths{i},cds{i}.DataInfo.VideoName);
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

