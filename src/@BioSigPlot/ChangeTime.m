
function ChangeTime(obj,src)
timemax=floor((size(obj.Data{1},1)-1)/obj.SRate);
%             if strcmpi(get(obj.BtnPlay,'String'),'Stop'), StopPlay(obj);end
if src==obj.BtnNextPage
    t=obj.Time+obj.WinLength;
elseif src==obj.BtnPrevPage
    t=obj.Time-obj.WinLength;
elseif src==obj.BtnNextSec
    t=obj.Time+1;
elseif src==obj.BtnPrevSec
    t=obj.Time-1;
else
    t=str2double(get(obj.EdtTime,'String'));
end
t=max(0,min(timemax,t));

obj.VideoLineTime=t;
obj.Time=t;
end