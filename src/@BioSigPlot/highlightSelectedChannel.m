function highlightSelectedChannel(obj)
%hightlight the selection on channels
if any(strcmp(obj.DataView,{'Vertical','Horizontal'}))
    for i=1:length(obj.Axes)
        highlightChannels(i,obj.ChannelLines{i},obj.ChanColors{i},obj.ChanSelect2Display{i},obj.FirstDispChans(i),...
            obj.DispChans(i),obj.ChanSelect2Edit{i},obj.ChanSelectColor);
        highlightYTicks(obj.Axes(i),obj.MontageChanNames{i},obj.ChanSelect2Edit{i},obj.ChanSelectColor);
    end
else
    i=str2double(obj.DataView(4));
    highlightChannels(i,obj.ChannelLines{i},obj.ChanColors{i},obj.ChanSelect2Display{i},obj.FirstDispChans(i),...
        obj.DispChans(i),obj.ChanSelect2Edit{i},obj.ChanSelectColor);
    highlightYTicks(obj.Axes,obj.MontageChanNames{i},obj.ChanSelect2Edit{i},obj.ChanSelectColor);
    
end

end

function highlightChannels(dataNum,ChannelLines,colors,ChanSelect2Display,FirstDispChan,...
    DispChans,ChanSelect2Edit,ChanSelectColor) %#ok<INUSD>
% ChanSelect2Display : list of selected chans
% FirstDispChan : the first channel to display
% DispChans : the channel number of one page
if ~isempty(FirstDispChan)&&~isempty(DispChans)
    if ~isempty(ChanSelect2Display)
        ChanSelect2Display=intersect(ChanSelect2Display,round(FirstDispChan:FirstDispChan+DispChans-1));
    else
        ChanSelect2Display=intersect(1:size(obj.PreprocData{dataNum},2),round(FirstDispChan:FirstDispChan+DispChans-1));
    end
end

if ~isempty(ChanSelect2Display)
    [f,ChanSelect2Edit]=ismember(ChanSelect2Edit,ChanSelect2Display);
end

for i=1:length(ChannelLines)
    set(ChannelLines(i),'Color',colors(i,:));
end

if ~isempty(ChanSelect2Edit)
    set(ChannelLines(ChanSelect2Edit(ChanSelect2Edit~=0)),'Color',ChanSelectColor);
end

end

function highlightYTicks(axe,ChanNames,ChanSelect2Edit,ChanSelectColor)
% Write channels names on Y Ticks
%  axe :  axes to plot
% ChanNames : cell of channel names that will be writted
% insideticks :1 (Ticks are inside) 0 (Ticks are outside)                                                                  *
lim=get(axe,'Ylim');
n=length(ChanNames);
for i=1:n
    p=(n-i+1-lim(1))/(lim(2)-lim(1));
    if p<.99 && p>0
        if ismember(i,ChanSelect2Edit)
            YLabelColor=ChanSelectColor;
        else
            YLabelColor=[0 0 0];
        end
        text(.002,p+.004,ChanNames{i},'Parent',axe,'HorizontalAlignment','left',...
            'VerticalAlignment','bottom','FontWeight','bold','units','normalized',...
            'color',YLabelColor)
    end
end
end




