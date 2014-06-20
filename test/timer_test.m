function timer_test()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


data=1;

t=timer('TimerFcn',{@update},'ExecutionMode','fixedRate','BusyMode','queue','period',0.5);

start(t);

for i=1:5
    set(t,'UserData',i);
    assignin('base','data',i);
    pause(1);
end

stop(t);
delete(t);
end

function update(src,evt)
% data=get(src,'UserData');
disp(data);
end

