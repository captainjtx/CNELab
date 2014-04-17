%BioSigPlotFHR - Class to visualize EEG signals.
%It is a pre-configuration of BioSigPlot for electroencephalogram.
%
%
% USAGE
%   >> BioSigPlot(FHR,TOCO, 'key1', value1 ...);
% INPUT
%   FHR  
%      Foetal Heart rate data 
%
%   TOCO
%      TOCO data
%
%   key1, key2,... : same as BioSigPlot
%
% See also
%    BioSigPlot
%   



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
% V0.1.2 Beta - 22/02/2013 


classdef BioSigPlotFHR < BioSigPlot
    properties (Access = protected,Hidden)
        StateMeasurer
    end
    methods

        function obj=BioSigPlotFHR(FHR,TOCO,varargin)
            
            data={FHR TOCO};
            
            obj=obj@BioSigPlot(data,varargin{:});
            obj.StateMeasurer=[0 0 0];
        end
        
    end
    methods(Access=protected)
        %*****************************************************
        function a=DefaultConfigFile(obj) %#ok<MANU>
            a='FHRdefaultconfig';
        end
        
        
        %*****************************************************
        function makeControls(obj)
            obj.timeControlPanel(obj.ControlPanel,[0 0 .2 1]);
            obj.infoControlPanel(obj.ControlPanel,[0.2 0 .2 1]);
        end
        
        %*****************************************************
        function makeToolbar(obj)
            obj.toolToolbar();
        end
        
        %*****************************************************
        function makeMenu(obj)
            obj.MenuFile=uimenu(obj.Fig,'Label','File');
            obj.MenuExport=uimenu(obj.MenuFile,'Label','Export to','Callback',@(src,evt) obj.ExportToWindow);
            obj.MenuCopy=uimenu(obj.MenuFile,'Label','Copy','Enable','off');
            obj.MenuSettings=uimenu(obj.Fig,'Label','Settings');
            obj.MenuCommands=uimenu(obj.MenuSettings,'Label','Command List',...
                'Callback',@(src,evts) listdlg('ListString',obj.Commands,'ListSize',[700 500],'PromptString','List of commands'));
            obj.MenuConfigurationState=uimenu(obj.MenuSettings,'Label','Configuration file','Callback',@(src,evt) ConfigWindow(obj));
            %obj.MenuColors=uimenu(obj.MenuSettings,'Label','Colors');
            obj.MenuReadSpeedTime=uimenu(obj.MenuSettings,'Label','Set the time for fast reading','Callback',@(src,evt) MnuFastRead(obj));
            obj.MenuChan=uimenu(obj.MenuSettings,'Label','Number of channels to display','Callback',@(src,evt) MnuChan2Display(obj));
            obj.MenuTime2disp=uimenu(obj.MenuSettings,'Label','Time range to display','Callback',@(src,evt) MnuTime2Display(obj));
            obj.MenuChanLink=uimenu(obj.MenuSettings,'Label','All datasets have the same channels',...
                'Callback',@(src,evt) set(obj,'ChanLink',~obj.ChanLink));
            obj.MenuDisplay=uimenu(obj.Fig,'Label','Display');
            obj.MenuInsideTicks=uimenu(obj.MenuDisplay,'Label','Put ticks inside the graph',...
                'Callback',@(src,evt) set(obj,'InsideTicks',~obj.InsideTicks));
            obj.MenuXGrid=uimenu(obj.MenuDisplay,'Label','Show XGrid',...
                'Callback',@(src,evt) set(obj,'XGrid',~obj.XGrid));
            obj.MenuYGrid=uimenu(obj.MenuDisplay,'Label','Show YGrid',...
                'Callback',@(src,evt) set(obj,'YGrid',~obj.YGrid));
        end
        
        
        %*****************************************************
        function MouseMovementMeasurer(obj)
            t=floor((obj.MouseTime-obj.Time)*obj.SRate);
            [unused,ndata,yvalue]=getMouseInfo(obj); %#ok<ASGLU>
            time=obj.MouseTime;
            
            
            for i=1:length(obj.Axes)
                
                set(obj.LineMeasurer(i),'XData',[t t])
                set(obj.LineMeasurer(i+2),'YData',[yvalue(i) yvalue(i)])
                % if round(time*obj.SRate)<=size(obj.Data{ndata},2)&&
                for j=1:length(obj.TxtMeasurer{i})% value changes with the movement of the mouse
                    p=get(obj.TxtMeasurer{i}(j),'position');
                    p(1)=t+0.01*obj.WinLength*obj.SRate;
                    %------------different states of measurer------------------------
                    if obj.StateMeasurer(1) == 0
                        set(obj.TxtMeasurer{i}(j),'Position',[p(1),yvalue(i)],'String',[num2str(floor(yvalue(ndata))) ' bpm']);
                    else
                        set(obj.TxtMeasurer{i}(j),'Position',[p(1),yvalue(i)],'String',[num2str(floor(yvalue(ndata) - obj.StateMeasurer(3))) ' bpm']);
                        m=floor(rem((time-obj.StateMeasurer(2)),60));
                        s=floor((rem((time-obj.StateMeasurer(2)),60) - m)*60);
                        set(obj.TxtMeasurer{i+2}(j),'Position',[p(1),yvalue(i)],'String',[num2str(m) 'm ' num2str(s) 's ']);
                    end
                end
            end
        end
        %*****************************************************
        function MouseDown(obj)
            
            
            if strcmpi(obj.MouseMode,'Measurer')
                [nchan,ndata,yvalue]=getMouseInfo(obj); %#ok<ASGLU>
                time=obj.MouseTime;
                t=floor((obj.MouseTime-obj.Time)*obj.SRate);
                if obj.StateMeasurer(1) == 0
                    for i=1:length(obj.Axes)
                        set(obj.LineMeasurer(i+4),'XData',[t t])
                        set(obj.LineMeasurer(i+6),'YData',[yvalue(i) yvalue(i)])
                        for j=1:length(obj.TxtMeasurer{i})
                            p=get(obj.TxtMeasurer{i}(j),'position');
                            p(1)=t+0.01*obj.WinLength*obj.SRate;
                            set(obj.TxtMeasurer{i+4}(j),'Position',[p(1),yvalue(i)],'String',[num2str(floor(yvalue(ndata))) ' bpm']);
                            obj.StateMeasurer(2)=time;
                            obj.StateMeasurer(3)=yvalue(ndata);
                        end
                    end
                else
                    for i=1:length(obj.Axes)
                        set(obj.LineMeasurer(i+4),'XData',[-1 -1])
                        set(obj.LineMeasurer(i+6),'YData',[-1 -1])
                        for j=1:length(obj.TxtMeasurer{i})
                            set(obj.TxtMeasurer{i}(j),'String',[num2str(floor(yvalue(ndata))) ' bpm']);
                            set(obj.TxtMeasurer{i+2}(j),'Position',[-200 -100]);
                            set(obj.TxtMeasurer{i+4}(j),'Position',[-100,-100]);
                        end
                    end
                end
                refresh
                if obj.StateMeasurer(1) == 0
                    obj.StateMeasurer(1) = 1;
                else
                    obj.StateMeasurer(1) = 0;
                end
            else
                MouseDown@BioSigPlot(obj);
            end
        end
        
        %*****************************************************
        function ChangTime(obj)
            obj.StateMeasurer(1)=0;
            ChangTime@BioSigPlot(obj);
        end
        
        %*****************************************************
        function ChangeMouseMode(obj,src)
            obj.StateMeasurer(1)=0;
            ChangeMouseMode@BioSigPlot(obj,src);
        end
        
        
    end
    
end