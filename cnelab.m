function cnelab()
cnelab_path=which('cnelab','-all');

if iscell(cnelab_path)&&length(cnelab_path)>1
    errordlg(['Multiple CNELAB found: ',[cnelab_path{:}]]);
    return
end

%CNELAB launcher, %inspired by xcode
cnb=CnelabWindow;
cnb.buildfig;
addlistener(cnb,'UserChoice',@(src,evts)cnelab_init(cnb));
end

function cnelab_init(cnb)
%Some additional default settings, will be migrated in to configuration
%file in the future release

buffer_size=300; % in megabytes, if you want to load the entire data, set it to inf
%entire data loading can enable more advanced analysis tools

visual_buffer_size=2; % in megabytes
%**************************************************************************
cds=[];

switch cnb.choice
    case 1
        %new data
        cds=CommonDataStructure.multiload();
    case 2
        %select data
        cds=CommonDataStructure.multiload(cnb.selectedFiles);
end
if isempty(cds)
    return;
end
%**************************************************************************
screensize = get(0,'ScreenSize');

info_h = dialog('Position',[screensize(3)/2-100 screensize(4)/2-50 220 150],'Name','Preparing ...');

[cnelab_path,~,~]=fileparts(mfilename('fullpath'));
logo_icon=javaObjectEDT(javax.swing.ImageIcon([cnelab_path,filesep,'db',filesep,'icon',filesep,'cnel.png']));
logo_label=javaObjectEDT(javax.swing.JLabel());
logo_label.setIcon(logo_icon);
logo_label.setHorizontalAlignment(javax.swing.JLabel.CENTER);
logo_label.setOpaque(false);
[jh,gh]=javacomponent(logo_label,[0,0,1,1],info_h);
set(gh,'Units','Norm','Position',[0.1,0.3,0.8,0.7]);

info_label=javaObjectEDT(javax.swing.JLabel());
info_label.setText('Creating MatFile 7.4 IO ...');
info_label.setHorizontalAlignment(javax.swing.JLabel.CENTER);
info_label.setForeground(java.awt.Color(0.6431,0.0745,0.149));
info_label.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, 15));
info_label.setOpaque(false);

[jh,gh]=javacomponent(info_label,[0,0,1,1],info_h);
set(gh,'Units','Norm','Position',[0,0,1,0.3]);

drawnow
%**************************************************************************
%if there is non-cds files loaded, set the buffer to inf
for i=1:length(cds)
    if cds{i}.file_type~=2
        buffer_size=inf;
    end
end
%**************************************************************************
fileinfo=cell(length(cds),1);
for i=1:length(cds)
    %this can be expensive
    fileinfo{i}=cds{i}.get_file_info(cds{i});
end

fs=fileinfo{1}.fs;

%The buffer length in samples
%If two dataset is retrieved at the sample time, the buffer needed will be
%doubled. If future test demonstrate that dynamic buffer had a low cost,
%automatic memory control might be implemented instead.
buffer_len=zeros(length(cds),1);
for i=1:length(cds)
    chan_num=length(cds{i}.Data(1,:));
    buffer_len(i)=min(round(buffer_size*1000*1000/8/chan_num/fs),fileinfo{i}.filesample(end,2)/fs);
end
buffer_len=min(buffer_len);

BufferTime=0;
%**************************************************************************
if ishandle(info_h)
    info_label.setText('Loading data ...');
    drawnow
end
% cdsmatfiles=cell(1,length(cds));
data=cell(1,length(cds));
FileNames=cell(1,length(cds));
fnames=cell(1,length(cds));
fpaths=cell(1,length(cds));
evts=cell(1,length(cds));

for i=1:length(cds)
    filenames=fileinfo{i}.filenames;
    filesample=fileinfo{i}.filesample;
    evts{i}=fileinfo{i}.events;
    %To be saved permanently into the files in future release
    cds{i}.DataInfo.AllFiles=filenames;
    cds{i}.DataInfo.FileSample=filesample;
    cds{i}.DataInfo.AllEvents=evts{i};
    % In future, automatic direct to a saved position might be possible
    data{i}=cds{i}.get_data_by_start_end(cds{i},1,min(round((BufferTime+buffer_len)*fs+1),filesample(end,2)));
    %     data{i}=cds{i}.Data;
    
    FileNames{i}=cds{i}.DataInfo.FileName;
    [fpaths{i},fnames{i}]=fileparts(cds{i}.DataInfo.FileName);
    %get the first mat file
end
if isempty(fs)||(fs==0)
    fs=256;
end
%**************************************************************************
ChanNames=cell(1,length(cds));
for i=1:length(cds)
    ChanNames{i}=fileinfo{i}.channelnames;
end

GroupNames=cell(1,length(cds));
for i=1:length(cds)
    GroupNames{i}=fileinfo{i}.groupnames;
end

ChanPosition=cell(1,length(cds));
for i=1:length(cds)
    ChanPosition{i}=fileinfo{i}.channelposition;
end
%**************************************************************************
VideoStartTime=0;
VideoTimeFrame=[];
NumberOfFrame=[];
for i=1:length(cds)
    if ~isempty(fileinfo{i}.video.StartTime)
        VideoStartTime=fileinfo{i}.video.StartTime;
    end
    
    if ~isempty(fileinfo{i}.video.TimeFrame)
        VideoTimeFrame=fileinfo{i}.video.TimeFrame;
    end
    if ~isempty(fileinfo{i}.video.NumberOfFrame)
        NumberOfFrame=fileinfo{i}.video.NumberOfFrame;
    end
end

if isempty(NumberOfFrame)
    if ~isempty(VideoTimeFrame)
        NumberOfFrame=max(VideoTimeFrame(:,2));
    end
end

%VideoTimeFrame Must Contain All Frame Information
%BioSigPlot will internally interpolate uneven frame
%**************************************************************************
Units=cell(length(cds),1);
for i=1:length(fileinfo)
    if iscell(fileinfo{i}.units)
        if length(fileinfo{i}.units)==size(data{i},2)
            Units{i}=fileinfo{i}.units;
        end
    elseif ischar(fileinfo{i}.units)
        Units{i}=cell(1,size(data{i},2));
        [Units{i}{:}]=deal(fileinfo{i}.units);
    end
end
%**************************************************************************
%StartTime will always be zero in the future, means, annotation time and
%all other time should be consistent with the data. Data always start at
%zero in CNELAB
StartTime=0;
%extral things need to be prepared for misaligned starting time between two
%datasets.
%**************************************************************************
try
    close(info_h)
catch
end
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
    'BufferLength',buffer_len,...
    'TotalSample',filesample(end,2),...
    'BufferTime',BufferTime,...
    'CDS',cds,...
    'VisualBuffer',visual_buffer_size);
%**************************************************************************
uncertainty_code={'hold','cue','go','exit','hit','end'};
Event={};
for i=1:length(cds)
    if ~isempty(evts{i})
        code=cell(size(evts{i},1),1);
        [code{:}]=deal(0);
        evts{i}=bsp.assignEventColor(evts{i});
        evts{i}=cat(2,evts{i},code);
    end
    Event=cat(1,Event,evts{i});
    % TriggerCode compatibility for special use
    if isfield(cds{i}.DataInfo,'TriggerCodes')
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
            
            if ~errorCode
                for c=1:6
                    if show_cue_time-center_hold_time<2.8%...
                        %                         ||fill_target_time-show_cue_time<0.8...
                        %                         ||fill_target_time-show_cue_time>1.7
                        color=[0.5 0.5 0.5];
                        Event=cat(1,Event,{cds{i}.DataInfo.TriggerCodes(r,c)/fs,['0-' num2str(c)],color,2});
                    else
                        Event=cat(1,Event,{cds{i}.DataInfo.TriggerCodes(r,c)/fs,uncertainty_code{c},color,2});
                    end
                end
            end
        end
    end
end

%check if the event is duplicated==========================================
duplicate=[];

if ~isempty(Event)
    for i=1:size(Event,1)
        t=Event{i,1};
        txt=Event{i,2};
        
        ind1=find(t==[Event{:,1}]);
        ind1(ind1<=i)=[];
        
        ind2=find(strcmpi(txt,Event(:,2)));
        ind2(ind2<=i)=[];
        
        if ~isempty(intersect(ind1,ind2))
            duplicate=cat(1,duplicate,i);
        end
        
    end
    non_dup=1:size(Event,1);
    
    non_dup(duplicate)=[];
    Event=Event(non_dup,:);
end
bsp.Evts__(1).name='Original';
bsp.Evts=Event;
bsp.EventsWindowDisplay=true;
%scan for montage file folder==============================================
montage=cell(length(fnames),1);
for i=1:length(fnames)
    if isdir(fullfile(fpaths{i},'montage'))
        montage{i}=CommonDataStructure.scanMontageFile(bsp.ChanNames{i},fullfile(fpaths{i},'montage'));
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
%scan for event file fiolder===============================================
events={};
if isdir(fullfile(fpaths{1},'events'))
    [evts,names]=CommonDataStructure.scanEventFile(fullfile(fpaths{1},'events'));
    for i=1:length(evts)
        events(i).name=names{i};
        events(i).event=bsp.assignEventColor(evts{i});
    end
end
if ~isempty(events)
bsp.Evts__=cat(1,bsp.Evts__,events(:));
remakeEventMenu(bsp);
end
%scan for video============================================================
%check if this is a right system
%video feature is only supported in windows system as activex is required
%currently only one video is supported
if ~isempty(regexp(computer,'WIN','ONCE'))
    for i=1:length(cds)
        if ~isempty(fileinfo{i}.video.FileName)
            videofile=[];
            if exist(fileinfo{i}.video.FileName,'file')==2
                videofile=fileinfo{i}.video.FileName;
            elseif exist(fullfile(fpaths{i},fileinfo{i}.video.FileName),'file')==2
                videofile=fullfile(fpaths{i},fileinfo{i}.video.FileName);
            end
            if ~isempty(videofile)
                bsp.WinVideo=VideoWindow(videofile); %VLC or WMPlayer
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
    if ~isempty(fileinfo{i}.masknames)
        bsp.Mask{i}=~ismember(ChanNames{i},fileinfo{i}.masknames);
    else
        bsp.Mask{i}=ones(length(ChanNames{i}),1);
    end
end
%==========================================================================
assignin('base','bsp',bsp);
enableDisableFig(bsp.Fig,true);
%**************************************************************************
for i=1:length(cnb.cfg.files)
    if isequal(cnb.cfg.files{i},FileNames)
        cnb.cfg.files(i)=[];
        break;
    end
end
cnb.cfg.files=[{FileNames},cnb.cfg.files];
cnb.cfg.files=cnb.cfg.files(1:min(9,length(cnb.cfg.files)));
cnb.saveConfig();

% license('inuse');
end