function ExportData(obj)

[FileName,FilePath]=uiputfile({...
    '*.mat','Binary Matlab File (*.mat)'}...
    ,'Save the data','data');

if ~FileName
    return
end

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
    if ~obj.IsChannelSelected
        chan=1:obj.MontageChanNumber(dd(i));
    else
        chan=obj.ChanSelect2Edit{dd(i)};
    end
    d=preprocessedAllData(obj,dd(i),chan,selection);
%     chanNames=catreshape(obj.MontageChanNames{dd(i)}(chan),length(chan),1);
    cds.(['data' num2str(dd(i))])=d;
end

save(fullfile(FilePath,FileName),'-struct','cds','-mat');


end
