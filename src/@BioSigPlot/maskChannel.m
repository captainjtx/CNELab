function maskChannel(obj,src)
if ismember(src,[obj.MenuClearMask,obj.BtnUnMaskChannel])
    mask=1;
elseif ismember(src,[obj.MenuMask,obj.BtnMaskChannel])
   mask=0;
end

obj.Mask=obj.applyPanelVal(obj.Mask_,mask);

end

