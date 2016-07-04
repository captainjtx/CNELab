function [data,chanNames,dataset,channel,sample,evts,groupnames,pos,segment]=get_selected_data(obj,varargin)
%This function returns the selected data and the corresponding channel
%names

%bsp_selection format
%|sta_1,sta_2,...|
%|end_1,end_2,...|

%get_selected_data(obj,omitMask,cat_output)

dd=obj.DisplayedData;
data=[];
selection=[];
dataset=[];
channel=[];
events=[];
evts=[];
sorted_bsp_selection=[];

bsp_selection=obj.Selection;

fs=obj.SRate;

omitMask=false;

if nargin>1
    omitMask=varargin{1};
end

if nargin>2
    bsp_selection=varargin{2};
end
    
if ~isempty(obj.Evts_)
    
    EventsList=obj.Evts_(obj.Evts2Display,:);
    
    if ~isempty(EventsList)
        EventsList=sortrows(EventsList,1);
    end
    
    events=EventsList(:,1:2);
end

if ~isempty(bsp_selection)
    [tmp,sort_ind]=sort(bsp_selection(1,:));
    SelectionSort=bsp_selection(:,sort_ind);
    interval=0;
    for i=1:size(SelectionSort,2)
        startInd=max(1,SelectionSort(1,i));
        endInd=min(floor(obj.TotalTime*fs),SelectionSort(2,i));
        
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
        sorted_bsp_selection=cat(2,sorted_bsp_selection,[startInd;endInd]);
    end
      
else
    selection=1:obj.TotalSample;
    sorted_bsp_selection=[1;selection(end)];
    evts=events;
    sort_ind=1;
end
sample=selection;
chanNames={};
groupnames={};
pos=[];

for i=1:length(dd)
    if ~obj.IsChannelSelected
        chan=1:obj.MontageChanNumber(dd(i));
    else
        chan=obj.ChanSelect2Edit{dd(i)};
        chan=sort(chan);
    end
    
    if isempty(chan)
        continue
    end
    
    if omitMask
       %Omit the mask channels
       if ~isempty(obj.Mask{dd(i)})
           chan=intersect(find(obj.Mask{dd(i)}~=0),chan);
       end
    end
    
    needfilter=any(sorted_bsp_selection(1,:)<obj.BufferStartSample)||any(sorted_bsp_selection(2,:)>obj.BufferEndSample);
    if needfilter
        alldata=CommonDataStructure.get_data_segment(obj.CDS{dd(i)},selection,[]);
        alldata=alldata*(obj.Montage{dd(i)}(obj.MontageRef(dd(i))).mat)';
        alldata=alldata(:,chan);
    else
        %if all ready loaded into the buffer, no need to reload from the
        %file
        selection=selection-obj.BufferStartSample+1;
        alldata=obj.PreprocData{dd(i)}(selection,chan);
    end
    %filter before merge trial segments
    count=1;
    d=[];
    seg=[];
    for t=1:size(sorted_bsp_selection,2)
        len=sorted_bsp_selection(2,t)-sorted_bsp_selection(1,t)+1;
        if needfilter
            tmpd=preprocessedData(obj,dd(i),alldata(count:count+len-1,:));
        else
            tmpd=alldata(count:count+len-1,:);
        end
        d=cat(1,d,tmpd);
        seg=cat(1,seg,sort_ind(t)*ones(length(tmpd),1));
        count=count+sorted_bsp_selection(2,t)-sorted_bsp_selection(1,t)+1;
    end

    dataset=cat(2,dataset,dd(i)*ones(1,size(d,2)));
    channel=cat(2,channel,reshape(chan,1,length(chan)));
    data=cat(2,data,d);
    
    chanNames=cat(1,chanNames,reshape(obj.MontageChanNames{dd(i)}(chan),length(obj.MontageChanNames{dd(i)}(chan)),1));
    if ~isempty(obj.Montage{dd(i)}(obj.MontageRef(dd(i))).groupnames)
        groupnames=cat(1,groupnames,obj.Montage{dd(i)}(obj.MontageRef(dd(i))).groupnames(chan));
    else
        default_name=cell(length(chan),1);
        for gn=1:length(default_name)
            default_name{gn}='Default';
        end
        groupnames=cat(1,groupnames,default_name);
    end
    
    if ~isempty(obj.Montage{dd(i)}(obj.MontageRef(dd(i))).position)
        pos=cat(1,pos,obj.Montage{dd(i)}(obj.MontageRef(dd(i))).position(chan,:));
    else
        pos=cat(1,pos,ones(length(chan),3)*nan);
    end
end

segment=seg;

end

