% Redraw when time change or sliders


%123456789012345678901234567890123456789012345678901234567890123456789012
%
%     BioSigPlot Copyright (C) 2013 Samuel Boudet, Faculté Libre de Médecine,
%     samuel.boudet@gmail.com
%
%     This file is part of BioSigPlot
%
%     BioSigPlot is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     BioSigPlot is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% V0.1.1 Beta - 13/02/2013 - Initial Version

function redraw(obj)



for i=1:length(obj.LineVideo)
    delete(obj.LineVideo(i));
end
for i=1:length(obj.LineMeasurer)
    delete(obj.LineMeasurer(i));
end
for i=1:length(obj.TxtMeasurer)
    for j=1:length(obj.TxtMeasurer{i})
        delete(obj.TxtMeasurer{i}(j));
    end
end
obj.LineMeasurer=[];obj.TxtMeasurer={};obj.LineVideo=[];
t=max(1,obj.Time*obj.SRate+1):min((obj.Time+obj.WinLength)*obj.SRate,size(obj.Data{1},2));


if isempty(obj.FirstDispChans_)
    obj.FirstDispChans_=ones(1,obj.DataNumber);
end

if ~isempty(obj.DispChans)
    obj.FirstDispChans_=max(min(obj.FirstDispChans_,obj.MontageChanNumber-obj.DispChans+1),1);
    if obj.ChanLink
        set(obj.Sliders,'value',get(obj.Sliders,'max')-obj.FirstDispChans_(1)+1)
    elseif any(strcmp(obj.DataView_,{'Vertical','Horizontal'}))
        for i=1:obj.DataNumber
            set(obj.Sliders(i),'value',get(obj.Sliders(i),'max')-obj.FirstDispChans_(i)+1)
        end
    else
        n=str2double(obj.DataView(4));
        set(obj.Sliders,'value',get(obj.Sliders,'max')-obj.FirstDispChans_(n)+1)
    end
end

EventLines=[];

if any(strcmp(obj.DataView,{'Vertical','Horizontal'}))
    Nchan=obj.MontageChanNumber;
    obj.PreprocData={1:obj.DataNumber};
    for i=1:obj.DataNumber
        if isempty(obj.DispChans) %No elevator
            ylim=[1-obj.YBorder_(1) Nchan(i)+obj.YBorder_(2)];
        else
            ylim=[Nchan(i)+2-obj.YBorder_(1)-obj.FirstDispChans(i)-obj.DispChans      Nchan(i)+obj.YBorder_(2)-obj.FirstDispChans(i)+1];
        end
        cla(obj.Axes(i))
        set(obj.Axes(i),'Ylim',ylim,'Ytick',1:Nchan(i),'YTickLabel',{},'XtickLabel',{});
        DrawSelect(obj.Axes(i),obj.Selection,obj.Time,obj.WinLength);
        obj.SelRect(i)=rectangle('Parent',obj.Axes(i),'Position',[-1 0 .0001 .0001],'EdgeColor','none','FaceColor',[.85 1 .85]); % Current Selection Rectangle
        if strcmp(obj.DataView,'Horizontal') || i==obj.DataNumber, plotXTicks(obj.Axes(i),obj.Time,obj.WinLength,obj.InsideTicks); end
        obj.PreprocData{i}=preprocessedData(obj,i);
        if obj.Spacing(i)==0
            obj.Spacing(i)=4*std(obj.PreprocData{i}(:));
        end
        plotData(obj.Axes(i),t-t(1)+1,obj.PreprocData{i},obj.NormalModeColors(rem(i-1,end)+1,:),obj.Spacing(i),Nchan(i):-1:1,obj.ChanSelect{i});
        if ~obj.ChanLink || i==1  || strcmp(obj.DataView,'Vertical') , plotYTicks(obj.Axes(i),obj.MontageChanNames{i},obj.InsideTicks); end
        tmp=DrawEvts(obj.Axes(i),obj.Evts,obj.Time,obj.WinLength,obj.SRate);
        if ~isempty(tmp)
            EventLines(i,:)=tmp;
        end
    end
else
    
    if strcmp(obj.DataView,'Superimposed')
        Nchan=obj.MontageChanNumber(1);
        n=1;
    elseif strcmp(obj.DataView,'Alternated')
        Nchan=sum(obj.MontageChanNumber);
        n=1;
    else
        n=str2double(obj.DataView(4));
        Nchan=obj.MontageChanNumber(n);
    end
    
    if isempty(obj.DispChans)
        ylim=[0 Nchan+1];
    else
        %ylim=[obj.FirstDispChans(n)-1 obj.FirstDispChans(n)+obj.DispChans];
        ylim=[obj.MontageChanNumber(n)+2-obj.YBorder_(1)-obj.FirstDispChans(n)-obj.DispChans    obj.MontageChanNumber(n)+obj.YBorder_(2)-obj.FirstDispChans(n)+1];
        if strcmp(obj.DataView,'Alternated')
            ylim=[(obj.MontageChanNumber(n)+1-obj.FirstDispChans(n)-obj.DispChans)*obj.DataNumber+1-obj.YBorder_(1)   obj.DataNumber*(obj.MontageChanNumber(n)+1-obj.FirstDispChans(n))+obj.YBorder_(2)];
            %ylim=[obj.DataNumber*(obj.FirstDispChans(n)-1) obj.DataNumber*(obj.FirstDispChans(n)-1+obj.DispChans)+1];
        end
    end
    cla(obj.Axes)
    set(obj.Axes,'Ylim',ylim,'Ytick',1:Nchan,'TickLength',[.005 0]);
    
    DrawSelect(obj.Axes,obj.Selection,obj.Time,obj.WinLength);
    obj.SelRect=rectangle('Parent',obj.Axes,'Position',[-1 0 .0001 .0001],'EdgeColor','none','FaceColor',[.85 1 .85]); % Current Selection Rectangle
    
    
    if strcmp(obj.DataView,'Alternated')
        obj.PreprocData={1:obj.DataNumber};
        for i=obj.DataNumber:-1:1
            obj.PreprocData{i}=preprocessedData(obj,i);
            if obj.Spacing(i)==0
                obj.Spacing(i)=4*std(obj.PreprocData{i}(:));
            end
            plotData(obj.Axes,t-t(1)+1,obj.PreprocData{i},obj.AlternatedModeColors(rem(i-1,end)+1,:),obj.Spacing(i),obj.DataNumber*obj.MontageChanNumber(1)+1-i:-obj.DataNumber:1,obj.ChanSelect{i});
        end
        tmp=obj.MontageChanNames{1}(:)';tmp(2:obj.DataNumber,:)={''};
        plotYTicks(obj.Axes,tmp(:),obj.InsideTicks)
        
    elseif strcmp(obj.DataView,'Superimposed')
        obj.PreprocData={1:obj.DataNumber};
        for i=1:obj.DataNumber
            obj.PreprocData{i}=preprocessedData(obj,i);
            if obj.Spacing(i)==0
                obj.Spacing(i)=4*std(obj.PreprocData{i}(:));
            end
            plotData(obj.Axes,t-t(1)+1,obj.PreprocData{i},obj.SuperimposedModeColors(rem(i-1,end)+1,:),obj.Spacing(i),obj.MontageChanNumber(i):-1:1,obj.ChanSelect{i});
        end
        plotYTicks(obj.Axes,obj.MontageChanNames{1},obj.InsideTicks)
    else
        i=str2double(obj.DataView(4));
        obj.PreprocData=preprocessedData(obj,i);
        if obj.Spacing(i)==0
            obj.Spacing(i)=4*std(obj.PreprocData{i}(:));
        end
        plotData(obj.Axes,t-t(1)+1,obj.PreprocData,obj.NormalModeColors(rem(i-1,end)+1,:),obj.Spacing(i),obj.MontageChanNumber(i):-1:1,obj.ChanSelect{i});
        plotYTicks(obj.Axes,obj.MontageChanNames{i},obj.InsideTicks)
    end
    plotXTicks(obj.Axes,obj.Time,obj.WinLength,obj.InsideTicks)
    tmp=DrawEvts(obj.Axes,obj.Evts,obj.Time,obj.WinLength,obj.SRate);
    if ~isempty(tmp)
        EventLines(i,:)=tmp;
    end
end

obj.EventLines=EventLines;

offon={'off','on'};
for i=1:length(obj.Axes)
    set(obj.Axes(i),'XGrid',offon{obj.XGrid+1},'YGrid',offon{obj.YGrid+1},'DrawMode','fast')
end


if strcmp(obj.MouseMode,'Measurer')
    for i=1:length(obj.Axes)
        obj.LineMeasurer(i)=line([-1 -1],[0 1000],'parent',obj.Axes(i),'Color',[1 0 0]);

        for j=1:Nchan(i)
            obj.TxtMeasurer{i}(j)=text('Parent',obj.Axes(i),'position',[-1,j],'EdgeColor',[0 0 0],'BackgroundColor',[0.7 0.7 0],...
                'VerticalAlignment','Top','Margin',1,'FontSize',10,'FontName','FixedWidth');
        end
    end
end

if strcmp(obj.MouseMode,'Annotate')
    for i=1:length(obj.Axes)
        obj.LineMeasurer(i)=line([-1 -1],[0 1000],'parent',obj.Axes(i),'Color',[1 0 0]); 
    end
end


for i=1:length(obj.Axes) 
    if obj.VideoTime>obj.Time && obj.VideoTime<obj.Time+obj.WinLength
        t=(obj.VideoTime-obj.Time)*obj.SRate;
    else
        t=-1;
    end
    obj.LineVideo(i)=line([t t],[0 1000],'parent',obj.Axes(i),'Color',[1 0 0]);
end


end

%**************************************************************************
function plotData(axe,t,data,color,spacing,posY,chanSelect) %#ok<INUSD>
% Plot data function
% axe :axes to plot                                                
% t : the time values
% data :   data matrix
% color :  data line color
% spacing : spacing in µV between 2 channels
% posY : the position of channel
% chanSelect : list of selected chans

%data=-data./(spacing'*ones(1,size(data,2)));
data=-data/spacing;
data=data+(posY'*ones(1,size(data,2)));
x=[t NaN]'*ones(1,size(data,1));
y=[data NaN*ones(size(data,1),1)]';

line(x,y,'parent',axe,'Color',color)
end

%**************************************************************************
function plotXTicks(axe,time,WinLength,insideticks)
% Plot X ticks
% axe :  axes to plot                                               
% time : starting time
% WinLength :  window time lentgth
% insideticks :1 (Ticks are inside) 0 (Ticks are outside)

if insideticks
    for i=time:time+WinLength-1
        p=(i-time)/WinLength;
        text(p+.002,.002,num2str(i),'Parent',axe,'HorizontalAlignment','left','VerticalAlignment','bottom','FontWeight','normal','units','normalized')
    end
else
    set(axe,'XTickLabel',time:time+WinLength);
end
end

%**************************************************************************
function plotYTicks(axe,ChanNames,insideticks)
% Write channels names on Y Ticks 
%  axe :  axes to plot  
% ChanNames : cell of channel names that will be writted
% insideticks :1 (Ticks are inside) 0 (Ticks are outside)                                                                  * 

if insideticks
    lim=get(axe,'Ylim');
    n=length(ChanNames);
    for i=1:n
        p=(n-i+1-lim(1))/(lim(2)-lim(1));
        if p<.99 && p>0
            text(.002,p+.004,ChanNames{i},'Parent',axe,'HorizontalAlignment','left','VerticalAlignment','bottom','FontWeight','bold','units','normalized')
        end
    end
else
    set(axe,'YTickLabel',ChanNames(end:-1:1));
end
end

%**************************************************************************
function DrawSelect(axe,selection,t,dt)
% Draw the rectangle of selected time periods
% axe :axes to draw
% selection :  periods of selection
% t : start time to draw
% dt : time interval within there is drawing


xlim=get(axe,'XLim');
ylim=get(axe,'YLim');

for i=1:size(selection,2)
    if selection(2,i)>=t && selection(1,i)<=t+dt
        p=(selection(:,i)-t)*xlim(2)/dt;
        p(1)=max(0,p(1));
        rectangle('Parent',axe,'Position',[p(1) ylim(1) p(2)-p(1)+0.0000001 ylim(2)],'EdgeColor','none','FaceColor',[.85 1 .85]);
    end
end
end

function EventLines=DrawEvts(axe,evts,t,dt,SRate)
yl=get(axe,'Ylim');
count=0;
EventLines=[];

for i=1:size(evts,1)
    if evts{i,1}>=t && evts{i,1}<=t+dt
        count=count+1;
        x=SRate*(evts{i,1}-t);
        EventLines(count)=line([x x],[0 1000],'parent',axe,'Color',[0 0.7 0]);
        text('Parent',axe,'position',[x yl(2)],'EdgeColor',[0 0 0],'BackgroundColor',[0.6 1 0.6],...
                'VerticalAlignment','Top','Margin',1,'FontSize',12,'String',evts{i,2});
    end
end

end
