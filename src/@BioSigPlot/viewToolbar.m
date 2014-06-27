function viewToolbar(obj)
obj.TogSuperimposed=uitoggletool(obj.Toolbar,'CData',imread('superimposed.bmp'),'TooltipString','Superimposed','separator','on','ClickedCallback',@(src,evt) set(obj,'DataView','Superimposed'));
obj.TogAlternated=uitoggletool(obj.Toolbar,'CData',imread('alternated.bmp'),'TooltipString','Alternated','ClickedCallback',@(src,evt) set(obj,'DataView','Alternated'));
obj.TogHorizontal=uitoggletool(obj.Toolbar,'CData',imread('horizontal.bmp'),'TooltipString','Horizontal','ClickedCallback',@(src,evt) set(obj,'DataView','Horizontal'));
obj.TogVertical=uitoggletool(obj.Toolbar,'CData',imread('vertical.bmp'),'TooltipString','Vertical','ClickedCallback',@(src,evt) set(obj,'DataView','Vertical'));

for i=1:9
    obj.TogData(i)=uitoggletool(obj.Toolbar,'CData',imread(['eeg' num2str(i) '.bmp']),'TooltipString',['DAT' num2str(i)],'ClickedCallback',@(src,evt) set(obj,'DataView',['DAT' num2str(i)]));
end

for i=obj.DataNumber+1:9
    set(obj.TogData(i),'Enable','off')
end
end