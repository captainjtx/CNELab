function tfpower=bmi_tfpower(eeg,fs,wd,ov,lc,hc)
%[tfm,f,t]=tfmap(eeg,nf,fs,wd,ov,lc,hc)
% eeg is the multi trial neural data with each correspond to column
% fs is the sampling frequency of the data
% wd is the width of the time window
% ov is the amount of overlap when moving the window along the time axis.
% lc and hc are the low and high frequency cutoff frequencies (optional)
if nargin > 4
    [b,a]=butter(2,[lc hc]/(fs/2));
    % Zero phase filtering the data
    eegf=filtfilt(b,a,eeg);
else
    eegf = eeg;
end

nf=2^nextpow2(wd);
win=hanning(wd);
% win=gausswin(wd,2.5);
tfm=0;
figure;
for i=1:size(eeg,2)
    [tf,f,t]=spectrogram(eegf(:,i),win,ov,nf,fs);
    tf=abs(tf);
    tfm=tfm+tf;
    
    subplot(2,1,1)
    plot(eegf(:,i));
    xlim([0 length(eegf(:,i))]);
    subplot(2,1,2)
    imagesc(t,f,tf);
    xlabel('Time');
    ylabel('Frequency');
    ylim([0 max(f)]);
    axis xy;
    colormap(jet);
    pause(0.5);
end

tfm=tfm/size(eeg,2);
tfpower=2*tfm.^2/size(tfm,1);

if nargout==0
    figure;
    imagesc(t,f,tfpower);
    xlabel('Time');
    ylabel('Frequency');
    ylim([0 max(f)]);
    axis xy;
    colormap(jet);
    colorbar;
end

end



