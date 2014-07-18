function gainChangeSelectedChannels(obj)
%hightlight the selection on channels
dd=obj.DisplayedData;
t=ceil(obj.Time*obj.SRate+1):min(ceil((obj.Time+obj.WinLength)*obj.SRate),size(obj.Data{1},1));

if obj.IsChannelSelected
    for i=1:length(dd)
        gainChangeChannels(dd(i),obj.PreprocData{dd(i)}(t,:),obj.Gain{dd(i)},obj.MontageChanNumber(dd(i)):-1:1,obj.ChannelLines{dd(i)},...
            obj.ChanSelect2Display{dd(i)},obj.FirstDispChans(dd(i)),obj.DispChans(dd(i)),obj.ChanSelect2Edit{dd(i)});
    end
else
    
    for i=1:length(dd)
        gainChangeChannels(dd(i),obj.PreprocData{dd(i)}(t,:),obj.Gain{dd(i)},obj.MontageChanNumber(dd(i)):-1:1,obj.ChannelLines{dd(i)},...
            obj.ChanSelect2Display{dd(i)},obj.FirstDispChans(dd(i)),obj.DispChans(dd(i)),obj.ChanSelect2Display{dd(i)});
    end
end
end

function gainChangeChannels(dataNum,data,gain,posY,ChannelLines,ChanSelect2Display,FirstDispChan,...
    DispChans,ChanSelect2Edit)
if ~isempty(FirstDispChan)&&~isempty(DispChans)
    if ~isempty(ChanSelect2Display)
        ChanSelect2Display=intersect(ChanSelect2Display,round(FirstDispChan:FirstDispChan+DispChans-1));
    else
        ChanSelect2Display=intersect(1:size(obj.PreprocData{dataNum},2),round(FirstDispChan:FirstDispChan+DispChans-1));
    end
end

%make zero gain channel disappear
gain(gain==0)=nan;

if ~isempty(ChanSelect2Display)
    data=data(:,ChanSelect2Display).*...
        repmat(reshape(gain(ChanSelect2Display),1,length(ChanSelect2Display)),size(data(:,ChanSelect2Display),1),1);
    posY=posY(ChanSelect2Display);
    [f,ChanSelect2Edit]=ismember(ChanSelect2Edit,ChanSelect2Display);
    
else
    data=data.*repmat(reshape(gain,1,length(gain)),size(data,1),1);
end
data=data+(posY'*ones(1,size(data,1)))';

y=[data;NaN*ones(1,size(data,2))];

if ~isempty(ChanSelect2Edit)
    ChanInd=ChanSelect2Edit(ChanSelect2Edit~=0);
    for i=1:length(ChanInd)
        set(ChannelLines(ChanInd(i)),'YData',y(:,ChanInd(i)));
    end
end



end





