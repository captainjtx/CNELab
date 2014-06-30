function ChangeGain(obj,src)
gain=str2double(get(obj.EdtGain,'string'));
if gain==0||isnan(gain)
    gain=[];
end
if src==obj.BtnAddGain
    obj.Gain=gain*2^.25;
elseif src==obj.BtnRemGain
    obj.Gain=gain*2^-.25;
else
    obj.Gain=gain;
end

end