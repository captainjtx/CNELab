function SaveData(obj)

dd=obj.DisplayedData;
fs=obj.SRate;
selection=[];

if ~isempty(obj.Selection)
    for i=1:size(obj.Selection,2)
        startInd=max(1,obj.Selection(1,i));
        endInd=min(size(obj.Data{1},1),obj.Selection(2,i));
        selection=cat(1,selection,startInd:endInd);
    end
else
    selection=1:size(obj.Data{1},1);
end

for i=1:length(dd)
    
    cds=CommonDataStructure;
    
    
    if ~obj.IsChannelSelected
        chan=1:obj.MontageChanNumber(dd(i));
    else
        chan=obj.ChanSelect2Edit{dd(i)};
    end
    d=obj.PreprocData{dd(i)}(selection,chan);
    %     chanNames=catreshape(obj.MontageChanNames{dd(i)}(chan),length(chan),1);
    
    Events=[];
    if ~isempty(obj.Evts_)
        
        EventsList=obj.Evts_(obj.Evts2Display,:);
        
        if ~isempty(EventsList)
            EventsList=sortrows(EventsList,1);
        else
            EventsList=[];
        end
        
        Events=EventsList(:,1:2);
        for evt=1:size(Events,1)
            Events{evt,1}=Events{evt,1}+obj.StartTime;
        end
    end
    
    cds.Data.Data=d;
    cds.Data.Annotations=Events;
    cds.Data.SampleRate=obj.SRate;
    cds.Data.Units=obj.Units{dd(i)};
    cds.Data.VideoName=obj.VideoFile;
    cds.Data.TimeStamps=linspace(0,obj.DataTime,size(obj.Data{1},1))+obj.StartTime;
    cds.Data.FileName=obj.FileNames{dd(i)};
    
    cds.Data.Video.StartTime=obj.VideoStartTime;
    cds.Data.Video.TimeFrame=obj.VideoTimeFrame;
    
    cds.Montage.ChannelNames=obj.MontageChanNames{dd(i)}(chan);
    cds.Montage.Name=obj.Montage{dd(i)}(obj.MontageRef(dd(i))).name;
    cds.Montage.GroupNames=obj.Montage{dd(i)}(obj.MontageRef(dd(i))).groupnames;
    cds.save('title',['DataSet-',num2str(dd(i))]);
end

end
