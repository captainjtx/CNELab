function showTimeLabel(obj,src)
if nargin>1
    if strcmpi(get(obj.MenuTimeLabel,'checked'),'on')
        set(obj.MenuTimeLabel,'checked','off');
    else
        set(obj.MenuTimeLabel,'checked','on');
    end
end

dd=obj.DisplayedData;

for i=1:length(dd)
    if length(obj.Axes)==1
        axe=obj.Axes;
    else
        axe=obj.Axes(dd(i));
    end
    
    h=findobj(axe,'-regexp','DisplayName','XTick*');
    if ~isempty(h)
        for j=1:length(h)
            set(h(j),'Visible',get(obj.MenuTimeLabel,'checked'));
        end
    end
end

end

