%Compute the proprecessed Data for dataset n


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


function [rcf, toco] = preprocessedData(obj)

leftborder=min(5*obj.SRate,obj.Time*obj.SRate);
rightborder=min(5*obj.SRate,  max( size(obj.Data{1},2)-(obj.Time+obj.WinLength)*obj.SRate , 0 ));

t=(obj.Time*obj.SRate+1-leftborder):(min((obj.Time+obj.WinLength)*obj.SRate,size(obj.Data{1},2))+rightborder);
rcf=double(obj.Data{1}(:,t));
toco=double(obj.Data{2}(:,t));
rcf = rcf(:,1+leftborder:end-rightborder);
toco = toco(:,1+leftborder:end-rightborder);

leftborder = (obj.Time*obj.SRate+1-leftborder) + leftborder + 1;
rightborder = (min((obj.Time+obj.WinLength)*obj.SRate,size(obj.Data{1},2))+rightborder) - rightborder;

end