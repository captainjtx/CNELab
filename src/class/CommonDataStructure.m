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
                '*.mat;*.cds;*.cds.old;*.medf','Supported formats (*.mat;*.cds;*.cds.old;*.medf)';...
                '*.cds','common data structure (*.cds)';...
                '*.cds.old','old common data structure (*.cds.old)';...
                '*.medf','matlab edf format (*.medf)'},...
                'Select your data file','data.mat');
            
            if ~FileName
                return
            else
                y=1;
            end
            
            if FilterIndex==1
                s=load(fullfile(FilePath,FileName),'-mat');
                FilterIndex=CommonDataStructure.dataStructureCheck(s);
            end
            switch FilterIndex
                case 2
                    cds=load(fullfile(FilePath,FileName),'-mat');
                    obj.assign(CommonDataStructure.readFromCDS(cds));
                    
                case 3
                    
                    cds=load(fullfile(FilePath,FileName),'-mat');
                    obj.assign(CommonDataStructure.readFromOldCDS(cds));
                    
                case 4
                    
                    medf=load(fullfile(FilePath,FileName),'-mat');
                    obj.assign(CommonDataStructure.readFromMEDF(medf));
                    
            end
        end
        
    end
    methods (Static=true)
        function FilterIndex=dataStructureCheck(s)
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
            s.Data.Unit.Data=[];
            s.Data.Unit.Stamp=[];
            s.Data.Video.StartTime=[];
            s.Data.Video.TimeFrame=[];
            
            %obj.Montage construction
            s.Montage.ChannelNames=[];
            s.Montage.GroupNames=[];
            s.Montage.HeadboxType=[];
            s.Montage.Amplifier=[];
            s.Montage.Name=[];
            s.Montage.Notes=[];
            s.Montage.SampleRate=[];
            
            %obj.PatientInfo construction
            s.PatientInfo.Case=[];
            s.PatientInfo.Experiment=[];
            s.PatientInfo.Index=[];
            s.PatientInfo.Params.TmExtend=[];
            s.PatientInfo.Params.TmMinimumData=[];
            s.PatientInfo.Params.NDownSample=[];
            s.PatientInfo.Side=[];
            s.PatientInfo.Study=[];
            s.PatientInfo.Task=[];
            s.PatientInfo.Time=[];
            s.PatientInfo.Location=[];
        end
        function s=readFromCDS(cds)
            
            s=CommonDataStructure.initial();
            
            %s.data construction
            if isfield(cds,'Data')
                if isfield(cds.Data,'Data')
                    s.Data.Data=cds.Data.Data;
                end
                if isfield(cds.Data,'Annotations')
                    s.Data.Annotations=cds.Data.Annotations;
                end
                if isfield(cds.Data,'Artifact')
                    s.Data.Artifact=cds.Data.Artifact;
                end
                if isfield(cds.Data,'TimeStamps')
                    s.Data.TimeStamps=cds.Data.TimeStamps;
                end
                
            end
            
            %s.Montage construction
            if isfield(cds,'Montage')
                if isfield(cds.Montage,'ChannelNames')
                    s.Montage.ChannelNames=cds.Montage.ChannelNames;
                end
                if isfield(cds.Montage,'GroupNames')
                    s.Montage.GroupNames=cds.Montage.GroupNames;
                end
                if isfield(cds.Montage,'HeadboxType')
                    s.Montage.HeadboxType=cds.Montage.HeadboxType;
                end
                if isfield(cds.Montage,'Amplifier')
                    s.Montage.Amplifier=cds.Montage.Amplifier;
                end
                if isfield(cds.Montage,'Name')
                    s.Montage.Name=cds.Montage.Name;
                end
                if isfield(cds.Montage,'Notes')
                    s.Montage.Notes=cds.Montage.Notes;
                end
                
                if isfield(cds.Montage,'SampleRate')
                    s.Montage.SampleRate=cds.Montage.SampleRate;
                end
            end
            %s.PatientInfo construction
            
            if isfield(cds,'PatientInfo')
                if isfield(cds.PatientInfo,'Case')
                    s.PatientInfo.Case=cds.PatientInfo.Case;
                end
                if isfield(cds.PatientInfo,'Experiment')
                    s.PatientInfo.Experiment=cds.PatientInfo.Experiment;
                end
                if isfield(cds.PatientInfo,'Index')
                    s.PatientInfo.Index=cds.PatientInfo.Index;
                end
                if isfield(cds.PatientInfo,'Params')
                    if isfield(cds.PatientInfo.Params,'TmExtend')
                        s.PatientInfo.Params.TmExtend=cds.PatientInfo.Params.TmExtend;
                    end
                    if isfield(cds.PatientInfo.Params,'TmMinimumData')
                        s.PatientInfo.Params.TmMinimumData=cds.PatientInfo.Params.TmMinimumData;
                    end
                    if isfield(cds.PatientInfo.Params,'NDownSample')
                        s.PatientInfo.Params.NDownSample=cds.PatientInfo.Params.NDownSample;
                    end
                end
                if isfield(cds.PatientInfo,'Side')
                    s.PatientInfo.Side=cds.PatientInfo.Side;
                end
                if isfield(cds.PatientInfo,'Study')
                    s.PatientInfo.Study=cds.PatientInfo.Study;
                end
                if isfield(cds.PatientInfo,'Task')
                    s.PatientInfo.Task=cds.PatientInfo.Task;
                end
                if isfield(cds.PatientInfo,'Time')
                    s.PatientInfo.Time=cds.PatientInfo.Time;
                end
                if isfield(cds.PatientInfo,'Location')
                    s.PatientInfo.Location=cds.PatientInfo.Location;
                end
            end
            
        end
        
        function s=readFromMEDF(medf)
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
                                    
                                    cprintf('yellow','The length of data in medf file is not consistent !');
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
                        s.Montage.SampleRate=medf.data.info{1}.sampleRate;
                    end
                    if isfield(medf.data.info{1},'unit')
                        s.Data.Unit.Data=medf.data.info{1}.unit;
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
                        s.Data.Video.timeFrame=medf.info.video.timeFrame;
                    end
                end
            end
            
        end
        function s=readFromOldCDS(oldcds)
            
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
                    s.Montage.SampleRate=oldcds.montage.SampleRate;
                    s.Data.TimeStamps=s.Data.TimeStamps/s.Montage.SampleRate;
                    evts=s.Data.Annotations;
                    evts(:,1)=num2cell(cell2mat(evts(:,1))/s.Montage.SampleRate);
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
                    if isfield(oldcds.patientInfo.Params,'tmExtend')
                        s.PatientInfo.Params.TmExtend=oldcds.patientInfo.Params.tmExtend;
                    end
                    if isfield(oldcds.patientInfo.Params,'tmMinimumData')
                        s.PatientInfo.Params.TmMinimumData=oldcds.patientInfo.Params.tmMinimumData;
                    end
                    if isfield(oldcds.patientInfo.Params,'nDownSample')
                        s.PatientInfo.Params.NDownSample=oldcds.patientInfo.Params.nDownSample;
                        n=s.PatientInfo.Params.NDownSample;
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
        
        function cds=multiImport()
            [FileName,FilePath,FilterIndex]=uigetfile({...
                '*.mat;*.cds;*.cds.old;*.medf','Supported formats (*.mat;*.cds;*.cds.old;*.medf)';...
                '*.cds','common data structure (*.cds)';...
                '*.cds.old','old common data structure (*.cds.old)';...
                '*.medf','matlab edf format (*.medf)'},...
                'Select your data file','data.mat','MultiSelect','on');
            
            if ~iscell(FileName)
                if ~FileName
                    cds=[];
                    return
                else
                    FileName={FileName};
                end
            end
            
            if FilterIndex==1
                s=cell(1,length(FileName));
                for i=1:length(FileName)
                    s{i}=load(fullfile(FilePath,FileName{i}),'-mat');
                    
                    FilterIndex(i)=CommonDataStructure.dataStructureCheck(s{i});
                end
            else
                FilterIndex=ones(1,length(FileName))*FilterIndex;
            end
            
            cds=cell(1,length(FilterIndex));
            for i=1:length(FileName)
                cds{i}=CommonDataStructure();
            end
            
            for i=1:length(FileName)
            switch FilterIndex(i)
                case 2
                    tmp=load(fullfile(FilePath,FileName{i}),'-mat');
                    cds{i}.assign(CommonDataStructure.readFromCDS(tmp));
                    
                case 3
                    
                    tmp=load(fullfile(FilePath,FileName{i}),'-mat');
                    cds{i}.assign(CommonDataStructure.readFromOldCDS(tmp));
                    
                case 4
                    
                    tmp=load(fullfile(FilePath,FileName{i}),'-mat');
                    cds{i}.assign(CommonDataStructure.readFromMEDF(tmp));
                    
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

