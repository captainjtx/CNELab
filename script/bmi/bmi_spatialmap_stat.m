%bmi_powermap_stat
clc
% clear
fname='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/neuroSeg.mat';
% fname='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/neuroSegs_PCA.mat';
segments=load(fname);

fs=segments.samplefreq;
montage=segments.montage;
channelnames=montage.channelnames;
channelindex=montage.channelindex;
for i=1:length(channelnames)
    t=channelnames{i};
    channelindex(i)=str2double(t(2:end));
end

movements=segments.movements;

%Delta band
% lc=0.5;
% hc=4;
%up-gamma band
lc=60;
hc=200;
pn='p';
%alpha band
% lc=8;
% hc=13;
%beta band
% lc=13;
% hc=30;

%alpha&beta band
% lc=8;
% hc=32;
% pn='n';

baseline_time=[0 1.7];
baseline_sample=round(baseline_time(1)*fs+1):round(baseline_time(2)*fs);
move_time=[1.7 2.7];
move_sample=round(move_time(1)*fs):round(move_time(2)*fs);

dw=30;
dh=30;

width=12*dw;
height=10*dh;

%gaussian kernel for interpolation in electrodes
sigma=0.5;
%so that 3 sigma almost cover the whole grid

%transform into pixel
sigma=round(sigma*(dw+dh)/2);

map_axe=[];
%**************************************************************************
for m=1:length(movements)
    coordinates=zeros(length(channelindex),2);
    for i=1:length(channelindex)
        cname=channelnames{i};
        data=squeeze(segments.(movements{m})(:,i,:));
        %=====Manual noise deletion for XUYUN==============================
        %=====Don't forget to disable it for other subjects
%         if strcmpi(movements{m},'open')
%             if any(strcmpi(cname,{'C3','C4','C5','C15','C16'}))
%                 data(:,[4,5,7])=[];
%             elseif strcmpi(cname,'C78')
%                 data(:,[4,7])=[];
%             end
%         elseif strcmpi(movements{m},'close')
%             if any(strcmpi(cname,{'C3','C4','C5','C15','C16'}))
%                 data(:,[3,4,18])=[];
%             elseif strcmpi(cname,'C78')
%                 data(:,[3,4,18,19])=[];
%             elseif strcmpi(cname,'C2')
%                 data(:,4)=[];
%             end
%         end
        %==================================================================
        rdata=data(baseline_sample,:);
        mdata=data(move_sample,:);
        relative=0;
        
        for t=1:size(rdata,2)
            [Pxx,F] = periodogram(rdata(:,t),hamming(length(rdata(:,t))),length(rdata(:,t)),fs);
            pwRest = bandpower(Pxx,F,[lc hc],'psd');
%             tmp = bandpower(rdata(:,t),fs,[lc,hc]);

            [Pxx,F] = periodogram(mdata(:,t),hamming(length(mdata(:,t))),length(mdata(:,t)),fs);
            pwMove = bandpower(Pxx,F,[lc hc],'psd');

            relative=pwMove/pwRest+relative;
        end
        
        relative=relative/size(rdata,2);
        
        cind=str2double(channelnames{i}(2:end));
        coordinates(i,1)=dw*rem(cind-1,12)+dw/2;
        coordinates(i,2)=dh*floor((cind-1)/12)+dh/2;
        
%         indl=floor(lc/(fs/2)*size(psdRest,1));
%         indh=floor(hc/(fs/2)*size(psdRest,1));
%         baseline_power=sum(psdRest(indl:indh))/size(psdRest,1);
%         
%         indl=floor(lc/(fs/2)*size(psdMove,1));
%         indh=floor(hc/(fs/2)*size(psdMove,1));
%         move_power=sum(psdMove(indl:indh))/size(psdMove,1);
        
        coordinates(i,3)=10*log10(relative);
    end
    
    
    val=coordinates(:,3);
    val=10.^(val/10);
    
    ind=channelindex;
         
    if strcmpi(pn,'p')
        ind(val<1.5)=[];
        val(val<1.5)=[];
    elseif strcmpi(pn,'n')
        ind(val>0.5)=[];
        val(val>0.5)=[];
    end
    
    stat.(movements{m}).mean=mean(10*log10(val));
    stat.(movements{m}).std=std(10*log10(val));
end
