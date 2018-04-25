clc
clear
%user defined region=======================================================
%get segments seconds before onset and after onset
% Hand open close
% SBefore=2;
% SAfter=2;
% TMin=0;

% Finger
% SBefore=1;
% SAfter=1.5;
% TMin=0;

%Abduction
SBefore=2;
SAfter=2;
TMin=1;
%Rest
% SBefore=0;
% SAfter=30;
% TMin=0;

%exclude bad\syn\noisy channels if any
%var channels stores clean channel index

%Yaqiang Sun
% badChannels={'C21','C33','C34','C46','C58','C82','C94','C106','C109',...
%     'ECG+','ECG-','EMG+','EMG-','Synch','C126','C127','C128'};
badChannels={'ECG Bipolar','EMG Bipolar','Synch','C126','C127','C128'};
% Li Ma
%badChannels for Handopenclose
% badChannels={'C27','C64','C75','C76','C100',...
%     'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128'};
%badChannels for AbductionAdduction
% badChannels={'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128'};

% badChannels={'Trigger','Acceleration X','Acceleration Y', 'Acceleration Z','Roll','Pitch'};

%Xu Yun
% badChannels={'C37','C3','C4','C5','C15','C16','C2','C27','C28','C6',...
%     'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128','C41','C10','C11',...
%     'C78','C9'};

%movemnt type
% Hand open close
% movements={'Open','Close'};
% movements={'Relax'};

% Finger
% movements={'F1 start','F2 start','F3 start','F4 start','F5 start'};
% movements={'Rest start'};

%Abduction
movements={'Abd','Add'};
%Rest
% movements={'Rest Start'};

save_seg=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

segments=bmi_segment_extract(SBefore,SAfter,TMin,badChannels,movements,save_seg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%p for p value, corr for correlation coefficient
% p_corr='p';
p_corr='corr';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% np_corr='n'; %display negative correlation
np_corr='p';  %display positive correlation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Delta band
% lc=0.5;
% hc=4;
%up-gamma band
% lc=60;
% hc=200;
% pn='p';%p for positive
%alpha band
% lc=8;
% hc=13;
%beta band
% lc=13;
% hc=30;

%alpha&beta band
lc=8;
hc=32;
pn='n'; %n for negative

scale=true;

plotmissing=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
corr_t=0.4;
p_t=0.05;
cluster_t=1.15;

%Threshold the spatial maps
percent_threshold=0.85;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs=segments.samplefreq;
montage=segments.montage;
channelnames=montage.channelnames;
channelindex=montage.channelindex;
for i=1:length(channelnames)
    t=channelnames{i};
    channelindex(i)=str2double(t(2:end));
end

movements=segments.movements;

% baseline_time=[0 1.7];
baseline_time=[1.3,1.7];
baseline_sample=round(baseline_time(1)*fs+1):round(baseline_time(2)*fs);
move_time=[1.7 2.7];
move_sample=round(move_time(1)*fs):round(move_time(2)*fs);

corr_time=[1.7,2.7];
corr_sampe=round(corr_time(1)*fs):round(corr_time(2)*fs);
dw=30;
dh=30;

width=12*dw;
height=10*dh;

%gaussian kernel for interpolation in electrodes
sigma=0.5;
%so that 3 sigma almost cover the whole grid

%transform into pixel
sigma=round(sigma*(dw+dh)/2);

dgf=[];
%==========================================================================
baseline=[];
% [FileName,FilePath]=uigetfile('.mat','select rest file',FilePath);
% if FileName
%     rest_segments=load(fullfile(FilePath,FileName));
%     names=matlab.lang.makeValidName(rest_segments.movements{1});
%     baseline=rest_segments.(names);
% end
%==========================================================================
pwRest=zeros(length(channelindex),1);
if ~isempty(baseline)
    for i=1:length(channelindex)
        [Pxx,F] = periodogram(baseline(:,i),hamming(length(baseline(:,i))),length(baseline(:,i)),fs);
        pwRest(i) = bandpower(Pxx,F,[lc hc],'psd');
    end
else
    %Average baseline across movements
    for i=1:length(channelindex)
        for m=1:length(movements)
            data=squeeze(segments.(movements{m})(:,i,:));
            rdata=data(baseline_sample,:);
            for t=1:size(rdata,2)
                [Pxx,F] = periodogram(rdata(:,t),hamming(length(rdata(:,t))),length(rdata(:,t)),fs);
                pwRest(i) = pwRest(i)+bandpower(Pxx,F,[lc hc],'psd');
            end
        end
    end
    pwRest=pwRest/length(movements)/size(rdata,2);
end
%==========================================================================
%**************************************************************************
%Set up at the first time
map_axe=[];
figure('Position',[0,0,45*dw,11*dh]);
pbase=zeros(length(channelindex),1);

for m=1:length(movements)
    
    a=axes('Units','Pixels','Position',[16*dw+13*dw*(m-1),dh/2,12*dw,10*dh]);
    map_axe=cat(1,map_axe,a);
    
    coordinates=zeros(length(channelindex),3);
    
    for i=1:length(channelindex)
        cname=channelnames{i};
        data=squeeze(segments.(movements{m})(:,i,:));
        
        mdata=data(move_sample,:);
        
        pwMove=0;
        for t=1:size(mdata,2)
            [Pxx,F] = periodogram(mdata(:,t),hamming(length(mdata(:,t))),length(mdata(:,t)),fs);
            pwMove = pwMove+bandpower(Pxx,F,[lc hc],'psd');
        end
        
        relative=pwMove/size(mdata,2)/pwRest(i);
        
        cind=str2double(channelnames{i}(2:end));
        coordinates(i,1)=dw*rem(cind-1,12)+dw/2;
        coordinates(i,2)=dh*floor((cind-1)/12)+dh/2;
        
        coordinates(i,3)=10*log10(relative);
    end
    gauss_interpolate_120_grid(map_axe(m),coordinates(:,3),channelindex,[],dw,dh,pn,scale,plotmissing,percent_threshold);
    
    if m==length(movements)
        cb=colorbar('Units','Pixels');
        cbpos=get(cb,'Position');
        set(cb,'Position',[28.5*dw+13*dw*(m-1)-10,dh/2,cbpos(3),cbpos(4)])
        set(map_axe(m),'Position',[16*dw+13*dw*(m-1)-10,dh/2,12*dw,10*dh]);
    end
    
end

a=axes('Units','Pixels','Position',[dw/2,dh/2,12*dw,10*dh]);
map_axe=cat(1,map_axe,a);

gauss_interpolate_120_grid(map_axe(end),pwRest,channelindex,[],dw,dh,pn,scale,plotmissing,[]);

cb=colorbar('Units','Pixels');
cbpos=get(cb,'Position');
set(map_axe(end),'Position',[dw/2,dh/2,12*dw,10*dh]);
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

%**************************************************************************
while (1)
    corr_matrix_base=0;
    p_matrix_base=0;
    total_trial=0;
    
    for m=1:length(movements)
        
        data=segments.(movements{m});
        
        cat_fdata=[];
        corr_matrix=0;
        p_matrix=0;
        
        for t=1:size(data,3)
            [b,a]=butter(2,[lc hc]/(fs/2));
            
            dt=data(:,:,t);
            
            fdata=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,dt,fs,0,'iir');
            
            base_data=fdata(baseline_sample,:);
            fdata=fdata(move_sample,:);
            
            [tmp3,tmp4]=corrcoef(base_data);
            corr_matrix_base=corr_matrix_base+tmp3;
            p_matrix_base=p_matrix_base+tmp4;
            
            [tmp1,tmp2]=corrcoef(fdata);
            corr_matrix=corr_matrix+tmp1;
            p_matrix=p_matrix+tmp2;
            cat_fdata=cat(1,cat_fdata,fdata);
        end
        %average the corr_matrix through trials
        corr_matrix=corr_matrix/size(data,3);
        p_matrix=p_matrix/size(data,3);
        total_trial=total_trial+size(data,3);
        %             [corr_matrix,p_matrix]=corrcoef(cat_fdata);
        
        %         d=pdist(cat_fdata','correlation');
        %         z=linkage(d,'complete');
        %         H=dendrogram(z,size(cat_fdata,2),'Reorder',1:size(cat_fdata,2));
        %         [H,T,outperm]=dendrogram(z,size(cat_fdata,2));
        
        %         clst = cluster(z,'cutoff',cluster_t);
        %         clst=cluster(z,'maxclust',4);
        %         hold on
        %         xl=get(gca,'xlim');
        %         plot(xl,[1-corr_t,1-corr_t],'-.');
        
        K=size(data,2)*(size(data,2)-1)/2;
        %Bonferroni
        p_matrix=p_matrix*K;
        p_matrix(p_matrix>p_t)=10;
        p_matrix(p_matrix<=p_t)=1;
        p_matrix(p_matrix==10)=0;
        
        corr_matrix((corr_matrix<=corr_t)&(corr_matrix>=-corr_t))=0;
        
        if strcmpi(p_corr,'p')
            update_correlation_maps(map_axe(m),p_matrix,coordinates(:,3),channelindex,dw,dh,np_corr);
        else
            update_correlation_maps(map_axe(m),corr_matrix,coordinates(:,3),channelindex,dw,dh,np_corr);
        end
        
        %         cluster_120_grid(a,clst,coordinates(:,3),channelindex,30,30,pn);
    end
    
    
    p_matrix_base=p_matrix_base/total_trial;
    corr_matrix_base=corr_matrix_base/total_trial;
    
    K=size(data,2)*(size(data,2)-1)/2;
    
    corr_matrix_base((corr_matrix_base<=corr_t)&(corr_matrix_base>=-corr_t))=0;
    p_matrix_base=p_matrix_base*K;
    p_matrix_base(p_matrix_base>p_t)=10;
    p_matrix_base(p_matrix_base<=p_t)=1;
    p_matrix_base(p_matrix_base==10)=0;
    
    if strcmpi(p_corr,'p')
        update_correlation_maps(map_axe(end),p_matrix_base,coordinates(:,3),channelindex,dw,dh,np_corr);
    else
        update_correlation_maps(map_axe(end),corr_matrix_base,coordinates(:,3),channelindex,dw,dh,np_corr);
    end
    
    %         cluster_120_grid(a,clst,coordinates(:,3),channelindex,30,30,pn);
    cprintf('SystemCommands','Correlation threshold: \n')
    s=input('','s');
    corr_t=str2double(s);
    
    if isempty(corr_t)||isnan(corr_t)
        break
    end
    
    firsttime=false;
end

