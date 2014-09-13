function showGauge(obj)
dd=obj.DisplayedData;

if ~obj.DisplayGauge
    set(obj.MenuGauge,'checked','off');
else
    set(obj.MenuGauge,'checked','on');
end

if ~isempty(obj.Axes)
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

end

