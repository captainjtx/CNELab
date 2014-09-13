function filterCheck(obj)

%do not require recalculate and redraw
obj.Filtering_=obj.applyPanelVal(obj.Filtering_,get(obj.ChkFilter,'Value'));

obj.FilterLow_=obj.applyPanelVal(obj.FilterLow_,str2double(get(obj.EdtFilterLow,'String')));

obj.FilterHigh_=obj.applyPanelVal(obj.FilterHigh_,str2double(get(obj.EdtFilterHigh,'String')));

obj.FilterNotch1_=obj.applyPanelVal(obj.FilterNotch1_,str2double(get(obj.EdtFilterNotch1,'String')));

obj.FilterNotch2_=obj.applyPanelVal(obj.FilterNotch2_,str2double(get(obj.EdtFilterNotch2,'String')));

obj.FilterCustomIndex_=obj.applyPanelVal(obj.FilterCustomIndex,get(obj.PopFilter,'value'));

%require recalculate and redraw

val=get(obj.ChkFilter,'Value');
obj.Filtering=obj.applyPanelVal(obj.Filtering_,val);

if val, offon='on'; else offon='off'; end
set(obj.EdtFilterLow,'Enable',offon)
set(obj.EdtFilterHigh,'Enable',offon)
set(obj.EdtFilterNotch1,'Enable',offon)
set(obj.EdtFilterNotch2,'Enable',offon)
set(obj.PopFilter,'Enable',offon)

end