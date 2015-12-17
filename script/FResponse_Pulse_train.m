clc
clear

f=50; %frequency of the impulse in Hz
fs=f*10; % sample frequency is 10 times higher
t=0:1/fs:1; % time vector
y=zeros(size(t));

w=5;
for i=1:w
y(i:fs/f:end)=1;
end

subplot(2,1,1)
plot(t,y);

fy=fft(y);
fy=abs(fy);

fy=fy(1:round(length(fy)/2)+1);
f=linspace(0,fs/2,length(fy));
subplot(2,1,2)
plot(f,fy)
