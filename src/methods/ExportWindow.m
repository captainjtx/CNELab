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


classdef ExportWindow < handle
    
    properties
        bsp
        
        Fig
        
        RdPDF
        RdEPS
        RdImage
        RdFig
        
        RdCurrPage
        RdWhole
        RdSelection
        RdTimes
        TxtTimes
        
        PopPaper
        
        PnlSize
        PopUnit
        TxtWidth
        TxtHeight
        ChkLandscape
        
    end
    
    methods
        function obj=ExportWindow(bsp)
            obj.bsp=bsp;
            obj.Fig=figure('MenuBar','none','position',[100 100 600 450],'NumberTitle','off','Name','Export to',...
                'CloseRequestFcn',@obj.Cancel,'Resize','off');
            
            h5 = uibuttongroup('Parent',obj.Fig,'Units','Normalized','Title','Format','Clipping','on','Position',[0.05 0.85 0.9 0.1],'SelectionChangeFcn',[]);
            obj.RdPDF = uicontrol('Parent',h5,'Units','Normalized','Position',[0.01,0.2,0.24,0.6],'String','PDF (multipage)','Style','radiobutton','Value',1 );
            obj.RdEPS = uicontrol('Parent',h5,'Units','Normalized','Position',[0.26,0.2,0.24,0.6],'String','EPS (multipage)','Style','radiobutton');
            obj.RdImage = uicontrol('Parent',h5,'Units','Normalized','Position',[0.51,0.2,0.24,0.6],'String','Image (png)','Style','radiobutton');
            obj.RdFig = uicontrol('Parent',h5,'Units','Normalized','Position',[0.76,0.2,0.24,0.6],'String','Matlab Fig','Style','radiobutton');
            
            h10 = uibuttongroup('Parent',obj.Fig,'Units','Normalized','Title','Pages to export','Position',[0.05 0.5 0.9 0.3],'SelectionChangeFcn',[]);
            obj.RdCurrPage = uicontrol('Parent',h10,'Units','Normalized','Position',[0.05,0.7,0.8,0.18],'String','Current page','Style','radiobutton','Value',1);
            obj.RdWhole = uicontrol('Parent',h10,'Units','Normalized','Position',[0.05,0.5,0.8,0.18],'String','Whole file','Style','radiobutton');
            obj.RdSelection = uicontrol('Parent',h10,'Units','Normalized','Position',[0.05,0.3,0.8,0.18],'String','Pages with a selected period','Style','radiobutton');
            obj.RdTimes = uicontrol('Parent',h10,'Units','Normalized','Position',[0.05,0.1,0.6,0.18],'String','Pages starting with times:','Style','radiobutton');
            obj.TxtTimes = uicontrol('Parent',h10,'Units','Normalized','BackgroundColor',[1 1 1],'Position',[0.5,0.1,0.4,0.2],'String',blanks(0),'Style','edit');
            
            uicontrol('Parent',obj.Fig,'Units','Normalized','Position',[0.05 0.4 0.1 0.05],'String','Paper Size :','Style','text');
            obj.PopPaper = uicontrol('Parent',obj.Fig,'BackgroundColor',[1 1 1],'Callback',@obj.PaperSelect,'Units','Normalized','Position',[0.2,0.4,0.2,0.05],'String',{'usletter','A4','user-defined'},'Style','popupmenu','Value',1);
            
            obj.PnlSize = uipanel('Parent',obj.Fig,'Units','Normalized','Title',{  'Output size' },'Position',[0.5 0.15 0.45 0.3],'Visible','off');
            uicontrol('Parent',obj.PnlSize,'Units','Normalized','Position',[0.1,0.7,0.3,0.2],'String','Unit','Style','text');
            uicontrol('Parent',obj.PnlSize,'Units','Normalized','Position',[0.1,0.4,0.3,0.2],'String','Width','Style','text');
            uicontrol('Parent',obj.PnlSize,'Units','Normalized','Position',[0.1,0.1,0.3,0.2],'String','Height','Style','text');
            obj.PopUnit = uicontrol('Parent',obj.PnlSize,'Units','Normalized','BackgroundColor',[1 1 1],'Position',[0.5,0.7,0.4,0.2],'String',{'inches','centimeters','points'},'Style','popupmenu','Value',1);
            obj.TxtWidth = uicontrol('Parent',obj.PnlSize,'Units','Normalized','BackgroundColor',[1 1 1],'Position',[0.5,0.4,0.4,0.2],'String', '','Style','edit');
            obj.TxtHeight = uicontrol('Parent',obj.PnlSize,'Units','Normalized','BackgroundColor',[1 1 1],'Position',[0.5,0.1,0.4,0.2],'String', '','Style','edit');
            
            obj.ChkLandscape = uicontrol('Parent',obj.Fig,'Units','Normalized','Position',[0.05 0.2 0.2 0.05],'String','Landscape','Style','checkbox','Value',1);
            
            uicontrol('Parent',obj.Fig,'Units','Normalized','Position',[0.7,0.05,0.1,0.05],'String','Export','Callback',@obj.Export);
            uicontrol('Parent',obj.Fig,'Callback',@obj.Cancel,'Units','Normalized','Position',[0.85,0.05,0.1,0.05],'String','Cancel');
            
        end
        %******************************************************************
        function delete(obj)
            if ishandle(obj.Fig)
               delete(obj.Fig);
            end
        end
        %*****************************************************
        function PaperSelect(obj,src,evt)
            if get(obj.PopPaper,'Value')==3
                set(obj.PnlSize,'Visible','on');
                set(obj.ChkLandscape,'Visible','off');
            else
                set(obj.PnlSize,'Visible','off');
                set(obj.ChkLandscape,'Visible','on');
            end
        end
        
        %*****************************************************
        function Export(obj,src,evt)
            if get(obj.RdPDF,'value')
                filetype='*.pdf';
            elseif get(obj.RdEPS,'value')
                filetype='*.ps';
            elseif get(obj.RdImage,'value')
                filetype={'*.png';'*.jpg';'*.bmp';'*.gif';'*.tiff';'*.*'};
            else
                filetype='*.fig';
            end
            [FileName,FilePath]=uiputfile(filetype,'Select file for exportation');
            if FileName
                
                if get(obj.RdCurrPage,'value')
                    pages='CurrentPage';
                elseif get(obj.RdWhole,'value')
                    pages='whole';
                elseif get(obj.RdSelection,'value')
                    pages='selection';
                else
                    pages=eval(['[' get(obj.TxtTimes,'String') ']']);
                end
                
                if(get(obj.PopPaper,'Value')==3)
                    units=get(obj.PopUnit,'String');
                    unit=units{get(obj.PopUnit,'Value')};
                    width=str2double(get(obj.TxtWidth,'String'));
                    height=str2double(get(obj.TxtHeight,'String'));
                    paperparams={'PaperUnits', unit ,'PaperSize',[width height]};
                else
                    papertypes=get(obj.PopPaper,'String');
                    paper=papertypes{get(obj.PopPaper,'Value')};
                    if get(obj.ChkLandscape,'Value'), orientation='landscape'; else orientation='portrait'; end
                    paperparams={'PaperType', paper, 'PaperOrientation',orientation};
                end
                
                if strcmpi(pages,'CurrentPage')
                    pages=obj.bsp.Time;
                elseif strcmpi(pages,'Whole')
                    pages=0:obj.bsp.WinLength:((size(obj.bsp.Data{1},2)-1)/obj.bsp.SRate);
                elseif strcmpi(pages,'Selection')
                    pages=[];
                    for i=1:size(obj.bsp.Selection,2)
                        for d=floor(obj.bsp.Selection(1,i)):obj.bsp.WinLength:obj.bsp.Selection(2,i)
                            pages=[pages d]; %#ok<AGROW>
                        end
                    end
                end
                
                
                if(obj.RdImage || obj.RdFig)
                    ExportWindow.ExportPagesTo(obj.bsp,fullfile(FilePath,FileName),pages,paperparams{:});
                else
                    ExportWindow.ExportPagesToMultiPages(obj.bsp,fullfile(FilePath,FileName),pages,paperparams{:});
                end
                
                obj.delete();
            end
            
        end
        
        %*****************************************************
        function Cancel(obj,src,evt)
            delete(obj);
        end
    end
    
    methods (Static=true)
        function ExportPagesTo(bsp,file,pages,varargin)
            oldtime=bsp.Time;
            n=find(file=='.',1,'last');
            f=figure('Visible','on',varargin{:},'Position',get(bsp.Fig,'Position'));
            
            for p=pages
                if p~=pages(1)
                    bsp.Time=p;
                end
                filename=[file(1:n-1) '-' num2str(p) file(n:end)];
                clf(f);
                
                copyobj(bsp.Axes(:),f);
                try 
                    saveas(f,filename);
%                     export_fig(filename,f);
                catch
                    msgbox(['The following file cannot be written :' filename]); 
                end %#ok<CTCH>
                
            end
            close(f);
            if bsp.Time~=oldtime
                bsp.Time=oldtime;
            end
        end
        
         function ExportPagesToMultiPages(bsp,file,pages,varargin)
            % Export to a single mutli-page document (PDF or PS)
            %
            %
            % USAGE
            %   obj.ExportPagesToMultiPages(file,pages,'PaperUnits',unit,'PaperSize',[width height]);
            %   OR
            %   obj.ExportPagesToMultiPages(file,pages,'PaperUnits',unit,'PaperType',paper,'PaperOrientation',orientation);
            %
            % INPUT
            %   file
            %       Filename to export. Can be .pdf or .ps
            %
            %   pages
            %       list of time corresponding to begginings of pages
            %
            %   unit
            %       Paper size unit ('inches' | 'centimeters' | 'points')
            %
            %   width, height
            %       Dimension of the paper in unit
            %
            
            oldtime=bsp.Time;
            n=find(file=='.',1,'last');
            if strcmpi(file(n+1:end),'pdf')
                tmpname='tmp.ps';
            else
                tmpname=file;
            end
            f=figure('Visible','off',varargin{:});
            set(f,'paperpositionMode','manual','paperunits','Normalized','PaperPosition',[0.02 0.02 0.96 0.96]);
            firstpage=1;
            for p=pages
                bsp.Time=p;
                clf(f);
                
                copyobj(bsp.Axes(:),f);
                if (firstpage)
                    print(['-f' num2str(f)],'-dpsc','tmp.ps');
                    firstpage=0;
                else
                    print(['-f' num2str(f)],'-append','-dpsc','tmp.ps');
                end
                
            end
            close(f);
            if strcmpi(file(n+1:end),'pdf')
                g=struct(varargin{:});
                
                if isfield(g,'PaperType')
                    if strcmpi(g.PaperType,'usletter')
                        gspapersize='letter';
                    else
                        gspapersize=g.PaperType;
                    end
                    ps2pdf('psfile',tmpname,'pdffile',file,'gspapersize', gspapersize);
                elseif isfield(g,'PaperUnits') && isfield(g,'PaperSize')
                    if strcmpi(g.PaperUnits,'inches')
                        dims=round(g.PaperSize*72);
                    elseif strcmpi(g.PaperUnits,'centimeters')
                        dims=round(g.PaperSize*72/2.54);
                    else
                        dims=round(g.PaperSize);
                    end
                    ps2pdf('psfile',tmpname,'pdffile',file,'gsdevicewidthpoints',dims(1),'gsdeviceheightpoints',dims(2));
                else
                    ps2pdf('psfile',tmpname,'pdffile',file);
                end
                
                delete(tmpname);
            end
            
            bsp.Time=oldtime;
            
        end
    end
end


