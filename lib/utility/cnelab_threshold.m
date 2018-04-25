function r=cnelab_threshold(ecg,Fs)
%th=cnelab_threshold(ecg,Fs)
% Fs=Sampling Frequency
L=length(ecg);
if L > Fs*5
    N=Fs*5; % 5 second segment
else
    N=Fs;
end
k=1;

segments=fix(L/N); % Divides into two sec segments
thresh=zeros(1,segments);

for i=1:N:L-N
    thresh(k)=max(ecg(i:i+N)); % Finds the maxmium points in these segments
    k=k+1;
end

r=median(thresh)*0.40; %Threshold is the k th of the median of these segments
% k=0.6 for this application and can be between 0.5-0.7
th=ones(1,N)*r;
figure;
plot(ecg(1:N));
hold on;
plot(th,'r');
pause(1);
close;
