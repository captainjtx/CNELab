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
ext=min(2*obj.SRate,round(size(d,1)/2));
phs=0;
ftyp='iir';
order=obj.FilterOrder;

notch_single=strcmpi(get(obj.MenuNotchFilterSingle,'checked'),'on');

a=cell(size(d,2),1);
b=cell(size(d,2),1);
fn=obj.FilterNotch{n};
fcum=obj.FilterCustomIndex{n};

fchan=[];
for i=1:size(d,2)
    if obj.Filtering{n}(i)
        fl=obj.FilterLow{n}(i);
        fh=obj.FilterHigh{n}(i);
        
        if fl==0||isempty(fl)||isnan(fl)||isinf(fl)
            if fh~=0
                if fh<(fs/2)
                    [b{i},a{i}]=butter(order,fh/(fs/2),'low');
                end
            end
        else
            if fh==0||isempty(fh)||isnan(fh)||isinf(fh)
                [b{i},a{i}]=butter(order,fl/(fs/2),'high');
            else
                if fl<fh
                    [b{i},a{i}]=butter(order,[fl,fh]/(fs/2),'bandpass');
                elseif fl>fh
                    [b{i},a{i}]=butter(order,[fl,fh]/(fs/2),'stop');
                end
            end
        end
        
        if ~isempty(b{i})
            fchan=cat(1,fchan,i);
            if isempty(a{i})
                a{i}=1;
            end
        end
    end
end

if ~isempty(fchan)
    fd=d(:,fchan);
    fd=wextend('ar','sym',fd,ext,'b');
    
    ja=a(fchan);
    jb=b(fchan);
    
    fd=FastFilter(jb,ja,fd);
    d(:,fchan)=fd(ext+1:end-ext,fchan);
end

%needs to be cascaded in future
for i=1:size(d,2)
    if obj.Filtering{n}(i)
        if ~isnan(fn(i))&&fn(i)~=0
            if notch_single
                [b,a]=butter(order,[fn(i)-2,fn(i)+2]/(fs/2),'stop');
                d(:,i)=filter_symmetric(b{i},a{i},d(:,i),ext,phs,ftyp);
            else
                d(:,i)=filter_harmonic(d(:,i),fn(i),fs,order);
            end
        end
        d(:,i)=applyCustomFilters(obj,d(:,i),fcum(i));
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
