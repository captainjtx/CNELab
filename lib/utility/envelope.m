function envmax=envelope(sig,fs)
% Generates the envelope of the signal.
% sliu@uh.edu

env=abs(hilbert(sig));

f_s=round(fs/2);
cutoff=8/f_s;

b1=fir1(2,cutoff);
    envmax=filtfilt(b1,1,env);
end
