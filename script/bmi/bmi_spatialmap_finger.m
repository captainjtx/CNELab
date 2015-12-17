clc
clear
fname='/Users/tengi/Desktop/Projects/data/BMI/fingers/Xuyun/neuroSegs_PCA.mat';
segments=load(fname);

fs=segments.samplefreq;
montage=segments.montage;
channelnames=montage.channelnames;

badchannels={'C37','C3','C4','C5','C15','C16','C2','C27','C28','C6',...
    'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128','C41','C10','C11',...
    'C78'};

movements={'F1Start','F2Start','F3Start','F4Start','F5Start'};
base={'RestStart'};
%Delta band
% lc=0.5;
% hc=4;
%up-gamma band
lc=60;
hc=200;
%alpha band
% lc=8;
% hc=13;
%beta band
% lc=13;
% hc=30;

%alpha&beta band
% lc=8;
% hc=32;

% baseline_time=[0 0.25];
% baseline_sample=round(baseline_time(1)*fs+1):round(baseline_time(2)*fs);
move_time=[1 2];
move_sample=round(move_time(1)*fs):round(move_time(2)*fs);

rname='/Users/tengi/Desktop/Projects/data/BMI/fingers/Xuyun/neuroSegs_rest.mat';
rest_segments=load(rname);
baseline=rest_segments.(base{1});

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
    coordinates=[];
    channelindex=[];
    c=0;
    for i=1:length(channelnames)
        
        if any(strcmpi(channelnames{i},badchannels))
            continue;
        end
        c=c+1;
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
        %         rdata=data(baseline_sample,:);
        
        relative=0;
        mdata=data(move_sample,:);
        
        [Pxx,F] = periodogram(baseline(:,i),hamming(length(baseline(:,i))),length(baseline(:,i)),fs);
        pwRest = bandpower(Pxx,F,[lc hc],'psd');
        
        for t=1:size(mdata,2)
            [Pxx,F] = periodogram(mdata(:,t),hamming(length(mdata(:,t))),length(mdata(:,t)),fs);
            pwMove = bandpower(Pxx,F,[lc hc],'psd');
            
            relative=pwMove/pwRest+relative;
        end
        
        relative=relative/size(mdata,2);
        
        cind=str2double(channelnames{i}(2:end));
        coordinates(c,1)=dw*rem(cind-1,12)+dw/2;
        coordinates(c,2)=dh*floor((cind-1)/12)+dh/2;
        
        %         indl=floor(lc/(fs/2)*size(psdRest,1));
        %         indh=floor(hc/(fs/2)*size(psdRest,1));
        %         baseline_power=sum(psdRest(indl:indh))/size(psdRest,1);
        %
        %         indl=floor(lc/(fs/2)*size(psdMove,1));
        %         indh=floor(hc/(fs/2)*size(psdMove,1));
        %         move_power=sum(psdMove(indl:indh))/size(psdMove,1);
        
        coordinates(c,3)=10*log10(relative);
        channelindex(c)=cind;
    end
    
    figure('Name',movements{m},'Position',[0,0,14.5*dw,11*dh]);
    a=axes('Units','Pixels','Position',[dw/2,dh/2,12*dw,10*dh]);
    map_axe=cat(1,map_axe,a);
    gauss_interpolate_120_grid(a,coordinates(:,3),channelindex,30,30,'n');
    cb=colorbar('Units','Pixels');
    cbpos=get(cb,'Position');
    set(a,'Position',[dw/2,dh/2,12*dw,10*dh]);
    set(cb,'Position',[13*dw,dh/2,cbpos(3),cbpos(4)])
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