function evts = get_uncertainty_trigger_events(trigger,fs)
%trigger: trigger channel
%fs:      sampling frequency

%evts:    extracted trigger events

[Tr,RisingIdx,FallingIdx]=extract_AC_trg(trigger,fs,0.2);


time=cat(1,reshape(RisingIdx,length(RisingIdx),1),reshape(FallingIdx,length(FallingIdx),1))/fs;

evts=cell(length(time),2);


time=num2cell(time);

evts(:,1)=time;

[evts{:,2}]=deal('');

end

