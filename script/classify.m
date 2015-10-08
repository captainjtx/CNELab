subs={s2_trials};

for i_sub=1:length(subs)
    
    
    fig=figure('name',['S',num2str(i_sub)]);
    sub=subs{i_sub};
    
    fs=sub(1).fs;
    
    if i_sub==1
%         Chi=find(~ismember(sub(1).channame,{'C1','C27','C64','C75','C76','C100','Synch','ECG Bipolar','EMG Bipolar'}));
Chi=find(~ismember(sub(1).channame,{'Synch','ECG Bipolar','EMG Bipolar'}));
    else
        Chi=find(~ismember(sub(1).channame,{'Synch','ECG Bipolar','EMG Bipolar'}));
%         Chi=1:length(sub(1).channame);
    end
    
    len=800;%classification data length in ms
    
    step=50;%step in ms
    
    f1=[8,60];
    f2=[30,200];
    col={'g','k','r','b',};
    exp={};
    
    fir_h=fir1(32,.001,'low');
    
    len=round(len/1000*fs);
    step=round(step/1000*fs);
    
    ms_before=sub(1).ms_before;
    
    onset=round(fs*ms_before/1000);
    
    for fi=1:length(f1)
        [b,a]=butter(2,[f1(fi) f2(fi)]/(fs/2));
        ecogC=sub(1).data;
        ecogO=sub(2).data;
        for i=1:size(ecogC,3)
            ecogC(:,:,i)=filter_symmetric(b,a,ecogC(:,:,i),[],0,'iir');
        end
        for i=1:size(ecogO,3)
            ecogO(:,:,i)=filter_symmetric(b,a,ecogO(:,:,i),[],0,'iir');
        end
        ecogC=permute(ecogC,[1 3 2]);
        ecogO=permute(ecogO,[1 3 2]);
        for env=0:1
            %**************************************************************************
            
            erM=[];
            
            total=size(ecogC,1);
            tr=len/2:step:total;
            
            for s=1:50
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
                    
                    NCh=size(do,3);
                    
                    if env
                        for k=1:NCh
                            dch(:,:,k)=abs(hilbert(dc(:,:,k)));
                            %             dch(:,:,k)=filtfilt(h,1,dch(:,:,k));
                            
                            doh(:,:,k)=abs(hilbert(do(:,:,k)));
                            %             doh(:,:,k)=filtfilt(h,1,doh(:,:,k));
                        end
                    end
                    
                    
                    %Chi=[1:7,14:19,26:32,38:43,50,52,53];
                    
                    
                    % S1
                    %Chi=setdiff([1:7,14:19,26:32,38:43,50,52,53],[1 27 64 75
                    %76 100]);
                    
                    
                    % S2
                    %Chi= [17 27 37 38 39 49 50 51 52 61 62 63 71 72 73 83 84 85 95 96 97 98];
                    
                    Nf=2; % Nmber of CSP vectors
                    K=5;
                    r=1;
                    eR=[];
                    CVc = cvpartition(size(dc,2),'Kfold',K);
                    CVo = cvpartition(size(do,2),'Kfold',K);
                    
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
                        
                        [W,Lmb,P]=csp_weights(data_c(:,TrCI,:),data_o(:,TrOI,:),Chi,1);
                        [trC,trO,tsC,tsO]=CSPFeatures(data_c(:,TrCI,Chi), data_o(:,TrOI,Chi), data_c(:,TsCI,Chi), data_o(:,TsOI,Chi), Nf, W);
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
            shadedErrorBar((tr-onset)*1000/fs,mean(erM,1),std(erM),col{env*2+fi},transparent)
            exp{env*2+fi}=['color: ',col{env*2+fi},' env ',num2str(env),' freq ',num2str(fi)];
            drawnow
        end
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


