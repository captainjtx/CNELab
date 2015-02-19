function evts=get_ekg_qrs(ekg,fs,varargin)
%get the qrs peaks of ekg signal
%ekg:     ekg signal
%fs:      sampling frequency

%Optional input arguments:
%timestamp (s)

%evts:    extracted qrs events

if isempty(varargin)
    timestamp=linspace(0,length(ekg)/fs,length(ekg));
end
if length(varargin)==1
    timestamp=varargin{1};
end
    
% prompt={'Percentile Threshold (1-100): '};
% title='Threshold for QRS detection';
% 
% if isempty(obj.QRS_Threshold)
%     obj.QRS_Threshold=50;
% end
% 
% def=num2str(obj.QRS_Threshold);
% 
% answer=inputdlg(prompt,title,1,def);
% 
% tmp=str2double(answer);
% if isempty(tmp)||isnan(tmp)
%     tmp=50;
% end
% 
% obj.QRS_Threshold=tmp;

% thr=prctile(abs(ekg),tmp);

[r,d,pat]=qrs_detector(ekg,fs);

evts=cell(length(r),2);
evts(:,1)=num2cell(timestamp(r));
[evts{:,2}]=deal('R');


end

