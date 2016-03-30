function ChangeData(obj,num)
if isempty(num)
    dd=obj.DisplayedData;
    nd=dd(1)+1;
    
    if nd>length(obj.Data)
        nd=1;
    end
    obj.DataView=['DAT' num2str(nd)];
else
    obj.DataView=['DAT' num2str(num)];
end
end

