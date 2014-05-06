function bmi_tfmap_ave()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%average the whole channels
channels={'C17'};

neuroSeg=load('neuroSeg.mat');
behvSeg=load('behvSeg.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs=neuroSeg.samplefreq;
montage=neuroSeg.montage;
channelnames=montage.channelnames;
channelindex=montage.channelindex;

movements=neuroSeg.movements;
refNum=20;

wd=200;
ov=180;
lc=1;
hc=200;



if isempty(channels)
    channels=channelnames;
end

%movements
for m=1:length(movements)
    figure('name',movements{m},'position',[0 0 400 800]);
    aveTFMap=0;
    for i=1:length(channelindex)
        if ismember(channelnames{i},channels)
        [tf,f,t]=bmi_tfmap(squeeze(neuroSeg.(movements{m})(:,i,:)),fs,wd,ov,lc,hc);
        rf=mean(tf(:,1:refNum),2);
        relativeTFMap=tf./repmat(rf+0.01,1,size(tf,2));
        aveTFMap=aveTFMap+relativeTFMap;
        end
    end
  
    subplot(3,1,1)
    imagesc(t-2,f,20*log10(aveTFMap/length(channels)),[-10 10]);
    title('time frequency power map')
    colormap(jet);
    xlabel('time (s)');
    ylabel('frequency (Hz)')
    axis xy;
    colorbar
    
    subplot(3,1,2)

    aveBehv=mean(behvSeg.(movements{m}),3);
    stamp=linspace(-2,2,size(behvSeg.(movements{m}),1));
    stamp=reshape(stamp,length(stamp),1);
    plot(repmat(stamp(1:end-1),1,size(behvSeg.(movements{m}),2)),abs(diff(aveBehv,1,1)));
    title('absolute velocity')
    xlabel('time (s)')
    legend('finger 1','finger 2','finger 3','finger 4','finger 5');
    
    
    subplot(3,1,3)
    plot(repmat(stamp(1:end),1,size(behvSeg.(movements{m}),2)),aveBehv);
    title('position')
    xlabel('time (s)')
    legend('finger 1','finger 2','finger 3','finger 4','finger 5');

end


end

