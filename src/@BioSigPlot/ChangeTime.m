
function ChangeTime(obj,src)
timemax=obj.TotalTime;

if src==obj.BtnNextPage
    t=obj.Time+obj.WinLength;
elseif src==obj.BtnPrevPage
    t=obj.Time-obj.WinLength;
elseif src==obj.BtnNextSec
    t=obj.Time+obj.WinLength/15;
elseif src==obj.BtnPrevSec
    t=obj.Time-obj.WinLength/15;
elseif src==obj.BtnPrevEvent
    MovebyEvent(obj,src);
    return
elseif src==obj.BtnPrevEvent1
    MovebyEvent(obj,src);
    return
elseif src==obj.BtnNextEvent
    MovebyEvent(obj,src);
    return
elseif src==obj.BtnNextEvent1
    MovebyEvent(obj,src);
    return
elseif src==obj.BtnStart
    t=0;
elseif src==obj.BtnEnd
    t=timemax-obj.WinLength;
else
    str=get(obj.EdtTime,'String');
    if strcmpi(str,'end')
        t=timemax-obj.WinLength;
    else
        t=str2double(str);
    end
end
t=max(0,min(timemax,t));
obj.Time=t;
updateVideo(obj);
end

function MovebyEvent(obj,src)

if isempty(obj.Evts_)
    if src==obj.BtnPrevEvent
        obj.Time=0;
    elseif src==obj.BtnNextEvent
        obj.Time=obj.TotalTime-obj.WinLength;
    end
    return
end

if isempty(obj.SelectedEvent)
    startTime=obj.Time;
    NaviEvts=unique(obj.Evts_(:,2));
else
    startTime=obj.Evts_{obj.SelectedEvent(1),1};
    NaviEvts=obj.Evts_{obj.SelectedEvent,2};
end

Lia = ismember(obj.Evts_(:,2),NaviEvts);
alltimes=[obj.Evts_{Lia,1}];
ind=find(Lia);

if src==obj.BtnPrevEvent
    t=alltimes(alltimes<startTime);
    ind=ind(alltimes<startTime);
    
    [C,I]=min(abs(t-startTime));
    
    if ~isempty(ind)
        if obj.Evts_{ind(I),1}<obj.Time
            obj.Time=obj.Evts_{ind(I),1}-9/10*obj.WinLength;
        end
        obj.SelectedEvent=ind(I);
    end
    
elseif src==obj.BtnNextEvent
    
    t=alltimes(alltimes>startTime);
    ind=ind(alltimes>startTime);
    
    [C,I]=min(abs(t-startTime));
    
    if ~isempty(ind)
        if obj.Evts_{ind(I),1}>obj.Time+obj.WinLength
            obj.Time=obj.Evts_{ind(I),1}-obj.WinLength/10;
        end
        obj.SelectedEvent=ind(I);
    end 
elseif src==obj.BtnPrevEvent1
    ind=obj.SelectedEvent-1;
    obj.SelectedEvent=max(1,min(ind,size(obj.Evts_,1)));
    
    if ind>0
        if obj.Evts_{ind,1}<obj.Time
            obj.Time=obj.Evts_{ind,1}-9/10*obj.WinLength;
        end  
    end
elseif src==obj.BtnNextEvent1
    ind=obj.SelectedEvent+1;
    obj.SelectedEvent=max(1,min(ind,size(obj.Evts_,1)));
    
    if ind<=size(obj.Evts_,1)
        if obj.Evts_{ind,1}>obj.Time+obj.WinLength
            obj.Time=obj.Evts_{ind,1}-1/10*obj.WinLength;
        end  
    end
end

end