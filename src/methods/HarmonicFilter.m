function [b,a] = HarmonicFilter(freq,fs,varargin)
%get the cascaded b and a to filter out harmonics
if length(varargin)==1
    order=varargin{1};
else
    order=2;
end

a=1;
b=1;

for i=1:floor(fs/2/freq)
    f=freq*i;
    
    w1=(f-1)/fs*2;
    w2=(f+1)/fs*2;
    
    if w1<=0&&w2>0&&w2<1
        [ib,ia]=butter(order,w2,'high');
        
    elseif w2>=1&&w1>0&&w1<1
        [ib,ia]=butter(order,w1,'low');
    elseif w1==0&&w2==1
%         data=data;
    else
        [ib,ia]=butter(order,[w1,w2],'stop');
    end
    
    H0=dfilt.df2t(b,a);
    H1=dfilt.df2t(ib,ia);
    
    H=dfilt.cascade(H0,H1);
    a=get(H,'Denominator');
    b=get(H,'Numerator');
end


end

