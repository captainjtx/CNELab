function ChangeChan(obj,src)

dd=obj.DisplayedData;
switch src
    case obj.BtnHeightIncrease
        for i=1:length(dd)
            obj.DispChans(dd(i))=obj.DispChans(dd(i))+1;
        end
        
    case obj.BtnHeightDecrease
        for i=1:length(dd)
            obj.DispChans(dd(i))=obj.DispChans(dd(i))-1;
        end    
end
end

