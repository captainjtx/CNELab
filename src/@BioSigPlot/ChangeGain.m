function ChangeGain(obj,src)
if get(obj.PopGainTarget,'Value')==1
    if src==obj.BtnAddGain
        obj.Gain=obj.Gain*2^.25;
    elseif src==obj.BtnRemGain
        obj.Gain=obj.Gain*2^-.25;
    else
        obj.Gain=str2double(get(src,'String'));
    end
else
    n=get(obj.PopGainTarget,'Value')-1;
    if src==obj.BtnAddGain
        obj.Gain(n)=obj.Gain(n)*2^.25;
    elseif src==obj.BtnRemGain
        obj.Gain(n)=obj.Gain(n)*2^-.25;
    else
        obj.Gain(n)=str2double(get(src,'String'));
    end
end
end