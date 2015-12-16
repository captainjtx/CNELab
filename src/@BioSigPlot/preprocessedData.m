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


function d=preprocessedData(obj,varargin)

% t=ceil(obj.Time*obj.SRate+1):min(ceil((obj.Time+obj.WinLength)*obj.SRate),size(obj.Data{1},1));
if nargin==2
    n=varargin{1};
    d=double(obj.Data{n}*(obj.Montage{n}(obj.MontageRef(n)).mat)');
elseif nargin==3
    n=varargin{1};
    %make sure the data is montage transformed
    d=double(varargin{2});
else
    d=[];
    return
end

fs=obj.SRate;
ext=2*obj.SRate;
phs=0;
ftyp='iir';
order=obj.FilterOrder;

notch_single=strcmpi(get(obj.MenuNotchFilterSingle,'checked'),'on');

for i=1:size(d,2)
    if obj.Filtering{n}(i)
        
        fl=obj.FilterLow{n}(i);
        fh=obj.FilterHigh{n}(i);
        
        fn=obj.FilterNotch{n}(i);
        
        fcum=obj.FilterCustomIndex{n}(i);
        b=[];
        a=[];
        if fl==0||isempty(fl)||isnan(fl)||isinf(fl)
            if fh~=0
                if fh<(fs/2)
                    [b,a]=butter(order,fh/(fs/2),'low');
                end
            end
        else
            if fh==0||isempty(fh)||isnan(fh)||isinf(fh)
                [b,a]=butter(order,fl/(fs/2),'high');
            else
                if fl<fh
                    [b,a]=butter(order,[fl,fh]/(fs/2),'bandpass');
                elseif fl>fh
                    [b,a]=butter(order,[fl,fh]/(fs/2),'stop');
                end
            end
        end
        
        if ~isempty(b)||~isempty(a)
            d(:,i)=filter_symmetric(b,a,d(:,i),ext,phs,ftyp);
        end
        
        if ~isnan(fn)&&fn~=0
            if notch_single
                [b,a]=butter(order,[fn-2,fn+2]/(fs/2),'stop');
                d(:,i)=filter_symmetric(b,a,d(:,i),ext,phs,ftyp);
            else
                d(:,i)=filter_harmonic(d(:,i),fn,fs,order);
            end
        end
        
        d(:,i)=applyCustomFilters(obj,d(:,i),fcum);
        
    end
end

%apply subspace filter
if ~isempty(obj.SPFObj)&&isvalid(obj.SPFObj)&&isa(obj.SPFObj,'SPFPlot')
    sample=obj.SPFObj.sample;
    channel=obj.SPFObj.channel;
    dataset=obj.SPFObj.dataset;
    channel=channel(dataset==n);
    
    if ~isempty(channel)
        d(sample,channel)=obj.SPFObj.subspacefilter(d(sample,channel));
    end
end
end

function data=applyCustomFilters(obj,data,fcum)
if fcum==1||fcum==2
    return
else
    
    CustomFilters=obj.CustomFilters;
    fs=obj.SRate;
    
    if isfield(CustomFilters{fcum-2},'fir')
        fir=CustomFilters{fcum-2}.fir;
        for i=1:length(fir)
            a=1;
            b=fir(i).h;
            data=filter_symmetric(b,a,data,fs,0,'fir');
        end
        
    elseif isfield(CustomFilters{fcum-2},'iir')
        
        iir=CustomFilters{fcum-2}.iir;
        for i=1:length(iir)
            a=iir(i).a;
            b=iir(i).b;
            data=filter_symmetric(b,a,data,fs,0,'iir');
        end
    end
end

end
