classdef CommonDataStructure < handle
    %The class definition for common data structure used in CNEL
    %By Tianxiao Jiang
    %jtxinnocence@gmail.com
    %06/03/2014
    
    properties (Access=public)
        DataInfo
        Montage
        PatientInfo
    end
    
    properties (Dependent)
        %Data will be either stored dat or a reference to a matfile
        Data
        MatFile
        %alias for the elements of common data structures
        fs  %DataInfo.SampleRate
        vtf %DataInfo.Video.TimeFrame
        nextf%DataInfo.NextFile
        prevf%DataInfo.PrevFile
        file%DataInfo.FileName
        evt %DataInfo.Annotations
        start_file
        file_type
        ts
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
        file_type_
    end
    
    methods
        function val=get.MatFile(obj)
            if ~isempty(obj.DataInfo.FileName)
                val=matfile(obj.DataInfo.FileName,'Writable',true);
            else
                val=[];
            end
        end
        function obj=set.Data(obj,val)
            ft=obj.file_type;
            if ft==2&&~isempty(obj.MatFile)
                obj.MatFile.Data=val;
            else
                obj.dat=val;
            end
        end
        function val=get.Data(obj)
            ft=obj.file_type;
            if ft==2&&~isempty(obj.MatFile)
                val=double(obj.MatFile.Data);
            else
                val=double(obj.dat);
            end
        end
        
        function obj = set.file_type(obj,val), obj.file_type_=val;end
        function val = get.file_type(obj)
            if isempty(obj.file_type_)
                if ~isempty(obj.DataInfo.FileName)
                    val=CommonDataStructure.dataStructureCheck(obj.DataInfo.FileName);
                else
                    val=-1;
                end
            else
                val=obj.file_type_;
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
        
        function obj = set.ts(obj,val), obj.DataInfo.TimeStamps=val; end
        function val = get.ts(obj),     val=obj.DataInfo.TimeStamps; end
        
        function val=get.start_file(obj), val=CommonDataStructure.get_start_file(obj); end
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
            try
                if ishandle(obj)
                    delete(obj);
                end
            catch
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
            
            obj.file_type=FilterIndex;
            switch FilterIndex
                case 0
                    obj.copy(CommonDataStructure.readFromMAT(filename));
                case 2
                    obj.copy(CommonDataStructure.readFromCDS(filename));
                case 3
                    obj.copy(CommonDataStructure.readFromOldCDS(filename));
                case 4
                    obj.copy(CommonDataStructure.readFromMEDF(filename));
                case 5
                    obj.copy(CommonDataStructure.readFromFIF(filename));
                case 6
                    obj.copy(CommonDataStructure.readFromEDF(filename));
                    
            end
            obj.DataInfo.FileName=filename;
            if FilterIndex==2
                obj.MatFile.DataInfo=obj.DataInfo;
            end
        end
        
        function export2workspace(obj,varname)
            assignin('base',varname,obj);
        end
        
        function save(obj,varargin)
            title=[];
            fnames=[];
            folders=true;
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
                    elseif strcmpi(varargin{i},'Folders')
                        folders=varargin{i+1};
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
            
            if isempty(obj.file_size)
                %might have problem if a single cds file is too large to fit
                %into the memory
                cds=CommonDataStructure.initial();
                cds.DataInfo=obj.DataInfo;
                cds.Montage=obj.Montage;
                cds.PatientInfo=obj.PatientInfo;
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
            
            if folders
                FilePath=fileparts(fnames);
                if exist([FilePath,'/montage'],'dir')~=7
                    mkdir(FilePath,'montage');
                end
                
                if exist([FilePath,'/position'],'dir')~=7
                    mkdir(FilePath,'position');
                end
                
                if exist([FilePath,'/events'],'dir')~=7
                    mkdir(FilePath,'events');
                end
            end
            
            close(wait_bar_h);
        end
        
        function success=extractTimeFrameFromData(obj,videoChannel)
            success=false;
            
            if isempty(obj.DataInfo.SampleRate)
                error('Sample rate missing!');
            end
            
            if ischar(videoChannel)
                videoChannel=find(ismember(obj.Montage.ChannelNames,videoChannel));
            end
            
            if ~isempty(videoChannel)
                
                %find the recording segments
                frames=obj.Data(:,videoChannel);
                
                %eliminate the zeros due to UDP drops
                ind=find(frames>=1);
                frames=frames(ind);
                
                [~,I]=max(frames);
                
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
                mf=matfile(filename,'Writable',true);
                field=who(mf);
                
                if any(strcmp(field,'data'))
                    %check if it is medf file
                    s_data=mf.data;
                    if isfield(s_data,'dataMat')&&isfield(s_data,'info')
                        FilterIndex=4;
                        return
                        %check if it is old cds file
                    elseif isfield(s_data,'data')
                        FilterIndex=3;
                        return
                    end
                end
                
                %check if it is cds file
                if any(strcmp(field,'Data'))&&any(strcmp(field,'Montage'))&&any(strcmp(field,'PatientInfo'))&&any(strcmp(field,'DataInfo'))
                    FilterIndex=2;
                    return
                end
                FilterIndex=0;
            end
        end
        
        function s=initial()
            %Auto generate an empty cds structure
            %Refer to /doc/manual for more information on the data
            %structure
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
            s.DataInfo.AllFiles=[];
            s.DataInfo.FileSample=[];
            s.DataInfo.AllEvents=[];
            
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
            s.PatientInfo.Time.Year=[];
            s.PatientInfo.Time.Month=[];
            s.PatientInfo.Time.Day=[];
            s.PatientInfo.Time.Hour=[];
            s.PatientInfo.Time.Minute=[];
            s.PatientInfo.Time.Second=[];
            s.PatientInfo.Location=[];
        end
        
        function s=completeDataInfo(s)
            
            fields={'Annotations','Artifact','TimeStamps','Units','Video','PreFilter','DownSample','SampleRate','FileName',...
                'VideoName','NextFile','PrevFile','AllFiles','FileSample','AllEvents'};
            for i=1:length(fields)
                if ~isfield(s,fields{i})
                    s.(fields{i})=[];
                end
            end
            
        end
        function s=readFromCDS(filename)
            s=matfile(filename,'Writable',true);
            if ~any(strcmp('DataInfo',who(s)))&&any(strcmp('Data',who(s)))
                dat=s.Data;
                %obsolete format Data.Data
                %get Data.Data outside
                s.DataInfo=CommonDataStructure.completeDataInfo(rmfield(dat,'Data'));
                s.Data=dat.Data;
            else
                di=s.DataInfo;
                s.DataInfo=CommonDataStructure.completeDataInfo(di);
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
                
                if length(oldcds.data)>1
                    %multi depth file, ilknur
                    prev_depth=inf;
                    for i=1:length(oldcds.data)
                        if isfield(oldcds.data(i),'timestamps')
                            s.DataInfo.TimeStamps=cat(1,s.DataInfo.TimeStamps,oldcds.data(i).timestamps(:));
                        end
                        if isfield(oldcds.data(i),'depth')&&oldcds.data(i).depth~=prev_depth
                            s.DataInfo.Annotations=cat(1,s.DataInfo.Annotations,{size(s.Data,1),['Depth ' num2str(oldcds.data(i).depth)]});
                            prev_depth=oldcds.data(i).depth;
                        end
                        if isfield(oldcds.data(i),'data')
                            s.Data=cat(1,s.Data,oldcds.data(i).data);
                        end
                    end
                    s.DataInfo.TimeStamps=0:size(s.Data,1)-1;
                else
                    if isfield(oldcds.data,'data')
                        s.Data=oldcds.data.data;
                    end
                    if isfield(oldcds.data,'annotations')
                        s.DataInfo.Annotations=oldcds.data.annotations;
                    end
                    if isfield(oldcds.data,'artifact')
                        s.DataInfo.Artifact=oldcds.data.artifact;
                    end
                    if isfield(oldcds.data,'timestamps')
                        s.DataInfo.TimeStamps=oldcds.data.timestamps;
                    end
                    
                    if isfield(oldcds.data,'triggerCodes')
                        s.DataInfo.TriggerCodes=oldcds.data.triggerCodes;
                    end
                end
            end
            
            %obj.Montage construction
            if isfield(oldcds,'montage')
                if isfield(oldcds.montage,'ChannelNames')
                    s.Montage.ChannelNames=oldcds.montage.ChannelNames(1:size(s.Data,2));
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
                    %sometimes Ilknur save as string
                    if ischar(oldcds.montage.SampleRate)
                        s.DataInfo.SampleRate=str2double(oldcds.montage.SampleRate);
                    else
                        s.DataInfo.SampleRate=oldcds.montage.SampleRate;
                    end
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
            
            %default
            fs=256;
            
            st=matfile(filename,'Writable',true);
            field=who(st);
            if length(field)>1
                %try to load gHI simulink file format
                if length(field)==2&&any(strcmp('y',field))&&any(strcmp('SR',field))
                    data=st.('y');
                    data=squeeze(data);
                    fs=st.('SR');
                else
                    prompt={'Please specify the field path for the data: '};
                    def={''};
                    
                    title='Unknow Data Structure !';
                    
                    answer=inputdlg(prompt,title,1,def);
                    
                    if isempty(answer)
                        return;
                    end
                    try
                        data = st.(answer{1});
                    catch
                        errordlg('Field does not exist !');
                        return;
                    end
                end
            else
                data=st.(field{1});
            end
            
            pause(0.5);
            try
                close(h)
            catch
            end
            
            if size(data,2)>size(data,1)
                %                 choice=questdlg('The data seems to be row-wise, do you want to transpose it?','CommonDataStructure','Yes','No','Yes');
                %                 if strcmpi(choice,'Yes')
                data=data';
                %                 end
            end
            s.DataInfo.SampleRate=fs;
            s.Data=data;
            s.Montage.ChannelNames=cell(size(data,2),1);
            s.Montage.ChannelNames=cellfun(@num2str,num2cell(1:size(data,2)),'UniformOutput',false);
            %             s.DataInfo.TimeStamps=(1:size(data,1))/256;
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
        
        function cds=multiload(varargin)
            cds=[];
            if nargin==0
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
            elseif nargin==1
                if iscell(varargin{1})
                    [FilePath,tmp_name,tmp_ext]=fileparts(varargin{1}{1});
                    FileName{1}=[tmp_name,tmp_ext];
                    for i=2:length(varargin{1})
                        [tmp_path,tmp_name,tmp_ext]=fileparts(varargin{1}{i});
                        if ~strcmp(FilePath,tmp_path)
                            errordlg('Input files are not in the same directory !');
                        else
                            FileName{i}=[tmp_name,tmp_ext];
                        end
                    end
                    FilterIndex=1;
                    
                elseif ischar(varargin{1})
                    [FilePath,FileName,ext]=fileparts(varargin{1});
                    FileName={[FileName,ext]};
                    FilterIndex=1;
                else
                    return
                end
            else
                return
            end
            
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
                cds{i}.file_type=FilterIndex(i);
                switch FilterIndex(i)
                    case 0
                        cds{i}.copy(CommonDataStructure.readFromMAT(filename));
                    case 2
                        cds{i}.copy(CommonDataStructure.readFromCDS(filename));
                    case 3
                        cds{i}.copy(CommonDataStructure.readFromOldCDS(filename));
                    case 4
                        cds{i}.copy(CommonDataStructure.readFromMEDF(filename));
                    case 5
                        cds{i}.copy(CommonDataStructure.readFromFIF(filename));
                    case 6
                        cds{i}.copy(CommonDataStructure.readFromEDF(filename));
                end
                cds{i}.DataInfo.FileName=filename;
                
                if FilterIndex(i)==2
                    cds{i}.MatFile.DataInfo=cds{i}.DataInfo;
                end
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
            mtg=[];
            if nargin<2
                return
            elseif nargin==2
                FileName={};
                fn=dir(FilePath);
                for i=1:length(fn)
                    if ~fn(i).isdir
                        FileName=cat(1,FileName,{fn(i).name});
                    end
                end
            end
            
            montage=cell(1,length(FileName));
            
            for i=1:length(FileName)
                filename=fullfile(FilePath,FileName{i});
                
                [~, ~, ext] = fileparts(FileName{i});
                
                if strcmpi(ext,'.txt')||strcmpi(ext,'.csv')||strcmpi(ext,'.mtg')
                    montage{i}=ReadMontage(filename);
                elseif strcmpi(ext,'.mat')
                    %Format
                    %mtg.mat;mtg.group;mtg.name
                    %mat is column wise projection matrix
                    montage{i}=load(filename,'-mat');
                end
            end
            
            count=1;
            for i=1:length(montage)
                if isempty(montage{i})
                    continue
                end
                [~, name, ~] = fileparts(FileName{i});
                
                [montage_channames,mat,groupnames]=parseMontage(montage{i},OriginalChanNames);
                
                if ~all(sum(abs(mat),2))
                    continue
                end
                
                mtg{count}.name=name;
                mtg{count}.channames=montage_channames;
                mtg{count}.mat=mat;
                mtg{count}.groupnames=groupnames;
                count=count+1;
            end
        end
        function [evt,names]=scanEventFile(FilePath,FileName)
            evt=[];
            if nargin<1
                return
            elseif nargin==1
                FileName={};
                fn=dir(FilePath);
                for i=1:length(fn)
                    if ~fn(i).isdir
                        FileName=cat(1,FileName,{fn(i).name});
                    end
                end
            end
            evt=cell(1,length(FileName));
            names=evt;
            for i=1:length(FileName)
                [~, name, ext] = fileparts(FileName{i});
                if strcmpi(ext,'.txt')||strcmpi(ext,'.csv')||strcmpi(ext,'.evt')
                    FilterIndex=1;
                elseif strcmpi(ext,'.mat')
                    FilterIndex=2;
                else
                    FilterIndex=0;
                end
                
                filename=fullfile(FilePath,FileName{i});
                
                switch FilterIndex
                    case 1
                        fileID = fopen(filename);
                        C = textscan(fileID,'%s%s%s%s',...
                            'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
                        fclose(fileID);
                        
                        time=cellfun(@str2double,C{1},'UniformOutput',false);
                        
                        time=time(:);
                        
                        text=C{2};
                        text=reshape(text,length(text),1);
                        
                        col=cellfun(@str2num,C{3},'UniformOutput',false);
                        col=reshape(col,length(col),1);
                        
                        code=cellfun(@str2double,C{4},'UniformOutput',false);
                        code=reshape(code,length(code),1);
                        
                        evt{i}=cat(2,time,text,col,code);
                        
                        cond=cellfun(@isnan,code,'UniformOutput',true);
                        evt{i}(cond,4)={0};
                        names{i}=name;
                    case 2
                        evt{i}=ReadEventFromMatFile(filename);
                        names{i}=name;
                end
            end
            
            ind=~cellfun(@isempty,evt,'UniformOutput',true);
            evt=evt(ind);
            names=names(ind);
        end
        
        function f=get_start_file(obj)
            current_data=obj.DataInfo;
            [pathstr, name, ext] = fileparts(current_data.FileName);
            tmp=matfile(current_data.FileName);
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
            [~,f,ext]=fileparts(tmp.Properties.Source);
            f=[f,ext];
            f=fullfile(pathstr,f);
        end
        
        function val=search_field(obj,structure,field,opt)
            if strcmpi(structure,'datainfo')
                structure='DataInfo';
            elseif strcmpi(structure,'patientinfo')
                structure='PatientInfo';
            elseif strcmpi(structure,'montage')
                structure='Montage';
            end
            
            current_structure=obj.(structure);
            
            if isfield(current_structure,field)
                val=current_structure.(field);
            else
                val=[];
            end
            
            
            if ~isempty(val)
                if strcmpi(field,'ChannelPosition')
                    if ~all(all(isnan(val)))
                        if strcmpi(opt,'once')
                            return
                        end
                    end
                else
                    return
                end
            end
            current_data_info=obj.DataInfo;
            [pathstr, ~, ~] = fileparts(current_data_info.FileName);
            
            if ~isempty(current_data_info.PrevFile)
                firstfile=CommonDataStructure.get_start_file(obj);
                
                current_file=matfile(firstfile,'Writable',true);
                if ~any(strcmpi(structure,who(current_file)))
                    current_file=CommonDataStructure.Load(firstfile);
                end
            else
                current_file=obj;
                
            end
            
            current_structure=current_file.(structure);
            current_data_info=current_file.DataInfo;
            
            while 1
                if strcmpi(opt,'union')
                    if isfield(current_structure,field)
                        val=union(val,current_structure.(field));
                    end
                elseif strcmpi(opt,'once')
                    if isfield(current_structure,field)
                        val=current_structure.(field);
                    else
                        val=[];
                    end
                end
                
                if ~isempty(val)
                    if strcmpi(field,'ChannelPosition')
                        if ~all(all(isnan(val)))
                            if strcmpi(opt,'once')
                                return
                            end
                        end
                    else
                        return
                    end
                end
                if isempty(current_data_info.NextFile)
                    return
                end
                fname=fullfile(pathstr,current_data_info.NextFile);
                
                current_file=matfile(fname,'Writable',true);
                if ~any(strcmpi(structure,who(current_file)))
                    current_file=CommonDataStructure.Load(fname);
                end
                current_structure=current_file.(structure);
                current_data_info=current_file.DataInfo;
            end
        end
        function write_file_info(cds,varargin)
            %This will write into all connected files
            current_data_info=cds.DataInfo;
            [pathstr, ~, ~] = fileparts(current_data_info.FileName);
            firstfile=CommonDataStructure.get_start_file(cds);
            [~,firstfile,ext]=fileparts(firstfile);
            firstfile=[firstfile,ext];
            
            current_file_name=fullfile(pathstr,firstfile);
            current_file=matfile(current_file_name,'Writable',true);
            current_montage=current_file.Montage;
            current_data_info=current_file.DataInfo;
            time=0;
            while 1
                for i=1:2:length(varargin)
                    name=varargin{i};
                    if ~ischar(name)
                        continue
                    end
                    if strcmpi(name,'SampleRate')
                        current_data_info.SampleRate=varargin{i+1};
                        len=length(current_data_info.TimeStamps);
                        current_data_info.TimeStamps=linspace(0,len/varargin{i+1},len);
                    elseif strcmpi(name,'Annotations')
                        evts=varargin{i+1};
                        if isempty(evts)
                            continue
                        end
                        t_len=current_data_info.TimeStamps(end)-current_data_info.TimeStamps(1);
                        tmp_evt=evts(cell2mat(evts(:,1))>=time&cell2mat(evts(:,1))<=(time+t_len),:);
                        tmp_evt(:,1)=num2cell(cell2mat(tmp_evt(:,1))-time);
                        current_data_info.Annotations=tmp_evt;
                    elseif strcmpi(name,'TimeStamps')
                        %timestamp will be specified automatically when creating the
                        %dataset
                    elseif strcmpi(name,'VideoName')
                        current_data_info.VideoName=varargin{i+1};
                    elseif strcmpi(name,'VideoStartTime')
                        current_data_info.Video.StartTime=varargin{i+1};
                    elseif strcmpi(name,'VideoEndTime')
                        current_data_info.Video.EndTime=varargin{i+1};
                    elseif strcmpi(name,'ChannelPosition')
                        current_montage.ChannelPosition=varargin{i+1};
                    elseif strcmpi(name,'ChannelNames')
                        current_montage.ChannelNames=varargin{i+1};
                    elseif strcmpi(name,'GroupNames')
                        current_montage.GroupNames=varargin{i+1};
                    elseif strcmpi(name,'MontageName')
                        current_montage.Name=varargin{i+1};
                    elseif strcmpi(name,'MaskChanNames')
                        current_montage.MaskChanNames=varargin{i+1};
                    end
                end
                
                current_data_info.FileName=current_file_name;
                current_file.Montage=current_montage;
                current_file.DataInfo=current_data_info;
                
                if isempty(current_data_info.NextFile)
                    break;
                else
                    current_file_name=fullfile(pathstr,current_data_info.NextFile);
                    current_file=matfile(current_file_name,'Writable',true);
                    current_data_info=current_file.DataInfo;
                    current_montage=current_file.Montage;
                    time=time+current_data_info.TimeStamps(end);
                end
            end
        end
        function fileinfo=get_file_info(varargin)
            %obj can either be the class instance or the matfile object
            %if it is a matfile object, you have to guarantee that the mat
            %file is in the correct format of CommonDataStructure
            
            evts=[];
            filenames={};
            filesample=[];
            
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
            current_montage=obj.Montage;
            
            fs=current_data_info.SampleRate;
            if isempty(fs)
                warndlg('Empty sampling rate, default to 256 Hz !');
                fs=256;
            end
            [pathstr, ~, ~] = fileparts(current_data_info.FileName);
            
            if ~isempty(current_data_info.PrevFile)
                firstfile=CommonDataStructure.get_start_file(obj);
                %get to the first node of the chain
                current_file=matfile(firstfile,'Writable',true);
                if ~any(strcmpi('DataInfo',who(current_file)))
                    current_file=CommonDataStructure.Load(firstfile);
                end
                
                current_data_info=current_file.DataInfo;
                current_montage=current_file.Montage;
                
                [~,name,ext]=fileparts(firstfile);
            else
                current_file=obj;
                [~,name,ext]=fileparts(current_data_info.FileName);
            end
            filenames{1}=[name,ext];
            %searching forward
            units=current_data_info.Units;
            channelnames=current_montage.ChannelNames;
            groupnames=current_montage.GroupNames;
            channelposition=current_montage.ChannelPosition;
            masknames=current_montage.MaskChanNames;
            allfiles=[];
            allfilesamples=[];
            video.VideoStartTime=[];
            video.TimeFrame=[];
            video.NumberOfFrame=[];
            video.FileName=[];
            
            while 1
                ts=current_data_info.TimeStamps;
                if isempty(units)
                    units=current_data_info.Units;
                end
                if isempty(channelnames)
                    channelnames=current_montage.ChannelNames;
                end
                if isempty(groupnames)
                    groupnames=current_montage.GroupNames;
                end
                
                if all(all(isnan(channelposition)))
                    channelposition=current_montage.ChannelPosition;
                end
                
                if isempty(ts)
                    %this will require to load Data, extremly slow, so it
                    %is always advisalbe to store timestamp into the data
                    ts=(1:length(current_file.Data(:,1)))/fs;
                end
                %get all events
                new_evt=current_data_info.Annotations;
                if ~isempty(new_evt)
                    new_evt(:,1)=num2cell(cell2mat(new_evt(:,1))-ts(1));
                    if ~isempty(filesample)
                        new_evt(:,1)=num2cell(cell2mat(new_evt(:,1))+filesample(end,2)/fs);
                    end
                end
                
                evts=cat(1,evts,new_evt);
                %**********************************************************
                new_t=[1,length(ts)];
                
                if ~isempty(filesample)
                    new_t=new_t+filesample(end,2);
                end
                filesample=cat(1,filesample,new_t);
                fname=fullfile(pathstr,current_data_info.NextFile);
                
                if isfield(current_data_info,'AllFiles')
                    allfiles=current_data_info.AllFiles;
                end
                if isfield(current_data_info,'Video')
                    video=current_data_info.Video;
                end
                if isfield(current_data_info,'VideoName')
                    video.FileName=current_data_info.VideoName;
                end
                if isfield(current_data_info,'FileSample')
                    allfilesamples=current_data_info.FileSample;
                end

                if isempty(current_data_info.NextFile)||exist(fname,'file')~=2
                    break
                end
                
                filenames=cat(1,filenames,current_data_info.NextFile);
                
                current_file=matfile(fname,'Writable',true);
                if ~any(strcmpi('DataInfo',who(current_file)))
                    current_file=CommonDataStructure.Load(fname);
                end
                current_data_info=current_file.DataInfo;
                current_montage=current_file.Montage;
            end
            
            if isempty(allfiles)
                allfiles=filenames;
            end
            
            if isempty(allfilesamples)
                allfilesamples=filesample;
            end
            %it is your responsibility to keep all common field consistent
            %in all files, I just take care of the missing ones
            fileinfo.path=pathstr;
            fileinfo.filesample=allfilesamples;
            fileinfo.filenames=allfiles;
            fileinfo.fs=fs;
            fileinfo.units=units;
            fileinfo.events=evts;
            fileinfo.channelnames=channelnames;
            fileinfo.groupnames=groupnames;
            fileinfo.channelposition=channelposition;
            fileinfo.masknames=masknames;
            fileinfo.video=video;
        end
        
        function [dat,eof,evts]=get_data_by_start_end(varargin)
            eof=[];
            evts=[];
            dat=[];
            if nargin==3
                obj=varargin{1};
                if ischar(obj)
                    if exist(obj,'file')~=2
                        return
                    else
                        obj=matfile(obj);
                    end
                end
                ind_start=varargin{end-1};
                ind_end=varargin{end};
            elseif nargin==2
                [FileName,FilePath,FilterIndex]=uigetfile({...
                    '*.cds';...
                    'Supported formats (*.cds)'},...
                    'Select your data file','DataInfo.mat');
                if ~FileName
                    return
                end
                obj=matfile(fullfile(FilePath,FileName));
                ind_start=varargin{end-1};
                ind_end=varargin{end};
            else
                return
            end
            eof=false;
            current_data_info=obj.DataInfo;
            
            if isempty(current_data_info.NextFile)&&isempty(current_data_info.PrevFile)
                dat=obj.Data(ind_start:ind_end,:);
                return
            end
            
            if isfield(current_data_info,'AllFiles')&&isfield(current_data_info,'FileSample')...
                    &&~isempty(current_data_info.AllFiles)&&~isempty(current_data_info.FileSample)
                filenames=current_data_info.AllFiles;
                
                [pathstr,~,~]=fileparts(current_data_info.FileName);
                filesample=current_data_info.FileSample;
            else
                fileinfo=CommonDataStructure.get_file_info(obj);
                filesample=fileinfo.filesample;
                pathstr=fileinfo.path;
                filenames=fileinfo.filenames;
            end
            
            f_start=find(filesample(:,1)<=ind_start);
            f_start=f_start(end);
            
            f_end=find(filesample(:,2)>=ind_end);
            f_end=f_end(1);
            
            for f=f_start:f_end
                i_start=1;
                i_end=filesample(f,2)-filesample(f,1)+1;
                if f==f_start
                    i_start=ind_start-filesample(f,1)+1;
                elseif f==f_end
                    i_end=ind_end-filesample(f,1)+1;
                end
                
                fullname=fullfile(pathstr,filenames{f});
                switch CommonDataStructure.dataStructureCheck(fullname)
                    case 2
                        fileobj=matfile(fullname);
                        dat=cat(1,dat,fileobj.Data(i_start:i_end,:));
                    otherwise
                        fileobj=CommonDataStructure.Load(fullname);
                        dat=cat(1,dat,fileobj.Data(i_start:i_end,:));
                end
            end
            
        end
        
        function [dat,eof,evts]=get_data_segment(varargin)
            wait_bar_h = waitbar(0,'Retrieving data from file...');
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
                sample=varargin{end-1};
                channel=varargin{end};
            elseif nargin==2
                [FileName,FilePath,FilterIndex]=uigetfile({...
                    '*.cds';...
                    'Supported formats (*.cds)'},...
                    'Select your data file','DataInfo.mat');
                if ~FileName
                    return
                end
                obj=matfile(fullfile(FilePath,FileName));
                sample=varargin{end-1};
                channel=varargin{end};
            else
                try
                    close(wait_bar_h)
                catch
                end
                return
            end
            
            %**************************************************************
            eof=false;
            current_data_info=obj.DataInfo;
            
            if isempty(sample)
                sample=1:size(obj.Data,1);
            end
            
            if isempty(channel)
                channel=1:length(obj.Data(1,:));
            end
            
            if isempty(current_data_info.NextFile)&&isempty(current_data_info.PrevFile)
                dat=obj.Data(sample,channel);
                try
                    close(wait_bar_h)
                catch
                end
                return
            end
            
            if isfield(current_data_info,'AllFiles')&&isfield(current_data_info,'FileSample')...
                    &&~isempty(current_data_info.AllFiles)&&~isempty(current_data_info.FileSample)
                filenames=current_data_info.AllFiles;
                
                [pathstr,~,~]=fileparts(current_data_info.FileName);
                filesample=current_data_info.FileSample;
            else
                fileinfo=CommonDataStructure.get_file_info(obj);
                filenames=fileinfo.filenames;
                filesample=fileinfo.filesample;
                pathstr=fileinfo.path;
            end
            
            dat=ones(length(sample),length(channel))*nan;
            
            for f=1:length(filenames)
                waitbar(f/length(filenames));
                f_ind_start=filesample(f,1);
                f_ind_end=filesample(f,2);
                ind=ismember(sample,f_ind_start:f_ind_end);
                if any(ind)
                    fullname=fullfile(pathstr,filenames{f});
                    switch CommonDataStructure.dataStructureCheck(fullname)
                        case 2
                            fileobj=matfile(fullname);
                            data=fileobj.Data;
                            dat(logical(ind),:)=data(sample(ind)-f_ind_start+1,channel);
                        otherwise
                            fileobj=CommonDataStructure.Load(fullname);
                            dat(logical(ind),:)=fileobj.Data(sample(ind)-f_ind_start+1,channel);
                    end
                end
            end
            
            
            try
                close(wait_bar_h)
            catch
            end
        end
        
        function create_new_data_from_mat(input_filenames,output_filename,fs,varargin)
            %input_filenames must be a cell arry in sequence
            %output_filename must a single string, the rest will be
            %automatically indexed
            %The mat files must have a single field -- data
            %sample rate must be specified along with creating the data
            
            chan=[];
            vname='';
            filesample=[];
            if length(varargin)==1
                %Only load specific channel
                chan=varargin{1};
            elseif length(varargin)==2
                chan=varargin{1};
                vname=varargin{2};
            end
            
            [out_path,out_name,~]=fileparts(output_filename);
            info=CommonDataStructure;
            total_sample=0;
            all_files={};

            for i=1:length(input_filenames)
                f_in=input_filenames{i};
                
                %needs to be modified if a single file contains too much
                %data
                
                oname=[out_name,'_',num2str(i),'.cds'];
                
                cds=CommonDataStructure.Load(f_in);
                cds.prevf=[out_name,'_',num2str(i-1),'.cds'];
                cds.nextf=[out_name,'_',num2str(i+1),'.cds'];
                cds.DataInfo.VideoName=vname;
                
                if i==1
                    cds.prevf=[out_name,'.info'];
                end
                if i==length(input_filenames)
                    cds.nextf=[];
                end
                
                if ~isempty(chan)
                    cds.Data=cds.Data(:,chan);
                end
                cds.fs=fs;
                cds.DataInfo.TimeStamps=(0:size(cds.Data,1)-1)/fs;
                total_sample=total_sample+size(cds.Data,1);
                
                if isempty(out_path)
                    out_path=fileparts(which(f_in));
                end
                
                new_t=[1,length(cds.DataInfo.TimeStamps)];
                if ~isempty(filesample)
                    new_t=new_t+filesample(end,2);
                end
                
                cds.save(fullfile(out_path,oname));
                
                filesample=cat(1,filesample,new_t);
                all_files=cat(1,all_files,oname);
            end
            info.fs=fs;
            info.nextf=[];
            info.DataInfo.TimeStamps=(0:total_sample-1)/fs;
            chan_num=size(cds.Data,2);
            info.Montage.ChannelNames=cell(chan_num,1);
            info.Montage.ChannelNames=cellfun(@num2str,num2cell(1:chan_num),'UniformOutput',false);
            info.DataInfo.VideoName=vname;
            info.DataInfo.FileSample=filesample;
            info.DataInfo.AllFiles=all_files;
            info.save(fullfile(out_path,[out_name,'.info']));
        end
    end
    methods
        function write_data_by_start_end(obj,data,ind_start)
            wait_bar_h = waitbar(0,'Writing data into file...');
            current_data_info=obj.DataInfo;
            ind_end=ind_start+size(data,1)-1;
            
            if isempty(current_data_info.NextFile)&&isempty(current_data_info.PrevFile)
                obj.Data(ind_start:ind_end,:)=data;
                try
                    close(wait_bar_h)
                catch
                end
                return
            end
            
            if isfield(current_data_info,'AllFiles')&&isfield(current_data_info,'FileSample')...
                    &&~isempty(current_data_info.AllFiles)&&~isempty(current_data_info.FileSample)
                filenames=current_data_info.AllFiles;
                
                [pathstr,~,~]=fileparts(current_data_info.FileName);
                filesample=current_data_info.FileSample;
            else
                fileinfo=CommonDataStructure.get_file_info(obj);
                filesample=fileinfo.filesample;
                pathstr=fileinfo.path;
                filenames=fileinfo.filenames;
            end
            
            f_start=find(filesample(:,1)<=ind_start);
            f_start=f_start(end);
            
            f_end=find(filesample(:,2)>=ind_end);
            f_end=f_end(1);
            
            for f=f_start:f_end
                i_start=1;
                i_end=filesample(f,2)-filesample(f,1)+1;
                if f==f_start
                    i_start=ind_start-filesample(f,1)+1;
                elseif f==f_end
                    i_end=ind_end-filesample(f,1)+1;
                end
                
                fullname=fullfile(pathstr,filenames{f});
                switch CommonDataStructure.dataStructureCheck(fullname)
                    case 2
                        fileobj=matfile(fullname,'Writable',true);
                        fileobj.Data(i_start:i_end,:)=data(i_start+filesample(f,1)-ind_start:i_end+filesample(f,1)-ind_start,:);
                    otherwise
                        msgbox('Invalid file format! Please convert your file into CommonDataStructure','CommonDataStructure.save','error');

                        return
                        %                         fileobj=CommonDataStructure.Load(fullname);
                        %                         fileobj.Data(i_start:i_end,:)=data(i_start+filesample(f,1)-ind_start:i_end+filesample(f,1)-ind_start,:);
                end
            end
            try
                close(wait_bar_h)
            catch
            end
        end
        
        function [dat,channames]=get_trials(obj,event,sbefore,safter)
            dat=[];
            channames=[];
            if isempty(obj.evt)
                errordlg('Event not found in CommonDataStructure !');
                return
            end
            t_evt=[obj.evt{:,1}];
            t_label=t_evt(strcmpi(obj.evt(:,2),event));
            
            if isempty(t_label)
                errordlg(['Event: ',event,' not found !']);
                return
            end
            nL=round(sbefore*obj.fs);
            
            nR=round(safter*obj.fs);
            
            i_event=round(t_label*obj.fs);
            
            current_data_info=obj.DataInfo;
            
            if isfield(current_data_info,'AllFiles')&&isfield(current_data_info,'FileSample')...
                    &&~isempty(current_data_info.AllFiles)&&~isempty(current_data_info.FileSample)
                filenames=current_data_info.AllFiles;
                
                [pathstr,~,~]=fileparts(current_data_info.FileName);
                filesample=current_data_info.FileSample;
            else
                fileinfo=CommonDataStructure.get_file_info(obj);
                filenames=fileinfo.filenames;
                filesample=fileinfo.filesample;
                pathstr=fileinfo.path;
            end
            channames=obj.Montage.ChannelNames;
            for f=1:length(filenames)
                f_ind_start=filesample(f,1);
                f_ind_end=filesample(f,2);
                ind=((i_event-nL)>=f_ind_start)&((i_event+nR)<=f_ind_end);
                ie=i_event(ind);
                
                fullname=fullfile(pathstr,filenames{f});
                switch CommonDataStructure.dataStructureCheck(fullname)
                    case 2
                        fileobj=matfile(fullname);
                        data=fileobj.Data;
                        for i=1:length(ie)
                            dat=cat(3,dat,data(ie(i)-nL-f_ind_start+1:ie(i)+nR-f_ind_start+1,:));
                        end
                    otherwise
                        fileobj=CommonDataStructure.Load(fullname);
                        for i=1:length(ie)
                            dat=cat(3,dat,fileobj.Data(ie(i)-nL-f_ind_start+1:ie(i)+nR-f_ind_start+1,:));
                        end
                end
            end
        end
    end
end

