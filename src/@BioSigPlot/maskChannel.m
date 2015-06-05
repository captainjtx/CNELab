function maskChannel(obj,src)
if src==obj.BtnUnMaskChannel
    mask=1;
elseif src==obj.BtnMaskChannel
   mask=0;
end

obj.Mask=obj.applyPanelVal(obj.Mask_,mask);

end

