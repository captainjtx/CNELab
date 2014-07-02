function viewToolbar(obj)
obj.TogSuperimposed=uitoggletool(obj.Toolbar,'CData',imread('superimposed.bmp'),'Enable','off',...
    'TooltipString','Superimposed','separator','on','ClickedCallback',@(src,evt) set(obj,'DataView','Superimposed'));

obj.TogAlternated=uitoggletool(obj.Toolbar,'CData',imread('alternated.bmp'),'Enable','off',...
    'TooltipString','Alternated','ClickedCallback',@(src,evt) set(obj,'DataView','Alternated'));

obj.TogHorizontal=uitoggletool(obj.Toolbar,'CData',imread('horizontal.bmp'),'TooltipString','Horizontal','ClickedCallback',@(src,evt) set(obj,'DataView','Horizontal'));

obj.TogVertical=uitoggletool(obj.Toolbar,'CData',imread('vertical.bmp'),'TooltipString','Vertical','ClickedCallback',@(src,evt) set(obj,'DataView','Vertical'));

end