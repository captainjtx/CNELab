function SaveData(obj,src)
if src==obj.MenuSaveSettings
    [chanNames,dataset,~,~,evts,groupnames,pos]=get_datainfo(obj,false);
    for i=1:length(obj.CDS)
        if obj.CDS{i}.file_type==2
            if ~isempty(pos)
                chanpos=pos(dataset==i,:);
            else
                chanpos=[];
            end
            
            CommonDataStructure.write_file_info(obj.CDS{i},...
                'SampleRate',obj.SRate,...
                'Annotations',obj.Evts,...
                'ChannelNames',chanNames(dataset==i),...
                'GroupNames',groupnames(dataset==i),...
                'MontageName',obj.Montage{i}(obj.MontageRef(i)).name,...
                'MaskChanNames',obj.MontageChanNames{i}(obj.Mask{i}==0),...
                'ChannelPosition',chanpos);
        else
            
        end
    end
elseif src==obj.MenuSaveData
    %this will save all files, if there are too many files, it would be
    %better to save needed files
    for i=1:length(obj.CDS)
        if isempty(obj.CDS{i}.DataInfo.FileSample)
            fileinfo=CommonDataStructure.get_file_info(obj.CDS{i});
            filesample=fileinfo.filesample;
        else
            filesample=obj.CDS{i}.DataInfo.FileSample;
        end
        
        for f=1:size(filesample,1)
            data=CommonDataStructure.get_data_by_start_end(obj.CDS{i},filesample(f,1),filesample(f,2));
            p_data=preprocessedData(obj,i,data);
            obj.CDS{i}.write_data_by_start_end(p_data,filesample(f,1));
        end
    end
else
    [data,chanNames,dataset,~,~,evts,groupnames,pos]=get_selected_data(obj);
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
            
            cds.Data.Data=data(1:downsample:end,dataset==dd(i));
            cds.Data.Annotations=evts;
            cds.Data.SampleRate=obj.SRate/downsample;
            cds.Data.Units=obj.Units{dd(i)};
            cds.Data.VideoName=obj.VideoFile;
            cds.Data.TimeStamps=linspace(0,obj.DataTime,size(cds.Data.Data,1));
            cds.Data.FileName=obj.FileNames{dd(i)};
            cds.Data.NextFile=obj.NextFiles{dd(i)};
            cds.Data.PrevFile=obj.PrevFiles{dd(i)};
            
            cds.Data.Video.StartTime=obj.VideoStartTime;
            cds.Data.Video.TimeFrame=obj.VideoTimeFrame;
            cds.Data.Video.NumberOfFrame=obj.NumberOfFrame;
            
            cds.Montage.ChannelNames=chanNames(dataset==dd(i));
            cds.Montage.Name=obj.Montage{dd(i)}(obj.MontageRef(dd(i))).name;
            cds.Montage.GroupNames=groupnames(dataset==dd(i));
            cds.Montage.MaskChanNames=obj.MontageChanNames{dd(i)}(obj.Mask{dd(i)}==0);
            if ~isempty(pos)
                cds.Montage.ChannelPosition=pos(dataset==dd(i),:);
            else
                cds.Montage.ChannelPosition=[];
            end
            
            cds.save('title',['DataSet-',num2str(dd(i))]);
        end
        
    elseif src==obj.MenuSaveAsMergeData
        
        cds=CommonDataStructure;
        
        cds.Data.Data=data(1:downsample:end,:);
        cds.Data.Annotations=evts;
        cds.Data.SampleRate=obj.SRate/downsample;
        units=obj.Units{dd(1)};
        for i=2:length(dd)
            units=cat(2,units,obj.Units{dd(i)});
        end
        cds.Data.Units=units;
        
        cds.Data.VideoName=obj.VideoFile;
        cds.Data.TimeStamps=linspace(0,obj.DataTime,size(cds.Data.Data,1));
        cds.Data.FileName=obj.FileNames{dd(1)};
        cds.Data.NextFile=obj.NextFiles{dd(1)};
        cds.Data.PrevFile=obj.PrevFiles{dd(1)};
        
        cds.Data.Video.StartTime=obj.VideoStartTime;
        cds.Data.Video.TimeFrame=obj.VideoTimeFrame;
        cds.Data.Video.NumberOfFrame=obj.NumberOfFrame;
        
        cds.Montage.ChannelNames=chanNames;
        cds.Montage.Name=obj.Montage{dd(1)}(obj.MontageRef(dd(1))).name;
        cds.Montage.GroupNames=groupnames;
        cds.Montage.ChannelPosition=pos;
        
        maskchan=obj.MontageChanNames{dd(1)}(obj.Mask{dd(1)}==0);
        for i=2:length(dd)
            maskchan=cat(2,maskchan,obj.MontageChanNames{dd(i)}(obj.Mask{dd(i)}==0));
        end
        
        cds.Montage.MaskChanNames=maskchan;
        
        cds.save('title','Merged Data');
    end
end
end

