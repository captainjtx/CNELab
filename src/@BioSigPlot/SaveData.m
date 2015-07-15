function SaveData(obj)

[data,chanNames,dataset,channel,sample,evts,groupnames]=get_selected_data(obj);
dd=unique(dataset);

for i=1:length(dd)
    cds=CommonDataStructure;
    
    cds.Data.Data=data(:,dataset==dd(i));
    cds.Data.Annotations=evts;
    cds.Data.SampleRate=obj.SRate;
    cds.Data.Units=obj.Units{dd(i)};
    cds.Data.VideoName=obj.VideoFile;
    cds.Data.TimeStamps=linspace(0,obj.DataTime,size(obj.Data{1},1))+obj.StartTime;
    cds.Data.FileName=obj.FileNames{dd(i)};
    cds.Data.NextFile=obj.
    cds.Data.PrevFile=obj.
    
    cds.Data.Video.StartTime=obj.VideoStartTime;
    cds.Data.Video.TimeFrame=obj.VideoTimeFrame;
    cds.Data.Video.NumberOfFrame=obj.NumberOfFrame;
    
    cds.Montage.ChannelNames=chanNames(dataset==dd(i));
    cds.Montage.Name=obj.Montage{dd(i)}(obj.MontageRef(dd(i))).name;
    cds.Montage.GroupNames=groupnames;
    cds.Montage.MaskChanNames=obj.MontageChanNames{dd(i)}(obj.Mask{dd(i)}==0);
    
    cds.save('title',['DataSet-',num2str(dd(i))]);
end

end

