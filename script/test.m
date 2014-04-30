function test()
%TEST Summary of this function goes here
%   Detailed explanation goes here
neuroSeg=load([pwd '/db/demo/neuroSeg.mat']);
behvSeg=load([pwd '/db/demo/behvSeg.mat']);

fl=2;
fh=60;
fs=neuroSeg.samplefreq;
ext=100;
order=2;

neuroChannel=1;
behvChannel=5;

[b,a]=butter(order,[fl fh]/(fs/2),'bandpass');

neuroCloseSeg=neuroSeg.Open;
behvCloseSeg=behvSeg.Open;

stamp=linspace(-2,2,size(neuroCloseSeg,1));
subplot(2,1,1)
for i=1:size(neuroCloseSeg,3)
    plot(stamp,filter_symmetric(b,a,neuroCloseSeg(:,neuroChannel,i),ext,0,'iir'));
    hold on;
end

xlim([-2 2]);

subplot(2,1,2)
for i=1:size(behvCloseSeg,3)
    imagesc(behvCloseSeg(:,1:5,i)');
    pause;
end

