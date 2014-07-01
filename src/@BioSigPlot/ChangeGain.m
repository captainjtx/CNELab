function ChangeGain(obj,src)
if isempty(get(obj.EdtGain,'String'))
    gain=[];
else  
    gain=str2double(get(obj.EdtGain,'string'));
end
if gain==0
    gain=NaN;
end
if src==obj.BtnAddGain
    obj.Gain=gain*2^.25;
elseif src==obj.BtnRemGain
    obj.Gain=gain*2^-.25;
else
    obj.Gain=gain;
end

end