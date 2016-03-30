function video_timer_test(frames)
figure
timerperiod=1/30;

frameNum=0;

setappdata(0,'frameNum',frameNum);

handle=imagesc(frames(1).cdata);

tim=timer('TimerFcn',{@timertest,frames,handle},'ExecutionMode','fixedRate'...
    ,'BusyMode','queue','period',timerperiod);

setappdata(0,'testTimer',tim);
assignin('base','tim',tim);

start(tim);

end

function timertest(src,evt,frames,handle)
frameNum=getappdata(0,'frameNum');
frameNum=frameNum+1;

setappdata(0,'frameNum',frameNum);

if frameNum>length(frames)
    tim=get(0,'testTimer');
    stop(tim);
else
    set(handle,'CData',frames(frameNum).cdata);
end

end

