f=load('Z:\Tianxiao\data\BMI\handopenclose\S2/Open.mat','-mat');
open=f.Open;
f=load('Z:\Tianxiao\data\BMI\handopenclose\S2/Close.mat','-mat');
close=f.Close;
%%
fs=open.fs;
ms_before=open.ms_before;
onset=round(fs*ms_before/1000);

stats={};

fig=figure('name','S1');

len=800;%classification data length in ms

step=50;%step in ms

f1=[8,12];
f2=[12,32];
col={'g','k','r','b',};
exp={};

fir_h=fir1(32,.001,'low');

len=round(len/1000*fs);
step=round(step/1000*fs);

for fi=1:length(f1)
    [b,a]=butter(2,[f1(fi) f2(fi)]/(fs/2));
    ecogC=close.data;
    ecogO=open.data;
    
    Chi=1:size(ecogC,2);
    
    for i=1:size(ecogC,3)
        ecogC(:,:,i)=filter_symmetric(b,a,ecogC(:,:,i),[],0,'iir');
    end
    for i=1:size(ecogO,3)
        ecogO(:,:,i)=filter_symmetric(b,a,ecogO(:,:,i),[],0,'iir');
    end
    
    for env=0:1
        %**************************************************************************
        erM=[];
        
        total=size(ecogC,1);
        tr=len/2:step:total;
        
        for s=1:25
            fprintf('Session%d:\n',s);
            tm=1;
            for i=1:length(tr)
                t=tr(i);
                fprintf('Processing Segment:%dms\n',(t-onset)*1000/fs);
                dS=[max(t-len,1):t];
                
                do=ecogO(dS,:,:);
                dc=ecogC(dS,:,:);
                
                %     dc=normalize_(dc,1);
                %     do=normalize_(do,1);
                
                dch=[];
                doh=[];
                
                NCh=size(do,2);
                
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
                r=1;
                eR=[];
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
                    eR(r)=(sum(cC==1)+sum(cO==-1))/(length(cC)+length(cO))*100;
                    r=r+1;
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
        
        stat(env*2+fi).onset=[mean_er(time==0),std_er(time==0)];
        [min_er,min_er_ind]=min(mean_er);
        stat(env*2+fi).min=[min_er,std_er(min_er_ind),time(min_er_ind)];
        shadedErrorBar(time,mean_er,std_er,col{env*2+fi},transparent)
        exp{env*2+fi}=['color: ',col{env*2+fi},' env ',num2str(env),' freq ',num2str(fi)];
        drawnow
    end
end

set(gcf,'position',[100,100,600,400])
set(gca,'fontsize',20)
set(gcf,'color','white')
set(findobj(gcf,'type','text'),'fontweight','bold')
ylabel('Error Rate(%)')
grid on
grid minor
axis tight
plot([0,0],[0,100],':k','linewidth',3)
xl=get(gca,'xlim');
hold on
plot(xl,[50,50],'--k','linewidth',3)

ylim([0,100])
xlabel('Time (ms)');
ylabel('Error Rate(%)');

