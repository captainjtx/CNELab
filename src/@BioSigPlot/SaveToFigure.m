%==================================================================
%******************************************************************
function SaveToFigure(obj,opt)

if strcmpi(opt,'data')
    f=figure('Name','Copy','Position',get(obj.Fig,'Position'));
    %             for i=1:length(obj.Axes)
    %                 set(obj.Axes(i),'YTick',[]);
    %                 set(obj.Axes(i),'XTick',[]);
    %             end
    % new_handle=copyfig(obj.Fig);
    % set(new_handle,'name','Copy');
    % export_fig 'test.png'
    
    copyobj(obj.Axes,f);
elseif strcmpi(opt,'mirror')
end
end