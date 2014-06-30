function ChangeFilterTarget(obj)
if get(obj.PopFilterTarget,'Value')==1
    if all(cellfun(@mode,obj.Filtering)==mode(obj.Filtering{1}))
        set(obj.ChkFilter,'Value',mode(obj.Filtering{1}));
        if mode(obj.Filtering{1})==1
            if all(cellfun(@mode,obj.StrongFilter)==mode(obj.StrongFilter{1}))
                set(obj.ChkStrongFilter,'Value',mode(obj.StrongFilter{1}));
            else
                set(obj.ChkStrongFilter,'Value','0');
            end
            
            if all(cellfun(@mode,obj.FilterLow)==mode(obj.FilterLow{1}))
                set(obj.EdtFilterLow,'String',num2str(mode(obj.FilterLow{1})));
            else
                set(obj.EdtFilterLow,'String','0');
            end
            
            if all(cellfun(@mode,obj.FilterHigh)==mode(obj.FilterHigh{1}))
                set(obj.EdtFilterHigh,'String',num2str(mode(obj.FilterHigh{1})));
            else
                set(obj.EdtFilterHigh,'String','0');
            end
                        
        end
        
    else
        set(obj.ChkFilter,'Value',0);
    end
else
    
    n=get(obj.PopFilterTarget,'Value')-1;
    set(obj.ChkFilter,'Value',mode(obj.Filtering{n}));
    
    if  mode(obj.Filtering{n})
        offon='on';
    else
        offon='off';
    end
    
    set(obj.ChkStrongFilter,'Enable',offon);
    set(obj.ChkStrongFilter,'Value',mode(obj.StrongFilter{n}));
    
    set(obj.EdtFilterLow,'Enable',offon);
    set(obj.EdtFilterLow,'String',num2str(mode(obj.FilterLow{n})));
    
    set(obj.EdtFilterHigh,'Enable',offon);
    set(obj.EdtFilterHigh,'String',num2str(mode(obj.FilterHigh{n})));
    
    set(obj.EdtFilterNotch1,'Enable',offon);
    set(obj.EdtFilterNotch1,'String',num2str(mode(obj.FilterNotch{n}(:,1))));
    
    set(obj.EdtFilterNotch2,'Enable',offon);
    set(obj.EdtFilterNotch2,'String',num2str(mode(obj.FilterNotch{n}(:,2))));
    
end
end