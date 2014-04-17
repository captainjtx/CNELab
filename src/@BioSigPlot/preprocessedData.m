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


function d=preprocessedData(obj,n)

leftborder=min(5*obj.SRate,obj.Time*obj.SRate);
rightborder=min(5*obj.SRate,  max( size(obj.Data{1},2)-(obj.Time+obj.WinLength)*obj.SRate , 0 )  );
t=(obj.Time*obj.SRate+1-leftborder):(min((obj.Time+obj.WinLength)*obj.SRate,size(obj.Data{1},2))+rightborder);
d=(obj.Montage{n}(obj.MontageRef(n)).mat*obj.ChanOrderMat{n})*double(obj.Data{n}(:,t));

if obj.StrongFilter
    order=6;zeroPhase=1;
else
    order=1;zeroPhase=0;
end
if obj.Filtering
    if obj.FilterLow~=0
        d=butterfilt(d,obj.SRate,obj.FilterLow,0,order,zeroPhase);
    end
    if obj.FilterHigh~=0
        d=butterfilt(d,obj.SRate,0,obj.FilterHigh,order,zeroPhase);
    end
    if obj.FilterNotch(1)~=0 && obj.FilterNotch(2)~=0
        d=butterfilt(d,obj.SRate,obj.FilterNotch(2),obj.FilterNotch(1),order,zeroPhase);
    end
end
d=d(:,1+leftborder:end-rightborder);

end