clc
clear

f=load('/Users/tengi/Desktop/Projects/data/China/handopenclose/S1/Open.mat','-mat');
open=f.Open;
f=load('/Users/tengi/Desktop/Projects/data/China/handopenclose/S1/Close.mat','-mat');
close=f.Close;
%%
fs=open.fs;
ms_before=open.ms_before;
onset=round(fs*ms_before/1000);

stats={};

len=800;%classification data length in ms

step=50;%step in ms

f1=[8,60];
f2=[32,200];

color={'g','b','r',};
exp={};

fir_h=fir1(32,.001,'low');

len=round(len/1000*fs);
step=round(step/1000*fs);

%%
%S1
% motor=[1:6,13:18,25:30,37:42,49:52,61:64,73:76,85:88,97:100,109:111];
% sensory=setdiff(1:120,motor);
%%
%%
%S2
% sensory=[75,61,49,37,25,13,1];
% motor=setdiff(1:120,sensory);
% %%
% motorchannel=cell(length(motor),1);
% sensorychannel=cell(length(sensory),1);
%
% for i=1:length(motor)
%     motorchannel{i}=['C',num2str(motor(i))];
% end
% for i=1:length(sensory)
%     sensorychannel{i}=['C',num2str(sensory(i))];
% end
H={[],[]};
for fi=1:length(f1)
    fig(fi)=figure('name',[num2str(f1(fi)),'-',num2str(f2(fi))],'position',[100,100,600,450]);
end

for ave=0:1
    for fi=1:length(f1)
        [b,a]=butter(2,[f1(fi) f2(fi)]/(fs/2));
        ecogC=close.data;
        ecogO=open.data;
        
        Chi=1:length(close.channame);
        
        for i=1:size(ecogC,3)
            ecogC(:,:,i)=filter_symmetric(b,a,ecogC(:,:,i),[],0,'iir');
        end
        for i=1:size(ecogO,3)
            ecogO(:,:,i)=filter_symmetric(b,a,ecogO(:,:,i),[],0,'iir');
        end
        if ave
            tmpC=ecogC;
            tmpO=ecogO;
            
            ecogC=zeros(size(tmpC,1),30,size(tmpC,3));
            ecogO=zeros(size(tmpO,1),30,size(tmpO,3));
            ind=[];
            for c=1:size(ecogC,2)
                for t=1:size(ecogC,3)
                    col=mod(c,6);
                    if(~col)
                        col=6;
                    end
                    row=(c-col)/6+1;
                    
                    top_left=(row-1)*12*2+(col-1)*2+1;
                    top_right=top_left+1;
                    bottom_left=top_left+12;
                    bottom_right=bottom_left+1;
                    
                    count=0;
                    
                    [ia,ib]=ismember(['C',num2str(top_left)],close.channame);
                    if ia
                        count=count+1;
                        ecogC(:,c,t)=ecogC(:,c,t)+tmpC(:,ib,t);
                    end
                    
                    [ia,ib]=ismember(['C',num2str(top_right)],close.channame);
                    if ia
                        count=count+1;
                        ecogC(:,c,t)=ecogC(:,c,t)+tmpC(:,ib,t);
                    end
                    
                    [ia,ib]=ismember(['C',num2str(bottom_right)],close.channame);
                    if ia
                        count=count+1;
                        ecogC(:,c,t)=ecogC(:,c,t)+tmpC(:,ib,t);
                    end
                    
                    [ia,ib]=ismember(['C',num2str(bottom_left)],close.channame);
                    if ia
                        count=count+1;
                        ecogC(:,c,t)=ecogC(:,c,t)+tmpC(:,ib,t);
                    end
                    
                    if(count==0)
                       ind=cat(1,ind,c);
                    else 
                        ecogC(:,c,t)=ecogC(:,c,t)/count;
                    end
                end
            end
            for c=1:size(ecogO,2)
                for t=1:size(ecogO,3)
                    col=mod(c,6);
                    if(~col)
                        col=6;
                    end
                    row=(c-col)/6+1;
                    
                    top_left=(row-1)*12*2+(col-1)*2+1;
                    top_right=top_left+1;
                    bottom_left=top_left+12;
                    bottom_right=bottom_left+1;
                    
                    count=0;
                    
                    [ia,ib]=ismember(['C',num2str(top_left)],close.channame);
                    if ia
                        count=count+1;
                        ecogO(:,c,t)=ecogO(:,c,t)+tmpO(:,ib,t);
                    end
                    
                    [ia,ib]=ismember(['C',num2str(top_right)],close.channame);
                    if ia
                        count=count+1;
                        ecogO(:,c,t)=ecogO(:,c,t)+tmpO(:,ib,t);
                    end
                    
                    [ia,ib]=ismember(['C',num2str(bottom_right)],close.channame);
                    if ia
                        count=count+1;
                        ecogO(:,c,t)=ecogO(:,c,t)+tmpO(:,ib,t);
                    end
                    
                    [ia,ib]=ismember(['C',num2str(bottom_left)],close.channame);
                    if ia
                        count=count+1;
                        ecogO(:,c,t)=ecogO(:,c,t)+tmpO(:,ib,t);
                    end
                    
                    if(count~=0)
                        ecogO(:,c,t)=ecogO(:,c,t)/count;
                    end
                end
                
            end
            Chi=1:30;
            Chi(ind)=[];
        end
     
        for env=0
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
            
            figure(fig(fi));
            hold on
            transparent=1;
            time=(tr-onset)*1000/fs;
            mean_er=mean(erM,1);
            std_er=std(erM);
            H{fi}=cat(1,H{fi},shadedErrorBar(time,mean_er,std_er,color{ave+1},transparent));
            drawnow
            
            %         stat(env*2+fi).onset=[mean_er(time==0),std_er(time==0)];
            %         [min_er,min_er_ind]=min(mean_er);
            %         stat(env*2+fi).min=[min_er,std_er(min_er_ind),time(min_er_ind)];
            %         exp{env*2+fi}=['color: ',col{env*2+fi},' env ',num2str(env),' freq ',num2str(fi)];
            
        end
    end
end
for i=1:length(fig)
    figure(fig(i));
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
    legend([H{i}(1).mainLine,H{i}(2).mainLine],'High-density ECoG','Averaged ECoG');
    
end
set([H{1}.mainLine,H{2}.mainLine],'linewidth',2)
%%
%
%
%title('S2')
%legend('boxoff')

