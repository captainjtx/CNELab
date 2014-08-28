%ICA demo 
%Expected result: Inversed Sign in Recon

clear
clc

%50 Hz Sawtooth wave
T = 10*(1/50);
Fs = 1000;
dt = 1/Fs;
t = 0:dt:T-dt;
s1 = sawtooth(2*pi*50*t);

s2=sin(2*pi*20*t);

A=[-0.5,0.5;0.5,1];

S=[s1;s2];
%Mixing process
D=A*S;

%Seperating process
[icasig, A, W] = fastica(D,'verbose', 'off', 'displayMode', 'off');

subplot(3,2,1)
plot(t,s1)
title('Source 1')

subplot(3,2,2)
plot(t,s2)
title('Source 2')

subplot(3,2,3)
plot(t,D(1,:))
title('Sensor 1')

subplot(3,2,4)
plot(t,D(2,:))
title('Sensor 2')

icasig=W*D;

subplot(3,2,5)
plot(t,icasig(1,:))
title('ICA 1')

subplot(3,2,6)
plot(t,icasig(2,:))
title('ICA 2')

