function MnuTFMapSettings(obj)

%**************************************************************************
% Dialog box to change the settings of Time frequency map
%**************************************************************************
fs=obj.SRate;

prompt={'STFT window:','STFT overlap:',...
    'Room frequency low:','Room frequency high',...
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
    if obj.STFTScaleLow~=sl
        needrescale=true;
        obj.STFTScaleLow=sl;
    end
end

sh=str2double(answer{6});
if ~isnan(sh)
    if obj.STFTScaleHigh~=sh
        needrescale=true;
        obj.STFTScaleHigh=sh;
    end
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

