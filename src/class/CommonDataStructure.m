classdef CommonDataStructure < handle
    %The class definition for common data structure used in CNEL
    %By Tianxiao Jiang
    %jtxinnocence@gmail.com
    %06/03/2014
    
    properties (Access=public)
        Data
        Montage
        PatientInfo
    end
    
    methods
        function obj=CommonDataStructure(varargin)
            if nargin==0
                cds=CommonDataStructure.initial();
                
                obj.Data=cds.Data;
                obj.Montage=cds.Montage;
                obj.PatientInfo=cds.PatientInfo;
            else
                d=varargin{1};
                obj.assign(d);
            end
        end
        
        function delete(obj)
            if ishandle(obj)
                delete(obj);
            end
        end
        
        function assign(obj,s)
            
            if isfield(s,'Data')
                obj.Data=s.Data;
            end
            
            if isfield(s,'Montage')
                obj.Montage=s.Montage;
            end
            
            if isfield(s,'PatientInfo')
                obj.PatientInfo=s.PatientInfo;
            end
            
        end
        function export(obj)
            
            cds.Data=obj.Data;
            cds.Montage=obj.Montage;
            cds.PatientInfo=obj.PatientInfo;
            
            [FileName,FilePath]=uiputfile({...
                '*.cds;*.mat','Common Data Structure Formats (*.cds;*.mat)';...
                '*.mat','Matlab Mat File (*.mat)';
                '*.cds','Common Data Structure Fromat (*.cds)'}...
                ,'Save your common data structure','untitled');
            
            if ~FileName
                return
            end
            save(fullfile(FilePath,FileName),'-struct','cds','-mat');
        end
        
        function y=import(obj)
            y=0;
            [FileName,FilePath,FilterIndex]=uigetfile({...
                '*.mat;*.cds;*.cds.old;*.medf;*.fif;*.edf',...
                'Supported formats (*.mat;*.cds;*.cds.old;*.medf;*.fif;*.edf)';...
                '*.cds','common data structure (*.cds)';...
                '*.ocds','old common data structure (*.ocds)';...
                '*.medf','matlab edf format (*.medf)';...
                '*.fif','NeuroMag MEG format (*.fif)';...
                '*.edf','Europeon Data Format (*.edf)'},...
                'Select your data file','data.mat');
            
            if ~FileName
                return
            else
                y=1;
            end
            
            filename=fullfile(FilePath,FileName);
            
            if FilterIndex==1
                FilterIndex=CommonDataStructure.dataStructureCheck(filename);
            end
            
            
            
            switch FilterIndex
                case 0
                    obj.assign(CommonDataStructure.readFromMAT(filename));
                case 2
                    obj.assign(CommonDataStructure.readFromCDS(filename));
                    
                case 3
                    obj.assign(CommonDataStructure.readFromOldCDS(filename));
                    
                case 4
                    obj.assign(CommonDataStructure.readFromMEDF(filename));
                case 5
                    obj.assign(CommonDataStructure.readFromFIF(filename));
                case 6
                    obj.assign(CommonDataStructure.readFromEDF(filename));
                    
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
                
                s=load(filename,'-mat');
                if isfield(s,'data')
                    if isfield(s.data,'dataMat')&&isfield(s.data,'info')
                        FilterIndex=4;
                        return
                    elseif isfield(s.data,'data')
                        FilterIndex=3;
                        return
                    end
                elseif isfield(s,'Data')&&isfield(s,'Montage')&&isfield(s,'PatientInfo')
                    FilterIndex=2;
                elseif ismatrix(s)
                    FilterIndex=0;
                end
            end
        end
        
        function s=initial()
            %Auto generate an empty cds
            %Refer to /doc/manual for more information on the data
            %structure
            
            %obj.Data construction
            s.Data.Data=[];
            s.Data.Annotations=[];
            s.Data.Artifact=[];
            s.Data.TimeStamps=[];
            s.Data.Units=[];
            s.Data.Video.StartTime=[];
            s.Data.Video.TimeFrame=[];
            s.Data.PreFilter='';
            s.Data.DownSample=[];
            s.Data.SampleRate=[];
            
            %obj.Montage construction
            s.Montage.ChannelNames=[];
            s.Montage.GroupNames=[];
            s.Montage.HeadboxType=[];
            s.Montage.Amplifier=[];
            s.Montage.Name=[];
            s.Montage.Notes=[];
            
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
            s=load(filename,'-mat');
        end
        
        function s=readFromMEDF(filename)
            medf=load(filename,'-mat');
            s=CommonDataStructure.initial();
            
            if isfield(medf,'data')
                if isfield(medf.data,'dataMat')
                    for i=1:length(medf.data.dataMat)
                        try
                            s.Data.Data(:,i)=reshape(medf.data.dataMat{i},...
                                length(medf.data.dataMat{i}),1);
                        catch exception
                            
                            if i>1
                                if length(medf.data.dataMat{i-1})~=...
                                        length(medf.data.dataMat{i})
                                    
                                    cprintf('yellow','The length of data in medf file is not consistent !\n');
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
                        s.Data.SampleRate=medf.data.info{1}.sampleRate;
                    end
                    
                    for i=1:length(medf.data.info)
                        if isfield(medf.data.info{i},'unit')
                            s.Data.Units{i}=medf.data.info{i}.unit;
                        end
                    end
                    
                    if isfield(medf.data.info{1},'stamp')
                        s.Data.TimeStamps=medf.data.info{1}.stamp;
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
                        s.Data.Video.StartTime=medf.info.video.startTime;
                    end
                    if isfield(medf.info.video,'timeFrame')
                        s.Data.Video.TimeFrame=medf.info.video.timeFrame;
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
                    s.Data.Data=oldcds.data.data;
                end
                if isfield(oldcds.data,'annotations')
                    s.Data.Annotations=oldcds.data.annotations;
                end
                if isfield(oldcds.data,'artifact')
                    s.Data.Artifact=oldcds.data.artifact;
                end
                if isfield(oldcds.data,'timestamps')
                    s.Data.TimeStamps=oldcds.data.timestamps;
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
                    s.Data.SampleRate=oldcds.montage.SampleRate;
                    s.Data.TimeStamps=s.Data.TimeStamps/s.Data.SampleRate;
                    evts=s.Data.Annotations;
                    evts(:,1)=num2cell(cell2mat(evts(:,1))/s.Data.SampleRate);
                    s.Data.Annotations=evts;
                end
            end
            %obj.PatientInfo construction
            
            if isfield(oldcds,'patientInfo')
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
                        s.Data.DownSample=oldcds.patientInfo.Params.nDownSample;
                        n=s.Data.DownSample;
                        if n~=0
                            s.Data.TimeStamps=s.Data.TimeStamps/n;
                            evts=s.Data.Annotations;
                            evts(:,1)=num2cell(cell2mat(evts(:,1))/n);
                            s.Data.Annotations=evts;
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
                        s.Data.SampleRate=raw.info.sfreq;
                    end
                    if isfield(raw.info,'lowpass')
                        s.Data.PreFilter=strcat(s.Data.PreFilter,'LP: ',num2str(raw.info.lowpass),' Hz');
                    end
                    if isfield(raw.info,'highpass')
                        s.Data.PreFilter=strcat(s.Data.PreFilter,'HP: ',num2str(raw.info.highpass),' Hz');
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
                
                all_picks=[meg_picks,eeg_picks];
                
                if ~isempty(all_picks)
                    ChannelNames=s.Montage.ChannelNames(all_picks);
                    [data,times]=fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp,all_picks);
                    units=cell(1,length(all_picks));
                    %transform the meg channel units to ft & ft/cm
                    
                    [units{meg_picks}]=deal('ft');
                    [units{meg_picks(3:3:end)}]=deal('ft/cm');
                    [units{eeg_picks}]=deal('uV');
                    data(meg_picks,:)=data(meg_picks,:)*10^12;
                    data(eeg_picks,:)=data(eeg_picks,:)*10^6;
                    
                    want_mag1=1;
                    want_mag2=1;
                    want_gra=0;
                    
                    if ~want_mag1
                        data(meg_picks(1:3:end),:)=[];
                        units(meg_picks(1:3:end))=[];
                        ChannelNames(meg_picks(1:3:end))=[];
                    end
                    if ~want_mag2
                        data(meg_picks(2:3:end),:)=[];
                        units(meg_picks(2:3:end))=[];
                        ChannelNames(meg_picks(2:3:end))=[];
                    end
                    
                    if ~want_gra
                        data(meg_picks(3:3:end),:)=[];
                        units(meg_picks(3:3:end))=[];
                        ChannelNames(meg_picks(3:3:end))=[];
                    end
                    
                    s.Data.Data=data';
                    s.Data.TimeStamps=times;
                    s.Data.Units=units;
                    s.Montage.ChannelNames=ChannelNames;
                end
                
                
            end
        end
        
        function s=readFromMAT(filename)
            s=CommonDataStructure.initial();
            st=load(filename,'-mat');
            field=fieldnames(st);
            if length(field)>1
                cprintf('Yellow','The file contain more than one field, try to import the first one...\n');
            end
            
            data=st.(field{1});
            
            if size(data,2)>size(data,1)
                cprintf('Yellow','The data seems to be row-wise, automatic transpose applied...\n');
                data=data';
            end
            
            s.Data.Data=data;
        end
        
        function s=readFromEDF(filename)
            s=CommonDataStructure.initial();
            [header,signalHeader,signalCell]=blockEdfLoad(filename);
            
            pChan=1;
            count=0;
            
            for i=1:length(signalHeader)
                if length(signalCell{i})~=length(signalCell{pChan})
                    cprintf('Errors',['Channel ' num2str(i) ' has different length with channel ' num2str(pChan)...
                        '\nChannel ' num2str(i) 'skipped\n']);
                    continue;
                elseif signalHeader(i).samples_in_record~=signalHeader(pChan).samples_in_record
                    cprintf('Errors',['Channel ' num2str(i) ' has different samplin rate with channel ' num2str(pChan)...
                        '\nChannel ' num2str(i) 'skipped\n']);
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
                        s.Data.SampleRate=signalHeader(count).samples_in_record/header.data_record_duration;
                    end
                end
                
                if isfield(signalHeader(count),'prefiltering')
                    s.Data.PreFilter{i}=signalHeader(count).prefiltering;
                end
                
                if isfield(signalHeader(count),'physical_dimension')
                    s.Data.Units{count}=signalHeader(count).physical_dimension;
                end
                s.Data.Data(:,count)=signalCell{count};
            end
            
        end
        
        function cds=multiImport()
            [FileName,FilePath,FilterIndex]=uigetfile({...
                '*.mat;*.cds;*.cds.old;*.medf;*.fif;*.edf',...
                'Supported formats (*.mat;*.cds;*.cds.old;*.medf;*.fif;*.edf)';...
                '*.cds','common data structure (*.cds)';...
                '*.ocds','old common data structure (*.ocds)';...
                '*.medf','matlab edf format (*.medf)';...
                '*.fif','NeuroMag MEG format (*.fif)';...
                '*.edf','Europeon Data Format (*.edf)'},...
                'Select your data file','data.mat',...
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
                        cds{i}.assign(CommonDataStructure.readFromMAT(filename));
                    case 2
                        cds{i}.assign(CommonDataStructure.readFromCDS(filename));
                    case 3
                        cds{i}.assign(CommonDataStructure.readFromOldCDS(filename));
                    case 4
                        cds{i}.assign(CommonDataStructure.readFromMEDF(filename));
                    case 5
                        cds{i}.assign(CommonDataStructure.readFromFIF(filename));
                    case 6
                        cds{i}.assign(CommonDataStructure.readFromEDF(filename));
                end
            end
            
        end
        
        function demo()
            
            obj=CommonDataStructure();
            assignin('base','obj',obj);
            
            obj.import();
            
            obj.export();
        end
        
        
    end
    
end

