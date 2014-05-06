function bmi_tfmap_channel_view()
% user define region
neuroSeg=load([pwd '/db/demo/neuroSeg.mat']);
behvSeg=load([pwd '/db/demo/behvSeg.mat']);

refNum=20; %use the first refNum point power to normalize time frequency map

wd=200; %window length
ov=180; %overlap length
lc=0.5; %lower cut off frequency in Hz
hc=200; %higher cut off frequency in Hz

channelToDisplay={}; % empty default as all avaiable channels
%--------------------------------------------------------------------------

fs=neuroSeg.samplefreq;
montage=neuroSeg.montage;
channelnames=montage.channelnames;

movements=segments.movements;

if isempty(channelToDisplay)
    channelToDisplay=channelnames;
end

stamp=(1:size(neuroSeg,1))/fs;
onset=size(neuroSeg,1)/2;

stamp=stamp-onset;
%movements
figure
for i=1:length(channelnames)
    if ismember(channelnames(i),channelToDisplay)
        
        for m=1:length(movements)
            
            neuroMat=squeeze(neuroSeg.(movements{m})(:,i,:));
            behvMat=squeeze(behvSeg.(movements(m))(:,i,:));
            
            subplot(length(movements),3,m*3-2)
            plot(repmat(reshape(stamp,length(stamp),1),1,size(neuroSeg.(movements{m}),3)),...
                neuroMat);
            
            
            [tf,f,t]=bmi_tfmap(neuroMat,fs,wd,ov,lc,hc);
            rf=mean(tf(:,1:refNum),2);
            relativeTFMap=tf./repmat(rf+0.01,1,size(tf,2));
            
            imagesc(t-2,f,20*log10(relativeTFMap),[-10 10]);
            colormap(jet);
            axis xy;
            xlabel('Time(s)');
            ylabel('Frequency(Hz)');
%             set(gca,'xticklabel',num2cell(t-2));
%             axis off;
        end
    end
    
    
    
end

