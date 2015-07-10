function Power_Spectrum_Density(obj,src)
%control the menu check====================================================
switch src
    case obj.MenuPSDSettings
        MnuPSDSettings(obj);
        return
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
    case obj.MenuPSD_Normal
        set(src,'checked','on');
        set(obj.MenuPSD_DB,'checked','off');
    case obj.MenuPSD_DB
        set(src,'checked','on');
        set(obj.MenuPSD_Normal,'checked','off');
        
end
%==========================================================================
%continue ?

if ~ishandle(obj.PSDFig)
    if ismember(src,[obj.MenuPSDAverage,obj.MenuPSDChannel,obj.MenuPSDGrid,...
        obj.MenuPSD_Normal,obj.MenuPSD_DB])
        return
    end
end

%==========================================================================
if strcmpi(get(obj.MenuPSDAverage,'checked'),'on')
    option=1;
elseif strcmpi(get(obj.MenuPSDChannel,'checked'),'on')
    option=2;
elseif strcmpi(get(obj.MenuPSDGrid,'checked'),'on')
    option=3;
end

if strcmpi(get(obj.MenuPSD_Normal,'checked'),'on')
    unit='normal';
elseif strcmpi(get(obj.MenuPSD_DB,'checked'),'on')
    unit='dB';
end
%==========================================================================
fs=obj.SRate;

omitMask=true;
[data,chanNames]=get_selected_data(obj,omitMask);

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
        
        if strcmpi(unit,'dB')
            plot(f,10*log10(psd(indLow:indHigh)));
        else
            plot(f,psd(indLow:indHigh));
        end
        
        xlim([freq(1),freq(2)])
        set(gca,'Tag','PSDAxes');
        title('Power Spectrum Density')

        xlabel('Frequency (Hz)');
        ylabel(['Power ',unit])
        
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
        
        if strcmpi(unit,'dB')
            plot(f*ones(1,size(psd,2)),10*log10(psd(indLow:indHigh,:)));
        else
            plot(f*ones(1,size(psd,2)),psd(indLow:indHigh,:));
        end
        
        xlim([freq(1),freq(2)])
        set(gca,'Tag','PSDAxes');
        title('Power Spectrum Density')

        xlabel('Frequency (Hz)');
        ylabel(['Power ',unit])
        
        legend(chanNames)
    case 3
        
end

end

function MnuPSDSettings(obj)

%**************************************************************************
% Dialog box to change the settings of Power spectrum density
%**************************************************************************
fs=obj.SRate;

prompt={'PSD window:','PSD overlap:',...
    'Frequency low:','Frequency high'};

def={num2str(obj.PSDWindowLength),num2str(obj.PSDOverlap),...
    num2str(obj.PSDFreqLow),num2str(obj.PSDFreqHigh)};

title='Periodogram Settings';


answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

wo=str2double(answer{1});

needredraw=false;
needroom=false;

if ~isnan(wo)
    if obj.PSDWindowLength~=wo
        needredraw=true;
        obj.PSDWindowLength=wo;
    end
end

ov=str2double(answer{2});
if ~isnan(ov)
    if obj.PSDOverlap~=ov
        needredraw=true;
        obj.PSDOverlap=ov;
    end
end

fl=str2double(answer{3});
if ~isnan(fl)
    if obj.PSDFreqLow~=fl&&fl>=0
       needroom=true;
       obj.PSDFreqLow=fl;
    end
end

fh=str2double(answer{4});
if ~isnan(fh)
    if obj.PSDFreqHigh~=fh&&fh<=fs/2
        needroom=true;
        obj.PSDFreqHigh=fh;
    end
end

if ishandle(obj.PSDFig)
    if needredraw
        Time_Freq_Map(obj,obj.BtnPSD);
        return
    end
    
    h=findobj(obj.PSDFig,'Tag','PSDAxes');
    
    if needroom
        set(h,'XLim',[fl,fh]);
        figure(obj.PSDFig);
    end
end

end



