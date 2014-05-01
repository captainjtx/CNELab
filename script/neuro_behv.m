function neuro_behv()
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

neuroSeg=neuroSeg.Open;
behvSeg=behvSeg.Open;

stamp=linspace(-2,2,size(neuroSeg,1));


for i=1:size(behvSeg,3)
    subplot(3,1,1)
    plot(stamp,filter_symmetric(b,a,neuroSeg(:,neuroChannel,i),ext,0,'iir'));
    xlim([-2 2]);
    
    subplot(3,1,2)
    imagesc(behvSeg(:,1:5,i)');
    
    subplot(3,1,3)
    for j=1:size(behvSeg,2)
        plot(stamp,behvSeg(:,j,i));
        hold on;
    end
    xlim([-2 2]);
    disp(num2str(i));
    hold off
    pause;
end

figure

for i=1:size(behvSeg,2)
    plot(stamp,squeeze(mean(behvSeg(:,i,:),3)));
    hold on
end




