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
behvChannel=1;

[b,a]=butter(order,[fl fh]/(fs/2),'bandpass');

neuroCloseSeg=neuroSeg.Close;
behvCloseSeg=behvSeg.Close;

stamp=linspace(-2,2,size(neuroCloseSeg,1));
subplot(3,1,1)
for i=1:size(neuroCloseSeg,3)
    plot(stamp,filter_symmetric(b,a,neuroCloseSeg(:,neuroChannel,i),ext,0,'iir'));
    hold on;
end

xlim([-2 2]);


for i=1:size(behvCloseSeg,3)
    subplot(3,1,2)
    imagesc(behvCloseSeg(:,1:5,i)');
    
    subplot(3,1,3)
    for j=1:size(behvCloseSeg,2)
        plot(stamp,behvCloseSeg(:,j,i));
        hold on;
    end
    xlim([-2 2]);
    disp(num2str(i));
    hold off
%     pause;
end

figure

for i=1:size(behvCloseSeg,2)
    plot(stamp,squeeze(mean(behvCloseSeg(:,i,:),3)));
    hold on
end




