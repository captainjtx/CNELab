
function toolToolbar(obj)
obj.TogPan=uitoggletool(obj.Toolbar,'CData',imread('pan.bmp'),'TooltipString','Vertical Pan',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.TogMeasurer=uitoggletool(obj.Toolbar,'CData',imread('measurer.bmp'),'TooltipString','Measure of each channels','separator','on',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.TogSelection=uitoggletool(obj.Toolbar,'CData',imread('select.bmp'),'TooltipString','Selection',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.TogEvts=uitoggletool(obj.Toolbar,'CData',imread('evts.bmp'),'TooltipString','Event Window','separator','on','Enable','off',...
    'ClickedCallback',@(src,evt) WinEvents(obj,src));


obj.TogAnnotate=uitoggletool(obj.Toolbar,'CData',imread('annotate.bmp'),'TooltipString','Annotate events','separator','on',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.TogVideo=uitoggletool(obj.Toolbar,'CData',imread('video.bmp'),'TooltipString','Video Window',...
    'ClickedCallback',@(src,evt) WinVideoFcn(obj,src));
end