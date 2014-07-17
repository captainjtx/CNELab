function filterControlPanel(obj,parent,position)

obj.FilterPanel=uipanel('Parent',parent,'Position',position,'units','normalized');

obj.ChkFilter=uicontrol(obj.FilterPanel,'Style','checkbox','units','normalized','position',[0 .55 .2 .4],'String','Enable',...
    'Callback',@(src,evt) ChangeFilter(obj,src));

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


