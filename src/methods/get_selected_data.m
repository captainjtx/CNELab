function [data,chanNames,dataset,channel,sample]=get_selected_data(obj)
%This function returns the selected data and the corresponding channel
%names
dd=obj.DisplayedData;
fs=obj.SRate;
data=[];
selection=[];
dataset=[];
channel=[];

if ~isempty(obj.Selection)
    for i=1:size(obj.Selection,2)
        startInd=max(1,round(obj.Selection(1,i)*fs));
        endInd=min(size(obj.Data{1},1),round(obj.Selection(2,i)*fs));
        selection=cat(1,selection,startInd:endInd);
    end
else
    selection=1:size(obj.Data{1},1);
end
sample=selection;
chanNames={};
for i=1:length(dd)
    if ~obj.IsChannelSelected
        chan=1:obj.MontageChanNumber(dd(i));
    else
        chan=obj.ChanSelect2Edit{dd(i)};
        chan=sort(chan);
    end
    d=obj.PreprocData{dd(i)}(selection,chan);
    dataset=cat(2,dataset,dd(i)*ones(1,size(d,2)));
    channel=cat(2,channel,reshape(chan,1,length(chan)));
    data=cat(2,data,d);
    
    chanNames=cat(1,chanNames,obj.MontageChanNames{dd(i)}(chan));
end

end

