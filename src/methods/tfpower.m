function [tfm,f,t]=tfpower(eeg,baseline,fs,wd,ov,nref)
%return the power
nf=2^nextpow2(wd);
win=hanning(wd);
% win=gausswin(wd,2.5);
tfm=0;

for i=1:size(eeg,2)
    [~,f,t,tf]=spectrogram(eeg(:,i),win,ov,nf,fs);
    %s is stft, tf is power
    
    tf=abs(tf);
    
    if ~isempty(baseline)
        bdata=squeeze(baseline(:,i,:));
        rtf=0;
        for b=1:size(bdata,2)
            [~,~,~,tmp_rtf]=spectrogram(bdata(:,b),win,ov,nf,fs);
            rtf=rtf+tmp_rtf;
        end
        rtf=rtf/size(bdata,2);
        rf=mean(abs(rtf),2);
        tf=tf./repmat(rf,1,size(tf,2));
    elseif ~isempty(nref)
        rf=mean(tf(:,(t>=(nref(1)/fs))&(t<=(nref(2)/fs))),2);
        tf=tf./repmat(rf,1,size(tf,2));
    end
    tfm=tfm+tf;
end
tfm=tfm/size(eeg,2);
end



