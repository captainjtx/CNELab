function bmi_tfmap_montage_view()

[FileName,FilePath]=uigetfile('.mat','select segments file');
segments=load(fullfile(FilePath,FileName));
segments=segments.segments;

fs=segments.samplefreq;
montage=segments.montage;
channelnames=montage.channelnames;
channelindex=montage.channelindex;

movements=segments.movements;
refNum=20;

wd=200;
ov=180;
lc=5;
hc=200;

%movements
for m=1:length(movements)
    figure('name',movements{m});
    for i=1:length(channelindex)
        subplot(10,12,channelindex(i))
        %     title(channelnames{i});
        [tf,f,t]=bmi_tfmap(squeeze(segments.(movements{m})(:,i,:)),fs,wd,ov,lc,hc);
        rf=mean(tf(:,1:refNum),2);
        relativeTFMap=tf./repmat(rf+0.01,1,size(tf,2));
        
        imagesc(t,f,20*log10(relativeTFMap),[-10 10]);
        colormap(jet);
        axis xy;
        axis off;
    end
end
end

