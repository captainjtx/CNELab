classdef CommonDataStructure < handle
    %The class definition for common data structure used in CNEL
    %By Tianxiao Jiang
    %jtxinnocence@gmail.com
    %06/03/2014
    
    properties (Access=public)
        CDS
    end
    
    methods
        function obj=CommonDataStructure(varargin)
            if nargin==0
                cds=CommonDataStructure.initial();
                
                obj.CDS=cds;
            end
        end
        
        function delete(obj)
            if ishandle(obj)
                delete(obj);
            end
        end
        
        function export(obj)
            
            cds=obj.CDS;
            
            [FileName,FilePath]=uiputfile('*.cds','Save your common data structure','untitled.cds');
            
            if ~FileName
                return
            end
            save(fullfile(FilePath,FileName),'-struct','cds');
        end
        
        function import(obj)
            
            [FileName,FilePath,FilterIndex]=uigetfile({...
                '*.mat','matlab format (*.mat)';...
                '*.cds','common data structure (*.cds)';...
                '*.cds.old','old common data structure (*.cds.old)';...
                '*.medf','matlab edf format (*.medf)'},...
                'Select your data file','data.mat');
            
            if FilterIndex==1
                s=load(fullfile(FilePath,FileName),'-mat');
                FilterIndex=CommonDataStructure.dataStructureCheck(s);
            end
            switch FilterIndex
                case 2
                    cds=load(fullfile(FilePath,FileName),'-mat');
                    obj.CDS=CommonDataStructure.readFromCDS(cds);
                    
                case 3
                    
                    cds=load(fullfile(FilePath,FileName),'-mat');
                    obj.CDS=CommonDataStructure.readFromOldCDS(cds);
                    
                case 4
                    
                    medf=load(fullfile(FilePath,FileName),'-mat');
                    obj.CDS=CommonDataStructure.readFromMEDF(medf);
                                        
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
        function obj=initial()
            %Auto generate an empty cds
            %Refer to /doc/manual for more information on the data
            %structure
            
            %obj.Data construction
            obj.Data.Data=[];
            obj.Data.Annotations=[];
            obj.Data.Artifact=[];
            obj.Data.TimeStamps=[];
            obj.Data.Unit.Data=[];
            obj.Data.Unit.Stamp=[];
            obj.Data.Video.StartTime=[];
            obj.Data.Video.TimeFrame=[];
            
            %obj.Montage construction
            obj.Montage.ChannelNames=[];
            obj.Montage.GroupNames=[];
            obj.Montage.HeadboxType=[];
            obj.Montage.Amplifier=[];
            obj.Montage.Name=[];
            obj.Montage.Notes=[];
            obj.Montage.SampleRate=[];
            
            %obj.PatientInfo construction
            obj.PatientInfo.Case=[];
            obj.PatientInfo.Experiment=[];
            obj.PatientInfo.Index=[];
            obj.PatientInfo.Params.TmExtend=[];
            obj.PatientInfo.Params.TmMinimumData=[];
            obj.PatientInfo.Params.NDownSample=[];
            obj.PatientInfo.Side=[];
            obj.PatientInfo.Study=[];
            obj.PatientInfo.Task=[];
            obj.PatientInfo.Time=[];
            obj.PatientInfo.Location=[];
        end
        function obj=readFromCDS(cds)
            
            obj=CommonDataStructure.initial();
            
            %obj.data construction
            if isfield(cds,'Data')
                if isfield(cds.Data,'Annotations')
                    obj.Data.Annotations=cds.Data.Annotations;
                end
                if isfield(cds.Data,'Artifact')
                    obj.Data.Artifact=cds.Data.Artifact;
                end
                if isfield(cds.Data,'TimeStamps')
                    obj.Data.TimeStamps=cds.Data.TimeStamps;
                end
                
            end
            
            %obj.Montage construction
            if isfield(cds,'Montage')
                if isfield(cds.Montage,'ChannelNames')
                    obj.Montage.ChannelNames=cds.Montage.ChannelNames;
                end
                if isfield(cds.Montage,'GroupNames')
                    obj.Montage.GroupNames=cds.Montage.GroupNames;
                end
                if isfield(cds.Montage,'HeadboxType')
                    obj.Montage.HeadboxType=cds.Montage.HeadboxType;
                end
                if isfield(cds.Montage,'Amplifier')
                    obj.Montage.Amplifier=cds.Montage.Amplifier;
                end
                if isfield(cds.Montage,'Name')
                    obj.Montage.Name=cds.Montage.Name;
                end
                if isfield(cds.Montage,'Notes')
                    obj.Montage.Notes=cds.Montage.Notes;
                end
                
                if isfield(cds.Montage,'SampleRate')
                    obj.Montage.SampleRate=cds.Montage.SampleRate;
                end
            end
            %obj.PatientInfo construction
            
            if isfield(cds,'PatientInfo')
                if isfield(cds.PatientInfo,'Case')
                    obj.PatientInfo.Case=cds.PatientInfo.Case;
                end
                if isfield(cds.PatientInfo,'Experiment')
                    obj.PatientInfo.Experiment=cds.PatientInfo.Experiment;
                end
                if isfield(cds.PatientInfo,'Index')
                    obj.PatientInfo.Index=cds.PatientInfo.Index;
                end
                if isfield(cds.PatientInfo,'Params')
                    if isfield(cds.PatientInfo.Params,'TmExtend')
                        obj.PatientInfo.Params.TmExtend=cds.PatientInfo.Params.TmExtend;
                    end
                    if isfield(cds.PatientInfo.Params,'TmMinimumData')
                        obj.PatientInfo.Params.TmMinimumData=cds.PatientInfo.Params.TmMinimumData;
                    end
                    if isfield(cds.PatientInfo.Params,'NDownSample')
                        obj.PatientInfo.Params.NDownSample=cds.PatientInfo.Params.NDownSample;
                    end
                end
                if isfield(cds.PatientInfo,'Side')
                    obj.PatientInfo.Side=cds.PatientInfo.Side;
                end
                if isfield(cds.PatientInfo,'Study')
                    obj.PatientInfo.Study=cds.PatientInfo.Study;
                end
                if isfield(cds.PatientInfo,'Task')
                    obj.PatientInfo.Task=cds.PatientInfo.Task;
                end
                if isfield(cds.PatientInfo,'Time')
                    obj.PatientInfo.Time=cds.PatientInfo.Time;
                end
                if isfield(cds.PatientInfo,'Location')
                    obj.PatientInfo.Location=cds.PatientInfo.Location;
                end
            end
            
        end
        
        function obj=readFromMEDF(medf)
            obj=CommonDataStructure.initial();
            
            if isfield(medf,'data')
                if isfield(medf.data,'dataMat')
                    for i=1:length(medf.data.dataMat)
                        try
                            obj.Data.Data(:,i)=reshape(medf.data.dataMat{i},...
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
                        obj.Montage.SampleRate=medf.data.info{1}.sampleRate;
                    end
                    if isfield(medf.data.info{1},'unit')
                        obj.Data.Unit.Data=medf.data.info{1}.unit;
                    end
                    if isfield(medf.data.info{1},'stamp')
                        obj.Data.TimeStamps=medf.data.info{1}.stamp;
                    end
                    
                    for i=1:length(medf.data.info)
                        if isfield(medf.data.info{i},'name')
                            obj.Montage.ChannelNames{i}=medf.data.info{i}.name;
                        end
                    end
                end
            end
            
            if isfield(medf,'info')
                if isfield(medf.info,'studyName')
                    obj.PatientInfo.Task=medf.info.studyName;
                end
                
                if isfield(medf.info,'location')
                    obj.PatientInfo.Location=medf.info.location;
                end
                
                if isfield(medf.info,'device')
                    obj.Montage.Amplifier=medf.info.device;
                end
                
                if isfield(medf.info,'video')
                    if isfield(medf.info.video,'startTime')
                        obj.Data.Video.StartTime=medf.info.video.startTime;
                    end
                    if isfield(medf.info.video,'timeFrame')
                        obj.Data.Video.timeFrame=medf.info.video.timeFrame;
                    end
                end
            end
            
        end
         function obj=readFromOldCDS(cds)
            
            obj=CommonDataStructure.initial();
            
            %obj.data construction
            if isfield(cds,'data')
                if isfield(cds.data,'annotations')
                    obj.Data.Annotations=cds.data.annotations;
                end
                if isfield(cds.data,'artifact')
                    obj.Data.Artifact=cds.data.artifact;
                end
                if isfield(cds.data,'timestamps')
                    obj.Data.TimeStamps=cds.data.timestamps;
                end
                
            end
            
            %obj.Montage construction
            if isfield(cds,'montage')
                if isfield(cds.montage,'ChannelNames')
                    obj.Montage.ChannelNames=cds.montage.ChannelNames;
                end
                if isfield(cds.montage,'GroupNames')
                    obj.Montage.GroupNames=cds.montage.GroupNames;
                end
                if isfield(cds.montage,'HeadboxType')
                    obj.Montage.HeadboxType=cds.montage.HeadboxType;
                end
                if isfield(cds.montage,'Amplifier')
                    obj.Montage.Amplifier=cds.montage.Amplifier;
                end
                if isfield(cds.montage,'Name')
                    obj.Montage.Name=cds.montage.Name;
                end
                if isfield(cds.montage,'Notes')
                    obj.Montage.Notes=cds.montage.Notes;
                end
                
                if isfield(cds.montage,'SampleRate')
                    obj.Montage.SampleRate=cds.montage.SampleRate;
                end
            end
            %obj.PatientInfo construction
            
            if isfield(cds,'patientInfo')
                if isfield(cds.patientInfo,'Case')
                    obj.PatientInfo.Case=cds.patientInfo.Case;
                end
                if isfield(cds.patientInfo,'Experiment')
                    obj.PatientInfo.Experiment=cds.patientInfo.Experiment;
                end
                if isfield(cds.patientInfo,'Index')
                    obj.PatientInfo.Index=cds.patientInfo.Index;
                end
                if isfield(cds.patientInfo,'Params')
                    if isfield(cds.patientInfo.Params,'tmExtend')
                        obj.PatientInfo.Params.TmExtend=cds.patientInfo.Params.tmExtend;
                    end
                    if isfield(cds.patientInfo.Params,'tmMinimumData')
                        obj.PatientInfo.Params.TmMinimumData=cds.patientInfo.Params.tmMinimumData;
                    end
                    if isfield(cds.patientInfo.Params,'nDownSample')
                        obj.PatientInfo.Params.NDownSample=cds.patientInfo.Params.nDownSample;
                    end
                end
                if isfield(cds.patientInfo,'Side')
                    obj.PatientInfo.Side=cds.patientInfo.Side;
                end
                if isfield(cds.patientInfo,'Study')
                    obj.PatientInfo.Study=cds.patientInfo.Study;
                end
                if isfield(cds.patientInfo,'Task')
                    obj.PatientInfo.Task=cds.patientInfo.Task;
                end
                if isfield(cds.patientInfo,'Time')
                    obj.PatientInfo.Time=cds.patientInfo.Time;
                end
                if isfield(cds.patientInfo,'Location')
                    obj.PatientInfo.Location=cds.patientInfo.Location;
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

