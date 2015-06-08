function [data,chanNames,dataset,channel,sample,evts,groupnames]=get_selected_data(obj)
%This function returns the selected data and the corresponding channel
%names

%obj.Selection format
%|sta_1,sta_2,...|
%|end_1,end_2,...|

dd=obj.DisplayedData;
data=[];
selection=[];
dataset=[];
channel=[];
events=[];
evts=[];

fs=obj.SRate;

if ~isempty(obj.Evts_)
    
    EventsList=obj.Evts_(obj.Evts2Display,:);
    
    if ~isempty(EventsList)
        EventsList=sortrows(EventsList,1);
    end
    
    events=EventsList(:,1:2);
end

if ~isempty(obj.Selection)
    [tmp,ind]=sort(obj.Selection(1,:));
    SelectionSort=obj.Selection(:,ind);
    interval=0;
    for i=1:size(SelectionSort,2)
        startInd=max(1,SelectionSort(1,i));
        endInd=min(size(obj.Data{1},1),SelectionSort(2,i));
        
        if ~isempty(events)
            if i==1
                interval=startInd/fs;
            else
                interval=interval+(startInd-SelectionSort(2,i-1))/fs;
            end
            
            ind=find(round([events{:,1}]*fs)>=startInd&round([events{:,1}]*fs)<=endInd);
            for k=1:length(ind)
                evts=cat(1,evts,{events{ind(k),1}-interval,events{ind(k),2}});
            end
        end
        
        
        selection=cat(2,selection,startInd:endInd);
    end
      
else
    selection=1:size(obj.Data{1},1);
    evts=events;
end
sample=selection;
chanNames={};
groupnames={};
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
    groupnames=cat(1,groupnames,obj.Montage{dd(i)}(obj.MontageRef(dd(i))).groupnames(chan));
end

end

