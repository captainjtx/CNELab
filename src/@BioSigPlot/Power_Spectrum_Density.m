function Power_Spectrum_Density(obj,src)

switch src
    case obj.MenuPSDAverage
        set(src,'checked','on');
        set(obj.MenuPSDChannel,'checked','off');
        set(obj.MenuPSDGrid,'checked','off');
    case obj.MenuPSDChannel
        set(src,'checked','on');
        set(obj.MenuPSDAverage,'checked','off');
        set(obj.MenuPSDGrid,'checked','off');
    case obj.MenuPSDGrid
        set(src,'checked','on');
        set(obj.MenuPSDAverage,'checked','off');
        set(obj.MenuPSDChannel,'checked','off');
end

if strcmpi(get(obj.MenuPSDAverage,'checked'),'on')
    option=1;
elseif strcmpi(get(obj.MenuPSDChannel,'checked'),'on')
    option=2;
elseif strcmpi(get(obj.MenuPSDGrid,'checked'),'on')
    option=3;
end

fs=obj.SRate;

[data,chanNames]=get_selected_data(obj);

wd=round(obj.PSDWindowLength);
ov=round(obj.PSDOverlap);
if isempty(wd)||wd>size(data,1)
    wd=round(size(data,1)/8);
    ov=round(wd*0.5);
end

if ov>wd
    ov=round(wd*0.5);
end

obj.PSDWindowLength=wd;
obj.PSDOverlap=ov;


nfft=wd;

freq=[obj.PSDFreqLow obj.PSDFreqHigh];

if ~ishandle(obj.PSDFig)
    obj.PSDFig=figure('Name','Power Spectrum Density','Visible','off','NumberTitle','off');
end
figure(obj.PSDFig)
set(obj.PSDFig,'visible','on')
clf

switch option
    case 1
        psd=0;
        for i=1:size(data,2)
            tmp=pwelch(data(:,i),wd,ov,nfft,fs,'onesided');
            psd=psd+tmp;
        end
        psd=psd/size(data,2);
        
        indLow=max(1,min(ceil(freq(1)/(fs/2)*length(psd)),length(psd)));
        indHigh=max(1,min(ceil(freq(2)/(fs/2)*length(psd)),length(psd)));
        f=linspace(freq(1),freq(2),indHigh-indLow+1);
        plot(f,10*log10(psd(indLow:indHigh)));
        
        xlim([freq(1),freq(2)])
        set(gca,'Tag','PSDAxes');
        title('Power Spectrum Density')

        xlabel('Frequency (Hz)');
        ylabel('Power (dB)')
        
    case 2
        psd=[];
        for i=1:size(data,2)
            tmp=pwelch(data(:,i),wd,ov,nfft,fs,'onesided');
            tmp=reshape(tmp,length(tmp),1);
            psd=cat(2,psd,tmp);
        end
        
        indLow=max(1,min(ceil(freq(1)/(fs/2)*size(psd,1)),size(psd,1)));
        indHigh=max(1,min(ceil(freq(2)/(fs/2)*size(psd,1)),size(psd,1)));
        f=linspace(freq(1),freq(2),indHigh-indLow+1);
        f=reshape(f,length(f),1);
        plot(f*ones(1,size(psd,2)),10*log10(psd(indLow:indHigh,:)));
        
        xlim([freq(1),freq(2)])
        set(gca,'Tag','PSDAxes');
        title('Power Spectrum Density')

        xlabel('Frequency (Hz)');
        ylabel('Power (dB)')
        
        legend(chanNames)
    case 3
        
end

end

