function MnuNotchFilter (obj)
%MNUNOTCHFILTER Summary of this function goes here
%   Detailed explanation goes here

prompt={'Frequency (Hz,Powerline)','Order'};
title='Notch Filters (Harmonics)';

def={'50 Hz Europe&Asia, 60 Hz USA','3'};
answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

freq=str2double(answer{1});
if isnan(freq)
    return
end

freq=max(0,min(freq,obj.SRate));

order=str2double(answer{2});
if isnan(order)
    return
end

order=max(1,order);

fs=obj.SRate;

[data,~,dataset,channel,sample,~,~,~]=get_selected_data(obj);

data = filter_harmonics(data,freq,fs,order);

for i=1:size(data,2)
    obj.PreprocData{dataset(i)}(sample,channel(i))=data(:,i);
end

obj.redrawChangeBlock('time');

end

