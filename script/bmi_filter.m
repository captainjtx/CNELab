function datamat = bmi_filter(datamat,fs,fn,f_notch)
%band pass filter parameters
order=2;

%notch filter quality value
notch_q=35;

%band pass filter
[b,a]=butter(order,fn*2/fs,'bandpass');
datamat=filter_symmetric(b,a,datamat,fs,0,'iir');
%%%%%%%%%%%%%%%%%%%notch filter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
harmonic_num=floor((fs-5)/2/f_notch);

for i=1:harmonic_num
    fo=f_notch*harmonic_num;
    wo = fo/(fs/2);
    bw = wo/notch_q;
    [b,a] = iirnotch(wo,bw);
    datamat=filter_symmetric(b,a,datamat,fs,0,'iir');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

