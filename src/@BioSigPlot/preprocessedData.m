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

% leftborder=round(min(5*obj.SRate,obj.Time*obj.SRate));
% rightborder=round(min(5*obj.SRate,  max( size(obj.Data{1},2)-(obj.Time+obj.WinLength)*obj.SRate , 0 )  ));
% t=(obj.Time*obj.SRate+1-leftborder):(min((obj.Time+obj.WinLength)*obj.SRate,size(obj.Data{1},2))+rightborder);


% if obj.StrongFilter
%     order=6;zeroPhase=1;
% else
%     order=1;zeroPhase=0;
% end
% if obj.Filtering
%     if fl~=0
%         d=butterfilt(d,obj.SRate,fl,0,order,zeroPhase);
%     end
%     if fh~=0
%         d=butterfilt(d,obj.SRate,0,fh,order,zeroPhase);
%     end
%     if obj.FilterNotch(1)~=0 && obj.FilterNotch(2)~=0
%         d=butterfilt(d,obj.SRate,obj.FilterNotch(2),obj.FilterNotch(1),order,zeroPhase);
%     end
% end
% d=d(:,1+leftborder:end-rightborder);
t=ceil(obj.Time*obj.SRate+1):min(ceil((obj.Time+obj.WinLength)*obj.SRate),size(obj.Data{1},2));
d=(obj.Montage{n}(obj.MontageRef(n)).mat*obj.ChanOrderMat{n})*double(obj.Data{n}(:,t));

order=1;
fs=obj.SRate;
ext=100;
phs=0;
ftyp='iir';

if obj.Filtering
    fl=obj.FilterLow;
    fh=obj.FilterHigh;
    
    if fl==0
        if fh~=0
            if fh<(fs/2)
                [b,a]=butter(order,fh/(fs/2),'low');
            end
        end
    else
        if fh==0
            [b,a]=butter(order,fl/(fs/2),'high');
        else
            if fl<fh
                [b,a]=butter(order,[fl,fh]/(fs/2),'bandpass');
            elseif fl>fh
                [b,a]=butter(order,[fl,fh]/(fs/2),'stop');
            end
        end         
    end
    
    if exist('b','var')&&exist('a','var')
    d=filter_symmetric(b,a,d',ext,phs,ftyp);
    d=d';
    end
    
end

end