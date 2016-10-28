%==================================================================
%******************************************************************
function SaveToFigure(obj,opt)
f=figure('Name','Copy','Position',get(obj.MainPanel,'Position'),'visible','on',...
    'color','white');

copyobj(obj.Axes,f);
end