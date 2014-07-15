function Time_Freq_Map(obj,src)

switch src
    case obj.MenuTFMapAverage
        set(src,'checked','on');
        set(obj.MenuTFMapChannel,'checked','off');
        set(obj.MenuTFMapGrid,'checked','off');
    case obj.MenuTFMapChannel
        set(src,'checked','on');
        set(obj.MenuTFMapAverage,'checked','off');
        set(obj.MenuTFMapGrid,'checked','off');
    case obj.MenuTFMapGrid
        set(src,'checked','on');
        set(obj.MenuTFMapAverage,'checked','off');
        set(obj.MenuTFMapChannel,'checked','off');
end

if strcmpi(get(obj.MenuTFMapAverage,'checked'),'on')
    option=1;
elseif strcmpi(get(obj.MenuTFMapChannel,'checked'),'on')
    option=2;
elseif strcmpi(get(obj.MenuTFMapGrid,'checked'),'on')
    option=3;
end


dd=obj.DisplayedData;
fs=obj.SRate;
data=[];
selection=[];

if ~isempty(obj.Selection)
    for i=1:size(obj.Selection,2)
        startInd=max(1,round(obj.Selection(1,i)*fs));
        endInd=min(size(obj.Data{1},1),round(obj.Selection(2,i)*fs));
        selection=cat(1,selection,startInd:endInd);
    end
else
    selection=1:size(obj.Data{1},1);
end

for i=1:length(dd)
    if ~obj.IsChannelSelected
        chan=1:obj.MontageChanNumber(dd(i));
    else
        chan=obj.ChanSelect2Edit{dd(i)};
    end
    d=preprocessedAllData(obj,dd(i),chan,selection);
    
    data=cat(2,data,d);
end

wd=200;
ov=180;
% refNum=20;

if ~ishandle(obj.TFMapFig)
    obj.TFMapFig=figure('Name','TFMap','Visible','off');
end
figure(obj.TFMapFig)
set(gcf,'visible','on')
clf

switch option
    case 1
        [tf,f,t]=bmi_tfmap(obj.TFMapFig,data(:,i),fs,wd,ov);  
        imagesc(t,f,tf/size(data,2));
        title('Time Frequency Map')
        colormap(jet);
        xlabel('time (s)');
        ylabel('frequency (Hz)')
        axis xy;
        colorbar
        
    case 2
        bmi_tfmap(obj.TFMapFig,data,fs,wd,ov);
    case 3
        
end

end

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
