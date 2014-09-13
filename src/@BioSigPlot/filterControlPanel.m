function filterControlPanel(obj,parent,position)

obj.FilterPanel=uipanel('Parent',parent,'Position',position,'units','normalized');

obj.ChkFilter=uicontrol(obj.FilterPanel,'Style','checkbox','units','normalized','position',[0 .2 .14 .6],'String','Enable',...
    'Callback',@(src,evt) ChangeFilter(obj,src));

uicontrol(obj.FilterPanel,'Style','text','String','Low:','units','normalized','position',[.14 .2 .06 .6],'HorizontalAlignment','right',...
    'FontUnits','normalized','FontSize',0.55);
obj.EdtFilterLow=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.21 0.1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) ChangeFilter(obj,src),'String','-');

uicontrol(obj.FilterPanel,'Style','text','String','High:','units','normalized','position',[.3 0.2 .06 .6],'HorizontalAlignment','right',...
    'FontUnits','normalized','FontSize',0.55);
obj.EdtFilterHigh=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.37 0.1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) ChangeFilter(obj,src),'String','-');

uicontrol(obj.FilterPanel,'Style','text','String','Bs:','units','normalized','position',[.46 .2 .06 .6],'HorizontalAlignment','right',...
    'FontUnits','normalized','FontSize',0.55);
obj.EdtFilterNotch1=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.53 .1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) ChangeFilter(obj,src),'String','-');

obj.EdtFilterNotch2=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.62 .1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) ChangeFilter(obj,src),'String','-');

uicontrol(obj.FilterPanel,'Style','text','String','Custom:','units','normalized','position',[0.72 0.2,0.1,0.6],'HorizontalAlignment','right',...
    'FontUnits','normalized','FontSize',0.55);
obj.PopFilter=uicontrol(obj.FilterPanel,'Style','popupmenu','units','normalized','position',[.83 0.1 0.165 0.8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) ChangeFilter(obj,src),'String','None');
end


