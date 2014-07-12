function ChangeChan(obj,src)

dd=obj.DisplayedData;
switch src
    case obj.HeightIncrease
        for i=1:length(dd)
            obj.DispChans(i)=obj.DispChans(i)+1;
        end
        
    case obj.HeightDecrease
        for i=1:length(dd)
            obj.DispChans(i)=obj.DispChans(i)-1;
        end    
end
end

