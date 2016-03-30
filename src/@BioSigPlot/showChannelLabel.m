function showChannelLabel(obj,src)
if nargin>1
    if strcmpi(get(obj.MenuChannelLabel,'checked'),'on')
        set(obj.MenuChannelLabel,'checked','off');
    else
        set(obj.MenuChannelLabel,'checked','on');
    end
end

dd=obj.DisplayedData;

for i=1:length(dd)
    if length(obj.Axes)==1
        axe=obj.Axes;
    else
        axe=obj.Axes(dd(i));
    end
    
    h=findobj(axe,'-regexp','DisplayName','ChanName*');
    if ~isempty(h)
        for j=1:length(h)
            set(h(j),'Visible',get(obj.MenuChannelLabel,'checked'));
        end
    end
end

end

