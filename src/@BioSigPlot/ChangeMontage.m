function ChangeMontage(obj,src,data,mtgref)

if strcmpi(get(src,'Checked'),'on')
    return
end

if strcmpi(mtgref,'end')
    mtgref=legnth(obj.Montage_{data});
end
for i=1:length(obj.MontageOptMenu{data})
    set(obj.MontageOptMenu{data}(i),'Checked','off');
end

set(src,'checked','on');

obj.MontageRef_(data)=mtgref;

obj.ResizeMode=false;
obj.UponAdjustPanel=false;

obj.VideoLineTime=0;
obj.IsSelecting=0;
obj.SelectionStart=[];
obj.Selection_=zeros(2,0);

obj.ChanSelect2Edit_=cell(1,obj.DataNumber);

obj.Gain_=cell(1,obj.DataNumber);
obj.Mask_=cell(1,obj.DataNumber);
obj.Mask_=obj.applyPanelVal(obj.Mask_,1);

NeedRefilter=false;
for i=1:obj.DataNumber
    if length(obj.Filtering_{i})~=obj.MontageChanNumber(i)
        NeedRefilter=true;
    end
end

if NeedRefilter
obj.Filtering_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
obj.FilterLow_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
obj.FilterHigh_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
obj.FilterNotch1_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
obj.FilterNotch2_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
resetFilterPanel(obj);
end

obj.EventLines=[];
obj.EventTexts=[];

obj.DragMode=0;
obj.EditMode=0;

obj.ChanColors_=obj.applyPanelVal(cell(1,obj.DataNumber),obj.DefaultLineColor);

obj.ChanSelect2Display_{data}=1:size(obj.Montage{data}(mtgref).mat,1);
obj.DispChans_(data)=min(obj.DispChans_(data),size(obj.Montage{data}(mtgref).mat,1));
obj.FirstDispChans_(data)=1;

recalculate(obj);
ChangeGain(obj,[]);
remakeAxes(obj);
resetView(obj);
assignChannelGroupColor(obj);
redraw(obj);
redrawEvts(obj);

end