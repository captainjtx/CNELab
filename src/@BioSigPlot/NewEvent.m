function  NewEvent( obj )
title='New event';

prompt={'Time (s)','Event'};
def={'0','myevent'};
answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

time=str2double(answer{1});

if isnan(time)
    return
end

event=answer{2};

newEvent={time,event,[0,0,0],0};
addNewEvent(obj,newEvent);
end

