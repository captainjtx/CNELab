function bmi_tfmap_channel_view()
% user define region
neuroSeg=load('/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/neuroSeg.mat');
behvSeg=load('/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/behvSeg.mat');

refNum=20; %use the first refNum point power to normalize time frequency map

wd=200; %window length
ov=180; %overlap length
lc=5; %lower cut off frequency in Hz
hc=200; %higher cut off frequency in Hz

channelToDisplay={}; % empty default as all avaiable channels
%--------------------------------------------------------------------------

fs=neuroSeg.samplefreq;
montage=neuroSeg.montage;
channelnames=montage.channelnames;

movements=neuroSeg.movements;

if isempty(channelToDisplay)
    channelToDisplay=channelnames;
end

stamp=(1:size(neuroSeg.(movements{1}),1))/fs;
onset=size(neuroSeg.(movements{1}),1)/fs/2;

stamp=stamp-onset;
%movements
figure
for i=1:length(channelnames)
    if ismember(channelnames(i),channelToDisplay)
        
        for m=1:length(movements)
            
            neuroMat=squeeze(neuroSeg.(movements{m})(:,i,:));
            
            [b,a]=butter(2,[lc hc]/(fs/2));
            % Zero phase filtering the data
            neuroMat=filtfilt(b,a,neuroMat);
            
            subplot(2,length(movements),m)
            
            plot(repmat(reshape(stamp,length(stamp),1),1,size(neuroSeg.(movements{m}),3)),neuroMat);
            xlim([min(stamp),max(stamp)])
            ylim([-0.8 0.8])
            
            title([channelnames(i),'--',movements{m}])
            [tf,f,t]=tfmap(neuroMat,fs,wd,ov);
            rf=mean(tf(:,1:refNum),2);
            relativeTFMap=tf./repmat(rf+0.01,1,size(tf,2));
            
            subplot(2,length(movements),length(movements)+m)
            imagesc(t-2,f,20*log10(relativeTFMap),[-10 10]);
            colormap(jet);
            axis xy;
            xlabel('Time(s)');
            ylabel('Frequency(Hz)');
            
        end
        
        pause
    end
    
    
    
end

