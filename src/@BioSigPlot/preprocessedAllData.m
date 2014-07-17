function d=preprocessedAllData(obj,n,chan,selection)
%chan: Vector of channels selected
%selection: Vector of index of samples selected
d=double(obj.Data{n}(selection,:))*(obj.Montage{n}(obj.MontageRef(n)).mat*obj.ChanOrderMat{n})';
d=d(:,chan);
fs=obj.SRate;
ext=round(size(d,1)/10);
phs=0;
ftyp='iir';

for i=1:size(d,2)
    if obj.Filtering{n}(chan(i))
        if obj.StrongFilter{n}(chan(i))
            order=2;
        else
            order=1;
        end
        fl=obj.FilterLow{n}(chan(i));
        fh=obj.FilterHigh{n}(chan(i));
        
        fn1=obj.FilterNotch1{n}(chan(i));
        fn2=obj.FilterNotch2{n}(chan(i));
        
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