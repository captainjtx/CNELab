% Window Class showing Events and enabling to select them
%
% USAGE
%    a=EventWindow(EvtsCell);
%
% 
% PROPERTIES
%    Set Access : a.key1=value1
%    Get Access : value1=a.key1
% 
%   Evts        (Read/Write) List of Events in cell
%   EventTime   Time of the selected event
%   Fig         The fig handle of the Window
%
% EVENTS
%  EvtSelected  : Call every 0.5 s if time has changed
%  EvtClosed    : When the window is closed



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




classdef EventWindow  < handle
    properties
        EventTime
        Evts
        Fig
    end
        
    methods
            function obj=EventWindow(evts)
            obj.Fig=figure('MenuBar','none','position',[500 100 344 500],'NumberTitle','off','Name','Events','CloseRequestFcn',@(src,evts) delete(obj));
            for i=1:size(evts,1)
                s{i}=sprintf('%8.2f -%s',evts{i,1},evts{i,2}); %#ok<AGROW>
            end
            uicontrol(obj.Fig,'Style','listbox','units','normalized','position',[0 0 1 1],'FontName','FixedWidth','String',s,'Callback',@(src,evt) click(obj,src));
            obj.Evts=evts;
        end
        
        function delete(obj)
            % Delete the figure
            h = obj.Fig;
            notify(obj,'EvtClosed');
            if ishandle(h)
                delete(h);
            else
                return
            end
        end
        
        function click(obj,src)
            obj.EventTime=obj.Evts{get(src,'value'),1};
            notify(obj,'EvtSelected');
        end
        
    end
    events
        EvtSelected
        EvtClosed
    end

end