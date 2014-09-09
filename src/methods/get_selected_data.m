function [data,chanNames]=get_selected_data(obj)
%This function returns the selected data and the corresponding channel
%names
dd=obj.DisplayedData;
fs=obj.SRate;
data=[];
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

chanNames=[];
for i=1:length(dd)
    if ~obj.IsChannelSelected
        chan=1:obj.MontageChanNumber(dd(i));
    else
        chan=obj.ChanSelect2Edit{dd(i)};
    end
    d=obj.PreprocData{dd(i)}(selection,chan);
    
    data=cat(2,data,d);
    chanNames=cat(2,chanNames,reshape(obj.MontageChanNames{dd(i)}(chan),length(chan),1));
end


end

