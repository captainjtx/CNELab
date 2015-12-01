function MnuDownSample(obj,src)
%MNUDOWNSAMPLE Summary of this function goes here
%   Detailed explanation goes here
prompt={'Down Sample Factor'};

title='Downsample the data';

switch src
    case obj.MenuSaveDownSample
        def={num2str(obj.DownSample)};
    case obj.MenuVisualDownSample
        def={num2str(obj.VisualDownSample)};
end

answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

ds=round(str2double(answer{1}));

if isnan(ds)
    return
end

switch src
    case obj.MenuSaveDownSample
        obj.DownSample=max(1,ds);
    case obj.MenuVisualDownSample
        obj.VisualDownSample=max(1,ds);
        obj.redrawChangeBlock('time');
end

end

