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
for i=1:length(obj.Sliders)
    delete(obj.Sliders(i));
end
for i=1:length(obj.Axes)
    delete(obj.Axes(i));
end


obj.Sliders=[];obj.Axes=[];obj.LineMeasurer=[];obj.TxtMeasurer={};obj.LineVideo=[];

ElevWide=.013;ChanNameWidth=.035;TimeHeight=.05;
VerticalSpace=.04;
Nchan=obj.MontageChanNumber;
n=obj.DataNumber;

for i=1:n
    
    DrawingHeightSpace=(1-(n-1)*VerticalSpace);
    Height=DrawingHeightSpace*obj.AxesHeight(i)/sum(obj.AxesHeight(1:n));
    start=(n-i)*VerticalSpace+DrawingHeightSpace*sum(obj.AxesHeight(i+1:n))/sum(obj.AxesHeight(1:n));
    position=[0    start    1    Height];
    

    obj.Axes(i)=axes('parent',obj.MainPanel,'XLim',[0 obj.WinLength*obj.SRate],'XTick',0:obj.SRate:obj.WinLength*obj.SRate,...
        'TickLength',[.003 0],'YLim',[(2-i)*50 100+(2-i)*110],'YTick',(2-i)*50:10:100+(2-i)*110,...
        'TickLength',[.003 0],'position',position); % codes pour grille
end




if ~isempty(obj.DispChans) && strcmp(obj.MouseMode,'Pan')
    set(obj.PanObj,'Enable','on')
else
    set(obj.PanObj,'Enable','off')
end



end


