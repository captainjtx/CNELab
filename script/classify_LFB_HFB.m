clc
clear

f=load('/Users/tengi/Desktop/Projects/data/China/handopenclose/S2/Open.mat','-mat');
open=f.Open;
f=load('/Users/tengi/Desktop/Projects/data/China/handopenclose/S2/Close.mat','-mat');
close=f.Close;
%%
fs=open.fs;
ms_before=open.ms_before;
onset=round(fs*ms_before/1000);

stats={};

fig=figure('name','S2','position',[100,100,600,450]);

len=800;%classification data length in ms

step=50;%step in ms

f1=[8,60];
f2=[32,200];

col={'g','r','k','b','m'};
exp={};

fir_h=fir1(32,.001,'low');

len=round(len/1000*fs);
step=round(step/1000*fs);

%%
%S1
% motor=[1:6,13:18,25:30,37:42,49:52,61:64,73:76,85:88,97:100,109:111];
% sensory=setdiff(1:120,motor);
% ers=[1:7,14:19,26:32,38:43,52:53];
%%
%%
%S2
sensory=[75,61,49,37,25,13,1];
motor=setdiff(1:120,sensory);
ers=[109:111,97,98,85,86,73:75,61:63,51,49,25];

motor_ers=union(motor,ers);
sensory_ers=union(sensory,ers);
%%
motorchannel=cell(length(motor),1);
sensorychannel=cell(length(sensory),1);

motorerschannel=cell(length(motor_ers),1);
sensoryerschannel=cell(length(sensory_ers),1);

for i=1:length(motor)
    motorchannel{i}=['C',num2str(motor(i))];
end
for i=1:length(sensory)
    sensorychannel{i}=['C',num2str(sensory(i))];
end

for i=1:length(motor_ers)
    motorerschannel{i}=['C',num2str(motor_ers(i))];
end
for i=1:length(sensory_ers)
    sensoryerschannel{i}=['C',num2str(sensory_ers(i))];
end
H={};

[b1,a1]=butter(2,[f1(1) f2(1)]/(fs/2));
[b2,a2]=butter(2,[f1(2) f2(2)]/(fs/2));

ecogC=close.data;
ecogO=open.data;

Chi1=find(ismember(close.channame,motorerschannel));

Chi2=find(ismember(close.channame,motorchannel));

for i=1:size(ecogC,3)
    ecogC1(:,:,i)=filter_symmetric(b1,a1,ecogC(:,:,i),[],0,'iir');
    ecogC2(:,:,i)=filter_symmetric(b2,a2,ecogC(:,:,i),[],0,'iir');
end
for i=1:size(ecogO,3)
    ecogO1(:,:,i)=filter_symmetric(b1,a1,ecogO(:,:,i),[],0,'iir');
    ecogO2(:,:,i)=filter_symmetric(b2,a2,ecogO(:,:,i),[],0,'iir');
end
%%
%**************************************************************************
total=size(ecogC,1);
tr=len/2:step:total;
erM1=zeros(25,length(tr));
erM2=zeros(25,length(tr));


figure(fig)
for s=1:25
    fprintf('Session%d:\n',s);
    tm=1;
    for i=1:length(tr)
        t=tr(i);
        fprintf('Processing Segment:%dms\n',(t-onset)*1000/fs);
        dS=max(t-len,1):t;
        
        do1=ecogO1(dS,:,:);
        dc1=ecogC1(dS,:,:);
        
        do2=ecogO2(dS,:,:);
        dc2=ecogC2(dS,:,:);
        
        %     dc=normalize_(dc,1);
        %     do=normalize_(do,1);
        NCh=size(do1,2);
        
        dch1=zeros(size(dc1,1),NCh,size(dc1,3));
        doh1=zeros(size(do1,1),NCh,size(do1,3));
        
        dch2=zeros(size(dc2,1),NCh,size(dc2,3));
        doh2=zeros(size(do2,1),NCh,size(do2,3));
        
        for k=1:NCh
            
            
            dch1(:,k,:)=reshape(abs(hilbert(squeeze(dc1(:,k,:)))),size(dc1,1),1,size(dc1,3));
            %             dch(:,:,k)=filtfilt(h,1,dch(:,:,k));
            
            doh1(:,k,:)=reshape(abs(hilbert(squeeze(do1(:,k,:)))),size(do1,1),1,size(do1,3));
            
            dch2(:,k,:)=reshape(abs(hilbert(squeeze(dc2(:,k,:)))),size(dc2,1),1,size(dc2,3));
            %             dch(:,:,k)=filtfilt(h,1,dch(:,:,k));
            
            doh2(:,k,:)=reshape(abs(hilbert(squeeze(do2(:,k,:)))),size(do2,1),1,size(do2,3));
            %             doh(:,:,k)=filtfilt(h,1,doh(:,:,k));
        end
        
        Nf=2; % Nmber of CSP vectors
        K=5;
        eR=zeros(K,1);
        CVc = cvpartition(size(dc1,3),'Kfold',K);
        CVo = cvpartition(size(do1,3),'Kfold',K);
        
        for n=1:K
            TrCI=CVc.training(n);
            TrOI=CVo.training(n);
            
            TsCI=CVc.test(n);
            TsOI=CVo.test(n);
            
            
            
            trC=10*log10(squeeze(sum(sum(dc1(:,Chi1,TrCI).^2,1),2)));
            trO=10*log10(squeeze(sum(sum(do1(:,Chi1,TrOI).^2,1),2)));
            
            trC1=10*log10(squeeze(sum(sum(dc2(:,Chi1,TrCI).^2,1),2)));
            trO1=10*log10(squeeze(sum(sum(do2(:,Chi1,TrOI).^2,1),2)));
            
            tsC=10*log10(squeeze(sum(sum(dc1(:,Chi1,TsCI).^2,1),2)));
            tsO=10*log10(squeeze(sum(sum(do1(:,Chi1,TsOI).^2,1),2)));
            
            tsC1=10*log10(squeeze(sum(sum(dc2(:,Chi1,TsCI).^2,1),2)));
            tsO1=10*log10(squeeze(sum(sum(do2(:,Chi1,TsOI).^2,1),2)));
            
                    
            [W,Lmb,P]=csp_weights(dc1(:,:,TrCI),do1(:,:,TrOI),Chi2,1);
            [trC3,trO3,tsC3,tsO3]=CSPFeatures(dc1(:,Chi2,TrCI), do1(:,Chi2,TrOI), dc1(:,Chi2,TsCI), do1(:,Chi2,TsOI), Nf, W);
            
            [W,Lmb,P]=csp_weights(dch2(:,:,TrCI),doh2(:,:,TrOI),Chi2,1);
            [trC4,trO4,tsC4,tsO4]=CSPFeatures(dch2(:,Chi2,TrCI), doh2(:,Chi2,TrOI), dch2(:,Chi2,TsCI), doh2(:,Chi2,TsOI), Nf, W);
            
            %    figure(2);
            %         clf
            %                 plot(tsO(:,1),tsO(:,4),'kd');
            %                 hold on;
            %                 plot(tsC(:,1),tsC(:,4),'ko');
            %                 %
            %                 plot(trO(:,1),trO(:,4),'rd');
            %                 hold on;
            %                 plot(trC(:,1),trC(:,4),'ro');
            %                 %         xlim([-5 1]);
            %                 %         ylim([-3 3]);
            %                 pause(.001);
            %                 hold off;
            
            %RAW LFB
            [w1,th1]=ldaweights([trC,trC1],[trO,trO1]);
            
            [w5,th5]=ldaweights([trC3,trC4],[trO3,trO4]);
            
            [cC1,dist]=LdaClassify(w1,th1,[tsC,tsC1]);
            [cO1,dist]=LdaClassify(w1,th1,[tsO,tsO1]);
            
            
            [cC2,dist]=LdaClassify(w5,th5,[tsC3,tsC4]);
            [cO2,dist]=LdaClassify(w5,th5,[tsO3,tsO4]);
            
            
            eR1(n)=(sum(cC1==1)+sum(cO1==-1))/(length(cC1)+length(cO1))*100;
            
            eR2(n)=(sum(cC2==1)+sum(cO2==-1))/(length(cC2)+length(cO2))*100;
        end
        erM1(s,i)=mean(eR1);
        erM2(s,i)=mean(eR2);

        %         plot(eR,'o-');
        %         title(mean(eR));
    end
end

transparent=1;
time=(tr-onset)*1000/fs;

mean_er=mean(erM1,1);
std_er=std(erM1);

H=cat(1,H,shadedErrorBar(time,mean_er,std_er,col{1},transparent));
hold on

mean_er=mean(erM2,1);
std_er=std(erM2);

H=cat(1,H,shadedErrorBar(time,mean_er,std_er,col{2},transparent));
hold on


%         stat(env*2+fi).onset=[mean_er(time==0),std_er(time==0)];
%         [min_er,min_er_ind]=min(mean_er);
%         stat(env*2+fi).min=[min_er,std_er(min_er_ind),time(min_er_ind)];
%         exp{env*2+fi}=['color: ',col{env*2+fi},' env ',num2str(env),' freq ',num2str(fi)];


set(gca,'fontsize',20)
set(gcf,'color','white')
set(findobj(gcf,'type','text'),'fontweight','bold')
ylabel('Error Rate(%)')
grid on
axis tight
plot([0,0],[0,100],':k','linewidth',3)
xl=get(gca,'xlim');
hold on
plot(xl,[50,50],'--k','linewidth',3)

ylim([0,100])
xlabel('Time (ms)');
ylabel('Error Rate(%)');
xlim([-500,1500])
text(20,95,'Onset','FontSize',18)

legend([H{1}.mainLine,H{2}.mainLine],'LFB+HFB Energy','LFB Raw + HFB Env CSP');
set([H{1}.mainLine,H{2}.mainLine],'linewidth',2)   
title('S2 Motor')
legend('boxoff')

