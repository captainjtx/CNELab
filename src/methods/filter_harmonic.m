function data = filter_harmonic(data,freq,fs,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if length(varargin)==1
    order=varargin{1};
else
    order=3;
end
ext=min(fs*2,round(size(data,1)/2));
for i=1:floor(fs/2/freq)
    f=freq*i;
    
    w1=(f-2)/fs*2;
    w2=(f+2)/fs*2;
    
    if w1<=0&&w2>0&&w2<1
        [b,a]=butter(order,w2,'high');
        data=filter_symmetric(b,a,data,ext,0,'iir');
    elseif w2>=1&&w1>0&&w1<1
        [b,a]=butter(order,w1,'low');
        data=filter_symmetric(b,a,data,ext,0,'iir');
    elseif w1==0&&w2==1
%         data=data;
    else
        [b,a]=butter(order,[w1,w2],'stop');
        data=filter_symmetric(b,a,data,ext,0,'iir');
    end
end

end

