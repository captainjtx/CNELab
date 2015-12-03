function redrawChangeBlock(obj,opt)
%This will load new data if necessary
dd=obj.DisplayedData;
ind_max=size(obj.PreprocData{dd(1)},1);
ind_start=max(1,min(round((obj.Time-obj.BufferTime)*obj.SRate+1),ind_max));
ind_end=min(round((obj.Time-obj.BufferTime+obj.WinLength)*obj.SRate+1),ind_max);
ind=ind_start:ind_end;

ind=ind(1:obj.VisualDownSample:end);
if isempty(ind)
    return
end
for i=1:length(dd)
    if ~isempty(obj.PreprocData)
        Nchan=obj.MontageChanNumber(dd(i));
        
        updateChannelLines(obj.ChannelLines{dd(i)},ind-ind(1)+1,obj.PreprocData{dd(i)}(ind,:),...
            obj.Gain{dd(i)},obj.Mask{dd(i)},Nchan:-1:1,obj.ChanSelect2Display{dd(i)},...
            obj.FirstDispChans(dd(i)),obj.DispChans(dd(i)));
        if length(obj.Axes)==1
            axe=obj.Axes;
        else
            axe=obj.Axes(dd(i));
        end
        
        if strcmpi(opt,'channel')
            if any(strcmp(obj.DataView,{'Vertical','Horizontal'}))
                
                if isempty(obj.DispChans) %No elevator
                    ylim=[1-obj.YBorder_(1) Nchan(dd(i))+obj.YBorder_(2)];
                else
                    ylim=[Nchan+2-obj.YBorder_(1)-obj.FirstDispChans(dd(i))-min(Nchan,obj.DispChans(dd(i)))      ...
                        Nchan+obj.YBorder_(2)-obj.FirstDispChans(dd(i))+1];
                end
            else
                if isempty(obj.DispChans)
                    ylim=[0 Nchan+1];
                else
                    %ylim=[obj.FirstDispChans(n)-1 obj.FirstDispChans(n)+obj.DispChans];
                    ylim=[Nchan+2-obj.YBorder_(1)-obj.FirstDispChans(dd(i))-min(obj.DispChans(dd(i)),Nchan)    ...
                        Nchan+obj.YBorder_(2)-obj.FirstDispChans(dd(i))+1];
                end
            end
            set(axe,'YLim',ylim);
            updateYTicks(axe,obj.MontageChanNames{dd(i)},obj.Gain{dd(i)},obj.ChanColors{dd(i)});
            updateEvents(axe);
        elseif strcmpi(opt,'time')
            updateXTicks(obj,axe,obj.Time,obj.WinLength,obj.SRate);
            
        end
        
        
    end
end

highlightSelectedChannel(obj);
redrawSelection(obj);
end

function updateChannelLines(channellines,ind,data,gain,mask,posY,ChanSelect2Display,FirstDispChan,DispChans)

if ~isempty(FirstDispChan)&&~isempty(DispChans)
    if ~isempty(ChanSelect2Display)
        ChanSelect2Display=intersect(ChanSelect2Display,round(FirstDispChan:FirstDispChan+DispChans-1));
    else
        ChanSelect2Display=intersect(1:size(data,2),round(FirstDispChan:FirstDispChan+DispChans-1));
    end
end
%make zero gain channel disappear
gain(mask==0)=nan;

if ~isempty(ChanSelect2Display)
    data=data(:,ChanSelect2Display).*...
        repmat(reshape(gain(ChanSelect2Display),1,length(ChanSelect2Display)),size(data(:,ChanSelect2Display),1),1);
    posY=posY(ChanSelect2Display);
else
    data=data.*repmat(reshape(gain,1,length(gain)),size(data,1),1);
end


data=data+(posY'*ones(1,size(data,1)))';

ind=linspace(ind(1),ind(end),size(data,1));

x=ind'*ones(1,size(data,2));

y=data;

for i=1:length(channellines)
    set(channellines(i),'XData',x(:,i));
    set(channellines(i),'YData',y(:,i));
end

end
function updateXTicks(obj,axe,time,WinLength,fs)
% Plot X ticks
% axe :  axes to plot
% time : starting time
% WinLength :  window time lentgth


delta=roundsd(WinLength/15,1);

startTime=ceil(time/delta)*delta;

time_labels=startTime:delta:time+WinLength;

set(axe,'XTick',(time_labels-time)*fs);
x_lim=get(axe,'XLim');
margin=obj.ChanNameMargin;
for i=1:length(time_labels)
    h=findobj(axe,'DisplayName',['XTick',num2str(i)]);
    t=time_labels(i);
    p=(t*fs+margin-time*fs)/(x_lim(2)-x_lim(1));
    set(h,'Position',[p+0.002,0.002],'String',num2str(t));
end

end

function updateYTicks(axe,ChanNames,gain,colors)
lim=get(axe,'Ylim');

n=length(ChanNames);

count=0;
for i=1:n

    p=(n-i+1-lim(1))/(lim(2)-lim(1));
    if p<.99 && p>0
        count=count+1;
        
        h=findobj(axe,'DisplayName',['ChanName' num2str(count)]);
        
        set(h,'String',ChanNames{i},'Color',colors(i,:),'FontSize',min(floor(55/length(ChanNames{i})),12));
        
        h=findobj(axe,'DisplayName',['YGauge' num2str(count)]);
        set(h,'String',num2str(1/gain(i),'%0.3g'));

    end
end
end

function updateEvents(axe)
lim=get(axe,'Ylim');

h=findobj(axe,'-regexp','DisplayName','Event*');

for i=1:length(h)
    pos=get(h(i),'Position');
    set(h(i),'Position',[pos(1),lim(2)]);
end
end

