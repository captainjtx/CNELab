function ExportDataToWorkspace(obj)

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

for i=1:length(dd)
    cds=CommonDataStructure;
    
    cds.Data.Data=data(1:downsample:end,dataset==dd(i));
    cds.Data.Annotations=evts;
    cds.Data.SampleRate=obj.SRate/downsample;
    cds.Data.Units=obj.Units{dd(i)};
    cds.Data.VideoName=obj.VideoFile;
    cds.Data.TimeStamps=linspace(0,obj.DataTime,size(cds.Data.Data,1))+obj.StartTime;
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
    if ~isempty(pos)
        cds.Montage.ChannelPosition=pos(dataset==dd(i),:);
    else
        cds.Montage.ChannelPosition=[];
    end
    
    cds.export2workspace(['selection_',num2str(dd(i))]);
end
end

