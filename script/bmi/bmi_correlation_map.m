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
SBefore=1.5;
SAfter=1.5;
TMin=1;
%Rest
% SBefore=0;
% SAfter=30;
% TMin=0;

%exclude bad\syn\noisy channels if any
%var channels stores clean channel index

%Yaqiang Sun
badChannels={'ECG Bipolar','EMG Bipolar','Synch'};

% Li Ma
%badChannels for Handopenclose
% badChannels={'C27','C64','C75','C76','C100','ECG Bipolar','EMG Bipolar','Synch'};

% badChannels for AbductionAdduction
% badChannels={'ECG Bipolar','EMG Bipolar','Synch'};

%Xu Yun
% badChannels={'C37','C3','C4','C5','C15','C16','C2','C27','C28','C6',...
%     'ECG Bipolar','EMG Bipolar','Synch','C126','C127','C128','C41','C10','C11',...
%     'C78','C9'};

%movemnt type
% Hand open close
movements={'Open','Close'};
% movements={'Relax'};

% Finger
% movements={'F1 start','F2 start','F3 start','F4 start','F5 start'};
% movements={'Rest start'};

%Abduction
% movements={'Abd','Add'};
%Rest
% movements={'Rest Start'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[segments,fs,channelnames,channelindex]=bmi_segment_extract(SBefore,SAfter,TMin,badChannels,movements);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Delta band
% lc=0.5;
% hc=4;
%up-gamma band
lc=60;
hc=200;
pn='p';
t_mask=1.5;
diff_corr=0.1;

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
% t_mask=0.5;
% diff_corr=0.2;

scale=true;

plotmissing=false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename='corr.txt';
fid=fopen(filename,'a');
pt=3;
% fprintf(fid,'%s,%s,%s,%s','Pt','Chan','Movement','PN','Coef','Sig');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(channelnames)
    t=channelnames{i};
    channelindex(i)=str2double(t(2:end));
end

%hand open close
baseline_time=[0,0.5];
move_time=[1.5 2];

%hand abd add
% baseline_time=[0.5,1];
% move_time=[1.5 2];


baseline_sample=round(baseline_time(1)*fs+1):round(baseline_time(2)*fs);

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

dgf=[];
%==========================================================================
%**************************************************************************
%Set up at the first time
map_axe=[];

corr_matrix_base=0;
p_matrix_base=0;
total_trial=0;
%==========================================================================
pwRest=zeros(length(channelindex),1);

%Average baseline across movements
for i=1:length(channelindex)
    for m=1:length(movements)
        data=squeeze(segments.(movements{m})(:,i,:));
        rdata=data(baseline_sample,:);
        for t=1:size(rdata,2)
            [Pxx,F] = periodogram(rdata(:,t),hamming(length(rdata(:,t))),length(rdata(:,t)),fs);
            %                 [Pxx,F]=pwelch(rdata(:,t),wn,ov,nfft,fs);
            pwRest(i) = pwRest(i)+bandpower(Pxx,F,[lc hc],'psd');
        end
    end
end
pwRest=pwRest/length(movements)/size(rdata,2);
%==========================================================================
figure('Position',[0,0,45*dw,11*dh]);
allSigChan=[];

%Pre-movement correlation
for m=1:length(movements)
    
    data=segments.(movements{m});
    
    for t=1:size(data,3)
        [b,a]=butter(2,[lc hc]/(fs/2));
        
        dt=data(:,:,t);
        
        fdata=filter_symmetric(b,a,dt,fs,0,'iir');
        
        base_data=fdata(baseline_sample,:);
        
        [tmp3,tmp4]=corrcoef(base_data);
        corr_matrix_base=corr_matrix_base+abs(tmp3);
        p_matrix_base=p_matrix_base+tmp4;
    end
    %average the corr_matrix through trials
    total_trial=total_trial+size(data,3);
end

corr_matrix_base=corr_matrix_base/total_trial;

base_corr_map_value = local_corr_map(corr_matrix_base,channelindex);

%==========================================================================
for m=1:length(movements)
    
    sigChan=[];
    for i=1:length(channelindex)
        cname=channelnames{i};
        data=squeeze(segments.(movements{m})(:,i,:));
        
        mdata=data(move_sample,:);
        
        pwMove=[];
        for t=1:size(mdata,2)
            [Pxx,F] = periodogram(mdata(:,t),hamming(length(mdata(:,t))),length(mdata(:,t)),fs);
%             [Pxx,F]=pwelch(mdata(:,t),wn,ov,nfft,fs);
            pwMove = cat(1,pwMove,bandpower(Pxx,F,[lc hc],'psd'));
        end
        
        relative=pwMove/pwRest(i);
        
        if strcmpi(pn,'n')
            if ttest(relative,t_mask,'Tail','Left')
               sigChan=cat(1,sigChan,i);
            end
        else
            if ttest(relative,t_mask,'Tail','Right')
               sigChan=cat(1,sigChan,i);
            end
        end
    end
    
    data=segments.(movements{m});
    
    corr_matrix=0;
    p_matrix=0;
    
    for t=1:size(data,3)
        [b,a]=butter(2,[lc hc]/(fs/2));
        
        dt=data(:,:,t);
        
        fdata=filter_symmetric(b,a,dt,fs,0,'iir');
        
        fdata=fdata(move_sample,:);
        
        [tmp1,tmp2]=corrcoef(fdata);
        corr_matrix=corr_matrix+abs(tmp1);
        p_matrix=p_matrix+tmp2;
    end
    %average the corr_matrix through trials
    corr_matrix=corr_matrix/size(data,3);
    p_matrix=p_matrix/size(data,3);
    
    K=size(data,2)*(size(data,2)-1)/2;
    %Bonferroni
    p_matrix=p_matrix*K;
    
    a=axes('Units','Pixels','Position',[16*dw+13*dw*(m-1),dh/2,12*dw,10*dh]);
    map_axe=cat(1,map_axe,a);
    
    map_value = local_corr_map(corr_matrix,channelindex);
%     map_value=sum(corr_matrix,2)/length(channelindex);
    
    gauss_interpolate_120_grid(map_axe(m),map_value-base_corr_map_value,channelindex,sigChan,dw,dh,pn,false,plotmissing,[]);
    set(a,'CLim',[-diff_corr,diff_corr]);
    %print out the correlation coefficient values==========================
    for i=1:length(channelindex)
        if any(i==sigChan)
            sig=1;
        else
            sig=0;
        end
        fprintf(fid,'%d,%d,%s,%s,%f,%d\n',pt,channelindex(i),movements{m},pn,map_value(i),sig);
    end
    %======================================================================
    if m==length(movements)
        cb=colorbar('Units','Pixels');
        cbpos=get(cb,'Position');
        set(cb,'Position',[28.5*dw+13*dw*(m-1)-10,dh/2,cbpos(3),cbpos(4)])
        set(map_axe(m),'Position',[16*dw+13*dw*(m-1)-10,dh/2,12*dw,10*dh]);
    end
    
    allSigChan=cat(1,allSigChan,sigChan);
end

a=axes('Units','Pixels','Position',[dw/2,dh/2,12*dw,10*dh]);
map_axe=cat(1,map_axe,a);

% map_value=sum(corr_matrix_base,2)/length(channelindex);

gauss_interpolate_120_grid(map_axe(end),base_corr_map_value,channelindex,unique(allSigChan),dw,dh,pn,false,plotmissing,[]);
set(a,'CLim',[0,1]);

%print out the correlation coefficient values==========================
for i=1:length(channelindex)
    if any(i==allSigChan)
        sig=1;
    else
        sig=0;
    end
    fprintf(fid,'%d,%d,%s,%s,%f,%d\n',pt,channelindex(i),'Base',pn,base_corr_map_value(i),sig);
end
fclose(fid);
%======================================================================
cb=colorbar('Units','Pixels');
cbpos=get(cb,'Position');
set(map_axe(end),'Position',[dw/2,dh/2,12*dw,10*dh]);
set(cb,'Position',[13*dw,dh/2,cbpos(3),cbpos(4)])

% clim=[inf -inf];
% for i=1:length(map_axe)
%     tmp=get(map_axe(i),'CLim');
%     clim(1)=min(clim(1),tmp(1));
%     clim(2)=max(clim(2),tmp(2));
% end
% 
% for i=1:length(map_axe)
%     set(map_axe(i),'CLim',[0.2,1]);
% end

%**************************************************************************

