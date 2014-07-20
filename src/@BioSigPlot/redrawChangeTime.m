function redrawChangeTime(obj)
dd=obj.DisplayedData;
t=round(max(1,obj.Time*obj.SRate+1):min((obj.Time+obj.WinLength)*obj.SRate,size(obj.Data{1},1)));

for i=1:length(dd)
    if ~isempty(obj.PreprocData)
        Nchan=obj.MontageChanNumber(dd(i));
        updateChannelLines(obj.ChannelLines{dd(i)},t-t(1)+1,obj.PreprocData{dd(i)}(t,:),...
            obj.Gain{dd(i)},Nchan:-1:1,obj.ChanSelect2Display{dd(i)},...
            obj.FirstDispChans(dd(i)),obj.DispChans(dd(i)));
        if length(obj.Axes)==1
            axe=obj.Axes;
        else
            axe=obj.Axes(dd(i));
        end
        plotXTicks(axe,obj.Time,obj.WinLength)
    end
end

end

function updateChannelLines(channellines,t,data,gain,posY,ChanSelect2Display,FirstDispChan,DispChans)

if ~isempty(FirstDispChan)&&~isempty(DispChans)
    if ~isempty(ChanSelect2Display)
        ChanSelect2Display=intersect(ChanSelect2Display,round(FirstDispChan:FirstDispChan+DispChans-1));
    else
        ChanSelect2Display=intersect(1:size(data,2),round(FirstDispChan:FirstDispChan+DispChans-1));
    end
end
%make zero gain channel disappear
gain(gain==0)=nan;

if ~isempty(ChanSelect2Display)
    data=data(:,ChanSelect2Display).*...
        repmat(reshape(gain(ChanSelect2Display),1,length(ChanSelect2Display)),size(data(:,ChanSelect2Display),1),1);
    posY=posY(ChanSelect2Display);
else
    data=data.*repmat(reshape(gain,1,length(gain)),size(data,1),1);
end


data=data+(posY'*ones(1,size(data,1)))';

t=linspace(t(1),t(end),size(data,1));

x=[t NaN]'*ones(1,size(data,2));

y=[data;NaN*ones(1,size(data,2))];

for i=1:length(channellines)
    set(channellines(i),'XData',x(:,i));
    set(channellines(i),'YData',y(:,i));
end

end
function plotXTicks(axe,time,WinLength)
% Plot X ticks
% axe :  axes to plot
% time : starting time
% WinLength :  window time lentgth

h=findobj(axe,'-regexp','DisplayName','XTick*');
if ~isempty(h)
    delete(h);
end
for i=time:time+WinLength-1
    p=(i-time)/WinLength;
    text(p+.002,.002,num2str(i),'Parent',axe,'HorizontalAlignment','left',...
        'VerticalAlignment','bottom','FontWeight','normal','units','normalized',...
        'color',[0 0 1],'DisplayName',['XTick',num2str(i)]);
end

end
