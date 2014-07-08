
function toolToolbar(obj)
obj.TogPan=uitoggletool(obj.Toolbar,'CData',imread('pan.bmp'),'TooltipString','Vertical Pan',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.TogMeasurer=uitoggletool(obj.Toolbar,'CData',imread('measurer.bmp'),'TooltipString','Measure of each channels','separator','on',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.TogSelection=uitoggletool(obj.Toolbar,'CData',imread('select.bmp'),'TooltipString','Selection',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.TogAnnotate=uitoggletool(obj.Toolbar,'CData',imread('evts.bmp'),'TooltipString','Insert events(i)','separator','on',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.TogVideo=uitoggletool(obj.Toolbar,'CData',imread('video.bmp'),'TooltipString','Video Window',...
    'ClickedCallback',@(src,evt) WinVideoFcn(obj,src));
end