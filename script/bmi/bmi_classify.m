%CSP test
clc
clear
fname1='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/Close.mat';
fname2='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/Open.mat';

% fname1='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/Close.mat';
% fname2='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/Open.mat';

% fname1='/Users/tengi/Desktop/Projects/data/BMI/abduction/lima/Abd.mat';
% fname2='/Users/tengi/Desktop/Projects/data/BMI/abduction/lima/Add.mat';

movements={'Close','Open'};
% movements={'Abd','Add'};

segments{1}=load(fname1);
segments{2}=load(fname2);

fs=segments{1}.(movements{1}).fs;
channelnames=segments{1}.(movements{1}).channame;

for i=1:length(channelnames)
    t=channelnames{i};
    channelindex(i)=str2double(t(2:end));
end

stats={};

fig=figure();

f1=[8,60];
f2=[32,200];

exp={};

ms_before=segments{1}.(movements{1}).ms_before;

onset=round(fs*ms_before/1000);

% baseline_time=[0 1.7];
baseline_time=[0.6 1.3];
% baseline_time=[1.3,1.7];
baseline_sample=round(baseline_time(1)*fs+1):round(baseline_time(2)*fs);
move_time=[1.3 2];
% move_time=[1.7 2.5];
move_sample=round(move_time(1)*fs):round(move_time(2)*fs);

SpL=[1:6,8,10,12,16,20,30,40,60,80,100,length(channelnames)];

mov1_err_lfb=zeros(size(SpL));
mov1_err_hfb=zeros(size(SpL));
mov2_err_lfb=zeros(size(SpL));
mov2_err_hfb=zeros(size(SpL));

mov_err_lfb=zeros(size(SpL));
mov_err_hfb=zeros(size(SpL));

col={'b','r'};
for fi=1:length(f1)
    erM=[];
    [b,a]=butter(2,[f1(fi) f2(fi)]/(fs/2));
    data1=segments{1}.(movements{1}).data;
    data2=segments{2}.(movements{2}).data;
    for i=1:size(data1,3)
        data1(:,:,i)=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,data1(:,:,i),[],0,'iir');
    end
    for i=1:size(data2,3)
        data2(:,:,i)=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,data2(:,:,i),[],0,'iir');
    end
    for sp=1:length(SpL)
        %**************************************************************************
        
        for s=1:25
            fprintf('Session%d:\n',s);
            tm=1;
            
            dch=[];
            doh=[];
            
            Nf=2; % Nmber of CSP vectors
            K=5;
            eR=[];
            CV2 = cvpartition(size(data2,3),'Kfold',K);
            CV1 = cvpartition(size(data1,3),'Kfold',K);
            
            for n=1:K
                Tr2=CV2.training(n);
                Tr1=CV1.training(n);
                
                Ts2=CV2.test(n);
                Ts1=CV1.test(n);
                
                %move vs baseline
                X=data1(move_sample,:,:);
                Y=data2(move_sample,:,:);
                
                Cx=0;
                Cy=0;
                
                for t=1:length(Tr1)
                    ctmp=cov(X(:,:,t));
                    Cx=Cx+ctmp/trace(ctmp);
                end
                
                
                
                for t=1:length(Tr2)
                    ctmp=cov(Y(:,:,t));
                    Cy=Cy+ctmp/trace(ctmp);
                end
                
                
                Cx=Cx/length(Tr1);
                Cy=Cy/length(Tr2);
                
                
                [F1,Lmd]=recursive_eliminate(Cx,Cy,SpL(sp),Nf);
                
                [F2,Lmd]=recursive_eliminate(Cy,Cx,SpL(sp),Nf);
                
                [tr1,tr2,ts1,ts2]=CSPFeatures(X(:,:,Tr1), Y(:,:,Tr2), X(:,:,Ts1), Y(:,:,Ts2), Nf*2, [F1,F2]);
                
                [w,th]=ldaweights(tr1,tr2);
                [c1,dist]=LdaClassify(w,th,ts1);
                [c2,dist]=LdaClassify(w,th,ts2);
                eR(n)=(sum(c1==1)+sum(c2==-1))/(length(c1)+length(c2))*100;
            end
            erM(s,sp)=mean(eR);
        end
    end
    figure(fig)
    
    hold on
    transparent=1;
    mean_er=mean(erM,1);
    std_er=std(erM);
    
    shadedErrorBar(SpL,mean_er,std_er,col{fi},transparent);
    drawnow
end


set(gcf,'position',[100,100,600,400])
set(gca,'fontsize',20)
set(gcf,'color','white')
set(findobj(gcf,'type','text'),'fontweight','bold')

grid on
grid minor
axis tight
plot([SpL(1),SpL(end)],[50,50],':k','linewidth',3)

ylim([0,100])
xlabel('Sparsity');
ylabel('Error Rate(%)');

