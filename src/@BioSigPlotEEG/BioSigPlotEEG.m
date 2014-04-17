%BioSigPlotEEG - Class to visualize EEG signals.
%It is a pre-configuration of BioSigPlot for electroencephalogram.
%
% USAGE
%  same as BioSigPlot
% 
% See also
%   BioSigPlot
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
% V0.1.2 Beta - 13/02/2013

classdef BioSigPlotEEG < BioSigPlot
    
    methods
        function obj=BioSigPlotEEG(data,varargin)
            obj=obj@BioSigPlot(data,varargin{:});           
        end
    end
    
    methods (Access=protected)
        function a=DefaultConfigFile(obj) %#ok<MANU>
            a='EEGdefaultconfig';
        end
    end
    
end