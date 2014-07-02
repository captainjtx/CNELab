function filterControlPanel(obj,parent,position)

obj.FilterPanel=uipanel('Parent',parent,'Position',position,'units','normalized');

obj.ChkFilter=uicontrol(obj.FilterPanel,'Style','checkbox','units','normalized','position',[0 .55 .2 .4],'String','Enable',...
    'Callback',@(src,evt) filterCheck(obj));

obj.ChkStrongFilter=uicontrol(obj.FilterPanel,'Style','checkbox','units','normalized','position',[0 .05 .2 .4],'String','High Order',...
    'Callback',@(src,evt) ChangeFilter(obj,src));

uicontrol(obj.FilterPanel,'Style','text','String','Low:','units','normalized','position',[.22 .2 .09 .6],'HorizontalAlignment','right');
obj.EdtFilterLow=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.33 .1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) ChangeFilter(obj,src),'String','-');

uicontrol(obj.FilterPanel,'Style','text','String','High:','units','normalized','position',[.42 .2 .09 .6],'HorizontalAlignment','right');
obj.EdtFilterHigh=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.52 .1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) ChangeFilter(obj,src),'String','-');

uicontrol(obj.FilterPanel,'Style','text','String','Notch:','units','normalized','position',[.65 .2 .09 .6],'HorizontalAlignment','right');
obj.EdtFilterNotch1=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.8 .1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) ChangeFilter(obj,src),'String','-');

obj.EdtFilterNotch2=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.9 .1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) ChangeFilter(obj,src),'String','-');
end

function filterCheck(obj)

%do not require recalculate and redraw
obj.StrongFilter_=obj.applyPanelVal(obj.StrongFilter_,get(obj.ChkStrongFilter,'Value'));

obj.FilterLow_=obj.applyPanelVal(obj.FilterLow_,str2double(get(obj.EdtFilterLow,'String')));

obj.FilterHigh_=obj.applyPanelVal(obj.FilterHigh_,str2double(get(obj.EdtFilterHigh,'String')));

obj.FilterNotch1_=obj.applyPanelVal(obj.FilterNotch1_,str2double(get(obj.EdtFilterNotch1,'String')));

obj.FilterNotch2_=obj.applyPanelVal(obj.FilterNotch2_,str2double(get(obj.EdtFilterNotch2,'String')));

%require recalculate and redraw
val=get(obj.ChkFilter,'Value');
obj.Filtering=obj.applyPanelVal(obj.Filtering_,val);

if val, offon='on'; else offon='off'; end
set(obj.ChkStrongFilter,'Enable',offon)
set(obj.EdtFilterLow,'Enable',offon)
set(obj.EdtFilterHigh,'Enable',offon)
set(obj.EdtFilterNotch1,'Enable',offon)
set(obj.EdtFilterNotch2,'Enable',offon)

end
