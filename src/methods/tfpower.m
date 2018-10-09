function [tfm,f,t]=tfpower(eeg,baseline,fs,wd,ov,nref,varargin)
if length(varargin) == 1
    align = varargin{1};
    assert(align == -1 || align == 1 || align == 0);
else
    align = 1; % causal
end
%return the power
nf=2^nextpow2(wd);
win=hanning(wd);
% win=gausswin(wd,2.5);
tfm=0;

if ~isempty(baseline)
    if size(baseline,2)~=size(eeg,2)
        error('Dimension conflict between Baseline and Signal');
    end
end

for i=1:size(eeg,2)
    [~,f,t,tf]=spectrogram(eeg(:,i),win,ov,nf,fs);
    %s is stft, tf is power
    t = t+wd/fs/2*align;
    tf=abs(tf);
    tfm=tfm+tf;
end

tfm = tfm/size(eeg,2);

if ~isempty(baseline)
    rtf=0;
    for i=1:size(baseline,2)
        bdata=squeeze(baseline(:,i,:));
        tmp=0;
        for b=1:size(bdata,2)
            [~,~,~,tmp_rtf]=spectrogram(bdata(:,b),win,ov,nf,fs);
            tmp=tmp+tmp_rtf;
        end
        rtf=rtf+tmp/size(bdata,2);
    end
    rf=mean(abs(rtf),2);
    tfm=tfm./repmat(rf,1,size(tf,2));
elseif ~isempty(nref)
    rf=mean(tfm(:,(t>=(nref(1)/fs))&(t<=(nref(2)/fs))),2);
    tfm=tfm./repmat(rf,1,size(tf,2));
end
end



