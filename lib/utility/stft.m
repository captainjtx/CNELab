function [tfm,t,f]=stft(x,nf,fs,wd,shft,typ)
% stft(x,nf,fs,wd,shft,typ)
% Calculates Short Time Fourier Transform of x
% nf = number of FFT points
% wd = window width
% shft = shift amount of the window
% typ=1 Thomson Multitaper Method
if nargin<6
    typ=0;  %default type
end


if length(wd)==1
    W=hamming(wd);
else
    W=wd;
    wd=length(wd);
end

x=x(:);
ln=length(x);
m=round((ln-wd+1)/shft); %to nearest integer
tfm=zeros(nf/2+1,m);
k=1;

for i=1:shft:ln-wd+1
    if ~typ
        data=x(i:i+wd-1).*W;
        xf=2*abs(fft(data,nf)).^2;
    else
        data=x(i:i+wd-1);
        [xf,w]=pmtm(data,1.5,nf,fs);
    end
    tfm(:,k)=abs(xf(1:nf/2+1));
    k=k+1;
end

 t=(1:shft:ln-wd+1)/fs;
 f=(0:nf/2)/(nf/2)*fs/2;

if nargout==0
    imagesc(t,f,tfm);
    axis xy;
    xlabel('Time');
    ylabel('Frequency (Hz)');
end
