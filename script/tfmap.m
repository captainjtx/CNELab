function [tfm,f,t]=tfmap(eeg,nf,fs,wd,ov,lc,hc)
%[tfm,f,t]=tfmap(eeg,nf,fs,wd,ov,lc,hc)
% eeg is the neural data where each column is a new trial and each row is a sample
% nf number of FFT points to use.
% fs is the sampling frequency of the data
% wd is the width of the time window
% ov is the amount of overlap when moving the window along the time axis.
% lc and hc are the low and high frequency cutoff frequencies (optional)
if nargin > 6
    [b,a]=butter(2,[lc hc]/(fs/2));
    % Zero phase filtering the data
    eegf=filtfilt(b,a,eeg);
else
    eegf = eeg;
end

[r,c]=size(eegf);
hm=hanning(wd);

%
if r>1
    xx=round((r-wd+1)/ov);
    m=c;
else
    xx=round((r-wd+1)/ov);
    m=r;
end

tfm=zeros(nf/2+1,xx);
%size(tfm)
% figure;
fprintf('Current Sweep:');
for l=1:m
    if r>1
        data=eegf(:,l);
    else
        data=eegf;
    end
    [tf,f,t]=specgram(data,nf,fs,hm,ov); % PSecgram returns the magnitude not the power
    %[tf,t,f]=stft(data,nf,fs,hm,length(hm)-ov,1);
    fprintf('-%d',l);
    %size(f)
    if l==1
        tfm=(abs(tf));
    end
    tfm=(abs(tf))+tfm;
    %whos tfm
    %pause;
    if nargout==0
        subplot(2,1,1);
        plot(data);
        lx=length(data);
        mx=2*max(abs(data));
        axis([0 lx -mx mx]);
        subplot(2,1,2);
        imagesc(t,f,tfm);
        axis xy;
        xlabel('Time');
        ylabel('Frequency');
        ylim([0 max(f)]);
        pause(.1);
    end
end
tfm=tfm/m;


