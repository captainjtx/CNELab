function SaveData(obj,src)

[data,chanNames,dataset,channel,sample,evts,groupnames,pos]=get_selected_data(obj);
dd=unique(dataset);

switch src
    case obj.MenuSaveData
        for i=1:length(dd)
            cds=CommonDataStructure;
            
            cds.Data.Data=data(:,dataset==dd(i));
            cds.Data.Annotations=evts;
            cds.Data.SampleRate=obj.SRate;
            cds.Data.Units=obj.Units{dd(i)};
            cds.Data.VideoName=obj.VideoFile;
            cds.Data.TimeStamps=linspace(0,obj.DataTime,size(obj.Data{1},1))+obj.StartTime;
            cds.Data.FileName=obj.FileNames{dd(i)};
            cds.Data.NextFile=obj.NextFiles{dd(i)};
            cds.Data.PrevFile=obj.PrevFiles{dd(i)};
            
            cds.Data.Video.StartTime=obj.VideoStartTime;
            cds.Data.Video.TimeFrame=obj.VideoTimeFrame;
            cds.Data.Video.NumberOfFrame=obj.NumberOfFrame;
            
            cds.Montage.ChannelNames=chanNames(dataset==dd(i));
            cds.Montage.Name=obj.Montage{dd(i)}(obj.MontageRef(dd(i))).name;
            cds.Montage.GroupNames=groupnames;
            cds.Montage.MaskChanNames=obj.MontageChanNames{dd(i)}(obj.Mask{dd(i)}==0);
            cds.Montage.ChannelPosition=pos(dataset==dd(i),:);
            
            cds.save('title',['DataSet-',num2str(dd(i))]);
        end
        
    case obj.MenuMergeData
        
        cds=CommonDataStructure;
        
        cds.Data.Data=data;
        cds.Data.Annotations=evts;
        cds.Data.SampleRate=obj.SRate;
        units=obj.Units{dd(1)};
        for i=2:length(dd)
            units=cat(2,units,obj.Units{dd(i)});
        end
        cds.Data.Units=units;
        
        cds.Data.VideoName=obj.VideoFile;
        cds.Data.TimeStamps=linspace(0,obj.DataTime,size(obj.Data{1},1))+obj.StartTime;
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

