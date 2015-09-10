function redraw(obj)

channelLines=cell(obj.DataNumber,1);

t=round(max(1,obj.Time*obj.SRate+1):min((obj.Time+obj.WinLength)*obj.SRate,size(obj.Data{1},1)));
% XIndex=ceil(obj.Time*obj.SRate+1):min(ceil((obj.Time+obj.WinLength)*obj.SRate),size(obj.Data{1},1));

if isempty(obj.FirstDispChans_)
    obj.FirstDispChans_=ones(1,obj.DataNumber);
end

if ~isempty(obj.DispChans)
    obj.FirstDispChans_=max(min(obj.FirstDispChans_,obj.MontageChanNumber-min(obj.DispChans,obj.MontageChanNumber)+1),1);
    
    if any(strcmp(obj.DataView_,{'Vertical','Horizontal'}))
        for i=1:obj.DataNumber
            set(obj.Sliders(i),'value',get(obj.Sliders(i),'max')-obj.FirstDispChans_(i)+1)
        end
    else
        n=str2double(obj.DataView(4));
        set(obj.Sliders,'value',get(obj.Sliders,'max')-obj.FirstDispChans_(n)+1)
    end
end


if any(strcmp(obj.DataView,{'Vertical','Horizontal'}))
    Nchan=obj.MontageChanNumber;
    
    for i=1:obj.DataNumber
        if isempty(obj.DispChans) %No elevator
            ylim=[1-obj.YBorder_(1) Nchan(i)+obj.YBorder_(2)];
        else
            ylim=[Nchan(i)+2-obj.YBorder_(1)-obj.FirstDispChans(i)-min(Nchan(i),obj.DispChans(i))      ...
                Nchan(i)+obj.YBorder_(2)-obj.FirstDispChans(i)+1];
        end
        cla(obj.Axes(i))
        set(obj.Axes(i),'Ylim',ylim,'Ytick',0.5:1:Nchan(i)+0.5,'YTickLabel',{},'XtickLabel',{});
        
        plotXTicks(obj.Axes(i),obj.Time,obj.WinLength,obj.SRate);
        if ~isempty(obj.PreprocData)
            
            lhs=plotData(obj.Axes(i),t-t(1)+1,obj.PreprocData{i}(t,:),obj.ChanColors{i},...
                obj.Gain{i},obj.Mask{i},Nchan(i):-1:1,obj.ChanSelect2Display{i},obj.FirstDispChans(i),obj.DispChans(i),...
                obj.ChanSelect2Edit{i},obj.ChanSelectColor);
            
            channelLines{i}=lhs;
        end
        plotYTicks(obj.Axes(i),obj.MontageChanNames{i},obj.ChanSelect2Edit{i},obj.ChanSelectColor,obj.Gain{i},obj.ChanColors{i});
    end
else
    n=str2double(obj.DataView(4));
    Nchan=obj.MontageChanNumber(n);
    
    if isempty(obj.DispChans)
        ylim=[0 Nchan+1];
    else
        %ylim=[obj.FirstDispChans(n)-1 obj.FirstDispChans(n)+obj.DispChans];
        ylim=[obj.MontageChanNumber(n)+2-obj.YBorder_(1)-obj.FirstDispChans(n)-min(obj.DispChans(n),obj.MontageChanNumber(n))    ...
            obj.MontageChanNumber(n)+obj.YBorder_(2)-obj.FirstDispChans(n)+1];
    end
    cla(obj.Axes)
    set(obj.Axes,'Ylim',ylim,'Ytick',0.5:1:Nchan+0.5,'YTickLabel',{},'TickLength',[.005 0]);
    
    i=str2double(obj.DataView(4));
    if ~isempty(obj.PreprocData)
        lhs=plotData(obj.Axes,t-t(1)+1,obj.PreprocData{i}(t,:),obj.ChanColors{i},...
            obj.Gain{i},obj.Mask{i},obj.MontageChanNumber(i):-1:1,obj.ChanSelect2Display{i},obj.FirstDispChans(i),...
            obj.DispChans(i),obj.ChanSelect2Edit{i},obj.ChanSelectColor);
        channelLines{i}=lhs;
    end
    plotYTicks(obj.Axes,obj.MontageChanNames{i},obj.ChanSelect2Edit{i},obj.ChanSelectColor,obj.Gain{i},obj.ChanColors{i});
    
    plotXTicks(obj.Axes,obj.Time,obj.WinLength,obj.SRate)
end

obj.ChannelLines=channelLines;


offon={'off','on'};
for i=1:length(obj.Axes)
    set(obj.Axes(i),'XGrid',offon{obj.XGrid+1},'XMinorGrid',offon{obj.XGrid+1},...
        'YGrid',offon{obj.YGrid+1},'YMinorGrid',offon{obj.YGrid+1});
end

if ~isempty(obj.LineVideo)
    delete(obj.LineVideo(ishandle(obj.LineVideo)));
    delete(obj.LineMeasurer(ishandle(obj.LineMeasurer)));
end
for i=1:length(obj.Axes)
%     yl=get(obj.Axes(i),'YLim');
    xl=get(obj.Axes(i),'XLim');
    obj.LineVideo(i)=line([xl(1)-100,xl(1)-100],[0,1000],'parent',obj.Axes(i),...
        'Color',[1 0 0],'LineStyle','-.','LineWidth',1.5,'ButtonDownFcn',@(src,evt) LineVideoButtonDown(obj,src));
    
    
    %     drawnow;
    obj.LineMeasurer(i)=line([xl(1)-100,xl(1)-100],[0,1000],'parent',obj.Axes(i),'Color',[1 0 0]);

    uistack(obj.LineVideo(i),'top');
end

% obj.EvtContextMenu.update(obj);
showGauge(obj);
showTimeLabel(obj);
showChannelLabel(obj);
end
%**************************************************************************
function h=plotData(axe,t,data,colors,gain,mask,posY,ChanSelect2Display,FirstDispChan,...
    DispChans,ChanSelect2Edit,ChanSelectColor) %#ok<INUSD>
% Plot data function
% axe :axes to plot
% t : the time values
% data :   data matrix
% color :  data line color
% Gain : Gain in µV between 2 channels
% posY : the position of channel
% ChanSelect2Display : list of selected chans
% FirstDispChan : the first channel to display
% DispChans : the channel number of one page
if ~isempty(FirstDispChan)&&~isempty(DispChans)
    if ~isempty(ChanSelect2Display)
        ChanSelect2Display=intersect(ChanSelect2Display,round(FirstDispChan:FirstDispChan+DispChans-1));
    else
        ChanSelect2Display=intersect(1:size(data,2),round(FirstDispChan:FirstDispChan+DispChans-1));
    end
end
%make zero gain channel disappear
gain(isnan(gain))=1;
gain(mask==0)=nan;

if ~isempty(ChanSelect2Display)
    data=data(:,ChanSelect2Display).*...
        repmat(reshape(gain(ChanSelect2Display),1,length(ChanSelect2Display)),size(data(:,ChanSelect2Display),1),1);
    posY=posY(ChanSelect2Display);
    colors=colors(ChanSelect2Display,:);
    [f,ChanSelect2Edit]=ismember(ChanSelect2Edit,ChanSelect2Display);
else
    data=data.*repmat(reshape(gain,1,length(gain)),size(data,1),1);
end


data=data+(posY'*ones(1,size(data,1)))';

t=linspace(t(1),t(end),size(data,1));

x=[t NaN]'*ones(1,size(data,2));
% x=t'*ones(1,size(data,1));

y=[data;NaN*ones(1,size(data,2))];
% y=data';

h=line(x,y,'parent',axe,'Color',[0 0 0],'linewidth',0.4);
% drawnow;
for i=1:length(h)
    set(h(i),'Color',colors(i,:));
end

if ~isempty(ChanSelect2Edit)
    set(h(ChanSelect2Edit(ChanSelect2Edit~=0)),'Color',ChanSelectColor);
end
end

%**************************************************************************
function plotXTicks(axe,time,WinLength,fs)
% Plot X ticks
% axe :  axes to plot
% time : starting time
% WinLength :  window time lentgth
h=findobj(axe,'-regexp','DisplayName','XTick*');
if ~isempty(h)
    delete(h);
end

delta=roundsd(WinLength/15,1);

startTime=ceil(time/delta)*delta;

time_labels=startTime:delta:time+WinLength;

set(axe,'XTick',(time_labels-time)*fs);

for i=1:length(time_labels)
    t=time_labels(i);
    p=(t-time)/WinLength;
    h=text(p+.002,.002,num2str(t),'Parent',axe,'HorizontalAlignment','left',...
        'VerticalAlignment','bottom','FontWeight','normal','units','normalized',...
        'color',[0 0 1],'DisplayName',['XTick',num2str(i)]);
    uistack(h,'top');
end

end

%**************************************************************************
function plotYTicks(axe,ChanNames,ChanSelect2Edit,ChanSelectColor,gain,colors)
% Write channels names on Y Ticks
%  axe :  axes to plot
% ChanNames : cell of channel names that will be writted

lim=get(axe,'Ylim');

h=findobj(axe,'-regexp','DisplayName','ChanName*');
if ~isempty(h)
    delete(h);
end

h=findobj(axe,'-regexp','DisplayName','YGauge*');
if ~isempty(h)
    delete(h);
end

n=length(ChanNames);
count=0;
for i=1:n
    p=(n-i+1-lim(1))/(lim(2)-lim(1));
    if p<.99 && p>0
        count=count+1;
        if ismember(i,ChanSelect2Edit)
            YLabelColor=ChanSelectColor;
        else
            YLabelColor=colors(i,:);
        end
        h=text(.002,p+.004,ChanNames{i},'Parent',axe,'HorizontalAlignment','left',...
            'VerticalAlignment','bottom','FontWeight','bold','units','normalized',...
            'color',YLabelColor,'DisplayName',['ChanName' num2str(count)]);
%             ,'Interpreter','none');
        %         drawnow;
%         uistack(h,'bottom');
        
        h=text(0.97,p,num2str(1/gain(i),'%0.3g'),'Parent',axe,'HorizontalAlignment','left',...
            'VerticalAlignment','middle','FontWeight','bold','units','normalized',...
            'DisplayName',['YGauge' num2str(count)],'Color',[1 0 1]);
%             ,'Interpreter','none');
        %         drawnow;
%         uistack(h,'top');
    end
end

end

%==========================================================================
%**************************************************************************
function plotDynamicGauge()

end

%==========================================================================
%**************************************************************************

function LineVideoButtonDown(obj,src)

obj.MouseMode='VideoAdjust';

end

