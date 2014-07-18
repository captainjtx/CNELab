
function ChangeTime(obj,src)
timemax=floor((size(obj.Data{1},1)-1)/obj.SRate);

if src==obj.BtnNextPage
    t=obj.Time+obj.WinLength;
elseif src==obj.BtnPrevPage
    t=obj.Time-obj.WinLength;
elseif src==obj.BtnNextSec
    t=obj.Time+1;
elseif src==obj.BtnPrevSec
    t=obj.Time-1;
elseif src==obj.BtnPrevEvent
    MovebyEvent(obj,src);
    return
elseif src==obj.BtnNextEvent
    MovebyEvent(obj,src);
    return
else
    t=str2double(get(obj.EdtTime,'String'));
end
t=max(0,min(timemax,t));
obj.Time=t;
end

function MovebyEvent(obj,src)

if isempty(obj.Evts_)
    if src==obj.BtnPrevEvent
        obj.Time=0;
    elseif src==obj.BtnNextEvent
        obj.Time=size(obj.Data{1},1)/obj.SRate-obj.WinLength;
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
            obj.Time=obj.Evts_{ind(I),1}-obj.WinLength+obj.WinLength/20;
        end
        obj.SelectedEvent=ind(I);
    end
    
elseif src==obj.BtnNextEvent
    
    t=alltimes(alltimes>startTime);
    ind=ind(alltimes>startTime);
    
    [C,I]=min(abs(t-startTime));
    
    if ~isempty(ind)
        if obj.Evts_{ind(I),1}>obj.Time+obj.WinLength
            obj.Time=obj.Evts_{ind(I),1}-obj.WinLength/20;
        end
        obj.SelectedEvent=ind(I);
    end 
end

end