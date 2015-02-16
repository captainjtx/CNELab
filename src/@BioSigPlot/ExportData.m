function ExportData(obj)

dd=obj.DisplayedData;
fs=obj.SRate;
selection=[];

if ~isempty(obj.Selection)
    for i=1:size(obj.Selection,2)
        startInd=max(1,round(obj.Selection(1,i)*fs));
        endInd=min(size(obj.Data{1},1),round(obj.Selection(2,i)*fs));
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
    cds.Data.Data=d;
    cds.Data.Annotations=obj.Evts;
    cds.Data.SampleRate=obj.SRate;
    cds.Data.Units=obj.Units{dd(i)};
    cds.Data.VideoName=obj.VideoFile;
    cds.Montage.ChannelNames=obj.MontageChanNames{dd(i)}(chan);
    cds.Montage.Name=obj.Montage{dd(i)}(obj.MontageRef).name;
    cds.Montage.GroupNames=obj.Montage{dd(i)}(obj.MontageRef).groupnames;
    cds.export();
end




end

