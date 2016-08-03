function [b,a] = butter_harmonic(freq,fs,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if length(varargin)==1
    order=varargin{1};
else
    order=2;
end

if freq<=1||freq>=fs/2-1
    return
end

b=cell(floor(fs/2/freq),1);
a=cell(floor(fs/2/freq),1);

for i=1:floor(fs/2/freq)
    f=freq*i;
    
    w1=(f-1)/fs*2;
    w2=(f+1)/fs*2;
    
    if w1<=0&&w2>0&&w2<1
        [b{i},a{i}]=butter(order,w2,'high');
    elseif w2>=1&&w1>0&&w1<1
        [b{i},a{i}]=butter(order,w1,'low');
    elseif w1==0&&w2==1
        b{i}=1;
        a{i}=1;
    else
        [b{i},a{i}]=butter(order,[w1,w2],'stop');
    end
end

end

