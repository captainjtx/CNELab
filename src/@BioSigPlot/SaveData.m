function SaveData(obj,src)
if src==obj.MenuSaveSettings
    for i=1:length(obj.CDS)
        if obj.CDS{i}.file_type==2
            CommonDataStructure.write_file_info(obj.CDS{i},...
                'SampleRate',obj.SRate,...
                'Annotations',obj.Evts,...
                'MaskChanNames',obj.MontageChanNames{i}(obj.Mask{i}==0),...
                'VideoName',obj.VideoFile,...
                'VideoStartTime',obj.VideoStartTime,...
                'VideoEndTime',obj.VideoEndTime);
            %                 'ChannelNames',chanNames(dataset==i),...
            %                 'GroupNames',groupnames(dataset==i),...
            %                 'MontageName',obj.Montage{i}(obj.MontageRef(i)).name,...
        else
            
        end
    end
elseif src==obj.MenuSavePosition
    [~,dataset,~,~,~,~,pos]=get_datainfo(obj,false);
    for i=1:length(obj.CDS)
        if obj.CDS{i}.file_type==2
            if ~isempty(pos)
                chanpos=pos(dataset==i,:);
            else
                chanpos=[];
            end  
            
            CommonDataStructure.write_file_info(obj.CDS{i},...
                'ChannelPosition',chanpos);
        else
            
        end
    end
elseif src==obj.MenuSaveEvents
    for i=1:length(obj.CDS)
        if obj.CDS{i}.file_type==2
            CommonDataStructure.write_file_info(obj.CDS{i},...
                'Annotations',obj.Evts);        
        else
        end
    end
elseif src==obj.MenuSaveData
    %this will save all files, if there are too many files, it would be
    %better to save needed files
    
    [chanNames,dataset,~,~,~,~,~]=get_datainfo(obj,false);
    for i=1:length(obj.CDS)
        fileinfo=CommonDataStructure.get_file_info(obj.CDS{i});
        filesample=fileinfo.filesample;
        
        if all(ismember(fileinfo.channelnames,chanNames(dataset==i)))&&...
                all(ismember(chanNames(dataset==i),fileinfo.channelnames))
            for f=1:size(filesample,1)
                data=CommonDataStructure.get_data_by_start_end(obj.CDS{i},filesample(f,1),filesample(f,2));
                p_data=preprocessedData(obj,i,data);
                obj.CDS{i}.write_data_by_start_end(p_data,filesample(f,1));
            end
        else
            errordlg('Selected data has different channel names with the original one !');
        end
    end
else
    [data,chanNames,dataset,channel,~,evts,groupnames,pos]=get_selected_data(obj);
    dd=unique(dataset);
    
    downsample=1;
    if obj.DownSample~=1
        choice=questdlg( sprintf('Are you sure you wanna DOWNSAMPLE the data by %d ?',obj.DownSample),'CNELab','Yes','No','No');
        
        if strcmpi(choice,'Yes')
            downsample=obj.DownSample;
            %applying low pass filter
            freq=obj.SRate/downsample/2*0.95;
            order=3;
            
            [b,a]=butter(order,freq/(obj.SRate/downsample/2),'low');
            data=filter_symmetric(b,a,data,obj.SRate/downsample,0,'iir');
        end
    end
    
    if src==obj.MenuSaveAsData
        for i=1:length(dd)
            cds=CommonDataStructure;
            
            cds.Data=data(1:downsample:end,dataset==dd(i));
            cds.DataInfo.Annotations=evts;
            cds.DataInfo.SampleRate=obj.SRate/downsample;
%             cds.DataInfo.Units=obj.Units{dd(i)}(channel);
            cds.DataInfo.VideoName=obj.VideoFile;
            cds.DataInfo.TimeStamps=linspace(0,obj.DataTime,size(cds.Data,1));
            
            cds.DataInfo.Video.StartTime=obj.VideoStartTime;
            cds.DataInfo.Video.TimeFrame=obj.VideoTimeFrame;
            cds.DataInfo.Video.NumberOfFrame=obj.NumberOfFrame;
            
            cds.Montage.ChannelNames=chanNames(dataset==dd(i));
            cds.Montage.Name=obj.Montage{dd(i)}(obj.MontageRef(dd(i))).name;
            cds.Montage.GroupNames=groupnames(dataset==dd(i));
            cds.Montage.MaskChanNames=obj.MontageChanNames{dd(i)}(obj.Mask{dd(i)}==0);
            if ~isempty(pos)
                cds.Montage.ChannelPosition=pos(dataset==dd(i),:);
            else
                cds.Montage.ChannelPosition=[];
            end
            
            cds.save('title',['DataSet-',num2str(dd(i))],'folders',false);
        end
        
    elseif src==obj.MenuSaveAsMergeData
        
        cds=CommonDataStructure;
        
        cds.Data=data(1:downsample:end,:);
        cds.DataInfo.Annotations=evts;
        cds.DataInfo.SampleRate=obj.SRate/downsample;
        units=obj.Units{dd(1)};
        for i=2:length(dd)
            units=cat(2,units,obj.Units{dd(i)});
        end
%         cds.DataInfo.Units=units;
        
        cds.DataInfo.VideoName=obj.VideoFile;
        cds.DataInfo.TimeStamps=linspace(0,obj.DataTime,size(cds.Data,1));
        
        cds.DataInfo.Video.StartTime=obj.VideoStartTime;
        cds.DataInfo.Video.TimeFrame=obj.VideoTimeFrame;
        cds.DataInfo.Video.NumberOfFrame=obj.NumberOfFrame;
        
        cds.Montage.ChannelNames=chanNames;
        cds.Montage.Name=obj.Montage{dd(1)}(obj.MontageRef(dd(1))).name;
        cds.Montage.GroupNames=groupnames;
        cds.Montage.ChannelPosition=pos;
        
        maskchan=obj.MontageChanNames{dd(1)}(obj.Mask{dd(1)}==0);
        for i=2:length(dd)
            maskchan=cat(2,maskchan,obj.MontageChanNames{dd(i)}(obj.Mask{dd(i)}==0));
        end
        
        cds.Montage.MaskChanNames=maskchan;
        
        cds.save('title','Merged Data','folders',false);
    elseif src==obj.MenuSaveAsEDF
        data=data(1:downsample:end,:);
        
        header.samplingrate=obj.SRate/downsample;
        header.channels=chanNames;
        if isempty(obj.RecordingTime)
            t=datetime('now');
        else
            t=obj.RecordingTime;
        end
        
        header.year=t.Year;
        header.month=t.Month;
        header.day=t.Day;
        header.hour=t.Hour;
        header.minute=t.Minute;
        header.second=t.Second;
        
        [FileName,FilePath]=uiputfile({'*.edf','Europen Data Format (*.edf)'}...
            ,'Save as EDF',obj.FileDir);
        
        if ~FileName
            return
        end
        [~,FileName,~]=fileparts(FileName);
        fnames=fullfile(FilePath,FileName);
        lab_write_edf(fnames,data',header);
    end
end
end

