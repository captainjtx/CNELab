clc
clear

fs=1000;

t=0:0.001:100;

x=2*sin(2*pi*20*t)+cos(2*pi*50*t)+randn(size(t));

p=2*pwelch(x,512,256,256);

N = length(x);
xdft = fft(x);
xdft = xdft(1:round(N/2)+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);

p1=2*pwelch(x,256,128,128);

subplot(2,1,1)
plot(linspace(0,fs/2,length(p)),p)
% 
subplot(2,1,2)
plot(linspace(0,fs/2,length(p1)),p1);

disp(sum(x.^2))
% disp(sum(p))
disp(sum(p)*fs)