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

% t=ceil(obj.Time*obj.SRate+1):min(ceil((obj.Time+obj.WinLength)*obj.SRate),size(obj.Data{1},1));
d=double(obj.Data{n})*(obj.Montage{n}(obj.MontageRef(n)).mat*obj.ChanOrderMat{n})';

fs=obj.SRate;
ext=2*obj.SRate;
phs=0;
ftyp='iir';

for i=1:size(d,2)
    if obj.Filtering{n}(i)
        if obj.StrongFilter{n}(i)
            order=2;
        else
            order=1;
        end
        fl=obj.FilterLow{n}(i);
        fh=obj.FilterHigh{n}(i);
        
        fn1=obj.FilterNotch1{n}(i);
        fn2=obj.FilterNotch2{n}(i);
        
        if fl==0||isempty(fl)||isnan(fl)
            if fh~=0
                if fh<(fs/2)
                    [b,a]=butter(order,fh/(fs/2),'low');
                end
            end
        else
            if fh==0||isempty(fh)||isnan(fh)
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
            d(:,i)=filter_symmetric(b,a,d(:,i),ext,phs,ftyp);
        end
        
        if ~isnan(fn1)&&~isnan(fn2)&&fn1~=0&&fn2~=0&&fn1<fn2
            [b,a]=butter(order,[fn1,fn2]/(fs/2),'stop');
            d(:,i)=filter_symmetric(b,a,d(:,i),ext,phs,ftyp);
        end
        
    end
end
end