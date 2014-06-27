function ChangeGainTarget(obj)
if get(obj.PopGainTarget,'Value')==1
    if all(obj.Gain==obj.Gain(1))
        set(obj.EdtGain,'String',obj.Gain(1))
    else
        set(obj.EdtGain,'String','-')
    end
else
    n=get(obj.PopGainTarget,'Value')-1;
    set(obj.EdtGain,'String',obj.Gain(n))
end
end