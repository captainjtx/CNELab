function evts=get_onset(traj,fs,varargin)
%get the qrs peaks of ekg signal
%ekg:     ekg signal
%fs:      sampling frequency

%Optional input arguments:
%timestamp (s)

%evts:    extracted qrs events

if isempty(varargin)
    timestamp=linspace(0,size(traj,1)/fs,size(traj,1));
end
if length(varargin)==1
    timestamp=varargin{1};
end

onset=MACCInitV4(traj,1/fs);

ind=min(length(timestamp),max(1,round(min(onset)*fs)));
evts={timestamp(ind),'Onset'};
end