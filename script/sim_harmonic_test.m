function sim_harmonic_test()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% tic
% [video,audio]=mmread('/Users/tengi/Desktop/SuperViewer/db/demo/neuro.avi',[],[0 1]);
% toc
% assignin('base','video',video);
% assignin('base','audio',audio);
fs=38.4*1000;
t=0:1/fs:0.5;

fpulse=130;


d=0:1/fpulse:0.5;

func='rectpuls';

puleswidth=100*10^-6;% 100 us


y=pulstran(t,d,func,puleswidth);
subplot(2,1,1)
plot(t,y);

subplot(2,1,2)
Y=fft(y);

A=Y(1:floor(length(y)/2));
f=linspace(0,fs/2,length(A));

plot(f,abs(A));
xlim([0 fs/2]);


end

