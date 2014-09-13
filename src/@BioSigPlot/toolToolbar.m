
function toolToolbar(obj)

obj.BtnWidthIncrease=uipushtool(obj.Toolbar,'CData',imread('time_plus.png'),'TooltipString','Increase width','separator','on',...
    'ClickedCallback',@(src,evt) ChangeDuration(obj,src));

obj.BtnWidthDecrease=uipushtool(obj.Toolbar,'CData',imread('time_minus.png'),'TooltipString','Decrease width',...
    'ClickedCallback',@(src,evt) ChangeDuration(obj,src));

obj.BtnHeightIncrease=uipushtool(obj.Toolbar,'CData',imread('chan_plus.png'),'TooltipString','Increase height',...
    'ClickedCallback',@(src,evt) ChangeChan(obj,src));

obj.BtnHeightDecrease=uipushtool(obj.Toolbar,'CData',imread('chan_minus.png'),'TooltipString','Decrease height',...
    'ClickedCallback',@(src,evt) ChangeChan(obj,src));

obj.BtnGainIncrease=uipushtool(obj.Toolbar,'CData',imread('gain_plus.png'),'TooltipString','Increase gain (ctrl =)','separator','on',...
    'ClickedCallback',@(src,evt) ChangeGain(obj,src));

obj.BtnGainDecrease=uipushtool(obj.Toolbar,'CData',imread('gain_minus.png'),'TooltipString','Decrease gain (ctrl -)',...
    'ClickedCallback',@(src,evt) ChangeGain(obj,src));

obj.BtnAutoScale=uipushtool(obj.Toolbar,'CData',imread('auto_scale.png'),'TooltipString','Auto scale','separator','on',...
    'ClickedCallback',@(src,evt) ChangeGain(obj,src));

obj.BtnMaskChannel=uipushtool(obj.Toolbar,'CData',imread('mask.png'),'TooltipString','Mask channel','separator','on',...
    'ClickedCallback',@(src,evt) maskChannel(obj,src));
obj.BtnUnMaskChannel=uipushtool(obj.Toolbar,'CData',imread('unmask.png'),'TooltipString','UnMask Channel',...
    'ClickedCallback',@(src,evt) maskChannel(obj,src));

obj.TogSelection=uitoggletool(obj.Toolbar,'CData',imread('select.bmp'),'TooltipString','Selection(ctrl e)','separator','on',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.TogMeasurer=uitoggletool(obj.Toolbar,'CData',imread('measurer.bmp'),'TooltipString','Measure of each channels','separator','on',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.TogAnnotate=uitoggletool(obj.Toolbar,'CData',imread('evts.bmp'),'TooltipString','Insert events(ctrl i)','separator','on',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));
obj.BtnPSD=uipushtool(obj.Toolbar,'CData',imread('psd.png'),'TooltipString','Power Spectrum Density','separator','on',...
    'ClickedCallback',@(src,evt) Power_Spectrum_Density(obj,src));
obj.BtnTFMap=uipushtool(obj.Toolbar,'CData',imread('tfmap.bmp'),'TooltipString','Time-Frequency Map',...
    'ClickedCallback',@(src,evt) Time_Freq_Map(obj,src));

obj.BtnPCA=uitoggletool(obj.Toolbar,'CData',imread('pca.png'),'TooltipString','Principle Component Analysis',...
    'ClickedCallback',@(src,evt) SPF_Analysis(obj,src));
obj.BtnICA=uitoggletool(obj.Toolbar,'CData',imread('ica.png'),'TooltipString','Independent Component Analysis',...
    'ClickedCallback',@(src,evt) SPF_Analysis(obj,src));
end