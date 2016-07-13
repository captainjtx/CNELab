function remakeEventMenu(obj)
try
    delete(obj.EventOptMenu);
catch
end

parent=obj.MenuEvent;

newMenu=zeros(length(obj.Evts__),1);

for j=1:length(obj.Evts__)
    h=uimenu(parent,'Label',obj.Evts__(j).name,...
        'Callback',@(src,evt)ChangeEvent(obj,src,j));
    if j==obj.EventRef
        set(h,'Checked','on');
    else
        set(h,'Checked','off');
    end
    newMenu(j)=h;
end

set(newMenu(1),'separator','on');

obj.EventOptMenu=newMenu;

end

function ChangeEvent(obj,src,j)
obj.EventRef=j;
obj.Evts=obj.Evts__(j).event;
set(obj.EventOptMenu,'checked','off');
set(src,'checked','on');
end



