function bmi_tfmap_grid_view()

[FileName,FilePath]=uigetfile('.mat','select segments file');
segments=load(fullfile(FilePath,FileName));
segments=segments;

[FileName,FilePath]=uigetfile('.mat','select rest file');
restfile=load(fullfile(FilePath,FileName));
rest=restfile.task;
rest_datamat=rest.data.datamat;


fs=segments.samplefreq;
montage=segments.montage;
channelnames=montage.channelnames;
channelindex=montage.channelindex;

movements=segments.movements;


% refNum=20;

wd=200;
ov=180;
% lc=5;
% hc=200;
%rest time frequency map
tf_rest=sqrt(mean(rest_datamat.^2,1));
%movements
for m=1:length(movements)
    
    figure('name',movements{m});
    for i=1:length(channelindex)
        subplot(10,12,channelindex(i))
        %     title(channelnames{i});
        [tf,f,t]=bmi_tfmap(squeeze(segments.(movements{m})(:,i,:)),fs,wd,ov);
       
        relativeTFMap=tf./tf_rest(channelindex(i));
        
        imagesc(t,f,20*log10(relativeTFMap),[-10 10]);
        colormap(jet);
        axis xy;
        axis off;
    end
end
end

