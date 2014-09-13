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
fs=obj.SRate;

[data,chanNames]=get_selected_data(obj);

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
        [tf,f,t]=bsp_tfmap(obj.TFMapFig,data,fs,wd,ov,s,chanNames,freq);
        imagesc(t,f,10*log10(tf));
        
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
        bsp_tfmap(obj.TFMapFig,data,fs,wd,ov,s,chanNames,freq);
    case 3
        
end

end

