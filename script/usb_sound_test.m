%in millisecond
impulseWidth=0.2;
impulseDuration=10;
fs=96000;
t=10000;

std_noise=0.5;

Vpp=4;

spike=zeros(round(impulseDuration/1000*fs),1);
spike(1:round(impulseWidth/2/1000*fs))=1;
spike(round(impulseWidth/2/1000*fs):round(impulseWidth/1000*fs))=-1;

num=round(t/impulseDuration);
sig=[];
for i=1:num
    sig=cat(1,sig,spike);
end

sound([-Vpp/2*sig,Vpp/2*sig],fs)

sound(rand([fs*t/1000,2]*std_noise),fs)