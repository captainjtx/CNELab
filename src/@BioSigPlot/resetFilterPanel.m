function resetFilterPanel(obj)
%reset the filter panel when dataview is changed
dd=obj.DisplayedData;

if all(cellfun(@mode,obj.Filtering(dd))==mode(obj.Filtering{dd(1)}))
    set(obj.ChkFilter,'Value',mode(obj.Filtering{dd(1)}));
else
    set(obj.ChkFilter,'Value',0);
end

if all(cellfun(@mode,obj.FilterLow(dd))==mode(obj.FilterLow{dd(1)}))
    if mode(obj.FilterLow{dd(1)})~=0
        set(obj.EdtFilterLow,'String',mode(obj.FilterLow{dd(1)}));
    end
else
    set(obj.EdtFilterLow,'String','-');
end

if all(cellfun(@mode,obj.FilterHigh(dd))==mode(obj.FilterHigh{dd(1)}))
    if mode(obj.FilterHigh{dd(1)})~=0
        set(obj.EdtFilterHigh,'String',mode(obj.FilterHigh{dd(1)}));
    end
else
    set(obj.EdtFilterHigh,'String','-');
end

if all(cellfun(@mode,obj.FilterNotch1(dd))==mode(obj.FilterNotch1{dd(1)}))
    if mode(obj.FilterNotch1{dd(1)})~=0
        set(obj.EdtFilterNotch1,'String',mode(obj.FilterNotch1{dd(1)}));
    end
else
    set(obj.EdtFilterNotch1,'String','-');
end

if all(cellfun(@mode,obj.FilterNotch2(dd))==mode(obj.FilterNotch2{dd(1)}))
    if mode(obj.FilterNotch2{dd(1)})~=0
        set(obj.EdtFilterNotch2,'String',mode(obj.FilterNotch2{dd(1)}));
    end
else
    set(obj.EdtFilterNotch2,'String','-');
end

if all(cellfun(@mode,obj.FilterCustomIndex(dd))==mode(obj.FilterCustomIndex{dd(1)}))
    set(obj.PopFilter,'Value',mode(obj.FilterCustomIndex{dd(1)}));
else
    set(obj.PopFilter,'Value',1);
end

if get(obj.ChkFilter,'Value')
    offon='on';
else
    offon='off';
end

set(obj.EdtFilterLow,'Enable',offon);

set(obj.EdtFilterHigh,'Enable',offon);

set(obj.EdtFilterNotch1,'Enable',offon);

set(obj.EdtFilterNotch2,'Enable',offon);

set(obj.PopFilter,'Enable',offon);

end