% Window for selection of pages to export and for selection of the mode of
% exportation 

%123456789012345678901234567890123456789012345678901234567890123456789012
%
%     BioSigPlot Copyright (C) 2010 Samuel Boudet, Faculté Libre de Médecine,
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
% V0.1.2 Beta - 22/02/2013 


function [file,filetype,pages,paperparams]=ExportWindow()
handles.Fig=figure('MenuBar','none','position',[100 100 560 420],'NumberTitle','off','Name','Export to',...
    'CloseRequestFcn',@(src,evts) Cancel(src),'Resize','off');

h2 = uicontrol('Parent',handles.Fig,'Position',[17 298 57 16],'String','File :','Style','text');
handles.EdtFile = uicontrol('Parent',handles.Fig,'BackgroundColor',[1 1 1],'Position',[99 292 319 28],'String','','Style','edit');
h4 = uicontrol('Parent',handles.Fig,'Callback',@(src,evt) browse(src),'Position',[434 293 88 27],'String','Browse');
h5 = uibuttongroup('Parent',handles.Fig,'Units','pixels','Title','Format','Clipping','on','Position',[15 340 530 71],'SelectionChangeFcn',[]);
handles.RdPDF = uicontrol('Parent',h5,'Units','characters','Position',[2.2 1.38461538461538 21.2 2.23076923076923],'String','PDF (multipage)','Style','radiobutton','Value',1 );
handles.RdEPS = uicontrol('Parent',h5,'Units','characters','Position',[24.8 1.30769230769231 21.2 2.30769230769231],'String','EPS (multipage)','Style','radiobutton');
handles.RdImage = uicontrol('Parent',h5,'Units','characters','Position',[47.4 1.38461538461538 25 2.23076923076923],'String','Image (Separate files)','Style','radiobutton');
handles.RdFig = uicontrol('Parent',h5,'Units','characters','Position',[74.2 1.61538461538462 29 2],'String','Matlab Fig (Separate files)','Style','radiobutton');
h10 = uibuttongroup('Parent',handles.Fig,'Units','pixels','Title','Pages to export','Position',[36 169 442 117],'SelectionChangeFcn',[]);
handles.RdCurrPage = uicontrol('Parent',h10,'Units','characters','Position',[2.6 5.76923076923077 17.4 1.76923076923077],'String','Current page','Style','radiobutton','Value',1);
handles.RdWhole = uicontrol('Parent',h10,'Units','characters','Position',[2.6 4.15384615384615 20.2 1.76923076923077],'String','Whole file','Style','radiobutton');
handles.RdSelection = uicontrol('Parent',h10,'Units','characters','Position',[2.6 2.53846153846154 34.6 1.76923076923077],'String','Pages with a selected period','Style','radiobutton');
handles.RdTimes = uicontrol('Parent',h10,'Units','characters','Position',[2.6 0.769230769230769 33.8 1.76923076923077],'String','Pages starting with times:','Style','radiobutton');
handles.TxtTimes = uicontrol('Parent',h10,'Units','characters','BackgroundColor',[1 1 1],'Position',[36.8 0.769230769230769 46 1.76923076923077],'String',blanks(0),'Style','edit');
h18 = uicontrol('Parent',handles.Fig,'Position',[32 129 90 20],'String','Paper Size :','Style','text');
handles.PopPaper = uicontrol('Parent',handles.Fig,'BackgroundColor',[1 1 1],'Callback',@(src,evt) PaperSelect(src),'Position',[118 130 133 23],'String',{'usletter','A4','user-defined'},'Style','popupmenu','Value',1);
handles.PnlSize = uipanel('Parent',handles.Fig,'Units','pixels','Title',{  'Output size' },'Position',[319 41 199 120],'Visible','off');
handles.PopUnit = uicontrol('Parent',handles.PnlSize,'Units','characters','BackgroundColor',[1 1 1],'Position',[16.4 5.46153846153846 20.8 2.07692307692308],'String',{'inches','centimeters','points'},'Style','popupmenu','Value',1);
h22 = uicontrol('Parent',handles.PnlSize,'Units','characters','Position',[1.8 5.53846153846154 12.2 1.92307692307692],'String','Unit','Style','text');
h23 = uicontrol('Parent',handles.PnlSize,'Units','characters','Position',[1.8 3.61538461538462 12.6 1.61538461538462],'String','Width','Style','text');
h24 = uicontrol('Parent',handles.PnlSize,'Units','characters','Position',[1.8 1.30769230769231 12.2 2.07692307692308],'String','Height','Style','text');
handles.TxtWidth = uicontrol('Parent',handles.PnlSize,'Units','characters','BackgroundColor',[1 1 1],'Position',[16.4 3.69230769230769 17.8 1.61538461538462],'String', '','Style','edit');
handles.TxtHeight = uicontrol('Parent',handles.PnlSize,'Units','characters','BackgroundColor',[1 1 1],'Position',[16.4 1.53846153846154 16.8 1.61538461538462],'String', '','Style','edit');
handles.ChkLandscape = uicontrol('Parent',handles.Fig,'Position',[82 94 158 26],'String','Landscape','Style','checkbox','Value',1);
uicontrol('Parent',handles.Fig,'Position',[254 7 96 26],'String','Export','Callback',@(src,evt) Export(src));
uicontrol('Parent',handles.Fig,'Callback',@(src,evt) delete(src),'Position',[404 7 96 26],'String','Cancel');

guidata(handles.Fig,handles);

uiwait(handles.Fig);
file=get(handles.EdtFile,'String');

if get(handles.RdPDF,'value')
    filetype='pdf';
elseif get(handles.RdEPS,'value')
    filetype='ps';
elseif get(handles.RdImage,'value')
    filetype='image';
else
    filetype='fig';
end
if get(handles.RdCurrPage,'value')
    pages='CurrentPage';
elseif get(handles.RdWhole,'value')
    pages='whole';
elseif get(handles.RdSelection,'value')
    pages='selection';
else
    pages=eval(['[' get(handles.TxtTimes,'String') ']']);
end

if(get(handles.PopPaper,'Value')==3)
    units=get(handles.PopUnit,'String');
    unit=units{get(handles.PopUnit,'Value')};
    width=str2double(get(handles.TxtWidth,'String'));
    height=str2double(get(handles.TxtHeight,'String'));
    paperparams={'PaperUnits', unit ,'PaperSize',[width height]};
else
    papertypes=get(handles.PopPaper,'String');
    paper=papertypes{get(handles.PopPaper,'Value')};
    if get(handles.ChkLandscape,'Value'), orientation='landscape'; else orientation='portrait'; end 
    paperparams={'PaperType', paper, 'PaperOrientation',orientation};
end    

if ishandle(handles.Fig)
    delete(handles.Fig);
end


end

%*****************************************************
function browse(src)
handles=guidata(src);
if get(handles.RdPDF,'value')
    filetype='*.pdf';
elseif get(handles.RdEPS,'value')
    filetype='*.ps';
elseif get(handles.RdImage,'value')
    filetype='*.bmp;*.pdf;*.eps;*.ps;*.pcx;*.jpg;*.tif;*.png;*.gif;';
else
    filetype='*.fig;*.m';
end
[f,d]=uiputfile(filetype,'Select file for exportation');
if(f~=0)
    set(handles.EdtFile,'String',[d f]);
end
end

%*****************************************************
function PaperSelect(src)
handles=guidata(src);
if get(handles.PopPaper,'Value')==3
    set(handles.PnlSize,'Visible','on');
    set(handles.ChkLandscape,'Visible','off');
else
    set(handles.PnlSize,'Visible','off');
    set(handles.ChkLandscape,'Visible','on');
end
end

%*****************************************************
function Export(src)
handles=guidata(src);
uiresume(handles.Fig);
end

%*****************************************************
function Cancel(src)
handles=guidata(src);
set(handles.EdtFile,'String','');
uiresume(handles.Fig);
% Delete the figure

end


