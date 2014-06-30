function ChangeGainTarget(obj)
if get(obj.PopGainTarget,'Value')==1
    if all(cellfun(@mode,obj.Gain)==mode(obj.Gain{1}))
        set(obj.EdtGain,'String',mode(obj.Gain{1}))
    else
        set(obj.EdtGain,'String','-')
    end
else
    n=get(obj.PopGainTarget,'Value')-1;
    set(obj.EdtGain,'String',mode(obj.Gain{n}))
end
end