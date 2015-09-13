function MnuDownSample(obj)
%MNUDOWNSAMPLE Summary of this function goes here
%   Detailed explanation goes here
prompt={'Down Sample Factor'};
title='Downsample the data when save';

def={num2str(obj.DownSample)};
answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

ds=round(str2double(answer{1}));

if isnan(ds)
    return
end

obj.DownSample=max(1,ds);


end

