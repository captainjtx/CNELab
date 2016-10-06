%multi-threaded filter demo

sig=rand(1000,2);

fs=200;

f1=2;
f2=80;
fn=60;

order=3;

[b1,a1]=butter(order,f1/(fs/2),'high');
[b2,a2]=butter(order,f2/(fs/2),'low');
[bn,an]=butter(order,[fn-1,fn+1]/(fs/2),'stop');

b={{b1,bn},{bn}};
%  chan 1  chan2
a={{a1,an},{an}};

if ismac
    fsig=UnixMultiThreadedFilter(b,a,sig);
elseif ispc
    fsig=WinMultiThreadedFilter(b,a,sig);
end

%estimate the psd
wd=200;
ov=100;
nfft=256;
[psd,f]=pwelch(fsig,wd,ov,nfft,fs,'onesided');
figure('Name','Fiter demo');
plot([f,f],10*log10(psd));
legend('band pass','notch')

