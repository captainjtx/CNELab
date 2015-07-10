function Time_Freq_Map(obj,src)
%control the menu check====================================================
switch src
    case obj.MenuTFMapSettings
        MnuTFMapSettings(obj);
        return
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
    case obj.MenuTFMap_Normal
        set(src,'checked','on');
        set(obj.MenuTFMap_DB,'checked','off');
        obj.STFTScaleLow=[];
        obj.STFTScaleHigh=[];
    case obj.MenuTFMap_DB
        set(src,'checked','on');
        set(obj.MenuTFMap_Normal,'checked','off');
        obj.STFTScaleLow=[];
        obj.STFTScaleHigh=[];
end
%==========================================================================
%continue ?
if ~ishandle(obj.TFMapFig)
    if ismember(src,[obj.MenuTFMapAverage,obj.MenuTFMapChannel,obj.MenuTFMapGrid,...
            obj.MenuTFMap_Normal,obj.MenuTFMap_DB])
        return
    end
end
%==========================================================================
if strcmpi(get(obj.MenuTFMapAverage,'checked'),'on')
    option=1;
elseif strcmpi(get(obj.MenuTFMapChannel,'checked'),'on')
    option=2;
elseif strcmpi(get(obj.MenuTFMapGrid,'checked'),'on')
    option=3;
end

if strcmpi(get(obj.MenuTFMap_Normal,'checked'),'on')
    unit='normal';
else
    unit='dB';
end
%==========================================================================
fs=obj.SRate;

omitMask=true;
[data,chanNames]=get_selected_data(obj,omitMask);

wd=obj.STFTWindowLength;
ov=obj.STFTOverlap;

s=[obj.STFTScaleLow obj.STFTScaleHigh];
freq=[obj.STFTFreqLow obj.STFTFreqHigh];

if ~ishandle(obj.TFMapFig)
    obj.TFMapFig=figure('Name','TFMap','Visible','off','NumberTitle','off');
end
figure(obj.TFMapFig)
set(gcf,'visible','on')
clf

switch option
    case 1
        [tf,f,t]=bsp_tfmap(obj.TFMapFig,data,fs,wd,ov,s,chanNames,freq,unit);
        if strcmpi(unit,'dB')
            imagesc(t,f,10*log10(tf));
        else
            imagesc(t,f,tf);
        end
        
        if ~isempty(s)
            set(gca,'CLim',s);
        end
        set(gca,'YLim',freq);
        set(gca,'Tag','TFMapAxes');
        title('Time Frequency Map')
        colormap(jet);
        xlabel('time (s)');
        ylabel('frequency (Hz)')
        axis xy;
        colorbar
        
    case 2
        bsp_tfmap(obj.TFMapFig,data,fs,wd,ov,s,chanNames,freq,unit);
    case 3
        
end

end
function MnuTFMapSettings(obj)

%**************************************************************************
% Dialog box to change the settings of Time frequency map
%**************************************************************************
fs=obj.SRate;

prompt={'STFT window:','STFT overlap:',...
    'Frequency low:','Frequency high',...
    'Lower bound of scale:','Upper bound of scale'};

def={num2str(obj.STFTWindowLength),num2str(obj.STFTOverlap),...
    num2str(obj.STFTFreqLow),num2str(obj.STFTFreqHigh),...
    num2str(obj.STFTScaleLow),num2str(obj.STFTScaleHigh)};

title='Time Frequency Settings';


answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

wo=str2double(answer{1});

needredraw=false;
needrescale=false;
needroom=false;

if ~isnan(wo)
    if obj.STFTWindowLength~=wo
        needredraw=true;
        obj.STFTWindowLength=wo;
    end
end

ov=str2double(answer{2});
if ~isnan(ov)
    if obj.STFTOverlap~=ov
        needredraw=true;
        obj.STFTOverlap=ov;
    end
end

fl=str2double(answer{3});
if ~isnan(fl)
    if obj.STFTFreqLow~=fl&&fl>=0
       needroom=true;
       obj.STFTFreqLow=fl;
    end
end

fh=str2double(answer{4});
if ~isnan(fh)
    if obj.STFTFreqHigh~=fh&&fh<=fs/2
        needroom=true;
        obj.STFTFreqHigh=fh;
    end
end
sl=str2double(answer{5});
if ~isnan(sl)
    if isempty(obj.STFTScaleLow)||obj.STFTScaleLow~=sl
        needrescale=true;
        obj.STFTScaleLow=sl;
    end
end

sh=str2double(answer{6});
if ~isnan(sh)
    if isempty(obj.STFTScaleHigh)||obj.STFTScaleHigh~=sh
        needrescale=true;
        obj.STFTScaleHigh=sh;
    end
end

if obj.STFTScaleHigh<=obj.STFTScaleLow
    obj.STFTScaleLow=[];
    obj.STFTScaleHigh=[];
end

if ishandle(obj.TFMapFig)
    if needredraw
        Time_Freq_Map(obj,obj.BtnTFMap);
        return
    end
    
    h=findobj(obj.TFMapFig,'Tag','TFMapAxes');
    
    if needrescale
        set(h,'CLim',[obj.STFTScaleLow,obj.STFTScaleHigh]);
        figure(obj.TFMapFig);
    end
    
    if needroom
        set(h,'YLim',[fl,fh]);
        figure(obj.TFMapFig);
    end
end
    
end


