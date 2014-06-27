function ChangeFilterTarget(obj)
if get(obj.PopFilterTarget,'Value')==1
    if all(obj.Filtering==obj.Filtering(1))
        set(obj.ChkFilter,'Value',obj.Filtering(1));
        if obj.Filtering(1)==1
            if all(obj.StrongFilter==obj.StrongFilter(1))
                set(obj.ChkStrongFilter,'Value',obj.StrongFilter(1));
            else
                set(obj.ChkStrongFilter,'Value','0');
            end
            
            if all(obj.FilterLow==obj.FilterLow(1))
                set(obj.EdtFilterLow,'String',num2str(obj.FilterLow(1)));
            else
                set(obj.EdtFilterLow,'String','0');
            end
            
            if all(obj.FilterHigh==obj.FilterHigh(1))
                set(obj.EdtFilterHigh,'String',num2str(obj.FilterHigh(1)));
            else
                set(obj.EdtFilterHigh,'String','0');
            end
            
            if all(obj.FilterNotch(:,1)==obj.FilterNotch(1,1))
                set(obj.EdtFilterNotch1,'String',num2str(obj.FilterNotch(1,1)));
            else
                set(obj.EdtFilterNotch1,'String','0');
            end
            
            if all(obj.FilterNotch(:,2)==obj.FilterNotch(1,2))
                set(obj.EdtFilterNotch2,'String',num2str(obj.FilterNotch(1,2)));
            else
                set(obj.EdtFilterNotch2,'String','0');
            end
        end
        
    else
        obj.Filtering=zeros(1,obj.DataNumber);
    end
else
    
    n=get(obj.PopFilterTarget,'Value')-1;
    set(obj.ChkFilter,'Value',obj.Filtering(n));
    
    if  obj.Filtering(n)
        offon='on';
    else
        offon='off';
    end
    
    set(obj.ChkStrongFilter,'Enable',offon);
    set(obj.ChkStrongFilter,'Value',obj.StrongFilter(n));
    
    set(obj.EdtFilterLow,'Enable',offon);
    set(obj.EdtFilterLow,'String',num2str(obj.FilterLow(n)));
    
    set(obj.EdtFilterHigh,'Enable',offon);
    set(obj.EdtFilterHigh,'String',num2str(obj.FilterHigh(n)));
    
    set(obj.EdtFilterNotch1,'Enable',offon);
    set(obj.EdtFilterNotch1,'String',num2str(obj.FilterNotch(n,1)));
    
    set(obj.EdtFilterNotch2,'Enable',offon);
    set(obj.EdtFilterNotch2,'String',num2str(obj.FilterNotch(n,2)));
    
end
end