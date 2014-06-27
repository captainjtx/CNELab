
function KeyPress(obj,src,evt)
%**************************************************************************
%Exit the special mouse mode except for "Pan" (which needs another click on the icon)
%Exit the special channel selection mode
if strcmpi(evt.Key,'escape')
    obj.MouseMode=[];
    obj.ChanSelect2Edit=[];
    return
end
%**************************************************************************
end