function viewToolbar(obj)

obj.TogHorizontal=uitoggletool(obj.Toolbar,'CData',imread('horizontal.bmp'),...
    'TooltipString','Horizontal','ClickedCallback',@(src,evt) set(obj,'DataView','Horizontal'));

obj.TogVertical=uitoggletool(obj.Toolbar,'CData',imread('vertical.bmp'),...
    'TooltipString','Vertical','ClickedCallback',@(src,evt) set(obj,'DataView','Vertical'));

end