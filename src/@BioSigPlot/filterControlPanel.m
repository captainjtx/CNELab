function filterControlPanel(obj,parent,position)

obj.FilterPanel=uipanel('Parent',parent,'Position',position,'units','normalized');

FilterPanelForEachData=uipanel('Parent',obj.FilterPanel,'Position',[0.2,0,0.8,1],'units','normalized');

list=[{'All'} num2cell(1:obj.DataNumber)];
uicontrol(obj.FilterPanel,'Style','text','String','Filter ','units','normalized','position',[0 0.2 0.07 0.5],'HorizontalAlignment','right');
obj.PopFilterTarget=uicontrol(obj.FilterPanel,'Style','popupmenu','String',list,'units','normalized','position',[0.08 .2 .09 .6],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) ChangeFilterTarget(obj));


obj.ChkFilter=uicontrol(FilterPanelForEachData,'Style','checkbox','units','normalized','position',[0 .55 .2 .4],'String','Enable',...
    'Callback',@(src,evt) filterChange(obj));
obj.ChkStrongFilter=uicontrol(FilterPanelForEachData,'Style','checkbox','units','normalized','position',[0 .05 .2 .4],'String','High Order',...
    'Callback',@(src,evt) set(obj,'StrongFilter',get(src,'Value')));
uicontrol(FilterPanelForEachData,'Style','text','String','Low:','units','normalized','position',[.22 .2 .09 .6],'HorizontalAlignment','right');
obj.EdtFilterLow=uicontrol(FilterPanelForEachData,'Style','edit','units','normalized','position',[.33 .1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) set(obj,'FilterLow',str2double(get(src,'String'))));
uicontrol(FilterPanelForEachData,'Style','text','String','High:','units','normalized','position',[.42 .2 .09 .6],'HorizontalAlignment','right');
obj.EdtFilterHigh=uicontrol(FilterPanelForEachData,'Style','edit','units','normalized','position',[.52 .1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) set(obj,'FilterHigh',str2double(get(src,'String'))));
uicontrol(FilterPanelForEachData,'Style','text','String','Notch:','units','normalized','position',[.65 .2 .09 .6],'HorizontalAlignment','right');
obj.EdtFilterNotch1=uicontrol(FilterPanelForEachData,'Style','edit','units','normalized','position',[.8 .1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) set(obj,'FilterNotch',[str2double(get(src,'String')),str2double(get(obj.EdtFilterNotch2,'String'))]));
obj.EdtFilterNotch2=uicontrol(FilterPanelForEachData,'Style','edit','units','normalized','position',[.9 .1 .08 .8],'BackgroundColor',[1 1 1],...
    'Callback',@(src,evt) set(obj,'FilterNotch',[str2double(get(obj.EdtFilterNotch1,'String')),str2double(get(src,'String'))]));
end

function filterChange(obj)
obj.NeedFilterWait=true;
obj.NeedRedrawWait=true;

obj.Filtering=get(obj.ChkFilter,'Value');

obj.StrongFilter=get(obj.ChkStrongFilter,'Value');

obj.FilterLow=str2double(get(obj.EdtFilterLow,'String'));

obj.FilterHigh=str2double(get(obj.EdtFilterHigh,'String'));

obj.NeedFilterWait=false;
obj.NeedRedrawWait=false;

obj.FilterNotch=[str2double(get(obj.EdtFilterNotch1,'String')),...
                 str2double(get(obj.EdtFilterNotch2,'String'))];

end