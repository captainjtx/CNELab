function MnuTFMapSettings(obj)

%**************************************************************************
% Dialog box to change the settings of Time frequency map
%**************************************************************************

prompt={'STFT window:','STFT overlap:','Lower bound of scale:','Upper bound of scale'};
def={num2str(obj.STFTWindowLength),num2str(obj.STFTOverlap),num2str(obj.STFTScaleLow),num2str(obj.STFTScaleHigh)};

title='Time Frequency Settings';

answer=inputdlg(prompt,title,1,def);

wo=str2double(answer{1});

needredraw=false;
needrescale=false;

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

sl=str2double(answer{3});
if ~isnan(sl)
    if obj.STFTScaleLow~=sl
        needrescale=true;
        obj.STFTScaleLow=sl;
    end
end

sh=str2double(answer{4});
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
end
    
end

