function gainChangeSelectedChannels(obj)
%hightlight the selection on channels
dd=obj.DisplayedData;

ind_max=size(obj.PreprocData{dd(1)},1);
ind_start=max(1,min(round((obj.Time-obj.BufferTime)*obj.SRate+1),ind_max));
ind_end=min(round((obj.Time-obj.BufferTime+obj.WinLength)*obj.SRate+1),ind_max);
ind=ind_start:ind_end;

ind=ind(1:obj.VisualDownSample:end);
if isempty(ind)
    return
end
if obj.IsChannelSelected
    for i=1:length(dd)
        if isempty(obj.Gain(dd(i)))
            continue
        end
        if length(obj.Axes)==1
            axes=obj.Axes;
        else
            axes=obj.Axes(dd(i));
        end
        gainChangeChannels(axes,dd(i),obj.PreprocData{dd(i)}(ind,:),obj.Gain{dd(i)},obj.Mask{dd(i)},obj.MontageChanNumber(dd(i)):-1:1,obj.ChannelLines{dd(i)},...
            obj.ChanSelect2Display{dd(i)},obj.FirstDispChans(dd(i)),obj.DispChans(dd(i)),obj.ChanSelect2Edit{dd(i)});
        
    end
else
    
    for i=1:length(dd)
        
        if isempty(obj.Gain(dd(i)))
            continue
        end
        if length(obj.Axes)==1
            axes=obj.Axes;
        else
            axes=obj.Axes(dd(i));
        end
        gainChangeChannels(axes,dd(i),obj.PreprocData{dd(i)}(ind,:),obj.Gain{dd(i)},obj.Mask{dd(i)},obj.MontageChanNumber(dd(i)):-1:1,obj.ChannelLines{dd(i)},...
            obj.ChanSelect2Display{dd(i)},obj.FirstDispChans(dd(i)),obj.DispChans(dd(i)),obj.ChanSelect2Display{dd(i)});
        
    end
end

end

function gainChangeChannels(axes,dataNum,data,gain,mask,posY,ChannelLines,ChanSelect2Display,FirstDispChan,...
    DispChans,ChanSelect2Edit)

if ~isempty(FirstDispChan)&&~isempty(DispChans)
    if ~isempty(ChanSelect2Display)
        ChanSelect2Display=intersect(ChanSelect2Display,round(FirstDispChan:FirstDispChan+DispChans-1));
    else
        ChanSelect2Display=intersect(1:size(obj.PreprocData{dataNum},2),round(FirstDispChan:FirstDispChan+DispChans-1));
    end
end

gain(isnan(gain))=1;
%make zero gain channel disappear
gain(mask==0)=nan;

if ~isempty(ChanSelect2Display)
    data=data(:,ChanSelect2Display).*...
        repmat(reshape(gain(ChanSelect2Display),1,length(ChanSelect2Display)),size(data(:,ChanSelect2Display),1),1);
    posY=posY(ChanSelect2Display);
    [f,ChanSelect2Edit]=ismember(ChanSelect2Edit,ChanSelect2Display);
    
else
    data=data.*repmat(reshape(gain,1,length(gain)),size(data,1),1);
end
data=data+(posY'*ones(1,size(data,1)))';

% y=[data;NaN*ones(1,size(data,2))];

if ~isempty(ChanSelect2Edit)
    ChanInd=ChanSelect2Edit(ChanSelect2Edit~=0);
    for i=1:length(ChanInd)
        set(ChannelLines(ChanInd(i)),'YData',data(:,ChanInd(i)));
        h=findobj(axes,'DisplayName',['YGauge' num2str(ChanInd(i))]);
        set(h,'String',num2str(1/gain(ChanInd(i)+FirstDispChan-1),'%0.3g'));
    end
end

end





