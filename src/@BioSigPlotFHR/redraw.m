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
%-------------------------------------------------------------------------%
%---------------------      initialisation       -------------------------%
%-------------------------------------------------------------------------%

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
limit = size(obj.Data{1},2);
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

%-------------------------------------------------------------------------%
%---------------------      Pour signal RCF       ------------------------%
%-------------------------------------------------------------------------%
Nchan=obj.MontageChanNumber;
[rcf, toco]=preprocessedData(obj);
obj.PreprocData{1}=rcf;
obj.PreprocData{2}=toco;


for i=1:obj.DataNumber
    cla(obj.Axes(i))
    set(obj.Axes(i),'YTickLabel',{},'XtickLabel',{});
    DrawSelect(obj.Axes(i),obj.Selection,obj.Time,obj.WinLength);
  
    obj.SelRect(i)=rectangle('Parent',obj.Axes(i),'Position',[-1 0 .0001 .0001],'EdgeColor','none','FaceColor',[.85 1 .85]); % Current Selection Rectangle ,'Clipping','off'
    %----------------------------------------------------%
    %-----------      Dessin de grille       ------------%
    %----------------------------------------------------%
    plotXTicks(obj.Axes(i),i,obj.Time,obj.WinLength,obj.SRate,obj.InsideTicks);
    plotYTicks(obj.Axes(i),i,obj.Time,obj.WinLength,obj.SRate,obj.InsideTicks);
    %----------------------------------------------------%
    %-----------         affichage           ------------%
    %----------------------------------------------------%
    if i == 1
        plotData(obj.Axes(i),t-t(1)+1, rcf ,i);% rcf

        % %                         DrawEvts(obj.Axes(i),obj.Evts,obj.Time,obj.WinLength,obj.SRate);
    elseif i == 2
        plotData(obj.Axes(i),t-t(1)+1,toco,i);% toco
    end
end

offon={'off','on'};
for i=1:length(obj.Axes)
    set(obj.Axes(i),'XGrid',offon{obj.XGrid+1},'YGrid',offon{obj.YGrid+1},'DrawMode','fast')
end

%-------------------------------------------------------------------------%
%------------------        Mesure les valeur         ---------------------%
%-------------------------------------------------------------------------%
if strcmp(obj.MouseMode,'Measurer')
    for i=1:length(obj.Axes)
        obj.LineMeasurer(i)=line([-1 -1],[0 1000],'parent',obj.Axes(i),'Color',[0 0 0]);
        obj.LineMeasurer(i+2)=line([0 10000],[-1 -1],'parent',obj.Axes(i),'Color',[0 0 0]);
        obj.LineMeasurer(i+4)=line([-1 -1],[0 1000],'parent',obj.Axes(i),'Color',[0 0 0]);
        obj.LineMeasurer(i+6)=line([0 10000],[-1 -1],'parent',obj.Axes(i),'Color',[0 0 0]);
        for j=1:Nchan(i)
            obj.TxtMeasurer{i+4}(j)=text('Parent',obj.Axes(i),'position',[-1,j],'EdgeColor',[0 0 0],'BackgroundColor',[0.7 0.7 0],...
                'VerticalAlignment','bottom','Margin',1,'FontSize',10,'FontName','FixedWidth');
            obj.TxtMeasurer{i}(j)=text('Parent',obj.Axes(i),'position',[-1,j],'EdgeColor',[0 0 0],'BackgroundColor',[0.7 0.7 0],...
                'VerticalAlignment','bottom','Margin',1,'FontSize',10,'FontName','FixedWidth');
            obj.TxtMeasurer{i+2}(j)=text('Parent',obj.Axes(i),'position',[-1,j],'EdgeColor',[0 0 0],'BackgroundColor',[0.7 0.7 0],...
                'VerticalAlignment','top','Margin',1,'FontSize',10,'FontName','FixedWidth');
        end
    end
    
    %  end
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
%-------------------------------------------------------------------------%
%-----------------------        Plot data         ------------------------%
% Plot data function
% axe :axes to plot
% t : the time values
% data :   data matrix
% dataNB :  number of aex
% spacing : spacing in µV between 2 channels
% posY : the position of channel
% chanSelect : list of selected chans
%-------------------------------------------------------------------------%
function plotData(axe,t,data,dataNB)

% x=[t NaN]'*ones(1,size(data,1));
% y=[data NaN*ones(size(data,1),1)]';
data(data==0)=nan;

if dataNB == 1
    line(t,data(1,:),'parent',axe,'Color',[1 0 0])%pour differente coleur
    line(t,data(2,:),'parent',axe,'Color',[0 0 1])%pour differente coleur
    
elseif dataNB == 2
    line(t,data,'parent',axe,'Color',[0 0 0])%pour differente coleur
end

end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-----------------------      plotXTicks       ---------------------------%
% Plot X ticks
% axe :  axes to plot
% dataNB : number of aex
% time : starting time
% WinLength :  window time lentgth
% insideticks :1 (Ticks are inside) 0 (Ticks are outside)
%-------------------------------------------------------------------------%
function plotXTicks(axe,dataNB,time,WinLength,SRate,insideticks)

if insideticks
    for j=time:time+WinLength-1
        p=(j-time)/WinLength;
        %if axe is on the bottom, print the text
        %for differrent width of grid
        line([p*SRate*WinLength+SRate/2 p*SRate*WinLength+SRate/2],[0 300],'parent',axe,'Color',[0.5 0.9 0.5],'LineWidth',1);
        line([p*SRate*WinLength p*SRate*WinLength],[0 300],'parent',axe,'Color',[0.5 0.9 0.5],'LineWidth',2);
        if dataNB==2,text(p,0,num2str(j),'Parent',axe,'Color',[0.5 0.9 0.5],'BackgroundColor',[1 1 1],'HorizontalAlignment','center','VerticalAlignment','bottom','FontWeight','normal','units','normalized');end
    end
else
    if dataNB==2, set(axe,'XTickLabel',time:time+WinLength); end
end
end

%-------------------------------------------------------------------------%
%-----------------------      plotYTicks       ---------------------------%
% Write channels names on Y Ticks
%  axe :  axes to plot
% dataNB : number of aex
% ChanNames : cell of channel names that will be writted
% insideticks :1 (Ticks are inside) 0 (Ticks are outside)
%-------------------------------------------------------------------------%
function plotYTicks(axe,dataNB,time,WinLength,SRate,insideticks)

if insideticks
    for j=0:2:10+(2-dataNB)*6-1
        p=(j+dataNB-1)/(10+(2-dataNB)*6);
        %       for differrent width of grid
        if j == 6 && (2 - dataNB)
            line([0 SRate*WinLength],[p*(100+(2-dataNB)*60)+50*(2-dataNB) p*(100+(2-dataNB)*60)+50*(2-dataNB)],'parent',axe,'Color',[0.5 0.9 0.5],'LineWidth',3);
        else
            line([0 SRate*WinLength],[p*(100+(2-dataNB)*60)+50*(2-dataNB) p*(100+(2-dataNB)*60)+50*(2-dataNB)],'parent',axe,'Color',[0.5 0.9 0.5],'LineWidth',1);
        end
    end
    for j=1:2:10+(2-dataNB)*6
        p=(j+dataNB-1)/(10+(2-dataNB)*6);
        %       for differrent width of grid
        if j == 11 && (2 - dataNB)
            line([0 SRate*WinLength],[p*(100+(2-dataNB)*60)+50*(2-dataNB) p*(100+(2-dataNB)*60)+50*(2-dataNB)],'parent',axe,'Color',[0.5 0.9 0.5],'LineWidth',3);
        else
            line([0 SRate*WinLength],[p*(100+(2-dataNB)*60)+50*(2-dataNB) p*(100+(2-dataNB)*60)+50*(2-dataNB)],'parent',axe,'Color',[0.5 0.9 0.5],'LineWidth',2);
        end
        for i=time:10:time+WinLength
            q=(WinLength-(i-floor(time/10)*10))/WinLength;
            text(q,p,num2str(j*10+10*(dataNB-1)+(2-dataNB)*50),'Parent',axe,'Color',[0.5 0.9 0.5],'BackgroundColor',[1 1 1],'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','normal','units','normalized')
        end
    end
else
    set(axe,'YTickLabel',(2-dataNB)*50:10:100+(2-dataNB)*110);
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
        rectangle('Parent',axe,'Position',[p(1) ylim(1) p(2)-p(1)+0.0000001 ylim(2)],'EdgeColor','none','FaceColor',[.85 1 .85]);
    end
end
end

function DrawEvts(axe,evts,t,dt,SRate)
yl=get(axe,'Ylim');
for i=1:size(evts,1)
    if evts{i,1}>=t && evts{i,1}<=t+dt
        x=SRate*(evts{i,1}-t);
        line([x x],[0 1000],'parent',axe,'Color',[0.4078 0.1333 0.5451]);
        %         text('Parent',axe,'position',[x yl(2)],'EdgeColor',[0 0 0],'BackgroundColor',[0.6 1 0.6],...
        %             'VerticalAlignment','Top','Margin',1,'FontSize',12,'String',evts{i,2});
    end
end
end
