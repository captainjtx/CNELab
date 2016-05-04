
function ChangeTime(obj,opt)
timemax=obj.TotalTime;

switch opt
    case 2 %obj.JBtnNextPage
        t=obj.Time+obj.WinLength;
    case -2 %obj.JBtnPrevPage
    t=obj.Time-obj.WinLength;
    case 1 %obj.JBtnNextSec
    t=obj.Time+obj.WinLength/15;
    case -1 %obj.JBtnPrevSec
    t=obj.Time-obj.WinLength/15;
    case -3 %obj.JBtnPrevEvent
    MovebyEvent(obj,opt);
    return
    case -4 %obj.JBtnPrevEvent1
    MovebyEvent(obj,opt);
    return
    case 3 %obj.JBtnNextEvent
    MovebyEvent(obj,opt);
    return
    case 4 %obj.JBtnNextEvent1
    MovebyEvent(obj,opt);
    return
    case -10 %obj.JBtnStart
    t=0;
    case 10 %obj.JBtnEnd
    t=timemax-obj.WinLength;
    otherwise 
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

function MovebyEvent(obj,opt)

if isempty(obj.Evts_)
    if opt==-4
        obj.Time=0;
    elseif opt==4
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

if opt==-4
    t=alltimes(alltimes<startTime);
    ind=ind(alltimes<startTime);
    
    [C,I]=min(abs(t-startTime));
    
    if ~isempty(ind)
        if obj.Evts_{ind(I),1}<obj.Time
            obj.Time=obj.Evts_{ind(I),1}-9/10*obj.WinLength;
        end
        obj.SelectedEvent=ind(I);
    end
    
elseif opt==4
    
    t=alltimes(alltimes>startTime);
    ind=ind(alltimes>startTime);
    
    [C,I]=min(abs(t-startTime));
    
    if ~isempty(ind)
        if obj.Evts_{ind(I),1}>obj.Time+obj.WinLength
            obj.Time=obj.Evts_{ind(I),1}-obj.WinLength/10;
        end
        obj.SelectedEvent=ind(I);
    end 
elseif opt==-3
    ind=obj.SelectedEvent-1;
    obj.SelectedEvent=max(1,min(ind,size(obj.Evts_,1)));
    
    if ind>0
        if obj.Evts_{ind,1}<obj.Time
            obj.Time=obj.Evts_{ind,1}-9/10*obj.WinLength;
        end  
    end
elseif opt==3
    ind=obj.SelectedEvent+1;
    obj.SelectedEvent=max(1,min(ind,size(obj.Evts_,1)));
    
    if ind<=size(obj.Evts_,1)
        if obj.Evts_{ind,1}>obj.Time+obj.WinLength
            obj.Time=obj.Evts_{ind,1}-1/10*obj.WinLength;
        end  
    end
end

end