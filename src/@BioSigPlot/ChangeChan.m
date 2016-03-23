function ChangeChan(obj,opt)

dd=obj.DisplayedData;
switch opt
    case 1
        for i=1:length(dd)
            obj.DispChans(dd(i))=obj.DispChans(dd(i))+1;
        end
        
    case -1
        for i=1:length(dd)
            obj.DispChans(dd(i))=obj.DispChans(dd(i))-1;
        end    
end
end

