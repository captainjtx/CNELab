function [r,d,pat]=qrs_detector(ecg,Fs)
% [r,d,pat]=qrs_detector(ecg,Fs)
%
wl=fix(Fs*.3); %300ms Window of left side of the R Point
wr=fix(Fs*.4); %400ms Window of right side of the R Point
ecgd=(diff(ecg)); % Derivative of the ECG signal
thr=threshold(ecgd,Fs); % Finds the threshold
Q=16; % QRS search window;
%close;

l=length(ecgd);
k=1;
pat=[];
j=wl+1;

for i=wl:(l-wr-1),
    m=ecgd(j);
    
    if j>l-wr-Q
        break;
    end
    
    
    if m>thr
        if m>=max(ecgd((j-wl:j+wr))) % Checks the right and left side of the point
            [mx,rx]=max(ecg((j:j+Q))); % If it is the maximum then
            r(k)=j+rx;
            d(k)=mx;
            pt=ecg(j+rx-wl:j+rx+wr);
            
            pat=[pat pt];
            k=k+1;
            j=j+wr;
            
        end
    end
    
    j=j+1;
end
%figure;
%plot(pat);
%size(r)
%pause;
rr=diff(r)/Fs; %Displays the RR indervals
%plot(rr);
