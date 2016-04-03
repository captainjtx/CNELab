%==================================================================
%******************************************************************
function SaveToFigure(obj,opt)
f=figure('Name','Copy','Position',get(obj.MainPanel,'Position'),'visible','on');

copyobj(obj.Axes,f);
end