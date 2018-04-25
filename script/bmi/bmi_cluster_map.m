clc
clear
% fname='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/neuroSeg.mat';
fname='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/neuroSegs_PCA.mat';
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

corr_time=[1.7,2.7];
corr_sampe=round(corr_time(1)*fs):round(corr_time(2)*fs);
dw=30;
dh=30;

corr_t=0.1;
p_t=0.01;
cluster_t=1.15;

width=12*dw;
height=10*dh;

%gaussian kernel for interpolation in electrodes
sigma=0.5;
%so that 3 sigma almost cover the whole grid

%transform into pixel
sigma=round(sigma*(dw+dh)/2);


dgf=[];

%**************************************************************************
while (1)
    map_axe=[];
    total_trial=0;
    
    pbase=zeros(length(channelindex),1);
    d_base=0;
    
    for m=1:length(movements)
        
        coordinates=zeros(length(channelindex),2);
        for i=1:length(channelindex)
            cname=channelnames{i};
            data=squeeze(segments.(movements{m})(:,i,:));
            %common average montage
            data=data-repmat(mean(data,2),1,size(data,2));
            rdata=data(baseline_sample,:);
            mdata=data(move_sample,:);
            
            relative=0;
            power_base=0;
            for t=1:size(rdata,2)
                [Pxx,F] = periodogram(rdata(:,t),hamming(length(rdata(:,t))),length(rdata(:,t)),fs);
                pwRest = bandpower(Pxx,F,[lc hc],'psd');
                %             tmp = bandpower(rdata(:,t),fs,[lc,hc]);
                
                [Pxx,F] = periodogram(mdata(:,t),hamming(length(mdata(:,t))),length(mdata(:,t)),fs);
                pwMove = bandpower(Pxx,F,[lc hc],'psd');
                
                relative=pwMove/pwRest+relative;
                power_base=power_base+pwRest;
                
                pbase(i)=10*log10(power_base)+pbase(i);
            end
            
            relative=relative/size(rdata,2);
            power_base=power_base/size(rdata,2);
            
            cind=str2double(channelnames{i}(2:end));
            coordinates(i,1)=dw*rem(cind-1,12)+dw/2;
            coordinates(i,2)=dh*floor((cind-1)/12)+dh/2;
            
            coordinates(i,3)=10*log10(relative);
        end
        
        data=segments.(movements{m});
        
        cat_fdata=[];
        d=0;
        for t=1:size(data,3)
            [b,a]=butter(2,[lc hc]/(fs/2));
            dt=data(:,:,t);
            %common averaged
            dt=dt-repmat(mean(dt,2),1,size(dt,2));
            
            fdata=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,dt,fs,0,'iir');
            
            base_data=fdata(baseline_sample,:);
            
            fdata=fdata(move_sample,:);
            
            d_tmp=pdist(fdata','correlation');
            d=d+d_tmp;
            
            d_base=d_base+pdist(base_data','correlation');
            
            cat_fdata=cat(1,cat_fdata,fdata);
        end
        total_trial=total_trial+size(data,3);
%         d=pdist(cat_fdata','correlation');
        d=d/size(data,3);
        
        z=linkage(d,'complete');
%         H=dendrogram(z,size(cat_fdata,2),'Reorder',1:size(cat_fdata,2));
%         [H,T,outperm]=dendrogram(z,size(cat_fdata,2));
        
%         clst = cluster(z,'cutoff',cluster_t);
        clst=cluster(z,'maxclust',4);
        
        figure('Name',movements{m},'Position',[0,0,14.5*dw,11*dh]);
        a=axes('Units','Pixels','Position',[dw/2,dh/2,12*dw,10*dh]);
        map_axe=cat(1,map_axe,a);
%         correlation_120_grid(a,p_matrix,coordinates(:,3),channelindex,30,30,pn);
        cluster_120_grid(a,clst,coordinates(:,3),channelindex,30,30);
        cb=colorbar('Units','Pixels');
        cbpos=get(cb,'Position');
        set(a,'Position',[dw/2,dh/2,12*dw,10*dh]);
        set(cb,'Position',[13*dw,dh/2,cbpos(3),cbpos(4)])
    end
    
    figure('Name','Base','Position',[0,0,14.5*dw,11*dh]);
    a=axes('Units','Pixels','Position',[dw/2,dh/2,12*dw,10*dh]);
    map_axe=cat(1,map_axe,a);
    
    pbase=pbase/length(movements);
    d_base=d_base/total_trial;
    z=linkage(d_base,'complete');
    clst=cluster(z,'maxclust',4);
    
    cluster_120_grid(a,clst,pbase,channelindex,30,30);
        
    cb=colorbar('Units','Pixels');
    cbpos=get(cb,'Position');
    set(a,'Position',[dw/2,dh/2,12*dw,10*dh]);
    set(cb,'Position',[13*dw,dh/2,cbpos(3),cbpos(4)])
    
    clim=[inf -inf];
   
    for i=1:length(map_axe(1:length(movements)))
        tmp=get(map_axe(i),'CLim');
        clim(1)=min(clim(1),tmp(1));
        clim(2)=max(clim(2),tmp(2));
    end
    
    for i=1:length(map_axe(1:length(movements)))
        tmp=max(abs(clim));
        set(map_axe(i),'CLim',[-tmp,tmp]);
    end
    cprintf('SystemCommands','Cluster threshold: \n')
    s=input('','s');
    cluster_t=str2double(s);
    
    if isempty(cluster_t)||isnan(cluster_t)
        break
    end
    
    close all
    
end

