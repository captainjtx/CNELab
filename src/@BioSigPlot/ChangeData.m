function ChangeData(obj,src)
if src==obj.BtnSwitchData
    dd=obj.DisplayedData;
    nd=dd(1)+1;
    
    if nd>length(obj.Data)
        nd=1;
    end
    obj.DataView=['DAT' num2str(nd)];
    
end


end

