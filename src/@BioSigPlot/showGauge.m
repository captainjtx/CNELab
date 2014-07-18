function showGauge(obj,src)
dd=obj.DisplayedData;

if nargin>1
    if strcmpi(get(obj.MenuGauge,'checked'),'on')
        set(obj.MenuGauge,'checked','off');
    else
        set(obj.MenuGauge,'checked','on');
    end
end

for i=1:length(dd)
    if length(obj.Axes)==1
        axe=obj.Axes;
    else
        axe=obj.Axes(dd(i));
    end
    
    h=findobj(axe,'-regexp','DisplayName','YGauge*');
    if ~isempty(h)
        for j=1:length(h)
            set(h(j),'Visible',get(obj.MenuGauge,'checked'));
        end
    end
end

end

