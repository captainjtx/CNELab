function MnuPSDSettings(obj)

%**************************************************************************
% Dialog box to change the settings of Power spectrum density
%**************************************************************************
fs=obj.SRate;

prompt={'PSD window:','PSD overlap:',...
    'Room frequency low:','Room frequency high'};

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

