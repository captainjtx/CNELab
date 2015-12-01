%Compute the baseline periodogram of Uncertainty task
%By Tianxiao Jiang
clc
clear

segDir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/09-01-2014/ACCsegs.mat';
infoDir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/09-01-2014/TrialsInfo.mat';


segs=load(segDir);
ACC_BaseLine=segs.PreTrialSegs;

info=load(infoDir);
TrialInfo=info.TrialInfo;

%Compute the TF Map
pt=unique(TrialInfo.Patient);

fs=512;
nfft=1024;
window=512;
noverlap=[];

uplimb_off=0;
lowlimb_off=0;

uplimb_on=0;
lowlimb_on=0;

for i=1:size(ACC_BaseLine,3)
    ACC_BaseLine(:,:,i)=detrend(ACC_BaseLine(:,:,i));
end
for i=1:length(pt)
    %pt_i medicine off
    ind1=find((TrialInfo.Patient==pt(i))&(strcmpi(TrialInfo.State,'MedicineOff')));
    %ACCNames={'UL Ax','LL Bx','UL Ay','LL By','UL Az','LL Bz'};
    bldata1=ACC_BaseLine(:,ind1,:);
    %Periodogram of Upper Limb Acc
    uplimb1=0;
    lowlimb1=0;
    
    for j=1:length(ind1)
        pxx=pwelch(bldata1(:,j,1),window,noverlap,nfft);
        pxx=abs(pxx);
        
        tmp=pwelch(bldata1(:,j,3),window,noverlap,nfft);
        tmp=abs(tmp);
        pxx=pxx+tmp;
        
        tmp=pwelch(bldata1(:,j,5),window,noverlap,nfft);
        tmp=abs(tmp);
        pxx=pxx+tmp;
        pxx=pxx/3;
        
        uplimb1=uplimb1+pxx;
        
        pxx=pwelch(bldata1(:,j,2),window,noverlap,nfft);
        pxx=abs(pxx);
        
        tmp=pwelch(bldata1(:,j,4),window,noverlap,nfft);
        tmp=abs(tmp);
        pxx=pxx+tmp;
        
        tmp=pwelch(bldata1(:,j,6),window,noverlap,nfft);
        tmp=abs(tmp);
        pxx=pxx+tmp;
        pxx=pxx/3;
        
        lowlimb1=lowlimb1+pxx;
    end
    %Periodogram of Lower Limb Acc
    uplimb2=0;
    lowlimb2=0;
    %pt_i medicine on
    ind2=find((TrialInfo.Patient==pt(i))&(strcmpi(TrialInfo.State,'MedicineOn')));
    bldata2=ACC_BaseLine(:,ind2,:);
    for j=1:length(ind2)
        
        pxx=pwelch(bldata2(:,j,1),window,noverlap,nfft);
        pxx=abs(pxx);
        
        tmp=pwelch(bldata2(:,j,3),window,noverlap,nfft);
        tmp=abs(tmp);
        pxx=pxx+tmp;
        
        tmp=pwelch(bldata2(:,j,5),window,noverlap,nfft);
        tmp=abs(tmp);
        pxx=pxx+tmp;
        pxx=pxx/3;
        
        uplimb2=uplimb2+pxx;
        
        pxx=pwelch(bldata2(:,j,2),window,noverlap,nfft);
        pxx=abs(pxx);
        
        tmp=pwelch(bldata2(:,j,4),window,noverlap,nfft);
        tmp=abs(tmp);
        pxx=pxx+tmp;
        
        tmp=pwelch(bldata2(:,j,6),window,noverlap,nfft);
        tmp=abs(tmp);
        pxx=pxx+tmp;
        pxx=pxx/3;
        
        lowlimb2=lowlimb2+pxx;
    end
    
    uplimb1=uplimb1/length(ind1);
    lowlimb1=lowlimb1/length(ind1);
    
    uplimb2=uplimb2/length(ind2);
    lowlimb2=lowlimb2/length(ind2);
    
    uplimb_off=uplimb_off+uplimb1;
    lowlimb_off=lowlimb_off+lowlimb1;
    
    uplimb_on=uplimb_on+uplimb2;
    lowlimb_on=lowlimb_on+lowlimb2;
end

fh=40;

n=round(length(uplimb_off)/(fs/2)*fh);
f=linspace(0,fh,n);
% plot(f,uplimb_off(1:n),'-r',f,uplimb_on(1:n),'-b',f,lowlimb_off(1:n),'-m',f,lowlimb_on(1:n),'-k');
figure
plot(f,uplimb_off(1:n),'-r',f,uplimb_on(1:n),'-b');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('Up Limb Off','Up Limb On');

figure
ind1=find(strcmpi(TrialInfo.State,'MedicineOff'));
ind2=find(strcmpi(TrialInfo.State,'MedicineOn'));
for j=1:length(ind2)
    i=ind2(j);
%     i=144;
    ULBaseLine=squeeze(ACC_BaseLine(:,i,[1,3,5]));
    ULBaseLine=ULBaseLine+ones(size(ACC_BaseLine,1),3)*[1,0,0;0,2,0;0,0,3];
    t=linspace(0,size(ULBaseLine,1)/fs,size(ULBaseLine,1));
    plot(t,ULBaseLine);
    set(gca,'YTick',[1 2 3]);
    set(gca,'YTickLabel',{'Ax','Ay','Az'});
    xlabel('time(s)')
    disp(i)
    disp(TrialInfo.State{i})
    pause
end

