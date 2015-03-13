% Re create Axes and sliders


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

function remakeAxes(obj)
%Lemon Chiffon
backgroundColor=obj.AxesBackgroundColor;



for i=1:length(obj.Sliders)
    delete(obj.Sliders(i));
end
for i=1:length(obj.Axes)
    delete(obj.Axes(i));
end


obj.Sliders=[];obj.Axes=[];

ElevWide=.013;
VerticalSpace=.01;
Nchan=obj.MontageChanNumber;
n=obj.DataNumber;


if strcmp(obj.DataView,'Horizontal')
    for i=1:n
        
        position=[(i-1)/n 0 1/n 1];
        if ~isempty(obj.DispChans(i)) %Need elevator
            
            position(3)=position(3)-ElevWide; % Multiple Elevator
            m=max(0.00001,Nchan(i)-obj.DispChans(i));
            obj.Sliders(i)=uicontrol(obj.MainPanel,'style','slider','units','normalized','position',[i/n-ElevWide 0 ElevWide 1],...
                'min',0,'max',m,'SliderStep',[1 obj.DispChans(i)]/max(1,m),'Callback',@(src,evt) ChangeSliders(obj,src));
            
        end
        obj.Axes(i)=axes('parent',obj.MainPanel,'XLim',[0 obj.WinLength*obj.SRate],'XTick',0:obj.SRate:obj.WinLength*obj.SRate,...
            'TickLength',[.005 0],'position',position,'color',backgroundColor,'YAxisLocation','right','Layer','bottom');
    end
elseif strcmp(obj.DataView,'Vertical')
    for i=1:n
        
        DrawingHeightSpace=(1-(n-1)*VerticalSpace);
        Height=DrawingHeightSpace*obj.AxesHeight(i)/sum(obj.AxesHeight(1:n));
        start=(n-i)*VerticalSpace+DrawingHeightSpace*sum(obj.AxesHeight(i+1:n))/sum(obj.AxesHeight(1:n));
        position=[0    start    1    Height];
        if ~isempty(obj.DispChans(i)) %Need elevator
            position(3)=position(3)-ElevWide; % Multiple Elevator
            
            m=max(0.00001,Nchan(i)-obj.DispChans(i));
            obj.Sliders(i)=uicontrol(obj.MainPanel,'style','slider','units','normalized','position',[1-ElevWide (n-i)/n ElevWide 1/n],...
                'min',0,'max',m,'SliderStep',[1 obj.DispChans(i)]/max(1,m),'Callback',@(src,evt) ChangeSliders(obj,src));
        end
        obj.Axes(i)=axes('parent',obj.MainPanel,'XLim',[0 obj.WinLength*obj.SRate],'XTick',0:obj.SRate:obj.WinLength*obj.SRate,...
            'TickLength',[.005 0],'position',position,'color',backgroundColor,'YAxisLocation','right','Layer','bottom');
    end
else
    
    position=[0 0 1 1];
    
    n=str2double(obj.DataView(4));
    
    if ~isempty(obj.DispChans)
        position(3)=position(3)-ElevWide;
        m=max(0.00001,Nchan(n)-obj.DispChans(n));
        obj.Sliders=uicontrol(obj.MainPanel,'style','slider','units','normalized','position',[1-ElevWide 0 ElevWide 1],...
            'min',0,'max',m,'SliderStep',[1 obj.DispChans(n)]/max(1,m),'Callback',@(src,evt) ChangeSliders(obj,src));
    end
    obj.Axes=axes('parent',obj.MainPanel,'XLim',[0 obj.WinLength*obj.SRate],'XTick',0:obj.SRate:obj.WinLength*obj.SRate,...
        'TickLength',[.005 0],'position',position,'color',backgroundColor,'YAxisLocation','right','Layer','bottom');
end

if ~isempty(obj.DispChans) && strcmp(obj.MouseMode,'Pan')
    set(obj.PanObj,'Enable','on')
else
    set(obj.PanObj,'Enable','off')
end

end


