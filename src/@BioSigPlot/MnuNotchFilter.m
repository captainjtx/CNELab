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

for i=1:floor(fs/2/freq)
    f=freq*i;
    
    w1=(f-2)/fs*2;
    w2=(f+2)/fs*2;
    
    if w1<=0&&w2>0&&w2<1
        [b,a]=butter(order,w2,'high');
        data=filter_symmetric(b,a,data,fs,0,'iir');
    elseif w2>=1&&w1>0&&w1<1
        [b,a]=butter(order,w1,'low');
        data=filter_symmetric(b,a,data,fs,0,'iir');
    elseif w1==0&&w2==1
%         data=data;
    else
        [b,a]=butter(order,[w1,w2],'stop');
        data=filter_symmetric(b,a,data,fs,0,'iir');
    end
end

for i=1:size(data,2)
    obj.PreprocData{dataset(i)}(sample,channel(i))=data(:,i);
end

obj.redrawChangeBlock('time');

end

