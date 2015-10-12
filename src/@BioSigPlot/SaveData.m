function SaveData(obj,src)

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

switch src
    case obj.MenuSaveData
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
            cds.Montage.GroupNames=groupnames(dataset==dd(i));
            cds.Montage.MaskChanNames=obj.MontageChanNames{dd(i)}(obj.Mask{dd(i)}==0);
            if ~isempty(pos)
                cds.Montage.ChannelPosition=pos(dataset==dd(i),:);
            else
                cds.Montage.ChannelPosition=[];
            end
            
            cds.save('title',['DataSet-',num2str(dd(i))]);
        end
        
    case obj.MenuMergeData
        
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
        cds.Data.TimeStamps=linspace(0,obj.DataTime,size(cds.Data.Data,1))+obj.StartTime;
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

