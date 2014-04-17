% Class to Open/Edit and Save Config Files (*.cfg), and change the
% configuration of the current BiosigPlot Object.


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


classdef ConfigWindow  < handle
    properties
        Fig
        BioSigPlotObj
        EdtConfigFile
        TxtKeys
        EdtKeys
        TxtHelpKeys
        PanelKeys
        SliderKeys
    end
    
    methods
        function obj=ConfigWindow(BioSigPlotObj)
            obj.Fig=figure('MenuBar','none','position',[100 100 730 650],'NumberTitle','off','Name','Config File Editor',...
                'CloseRequestFcn',@(src,evts) delete(obj),'ResizeFcn',@(src,evt) ChangePosition(obj));
            panfile=uipanel('parent',obj.Fig,'position',[0.01 .93 0.98 .05]);
            
            uicontrol(panfile,'Style','pushbutton','position',[5 5 95 20],'String','Load CFG File','Callback',@(src,evts) EvtLoad(obj));
            uicontrol(panfile,'Style','pushbutton','position',[105 5 95 20],'String','Save CFG File','Callback',@(src,evts) EvtSave(obj));
            uicontrol(panfile,'Style','pushbutton','position',[205 5 145 20],'String','Import from BioSigPlot','Callback',@(src,evts) EvtImport(obj));
            uicontrol(panfile,'Style','pushbutton','position',[355 5 145 20],'String','Export to BioSigPlot','Callback',@(src,evts) EvtExport(obj));
            uicontrol(panfile,'Style','pushbutton','position',[605 5 95 20],'String','Exit','Callback',@(src,evts) delete(obj));
            
            obj.PanelKeys=uipanel('parent',obj.Fig,'position',[0.01 0.01 .98 .88]);
            obj.SliderKeys=uicontrol(obj.Fig,'Style','slider','units','normalized','position',[0.97 0.01 .02 .88],'Callback',@(src,evt) ChangePosition(obj));
            
            if exist('BioSigPlotObj','var')
                obj.BioSigPlotObj=BioSigPlotObj;
            end
        end
        
        function delete(obj)
            % Delete the figure
            h = obj.Fig;
            if ishandle(h)
                delete(h);
            else
                return
            end
        end
        
        
        function EvtLoad(obj)
            [file,path]=uigetfile('*.cfg','Select a config file');
            if file~=0
                ConfigFile=[path file];
                
                if ~isempty(obj.TxtKeys)
                    for i=1:length(obj.TxtKeys)
                        delete(obj.TxtKeys(i));
                        delete(obj.EdtKeys(i))
                        delete(obj.TxtHelpKeys(i));
                    end
                    obj.TxtKeys=[];
                    obj.EdtKeys=[];
                    obj.TxtHelpKeys=[];
                end
                if exist(ConfigFile,'file')
                    C=load('-mat',ConfigFile);
                    names=fieldnames(C);
                    
                    for i=1:length(names)
                        obj.TxtKeys(i)=uicontrol(obj.PanelKeys,'Style','text','String',names{i},'HorizontalAlignment','Left');
                        obj.EdtKeys(i)=uicontrol(obj.PanelKeys,'Style','edit','BackgroundColor',[1 1 1],'String',obj2str(C.(names{i})),'HorizontalAlignment','Left');
                        obj.TxtHelpKeys(i)=uicontrol(obj.PanelKeys,'Style','text','String',help(['BioSigPlot.' names{i}]),'HorizontalAlignment','Left');
                    end
                    set(obj.PanelKeys,'units','pixels')
                    p=get(obj.PanelKeys,'position');
                    h=p(4);
                    set(obj.PanelKeys,'units','normalized')
                    m=max(length(names)*45+5-h,0.001);
                    set(obj.SliderKeys,'Max',m,'Value',m);
                    ChangePosition(obj);
                end
            end
        end
        
        function EvtSave(obj)
            [file,path]=uiputfile('*.cfg','Select a config file');
            if file~=0
                ConfigFile=[path file];
                
                
                if ~isempty(obj.TxtKeys)
                    for i=1:length(obj.TxtKeys)
                        C.(get(obj.TxtKeys(i),'String'))=eval(get(obj.EdtKeys(i),'String'));
                    end
                    
                    save(ConfigFile,'-mat','-struct','C');
                end
            end
        end
        
        function EvtImport(obj)
            
            
            ConfigFile='DefaultConfig.cfg';
            
            if ~isempty(obj.TxtKeys)
                for i=1:length(obj.TxtKeys)
                    delete(obj.TxtKeys(i));
                    delete(obj.EdtKeys(i))
                    delete(obj.TxtHelpKeys(i));
                end
                obj.TxtKeys=[];
                obj.EdtKeys=[];
                obj.TxtHelpKeys=[];
            end
            if exist(ConfigFile,'file')
                C=load('-mat',ConfigFile);
                names=fieldnames(C);
                
                for i=1:length(names)
                    obj.TxtKeys(i)=uicontrol(obj.PanelKeys,'Style','text','String',names{i},'HorizontalAlignment','Left');
                    obj.EdtKeys(i)=uicontrol(obj.PanelKeys,'Style','edit','BackgroundColor',[1 1 1],'String',obj2str(obj.BioSigPlotObj.(names{i})),'HorizontalAlignment','Left');
                    obj.TxtHelpKeys(i)=uicontrol(obj.PanelKeys,'Style','text','String',help(['BioSigPlot.' names{i}]),'HorizontalAlignment','Left');
                end
                set(obj.PanelKeys,'units','pixels')
                p=get(obj.PanelKeys,'position');
                h=p(4);
                set(obj.PanelKeys,'units','normalized')
                m=max(length(names)*45+5-h,0.001);
                set(obj.SliderKeys,'Max',m,'Value',m);
                ChangePosition(obj);
            end
            
        end
        
        function EvtExport(obj)
            g={};
            for i=1:length(obj.TxtKeys)
                g{2*i-1}=get(obj.TxtKeys(i),'String'); %#ok<*AGROW>
                g{2*i}=eval(get(obj.EdtKeys(i),'String'));
            end
            
            set(obj.BioSigPlotObj,g{:});
        end
        
        function ChangePosition(obj)
            set(obj.PanelKeys,'units','pixels')
            p=get(obj.PanelKeys,'position');
            h=p(4);
            set(obj.PanelKeys,'units','normalized')
            m=max(length(obj.TxtKeys)*45+5-h,0.001);
            set(obj.SliderKeys,'Max',m);
            
            h=h+m-get(obj.SliderKeys,'value');
            
            for i=1:length(obj.TxtKeys)
                if h-i*45+42<=p(4) && h-i*45>=1
                    set(obj.TxtKeys(i),'position',[10 h-i*45+16 150 20],'Visible','on');
                    set(obj.EdtKeys(i),'position',[160 h-i*45+16 p(3)-190 20],'Visible','on');
                    set(obj.TxtHelpKeys(i),'position',[165 h-i*45 p(3)-195 15],'Visible','on');
                    
                else
                    set(obj.TxtKeys(i),'Visible','off');
                    set(obj.EdtKeys(i),'Visible','off');
                    set(obj.TxtHelpKeys(i),'Visible','off');
                end
            end
        end
        
        
    end
    events
        EvtSelected
        EvtClosed
    end
end