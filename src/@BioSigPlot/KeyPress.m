
function KeyPress(obj,src,evt)
%**************************************************************************
%Exit the special mouse mode except for "Pan" (which needs another click on the icon)
%Exit the special channel selection mode
if strcmpi(evt.Key,'escape')
    obj.MouseMode=[];
    obj.ChanSelect2Edit=[];
    obj.Filtering=get(obj.ChkFilter,'value');
    return
end
%**************************************************************************
end