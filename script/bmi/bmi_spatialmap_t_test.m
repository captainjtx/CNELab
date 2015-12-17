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
%badChannels for AbductionAdduction
% badChannels={'ECG Bipolar','EMG Bipolar','Synch','C126','C127','C128'};

% badChannels={'Trigger','Acceleration X','Acceleration Y', 'Acceleration Z','Roll','Pitch'};

%Xu Yun
% badChannels={'C37','C3','C4','C5','C15','C16','C2','C27','C28','C6',...
%     'ECG Bipolar','EMG Bipolar','Synch','C41','C10','C11','C78','C9'};

%movemnt type
% Hand open close
% movements={'Open','Close'};
% movements={'Relax'};

% Finger
% movements={'F1 start','F2 start','F3 start','F4 start','F5 start'};
% movements={'Rest start'};

%Abduction
movements={'Abd','Add'};
%if movements is 2*n, will extract the segments between the first row and
%second row
% movements={'Rest Start';'Rest End'};
%Rest
% movements={'Rest Start'};

save_seg=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
segments=bmi_segment_extract(SBefore,SAfter,TMin,badChannels,movements,save_seg);

%Delta band
% lc=0.5;
% hc=4;
%up-gamma band
% lc=60;
% hc=200;
% pn='p';
% t_mask=1.5;

%alpha band
% lc=8;
% hc=13;
%beta band
% lc=13;
% hc=32;

%alpha&beta band
lc=8;
hc=32;
pn='n';
t_mask=0.5;

%%This will normalize the tfmap to -1 and 1 by dividing the maximum abs
scale=true;
%This will plot the missing channel
plotmissing=false;
%Maintain percent of cumsum
percent_threshold=[];

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
%hand open close
% baseline_time=[0,0.5];

%hand abd add
baseline_time=[0.5,1];

baseline_sample=round(baseline_time(1)*fs+1):round(baseline_time(2)*fs);

%hand open close
% move_time=[1.5 2];

%hand abd add
move_time=[1 2.2];

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
%         [Pxx,F]=pwelch(baseline(:,i),wn,ov,nfft,fs);
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
%                 [Pxx,F]=pwelch(rdata(:,t),wn,ov,nfft,fs);
                pwRest(i) = pwRest(i)+bandpower(Pxx,F,[lc hc],'psd');
            end
        end
    end
    pwRest=pwRest/length(movements)/size(rdata,2);
end
%==========================================================================

figure('Name','Baseline','Position',[0,0,14.5*dw,11*dh]);
a=axes('Units','Pixels','Position',[dw/2,dh/2,12*dw,10*dh]);
gauss_interpolate_120_grid(a,pwRest,channelindex,[],30,30,pn,false,plotmissing);
cb=colorbar('Units','Pixels');
cbpos=get(cb,'Position');
set(a,'Position',[dw/2,dh/2,12*dw,10*dh]);
set(cb,'Position',[13*dw,dh/2,cbpos(3),cbpos(4)])
%**************************************************************************
for m=1:length(movements)
    coordinates=zeros(length(channelindex),2);
    
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
            if ~ttest(relative,1,'Tail','Left')
                relative=1;
            end
        else
            if ttest(relative,t_mask,'Tail','Right')
               sigChan=cat(1,sigChan,i);
            end
            if ~ttest(relative,1,'Tail','Right')
                relative=1;
            end
        end
        cind=str2double(channelnames{i}(2:end));
        coordinates(i,1)=dw*rem(cind-1,12)+dw/2;
        coordinates(i,2)=dh*floor((cind-1)/12)+dh/2;
        
        coordinates(i,3)=10*log10(mean(relative));
    end
    
    figure('Name',movements{m},'Position',[0,0,14.5*dw,11*dh]);
    a=axes('Units','Pixels','Position',[dw/2,dh/2,12*dw,10*dh]);
    map_axe=cat(1,map_axe,a);

    gauss_interpolate_120_grid(a,coordinates(:,3),channelindex,sigChan,30,30,pn,scale,plotmissing,percent_threshold);
    cb=colorbar('Units','Pixels');
    cbpos=get(cb,'Position');
    set(a,'Position',[dw/2,dh/2,12*dw,10*dh]);
    set(cb,'Position',[13*dw,dh/2,cbpos(3),cbpos(4)])
    
    
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
    obj.(movements{m})=cat(1,reshape(val,length(val),1),reshape(ind,length(ind),1));
    
    stat.(movements{m}).mean=mean(val);
    stat.(movements{m}).std=std(val);
end

%statistics
if strcmpi(pn,'p')
    if ~isempty(obj.(movements{1}))
        [v,ind]=max(obj.(movements{1})(1,:));
        disp([movements{1} ,'max channel: ', num2str(obj.(movements{1})(2,ind))])
    end
    
    if ~isempty(obj.(movements{2}))
        [v,ind]=max(obj.(movements{2})(1,:));
        disp([movements{2},' max channel: ', num2str(obj.(movements{2})(2,ind))])
    end
elseif strcmpi(pn,'n')
    if ~isempty(obj.(movements{1}))
        [v,ind]=min(obj.(movements{1})(1,:));
        disp([movements{1},' min channel: ', num2str(obj.(movements{1})(2,ind))])
    end
    if ~isempty(obj.(movements{2}))
        [v,ind]=min(obj.(movements{2})(1,:));
        disp([movements{2},' min channel: ', num2str(obj.(movements{2})(2,ind))])
    end
end

if ~isempty(obj.(movements{1}))
    for i=1:size(obj.(movements{1}),2)
        if isempty(obj.(movements{2}))
            disp(['Channel: ',num2str(obj.(movements{1})(2,i)),' ON in ',movements{1},' OFF in ',movements{2}])
        elseif ~any(obj.(movements{1})(2,i)==obj.(movements{2})(2,:))
            disp(['Channel: ',num2str(obj.(movements{1})(2,i)),' ON in ',movements{1},' OFF in ',movements{2}])
        end
    end
end

if ~isempty(obj.(movements{2}))
    for i=1:size(obj.(movements{2}),2)
        if isempty(obj.(movements{1}))
            disp(['Channel: ',num2str(obj.(movements{2})(2,i)),' OFF in ',movements{1},' On in ',movements{2}])
        elseif ~any(obj.(movements{2})(2,i)==obj.(movements{1})(2,:))
            disp(['Channel: ',num2str(obj.(movements{2})(2,i)),' OFF in ',movements{1},' On in ',movements{2}])
        end
    end
end

clim=[inf -inf];
for i=1:length(map_axe)
    tmp=get(map_axe(i),'CLim');
    clim(1)=min(clim(1),tmp(1));
    clim(2)=max(clim(2),tmp(2));
end

for i=1:length(map_axe)
    tmp=max(abs(clim));
    set(map_axe(i),'CLim',[-tmp,tmp]);
end