clc
clear

f=load('/Users/tengi/Desktop/Projects/data/China/abduction/S1/Abd.mat','-mat');
open=f.Abd;
f=load('/Users/tengi/Desktop/Projects/data/China/abduction/S1/Add.mat','-mat');
close=f.Add;
%%
fs=open.fs;
ms_before=open.ms_before;
onset=round(fs*ms_before/1000);

stats={};

fig=figure('name','S1','position',[100,100,600,450]);

len=800;%classification data length in ms

step=50;%step in ms

f1=[8,60];
f2=[32,200];

col={'g','k','r','b',};
exp={};

fir_h=fir1(32,.001,'low');

len=round(len/1000*fs);
step=round(step/1000*fs);

ave_m=zeros(114,30);

ave_m([1,12,13],1)=1/3;
ave_m([2,3,14,15],2)=1/4;
ave_m([4,5,16,17],3)=1/4;
ave_m([6,7,18,19],4)=1/4;
ave_m([8,9,20,21],5)=1/4;
ave_m([10,11,22,23],6)=1/4;
ave_m([24,25,35,36],7)=1/4;
ave_m([26,37,38],8)=1/3;
ave_m([27,28,39,40],9)=1/4;
ave_m([29,30,41,42],10)=1/4;
ave_m([31,32,43,44],11)=1/4;
ave_m([33,34,45,46],12)=1/4;
ave_m([47,48,59,60],13)=1/4;
ave_m([49,50,61],14)=1/3;
ave_m([51,52,62,63],15)=1/4;
ave_m([53,54,64,65],16)=1/4;
ave_m([55,56,66,67],17)=1/4;
ave_m([57,58,68,69],18)=1/4;
ave_m([70,71,80,81],19)=1/4;
ave_m([82,83],20)=1/2;
ave_m([72,73,84,85],21)=1/4;
ave_m([74,75,86,87],22)=1/4;
ave_m([76,77,88,89],23)=1/4;
ave_m([78,79,90,91],24)=1/4;
ave_m([92,93,103,104],25)=1/4;
ave_m([94,105,106],26)=1/3;
ave_m([95,96,107,108],27)=1/4;
ave_m([97,98,109,110],28)=1/4;
ave_m([99,100,111,112],29)=1/4;
ave_m([101,102,113,114],30)=1/4;

ave_m=zeros(119,30);
for i=1:6
    for j=1:5
        if i==1&&j==1
            ave_m(1,1)=1/3;
            ave_m(12,1)=1/3;
            ave_m(13,1)=1/3;
        else
            ave_m((j-1)*24+(i-1)*2,(j-1)*6+i)=1/4;
            ave_m((j-1)*24+(i-1)*2+1,(j-1)*6+i)=1/4;
            ave_m((j-1)*24+(i-1)*2+12,(j-1)*6+i)=1/4;
            ave_m((j-1)*24+(i-1)*2+13,(j-1)*6+i)=1/4;
        end
    end
end
%%
%S1
motor=[1:6,13:18,25:30,37:42,49:52,61:64,73:76,85:88,97:100,109:111];
sensory=setdiff(1:120,motor);
%%
%%
%S2
% sensory=[75,61,49,37,25,13,1];
% motor=setdiff(1:120,sensory);
%%
motorchannel=cell(length(motor),1);
sensorychannel=cell(length(sensory),1);

for i=1:length(motor)
    motorchannel{i}=['C',num2str(motor(i))];
end
for i=1:length(sensory)
    sensorychannel{i}=['C',num2str(sensory(i))];
end
H={};
for fi=1:length(f1)
    [b,a]=butter(2,[f1(fi) f2(fi)]/(fs/2));
    ecogC=close.data;
%     for i=1:size(close.data,3)
%         ecogC(:,:,i)=close.data(:,:,i)*ave_m;
%     end
    ecogO=open.data;
%     for i=1:size(open.data,3)
%         ecogO(:,:,i)=open.data(:,:,i)*ave_m;
%     end
    
    Chi=find(ismember(close.channame,sensorychannel));
%     Chi=1:30;
    
    for i=1:size(ecogC,3)
        ecogC(:,:,i)=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,ecogC(:,:,i),[],0,'iir');
    end
    for i=1:size(ecogO,3)
        ecogO(:,:,i)=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,ecogO(:,:,i),[],0,'iir');
    end
    
    for env=0:1
        %**************************************************************************
        total=size(ecogC,1);
        tr=len/2:step:total;
        erM=zeros(25,length(tr));
        for s=1:25
            fprintf('Session%d:\n',s);
            tm=1;
            for i=1:length(tr)
                t=tr(i);
                fprintf('Processing Segment:%dms\n',(t-onset)*1000/fs);
                dS=max(t-len,1):t;
                
                do=ecogO(dS,:,:);
                dc=ecogC(dS,:,:);
                
                %     dc=normalize_(dc,1);
                %     do=normalize_(do,1);
                NCh=size(do,2);
                
                dch=zeros(size(dc,1),NCh,size(dc,3));
                doh=zeros(size(do,1),NCh,size(do,3));
                
                if env
                    for k=1:NCh
                        dch(:,k,:)=reshape(abs(hilbert(squeeze(dc(:,k,:)))),size(dc,1),1,size(dc,3));
                        %             dch(:,:,k)=filtfilt(h,1,dch(:,:,k));
                        
                        doh(:,k,:)=reshape(abs(hilbert(squeeze(do(:,k,:)))),size(do,1),1,size(do,3));
                        %             doh(:,:,k)=filtfilt(h,1,doh(:,:,k));
                    end
                end
                
                Nf=2; % Nmber of CSP vectors
                K=5;
                eR=zeros(K,1);
                CVc = cvpartition(size(dc,3),'Kfold',K);
                CVo = cvpartition(size(do,3),'Kfold',K);
                
                for n=1:K
                    TrCI=CVc.training(n);
                    TrOI=CVo.training(n);
                    
                    TsCI=CVc.test(n);
                    TsOI=CVo.test(n);
                    
                    if env
                        data_o=doh;
                        data_c=dch;
                    else
                        data_o=do;
                        data_c=dc;
                    end
                    
                    [W,Lmb,P]=csp_weights(data_c(:,:,TrCI),data_o(:,:,TrOI),Chi,1);
                    [trC,trO,tsC,tsO]=CSPFeatures(data_c(:,Chi,TrCI), data_o(:,Chi,TrOI), data_c(:,Chi,TsCI), data_o(:,Chi,TsOI), Nf, W);
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
                    
                    [w,th]=ldaweights(trC,trO);
                    [cC,dist]=LdaClassify(w,th,tsC);
                    [cO,dist]=LdaClassify(w,th,tsO);
                    eR(n)=(sum(cC==1)+sum(cO==-1))/(length(cC)+length(cO))*100;
                end
                erM(s,i)=mean(eR);
                %         plot(eR,'o-');
                %         title(mean(eR));
            end
        end
        figure(fig)
        
        hold on
        transparent=1;
        time=(tr-onset)*1000/fs;
        mean_er=mean(erM,1);
        std_er=std(erM);
        H=cat(1,H,shadedErrorBar(time,mean_er,std_er,col{env*2+fi},transparent));
        drawnow
        
%         stat(env*2+fi).onset=[mean_er(time==0),std_er(time==0)];
%         [min_er,min_er_ind]=min(mean_er);
%         stat(env*2+fi).min=[min_er,std_er(min_er_ind),time(min_er_ind)];      
%         exp{env*2+fi}=['color: ',col{env*2+fi},' env ',num2str(env),' freq ',num2str(fi)];
        
    end
end
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
xlim([-700,1500])
text(20,95,'Onset','FontSize',18)
%%
legend([H{1}.mainLine,H{2}.mainLine,H{3}.mainLine,H{4}.mainLine],'LFB Raw','LFB Env','HFB Raw','HFB Env');
set([H{1}.mainLine,H{2}.mainLine,H{3}.mainLine,H{4}.mainLine],'linewidth',2)   
title('S1 Sensory')
legend('boxoff')
set(gcf,'position',[  645   234   600   400]);

