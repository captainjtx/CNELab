function evts = get_uncertainty_trigger_events(trigger,fs,varargin)
%trigger: trigger channel
%fs:      sampling frequency

%evts:    extracted trigger events

%Optional input arguments:
%timestamp (s)

%evts:    extracted qrs events

if isempty(varargin)
    timestamp=linspace(0,length(ekg)/fs,length(ekg));
end
if length(varargin)==1
    timestamp=varargin{1};
end

[Tr,RisingIdx,FallingIdx]=extract_AC_trg(trigger,fs,0.2);


time=cat(1,reshape(RisingIdx,length(RisingIdx),1),reshape(FallingIdx,length(FallingIdx),1));

evts=cell(length(time),2);


time=num2cell(timestamp(time));

evts(:,1)=time;

[evts{:,2}]=deal('');

end

