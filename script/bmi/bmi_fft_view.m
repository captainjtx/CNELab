clc
clear
% fname='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/neuroSeg.mat';
% disp_channel={'C2','C3','C4','C5','C6','C7','C8','C15','C16','C17','C18',...
%     'C19','C28','C29','C30','C31','C40','C41','C42','C43'};%Empty means all
fname='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/neuroSegs_PCA.mat';
disp_channel={'C78','C63','C110'};

segments=load(fname);

fs=segments.samplefreq;
montage=segments.montage;
channelnames=montage.channelnames;
channelindex=montage.channelindex;

movements=segments.movements;
refNum=20;

lc=0.5;
hc=200;

baseline_time=1.5;
baseline_sample=1:round(baseline_time*fs);
move_time=1.5;
move_sample=baseline_sample(end)+1:round((baseline_time+move_time)*fs);

if isempty(disp_channel)
    disp_channel=channelnames;
end

chanind=zeros(size(channelnames));
for i=1:length(disp_channel)
    chanind=chanind|strcmpi(channelnames,disp_channel{i});
end

ind=find(chanind);
%**************************************************************************


for c=1:length(ind)
    clf;
    rest=0;
    move=[];
    cname=channelnames{ind(c)};
    for m=1:length(movements)
        data=squeeze(segments.(movements{m})(:,ind(c),:));
        data=detrend(data);
        mdata=data(move_sample,:);
        rdata=data(baseline_sample,:);
        %=====Manual noise deletion for XUYUN==============================
        %=====Don't forget to disable it for other subjects
        if strcmpi(movements{m},'open')
            if any(strcmpi(cname,{'C3','C4','C5','C15','C16'}))
                data(:,[4,5,7])=[];
            elseif strcmpi(cname,'C78')
                data(:,[4,7])=[];
            end
        elseif strcmpi(movements{m},'close')
            if any(strcmpi(cname,{'C3','C4','C5','C15','C16'}))
                data(:,[3,4,18])=[];
            elseif strcmpi(cname,'C78')
                data(:,[3,4,18,19])=[];
            elseif strcmpi(cname,'C2')
                data(:,4)=[];
            end
        end
        %==================================================================
        %         nfft=2^nextpow2(size(mdata,1));
        nfft=512;
        Y=abs(fft(mdata,nfft));
        Y=mean(Y(1:nfft/2+1,:),2);
        
        %         nfft=2^nextpow2(size(rdata,1));
        nfft=512;
        Yr=abs(fft(rdata,nfft));
        Yr=mean(Yr(1:nfft/2+1,:),2);
        rest=Yr+rest;
        
        move=cat(2,move,Y);
    end
    
    indl=round(lc/(fs/2)*size(move,1));
    indh=round(hc/(fs/2)*size(move,1));
    
    f=linspace(lc,hc,indh-indl+1);
    plot(f,20*log10(move(indl:indh,:)))
    hold on
    rest=rest/length(movements);
    
    indl=round(lc/(fs/2)*size(rest,1));
    indh=round(hc/(fs/2)*size(rest,1));
    plot(linspace(lc,hc,indh-indl+1),20*log10(rest(indl:indh)),'m');
    hold off
    
    xlabel('Frequency(Hz)');
    ylabel('Log Power');
    title(cname)
    legend(movements{:},'Rest')
    pause
    clf
    
    
end
%==========================================================================
