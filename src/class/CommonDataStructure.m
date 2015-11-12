classdef CommonDataStructure < handle
    %The class definition for common data structure used in CNEL
    %By Tianxiao Jiang
    %jtxinnocence@gmail.com
    %06/03/2014
    
    properties (Access=public)
        
        DataInfo
        Montage
        PatientInfo
        
        MatFile
    end
    
    properties (Dependent)
        %Data will be either stored dat or a reference to a matfile
        Data
        
        %alias for the elements of common data structures
        fs  %DataInfo.SampleRate
        vtf %DataInfo.Video.TimeFrame
        nextf%DataInfo.NextFile
        prevf%DataInfo.PrevFile
        file%DataInfo.FileName
        evt %DataInfo.Annotations
        
        all_evts
        all_files
        start_file
        file_time
    end
    
    properties  (Access=protected)
        %buffer_size is for cnelab visualization and preprocessing
        buffer_size
        %file_size is to automatically split storing the file
        %if empty, all files chained together will be merged and saved to a
        %single mat file.
        file_size %in mega bytes
        %dat is for other file type compatibility
        dat
        
        save_as_single % default single, otherwise save as loaded precision
    end
    
    methods
        function obj=set.Data(obj,val)
            if ~isempty(obj.MatFile)
                obj.MatFile.Data=val; 
            else
                obj.dat=val;
            end
        end
        function val=get.Data(obj)
            if ~isempty(obj.MatFile)
                val=obj.MatFile.Data;
            else
                val=obj.dat;
            end
        end
        
        function obj = set.fs(obj,val), obj.DataInfo.SampleRate=val; end
        function val = get.fs(obj),     val=obj.DataInfo.SampleRate; end
        
        function obj = set.vtf(obj,val), obj.DataInfo.Video.TimeFrame=val; end
        function val = get.vtf(obj),     val=obj.DataInfo.Video.TimeFrame; end
        
        function obj = set.nextf(obj,val), obj.DataInfo.NextFile=val; end
        function val = get.nextf(obj),     val=obj.DataInfo.NextFile; end
        
        function obj = set.prevf(obj,val), obj.DataInfo.PrevFile=val; end
        function val = get.prevf(obj),     val=obj.DataInfo.PrevFile; end
        
        function obj = set.evt(obj,val), obj.DataInfo.Annotations=val; end
        function val = get.evt(obj),       val=obj.DataInfo.Annotations; end
        
        function obj = set.file(obj,val), obj.DataInfo.FileName=val; end
        function val = get.file(obj),     val=obj.DataInfo.FileName; end
        function val=get.all_evts(obj),   [~,~,~,val]=CommonDataStructure.get_file_info(obj); end
        
        function val=get.all_files(obj),  [val,~,~,~]=CommonDataStructure.get_file_info(obj); end
        
        function val=get.start_file(obj), val=CommonDataStructure.get_start_file(obj); end
        
        function val=get.file_time(obj), [~,~,val,~]=CommonDataStructure.get_file_info(obj); end
    end
    
    methods
        function obj=CommonDataStructure(varargin)
            if nargin==0
                cds=CommonDataStructure.initial();
                
                obj.DataInfo=cds.DataInfo;
                obj.Montage=cds.Montage;
                obj.PatientInfo=cds.PatientInfo;
            else
                d=varargin{1};
                obj.copy(d);
            end
            obj.save_as_single=true;
        end
        
        function delete(obj)
            if ishandle(obj)
                delete(obj);
            end
        end
        
        function copy(obj,s)
            %s can either be a matfile object or a struct
            if isfield(s,'Data')
                obj.Data=s.Data;
            end
            
            if isfield(s,'Montage')||any(strcmpi('Montage',who(s)))
                obj.Montage=s.Montage;
            end
            
            if isfield(s,'PatientInfo')||any(strcmpi('PatientInfo',who(s)))
                obj.PatientInfo=s.PatientInfo;
            end
            if isfield(s,'DataInfo')||any(strcmpi('DataInfo',who(s)))
                obj.DataInfo=s.DataInfo;
            end
        end
        
        function y=load(obj,varargin)
            y=0;
            if nargin==2
                filename=varargin{1};
                FilterIndex=CommonDataStructure.dataStructureCheck(filename);
            else
                [FileName,FilePath,FilterIndex]=uigetfile({...
                    '*.mat;*.cds;*.cds.old;*.medf;*.fif;*.edf',...
                    'Supported formats (*.mat;*.cds;*.cds.old;*.medf;*.fif;*.edf)';...
                    '*.cds','common data structure (*.cds)';...
                    '*.ocds','old common data structure (*.ocds)';...
                    '*.medf','matlab edf format (*.medf)';...
                    '*.fif','NeuroMag MEG format (*.fif)';...
                    '*.edf','Europeon Data Format (*.edf)'},...
                    'Select your data file','DataInfo.mat');
                
                if ~FileName
                    return
                else
                    y=1;
                end
                
                filename=fullfile(FilePath,FileName);
            end
            
            if exist(filename,'file')~=2
                y=[];
                return
            end
            
            if FilterIndex==1
                FilterIndex=CommonDataStructure.dataStructureCheck(filename);
            end
            
            switch FilterIndex
                case 0
                    obj.MatFile=[];
                    obj.copy(CommonDataStructure.readFromMAT(filename));
                case 2
                    
                    obj.MatFile=matfile(filename,'Writable',true);
                    obj.copy(CommonDataStructure.readFromCDS(filename));
                case 3
                    obj.MatFile=[];
                    obj.copy(CommonDataStructure.readFromOldCDS(filename));
                    
                case 4
                    obj.MatFile=[];
                    obj.copy(CommonDataStructure.readFromMEDF(filename));
                case 5
                    obj.MatFile=[];
                    obj.copy(CommonDataStructure.readFromFIF(filename));
                case 6
                    obj.MatFile=[];
                    obj.copy(CommonDataStructure.readFromEDF(filename));
                    
            end
            obj.DataInfo.FileName=filename;
            if ~isempty(obj.MatFile)
                obj.MatFile.DataInfo=obj.DataInfo;
            end
        end
        
        function export2workspace(obj,varname)
            assignin('base',varname,obj);
        end
        
        function save(obj,varargin)
            
            save_all=false;
            
            title=[];
            fnames=[];
            if isempty(varargin)
            elseif length(varargin)==1
                fnames=varargin{1};
            else
                for i=1:2:length(varargin)
                    if strcmpi(varargin{i},'FileName')
                        fnames=varargin{i+1};
                    elseif strcmpi(varargin{i},'Title')
                        title=varargin{i+1};
                    elseif strcmpi(varargin{i},'FileSize')
                        obj.file_size=varargin{i+1};
                    elseif strcmpi(varargin{i},'All')
                        save_all=varargin{i+1};
                    else
                        msgbox('Invalid argument-value pair!','CommonDataStructure.save','error');
                        return
                    end
                end
            end
            
            if isempty(title)
                title='Save your common data structure';
            end
            if isempty(fnames)
                [FileName,FilePath]=uiputfile({...
                    '*.cds;*.mat','Common Data Structure Formats (*.cds;*.mat)';...
                    '*.mat','Matlab Mat File (*.mat)';
                    '*.cds','Common Data Structure Fromat (*.cds)'}...
                    ,title,obj.DataInfo.FileName);
                
                if ~FileName
                    return
                end
                
                fnames=fullfile(FilePath,FileName);
            end
            
            wait_bar_h = waitbar(0,'Saving data');
            
            if save_all
                [filenames,pathstr,filetime,evts]=obj.get_file_info(obj);
                if isempty(obj.file_size)
                    %might have problem if a single cds file is too large to fit
                    %into the memory
                    for i=1:length(filenames)
                        [tmp_pathstr, tmp_name, tmp_ext] = fileparts(fnames);
                        
                        cds=CommonDataStructure.initial();
                        tmp=CommonDataStructure.Load(fullfile(pathstr,filenames{i}));
                        
                        cds.DataInfo=tmp.DataInfo;
                        cds.Montage=tmp.Montage;
                        cds.PatientInfo=tmp.PatientInfo;
                        cds.MatFile=[];
                        
                        cds.DataInfo.NextFile=[tmp_name,'_',num2str(i+1),tmp_ext];
                        cds.DataInfo.PrevFile=[tmp_name,'_',num2str(i-1),tmp_ext];
                        cds.DataInfo.FileName=fullfile(tmp_pathstr,[tmp_name,'_',num2str(i),tmp_ext]);
                        
                        if i==1
                            cds.DataInfo.PrevFile=[];
                        end
                        
                        if i==length(filenames)
                            cds.DataInfo.NextFile=[];
                        end
                        
                        if obj.save_as_single
                            cds.Data=single(tmp.Data);
                        else
                            cds.Data=tmp.Data;
                        end
                        
                        
                        save([fullfile(tmp_pathstr,[tmp_name,'_',num2str(i)]),tmp_ext],'-struct','cds','-mat','-v7.3');
                        waitbar(i/length(filenames));
                    end
                else
                    
                end
            else
                if isempty(obj.file_size)
                    %might have problem if a single cds file is too large to fit
                    %into the memory
                    cds=CommonDataStructure.initial();
                    cds.DataInfo=obj.DataInfo;
                    cds.Montage=obj.Montage;
                    cds.PatientInfo=obj.PatientInfo;
                    cds.MatFile=[];
                    if obj.save_as_single
                        cds.Data=single(obj.Data);
                    else
                        cds.Data=obj.Data;
                    end
                    save(fnames,'-struct','cds','-mat','-v7.3');
                else
                    %automatic split or merge files when saving using specified
                    %file_size in megabytes
                    
                end
            end
            close(wait_bar_h);
        end
        
        function success=extractTimeFrameFromData(obj,varargin)
            success=false;
            
            if isempty(obj.DataInfo.SampleRate)
                error('Sample rate missing!');
            end
            if nargin==1
                %try to automatically detect the videochannel
                videoChannel=[];
                for i=1:size(obj.DataInfo.Data,2)
                    [frame,ind]=unique(obj.DataInfo.Data(:,i));
                    nv=frame<1;
                    frame(nv)=[];
                    
                    if sum(diff(frame)==1)>(0.5*length(frame))
                        videoChannel=i;
                        break
                    end
                end
                
                if isempty(videoChannel)
                    error('Can not find the timeframe channel for video!');
                end
            else
                videoChannel=varargin{1};
            end
            
            if ischar(videoChannel)
                videoChannel=find(ismember(obj.Montage.ChannelNames,videoChannel));
            end
            
            if ~isempty(videoChannel)
                
                %find the recording segments
                frames=obj.DataInfo.Data(:,videoChannel);
                
                %eliminate the zeros due to UDP
                ind=find(frames>=1);
                frames=frames(ind);
                
                [tmp,I]=max(frames);
                
                frames=frames(1:I);
                ind=ind(1:I);
                
                dframe=find(abs(diff(frames))>5);
                
                if ~isempty(dframe)
                    frames=frames(max(dframe)+1:end);
                    ind=ind(max(dframe)+1:end);
                end
                %eliminate duplicated frames
                [frames,newind]=unique(frames);
                ind=ind(newind);
                
                time=ind/obj.DataInfo.SampleRate;
                obj.DataInfo.Video.TimeFrame=cat(2,reshape(time,length(time),1),reshape(frames,length(frames),1));
                obj.DataInfo.Video.StartTime=0;
                
                figure('Name',['Extracted Time-Frame Plot on Channel ',num2str(videoChannel)]);
                plot(time,frames);
                xlabel('Time(S)');
                ylabel('Frame Number');
                success=true;
            end
        end
        
        function cds=extractSegment(obj,start_ind,len)
            
            
            
        end
        
        
    end
    methods (Static=true)
        function FilterIndex=dataStructureCheck(filename)
            [pathstr, name, ext] = fileparts(filename);
            if strcmpi(ext,'.cds')
                FilterIndex=2;
                return
            elseif strcmpi(ext,'.ocds')
                FilterIndex=3;
                return
            elseif strcmpi(ext,'.medf')
                FilterIndex=4;
                return
            elseif strcmpi(ext,'.fif')
                FilterIndex=5;
                return
            elseif strcmpi(ext,'.edf')
                FilterIndex=6;
            elseif strcmpi(ext,'.mat')
                
                s=load(filename,'-mat');
                field=fieldnames(s);
                
                if isfield(s,'data')
                    %check if it is medf file
                    if isfield(s.data,'dataMat')&&isfield(s.data,'info')
                        FilterIndex=4;
                        return
                        
                        %check if it is old cds file
                    elseif isfield(s.data,'data')
                        FilterIndex=3;
                        return
                    end
                end
                
                %check if it is cds file
                if isfield(s,'Data')&&isfield(s,'Montage')&&isfield(s,'PatientInfo')
                    FilterIndex=2;
                    return
                end
                
                %check if it is raw data file
                if length(field)>1
                    msgbox('The file contain more than one field, try to load the first one...','CommonDataStructure','warn');
                end
                if ismatrix(s.(field{1}))
                    FilterIndex=0;
                    return
                end
            end
        end
        
        function s=initial()
            %Auto generate an empty cds structure
            %Refer to /doc/manual for more information on the data
            %structure
            s.MatFile=[];
            s.Data=[];
            s.buffer_size=[];
            s.file_size=[];% in megabytes
            s.save_as_single=true;
            %obj.Data construction
            s.DataInfo.Annotations=[];
            s.DataInfo.Artifact=[];
            s.DataInfo.TimeStamps=[];
            s.DataInfo.Units=[];
            s.DataInfo.Video.StartTime=[];
            s.DataInfo.Video.TimeFrame=[];
            s.DataInfo.Video.NumberOfFrame=[];
            s.DataInfo.PreFilter='';
            s.DataInfo.DownSample=[];
            s.DataInfo.SampleRate=[];
            s.DataInfo.FileName=[];
            s.DataInfo.VideoName=[];
            s.DataInfo.NextFile=[];
            s.DataInfo.PrevFile=[];
            
            %obj.Montage construction
            s.Montage.ChannelNames=[];
            s.Montage.GroupNames=[];
            s.Montage.SystemNames=[];
            s.Montage.HeadboxType=[];
            s.Montage.Amplifier=[];
            s.Montage.Name=[];
            s.Montage.Notes=[];
            s.Montage.MaskChanNames=[];
            s.Montage.ElectrodeID=[];
            s.Montage.ChannelPosition=[];
            
            %obj.PatientInfo construction
            s.PatientInfo.Case=[];
            s.PatientInfo.Experiment=[];
            s.PatientInfo.Index=[];
            s.PatientInfo.Side=[];
            s.PatientInfo.Study=[];
            s.PatientInfo.Task=[];
            s.PatientInfo.Time=[];
            s.PatientInfo.Location=[];
        end
        function s=readFromCDS(filename)
            s=matfile(filename,'Writable',true);
            if ~any(strcmpi('DataInfo',who(s)))&&any(strcmpi('Data',who(s)))
                dat=s.Data;
                %obsolete format Data.Data
                %get Data.Data outside
                s.DataInfo=rmfield(dat,'Data');
                s.Data=dat.Data;
            end
        end
        
        function s=readFromMEDF(filename)
            medf=load(filename,'-mat');
            s=CommonDataStructure.initial();
            
            if isfield(medf,'data')
                if isfield(medf.data,'dataMat')
                    for i=1:length(medf.data.dataMat)
                        try
                            s.Data(:,i)=reshape(medf.data.dataMat{i},...
                                length(medf.data.dataMat{i}),1);
                        catch exception
                            
                            if i>1
                                if length(medf.data.dataMat{i-1})~=...
                                        length(medf.data.dataMat{i})
                                    
                                    msgbox('The length of data in medf file is not consistent !','CommonDataStructure','warn');
                                    continue
                                else
                                    rethrow(exception);
                                end
                            else
                                rethrow(exception);
                            end
                        end
                    end
                end
                
                if isfield(medf.data,'info')
                    if isfield(medf.data.info{1},'sampleRate')
                        s.DataInfo.SampleRate=medf.data.info{1}.sampleRate;
                    end
                    
                    for i=1:length(medf.data.info)
                        if isfield(medf.data.info{i},'unit')
                            s.DataInfo.Units{i}=medf.data.info{i}.unit;
                        end
                    end
                    
                    if isfield(medf.data.info{1},'stamp')
                        s.DataInfo.TimeStamps=medf.data.info{1}.stamp;
                    end
                    
                    for i=1:length(medf.data.info)
                        if isfield(medf.data.info{i},'name')
                            s.Montage.ChannelNames{i}=medf.data.info{i}.name;
                        end
                    end
                end
            end
            
            if isfield(medf,'info')
                if isfield(medf.info,'studyName')
                    s.PatientInfo.Task=medf.info.studyName;
                end
                
                if isfield(medf.info,'location')
                    s.PatientInfo.Location=medf.info.location;
                end
                
                if isfield(medf.info,'device')
                    s.Montage.Amplifier=medf.info.device;
                end
                
                if isfield(medf.info,'video')
                    if isfield(medf.info.video,'startTime')
                        s.DataInfo.Video.StartTime=medf.info.video.startTime;
                    end
                    if isfield(medf.info.video,'timeFrame')
                        s.DataInfo.Video.TimeFrame=medf.info.video.timeFrame;
                    end
                end
            end
        end
        function s=readFromOldCDS(filename)
            oldcds=load(filename,'-mat');
            s=CommonDataStructure.initial();
            
            %obj.data construction
            if isfield(oldcds,'data')
                if isfield(oldcds.data,'data')
                    s.Data=oldcds.Data.data;
                end
                if isfield(oldcds.data,'annotations')
                    s.DataInfo.Annotations=oldcds.Data.annotations;
                end
                if isfield(oldcds.data,'artifact')
                    s.DataInfo.Artifact=oldcds.Data.artifact;
                end
                if isfield(oldcds.data,'timestamps')
                    s.DataInfo.TimeStamps=oldcds.Data.timestamps;
                end
                
                if isfield(oldcds.data,'triggerCodes')
                    s.DataInfo.TriggerCodes=oldcds.Data.triggerCodes;
                end
            end
            
            %obj.Montage construction
            if isfield(oldcds,'montage')
                if isfield(oldcds.montage,'ChannelNames')
                    s.Montage.ChannelNames=oldcds.montage.ChannelNames;
                end
                if isfield(oldcds.montage,'GroupNames')
                    s.Montage.GroupNames=oldcds.montage.GroupNames;
                end
                if isfield(oldcds.montage,'HeadboxType')
                    s.Montage.HeadboxType=oldcds.montage.HeadboxType;
                end
                if isfield(oldcds.montage,'Amplifier')
                    s.Montage.Amplifier=oldcds.montage.Amplifier;
                end
                if isfield(oldcds.montage,'Name')
                    s.Montage.Name=oldcds.montage.Name;
                end
                if isfield(oldcds.montage,'Notes')
                    s.Montage.Notes=oldcds.montage.Notes;
                end
                
                if isfield(oldcds.montage,'SampleRate')
                    s.DataInfo.SampleRate=oldcds.montage.SampleRate;
                    s.DataInfo.TimeStamps=s.DataInfo.TimeStamps/s.DataInfo.SampleRate;
                    evts=s.DataInfo.Annotations;
                    evts(:,1)=num2cell(cell2mat(evts(:,1))/s.DataInfo.SampleRate);
                    s.DataInfo.Annotations=evts;
                end
            end
            %obj.PatientInfo construction
            
            if isfield(oldcds,'patientInfo')
                
                if isfield(oldcds.patientInfo,'TriggerNames')
                    s.Montage.TriggerNames=oldcds.patientInfo.TriggerNames;
                end
                if isfield(oldcds.patientInfo,'Case')
                    s.PatientInfo.Case=oldcds.patientInfo.Case;
                end
                if isfield(oldcds.patientInfo,'Experiment')
                    s.PatientInfo.Experiment=oldcds.patientInfo.Experiment;
                end
                if isfield(oldcds.patientInfo,'Index')
                    s.PatientInfo.Index=oldcds.patientInfo.Index;
                end
                if isfield(oldcds.patientInfo,'Params')
                    %                     if isfield(oldcds.patientInfo.Params,'tmExtend')
                    %                         s.PatientInfo.Params.TmExtend=oldcds.patientInfo.Params.tmExtend;
                    %                     end
                    %                     if isfield(oldcds.patientInfo.Params,'tmMinimumData')
                    %                         s.PatientInfo.Params.TmMinimumData=oldcds.patientInfo.Params.tmMinimumData;
                    %                     end
                    if isfield(oldcds.patientInfo.Params,'nDownSample')
                        s.DataInfo.DownSample=oldcds.patientInfo.Params.nDownSample;
                        n=s.DataInfo.DownSample;
                        if n~=0
                            s.DataInfo.TimeStamps=s.DataInfo.TimeStamps/n;
                            evts=s.DataInfo.Annotations;
                            evts(:,1)=num2cell(cell2mat(evts(:,1))/n);
                            s.DataInfo.Annotations=evts;
                        end
                    end
                end
                if isfield(oldcds.patientInfo,'Side')
                    s.PatientInfo.Side=oldcds.patientInfo.Side;
                end
                if isfield(oldcds.patientInfo,'Study')
                    s.PatientInfo.Study=oldcds.patientInfo.Study;
                end
                if isfield(oldcds.patientInfo,'Task')
                    s.PatientInfo.Task=oldcds.patientInfo.Task;
                end
                if isfield(oldcds.patientInfo,'Time')
                    s.PatientInfo.Time=oldcds.patientInfo.Time;
                end
                if isfield(oldcds.patientInfo,'Location')
                    s.PatientInfo.Location=oldcds.patientInfo.Location;
                end
            end
            
        end
        
        function s=readFromFIF(filename)
            
            s=CommonDataStructure.initial();
            try
                raw=fiff_setup_read_raw(filename);
            catch
                try
                    raw=fiff_setup_read_raw(filename,1);
                catch me
                    rethrow(me);
                end
            end
            
            if ~isempty(raw)
                if isfield(raw,'info')
                    if isfield(raw.info,'sfreq')
                        s.DataInfo.SampleRate=raw.info.sfreq;
                    end
                    if isfield(raw.info,'lowpass')
                        s.DataInfo.PreFilter=strcat(s.DataInfo.PreFilter,'LP: ',num2str(raw.info.lowpass),' Hz');
                    end
                    if isfield(raw.info,'highpass')
                        s.DataInfo.PreFilter=strcat(s.DataInfo.PreFilter,'HP: ',num2str(raw.info.highpass),' Hz');
                    end
                    
                    if isfield(raw.info,'ch_names')
                        s.Montage.ChannelNames=raw.info.ch_names;
                    end
                end
                
                include=[];
                want_meg=1;
                want_eeg=0;
                want_stim=0;
                meg_picks=fiff_pick_types(raw.info,want_meg,want_eeg,want_stim,include,raw.info.bads);
                
                want_meg=0;
                want_eeg=1;
                want_stim=0;
                eeg_picks=fiff_pick_types(raw.info,want_meg,want_eeg,want_stim,include,raw.info.bads);
                
                want_meg=0;
                want_eeg=0;
                want_stim=1;
                
                stim_picks=fiff_pick_types(raw.info,want_meg,want_eeg,want_stim,include,raw.info.bads);
                
                all_picks=[meg_picks,eeg_picks,stim_picks];
                
                if ~isempty(all_picks)
                    ChannelNames=s.Montage.ChannelNames(all_picks);
                    [data,times]=fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp,all_picks);
                    units=cell(1,size(data,1));
                    %transform the meg channel units to ft & ft/cm
                    
                    [units{1:length(meg_picks)}]=deal('ft');
                    [units{3:3:length(meg_picks)}]=deal('ft/cm');
                    [units{length(meg_picks)+1:length(eeg_picks)+length(meg_picks)}]=deal('uV');
                    data(1:length(meg_picks),:)=data(1:length(meg_picks),:)*10^12;
                    data(length(meg_picks)+1:length(eeg_picks)+length(meg_picks),:)=...
                        data(length(meg_picks)+1:length(eeg_picks)+length(meg_picks),:)*10^6;
                    
                    want_mag1=1;
                    want_mag2=0;
                    want_gra=0;
                    want_eeg=0;
                    want_stim=0;
                    
                    chan_ignore=[];
                    if ~want_mag1
                        chan_ignore=[chan_ignore,1:3:length(meg_picks)];
                    end
                    if ~want_mag2
                        chan_ignore=[chan_ignore,2:3:length(meg_picks)];
                    end
                    
                    if ~want_gra
                        chan_ignore=[chan_ignore,3:3:length(meg_picks)];
                    end
                    if ~want_eeg
                        chan_ignore=[chan_ignore,length(meg_picks)+1:length(meg_picks)+length(eeg_picks)];
                    end
                    
                    if ~want_stim
                        chan_ignore=[chan_ignore,length(meg_picks)+length(eeg_picks)+1:length(meg_picks)+length(eeg_picks)+length(stim_picks)];
                    end
                    
                    data(chan_ignore,:)=[];
                    units(chan_ignore)=[];
                    
                    ChannelNames(chan_ignore)=[];
                    
                    s.Data=data';
                    s.DataInfo.TimeStamps=times;
                    s.DataInfo.Units=units;
                    s.Montage.ChannelNames=ChannelNames;
                end
                
                
            end
        end
        
        function s=readFromMAT(filename)
            %Raw mat data
            s=CommonDataStructure.initial();
            st=load(filename,'-mat');
            field=fieldnames(st);
            if length(field)>1
                msgbox('The file contain more than one field, try to load the first one...','CommonDataStructure','warn');
            end
            
            data=st.(field{1});
            
            if size(data,2)>size(data,1)
                
                choice=questdlg('The data seems to be row-wise, do you want to transpose it?','CommonDataStructure','Yes','No','Yes');
                if strcmpi(choice,'Yes')
                    data=data';
                end
            end
            
            s.Data=data;
        end
        
        function s=readFromEDF(filename)
            s=CommonDataStructure.initial();
            [header,signalHeader,signalCell]=blockEdfLoad(filename);
            
            pChan=1;
            count=0;
            
            for i=1:length(signalHeader)
                if length(signalCell{i})~=length(signalCell{pChan})
                    msgbox(['Channel ' num2str(i) ' has different length with channel ' num2str(pChan)...
                        '\nChannel ' num2str(i) 'skipped'],'CommonDataStructure','warn');
                    continue;
                elseif signalHeader(i).samples_in_record~=signalHeader(pChan).samples_in_record
                    msgbox(['Channel ' num2str(i) ' has different sampling rate with channel ' num2str(pChan)...
                        '\nChannel ' num2str(i) 'skipped','CommonDataStructure','warn']);
                    continue;
                else
                    pChan=i;
                    count=count+1;
                end
                
                if isfield(signalHeader(count),'signal_labels')
                    s.Montage.ChannelNames{count}=signalHeader(count).signal_labels;
                end
                
                if isfield(header,'data_record_duration')&&isfield(signalHeader(count),'samples_in_record')
                    if header.data_record_duration
                        s.DataInfo.SampleRate=signalHeader(count).samples_in_record/header.data_record_duration;
                    end
                end
                
                if isfield(signalHeader(count),'prefiltering')
                    s.DataInfo.PreFilter{i}=signalHeader(count).prefiltering;
                end
                
                if isfield(signalHeader(count),'physical_dimension')
                    s.DataInfo.Units{count}=signalHeader(count).physical_dimension;
                end
                s.Data(:,count)=signalCell{count};
            end
            
        end
        
        function cds=multiload()
            [FileName,FilePath,FilterIndex]=uigetfile({...
                '*.mat;*.cds;*.cds.old;*.medf;*.fif;*.edf',...
                'Supported formats (*.mat;*.cds;*.cds.old;*.medf;*.fif;*.edf)';...
                '*.cds','common data structure (*.cds)';...
                '*.ocds','old common data structure (*.ocds)';...
                '*.medf','matlab edf format (*.medf)';...
                '*.fif','NeuroMag MEG format (*.fif)';...
                '*.edf','Europeon Data Format (*.edf)'},...
                'Select your data file','DataInfo.mat',...
                'MultiSelect','on');
            
            if ~iscell(FileName)
                if ~FileName
                    cds=[];
                    return
                else
                    FileName={FileName};
                end
            end
            
            if FilterIndex==1
                for i=1:length(FileName)
                    FilterIndex(i)=CommonDataStructure.dataStructureCheck(fullfile(FilePath,FileName{i}));
                end
            else
                FilterIndex=ones(1,length(FileName))*FilterIndex;
            end
            
            cds=cell(1,length(FilterIndex));
            for i=1:length(FileName)
                cds{i}=CommonDataStructure();
            end
            
            for i=1:length(FileName)
                filename=fullfile(FilePath,FileName{i});
                switch FilterIndex(i)
                    case 0
                        cds{i}.MatFile=[];
                        cds{i}.copy(CommonDataStructure.readFromMAT(filename));
                    case 2
                        cds{i}.MatFile=matfile(filename,'Writable',true);
                        cds{i}.copy(CommonDataStructure.readFromCDS(filename));
                    case 3
                        cds{i}.MatFile=[];
                        cds{i}.copy(CommonDataStructure.readFromOldCDS(filename));
                    case 4
                        cds{i}.MatFile=[];
                        cds{i}.copy(CommonDataStructure.readFromMEDF(filename));
                    case 5
                        cds{i}.MatFile=[];
                        cds{i}.copy(CommonDataStructure.readFromFIF(filename));
                    case 6
                        cds{i}.MatFile=[];
                        cds{i}.copy(CommonDataStructure.readFromEDF(filename));
                end
                cds{i}.DataInfo.FileName=filename;
            end
            
        end
        
        function demo()
            
            obj=CommonDataStructure();
            assignin('base','obj',obj);
            
            obj.load();
            
            obj.save();
        end
        
        function cds=Load(varargin)
            cds=CommonDataStructure;
            
            if nargin==1
                fname=varargin{1};
                cds.load(fname);
            else
                cds.load();
            end
            
        end
        
        function mtg=scanMontageFile(OriginalChanNames,FilePath,FileName)
            if nargin==2
                FileName={};
                fn=dir(FilePath);
                count=1;
                for i=1:length(fn)
                    if ~fn(i).isdir
                        FileName{count}=fn(i).name;
                        count=count+1;
                    end
                end
            end
            
            montage=cell(1,length(FileName));
            
            for i=1:length(FileName)
                filename=fullfile(FilePath,FileName{i});
                
                [pathstr, name, ext] = fileparts(FileName{i});
                
                if strcmpi(ext,'.txt')||strcmpi(ext,'.csv')||strcmpi(ext,'.mtg')
                    montage{i}=ReadMontage(filename);
                elseif strcmpi(ext,'.mat')
                    %Format
                    %mtg.mat;mtg.group;mtg.name
                    %mat is column wise projection matrix
                    montage{i}=load(filename,'-mat');
                end
            end
            
            mtg=cell(length(montage),1);
            for i=1:length(montage)
                [pathstr, name, ext] = fileparts(FileName{i});
                
                if length(OriginalChanNames)==1
                    channame=OriginalChanNames{1};
                else
                    channame=OriginalChanNames{i};
                end
                [montage_channames,mat,groupnames]=parseMontage(montage{i},channame);
                
                mtg{i}.name=name;
                mtg{i}.channames=montage_channames;
                mtg{i}.mat=mat;
                mtg{i}.groupnames=groupnames;
                
            end
        end
        
        function f=get_start_file(obj)
            current_data=obj.DataInfo;
            [pathstr, name, ext] = fileparts(current_data.FileName);
            
            while ~isempty(current_data.PrevFile)
                
                fname=fullfile(pathstr,current_data.PrevFile);
                if exist(fname,'file')~=2
                    break
                end
                tmp=matfile(fname);
                %matfile object cannot access the subfield of its subfield.
                %you need to retrieve the the substructure to access below
                current_data=tmp.DataInfo;
            end
            f=current_data.FileName;
        end
        
        function [filenames,pathstr,filetime,evts]=get_file_info(varargin)
            %obj can either be the class instance or the matfile object
            %if it is a matfile object, you have to guarantee that the mat
            %file is in the correct format of CommonDataStructure
            evts=[];
            filenames={};
            filetime=[];
            pathstr=[];
            
            if nargin==1
                obj=varargin{1};
                if ischar(obj)
                    if exist(obj,'file')~=2
                        return
                    else
                        obj=matfile(obj);
                        if ~any(strcmpi('DataInfo',who(obj)))
                            obj=CommonDataStructure.Load(obj);
                        end
                    end
                end
            elseif nargin==0
                [FileName,FilePath,FilterIndex]=uigetfile({...
                    '*.cds';...
                    'Supported formats (*.cds)'},...
                    'Select your data file','DataInfo.mat');
                if ~FileName
                    return
                end
                obj=matfile(fullfile(FilePath,FileName));
                
                if ~any(strcmpi('DataInfo',who(obj)))
                    obj=CommonDataStructure.Load(fullfile(FilePath,FileName));
                end
                
            end
            current_data_info=obj.DataInfo;
            
            [pathstr, ~, ~] = fileparts(current_data_info.FileName);
            firstfile=CommonDataStructure.get_start_file(obj);
            
            %get to the first node of the chain
            current_file=matfile(firstfile);
            if ~any(strcmpi('DataInfo',who(current_file)))
                current_file=CommonDataStructure.Load(firstfile);
            end
            
            current_data_info=current_file.DataInfo;
            
            [~,name,ext]=fileparts(firstfile);
            filenames{1}=[name,ext];
            %searching forward
            while 1
                ts=current_data_info.TimeStamps;
                %get all events
                new_evt=current_data_info.Annotations;
                if ~isempty(new_evt)
                    if ~isempty(ts)
                        new_evt(:,1)=num2cell(cell2mat(new_evt(:,1))-ts(1));
                    end
                    if ~isempty(filetime)
                        new_evt(:,1)=num2cell(cell2mat(new_evt(:,1))+filetime(end,2));
                    end
                end
                
                evts=cat(1,evts,new_evt);
                %**********************************************************
                if ~isempty(ts)
                    new_t=[ts(1),ts(end)]-ts(1);
                else
                    %this will require to load Data, extremly slow, so it
                    %is always advicalbe to store timestamp into the data
                    %very costy
                    new_t=[0,size(current_file.Data,1)]/current_data_info.SampleRate;
                end
                
                if ~isempty(filetime)
                    new_t=new_t+filetime(end,2);
                end
                filetime=cat(1,filetime,new_t);
                
                fname=fullfile(pathstr,current_data_info.NextFile);
                
                if isempty(current_data_info.NextFile)||exist(fname,'file')~=2
                    break
                end
                
                filenames=cat(1,filenames,current_data_info.NextFile);
                
                current_file=matfile(fname);
                if ~any(strcmpi('DataInfo',who(current_file)))
                    current_file=CommonDataStructure.Load(fname);
                end
                current_data_info=current_file.DataInfo;
            end
        end
        
        function [dat,eof,evts]=get_data_segment(varargin)
            %t_start, t_end will be the start and end time in seconds, if
            %t_start is empty, will start from the begining; if t_end is
            %empty, will extend to the end
            %if negative , start from the end
            dat=[];
            eof=[];
            evts=[];
            if nargin==3
                obj=varargin{1};
                if ischar(obj)
                    if exist(obj,'file')~=2
                        return
                    else
                        obj=matfile(obj);
                    end
                end
            elseif nargin==2
                [FileName,FilePath,FilterIndex]=uigetfile({...
                    '*.cds';...
                    'Supported formats (*.cds)'},...
                    'Select your data file','DataInfo.mat');
                if ~FileName
                    return
                end
                obj=matfile(fullfile(FilePath,FileName));
            else
                return
            end
            
            t_start=varargin{end-1};
            t_end=varargin{end};
            current_data_info=obj.DataInfo;
            fs=current_data_info.SampleRate;
            %**************************************************************
            eof=false;
            [filenames,pathstr,filetime,evts]=CommonDataStructure.get_file_info(obj);
            
            if isempty(t_start)
                f_start=1;
            else
                if t_start<0
                    t_start=filetime(end,2)+t_start;
                end
                tmp=find(t_start>=filetime(:,1));
                if isempty(tmp)
                    eof=true;
                    return
                end
                f_start=tmp(end);
            end
            if isempty(t_end)
                f_end=length(filenames);
            else
                if t_end<0
                    t_end=filetime(end,2)+t_end;
                end
                tmp=find(t_end<=filetime(:,2));
                if isempty(tmp)
                    eof=true;
                    return
                end
                f_end=tmp(1);
            end
            
            if t_start>t_end
                tmp=t_start;
                t_start=t_end;
                t_end=tmp;
            end
            
            for f=f_start:f_end
                fileobj=matfile(fullfile(pathstr,filenames{f}));
                if f==f_end
                    ind_end=max(1,floor((t_end-filetime(f,1))*fs));
                else
                    ind_end=round((filetime(f,2)-filetime(f,1))*fs);
                end
                
                if f==f_start
                    ind_start=max(1,floor((t_start-filetime(f,1))*fs));
                else
                    ind_start=1;
                end
                dat=cat(1,dat,fileobj.Data(ind_start:ind_end,:));
            end
        end
    end
end

