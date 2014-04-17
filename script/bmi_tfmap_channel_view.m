function bmi_tfmap_channel_view(channelname)
if nargin==0;
    channelname='C17';
end
[FileName,FilePath]=uigetfile('*.mat','select a segment file');
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
lc=0.5;
hc=200;

%movements
for i=1:length(channelindex)
    if strcmpi(channelnames(i),channelname)
        
        for m=1:length(movements)
            
            figure('name',[channelname ' - ' movements{m}]);
            
            [tf,f,t]=bmi_tfmap(squeeze(segments.(movements{m})(:,i,:)),fs,wd,ov,lc,hc);
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

