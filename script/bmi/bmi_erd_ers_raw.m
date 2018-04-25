%Written for NER conference
%ERD, ERS 

clc
clear

fname='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/neuroSeg.mat';
% fname='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/neuroSegs_PCA.mat';
segments=load(fname);

%Delta band
% lc=0.5;
% hc=4;
%up-gamma band
% lc=60;
% hc=200;
%alpha band
% lc=8;
% hc=13;
%beta band
% lc=13;
% hc=30;

%alpha&beta band
lc=8;
hc=32;

fs=segments.samplefreq;
montage=segments.montage;
channelnames=montage.channelnames;
channelindex=montage.channelindex;
for i=1:length(channelnames)
    t=channelnames{i};
    channelindex(i)=str2double(t(2:end));
end

movements=segments.movements;

baseline_time=[0 1.7];
baseline_sample=round(baseline_time(1)*fs+1):round(baseline_time(2)*fs);
move_time=[1.7 2.7];
move_sample=round(move_time(1)*fs):round(move_time(2)*fs);

for i=1:length(movements)
    seg=segments.(movements{i});
    
    evts={};
    data=[];
    
    for s=1:size(seg,3)
        
        [b,a]=butter(2,[lc hc]/(fs/2));
        seg_f=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,seg(:,:,s),fs,0,'iir');
        
        evts=cat(1,evts,{size(data,1)/fs,'Rest'});
        evts=cat(1,evts,{size(data,1)/fs+length(baseline_sample)/fs,movements{i}});
        
        data=cat(1,data,seg_f([baseline_sample,move_sample],:));
        
        
    end
    
    bsp=BioSigPlot(data,'Evts',evts,'SRate',fs,'ChanNames',channelnames,'Title',movements{i},...
        'WinLength',13,'Position',[0,0,600,150],'Gain',2,'DispChans',2);
end

