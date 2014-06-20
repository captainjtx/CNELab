clc
clear
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%average the whole channels
channels={'C17'};

neuroSeg=load('neuroSeg.mat');
behvSeg=load('behvSeg.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs=neuroSeg.samplefreq;
montage=neuroSeg.montage;
channelnames=montage.channelnames;
channelindex=montage.channelindex;

movements=neuroSeg.movements;
refNum=20;

wd=200;
ov=180;
lc=1;
hc=200;

Alpha=[8 16];
Beta=[16 32];
Gamma=[32 200];


if isempty(channels)
    channels=channelnames;
end

%movements
for m=1:length(movements)
    aveTFMap=0;
    for i=1:length(channelindex)
        if ismember(channelnames{i},channels)
            [tf,f,t]=bmi_tfmap(squeeze(neuroSeg.(movements{m})(:,i,:)),fs,wd,ov,lc,hc);
            rf=mean(tf(:,1:refNum),2);
            relativeTFMap=tf./repmat(rf+0.01,1,size(tf,2));
            aveTFMap=aveTFMap+relativeTFMap;
        end
    end
    aveTFMap=aveTFMap/length(channels);
    
    subBandMap=zeros(3,length(t));
    for i=1:length(t)
        for j=1:length(f)
            if (f(j)>=Alpha(1))&&(f(j)<Alpha(2))
                subBandMap(1,i)=subBandMap(1,i)+aveTFMap(j,i);
            elseif (f(j)>=Beta(1))&&(f(j)<Beta(2))
                subBandMap(2,i)=subBandMap(2,i)+aveTFMap(j,i);
            elseif (f(j)>=Gamma(1))&&(f(j)<Gamma(2))
                subBandMap(3,i)=subBandMap(3,i)+aveTFMap(j,i);
            end
        end
    end
    alpha.(movements{m})=subBandMap(1,:);
    beta.(movements{m})=subBandMap(2,:);
    gama.(movements{m})=subBandMap(3,:);
    
    aveBehv.(movements{m})=mean(behvSeg.(movements{m}),3);
    
end
t=t-2;
subplot(4,1,1)
plot(t,alpha.Close,'r',t,alpha.Open,'b');
title('Alpha band')
legend('Close','Open');

subplot(4,1,2)
plot(t,beta.Close,'r',t,beta.Open,'b');
title('Beta band')
legend('Close','Open');

subplot(4,1,3)
plot(t,gama.Close,'r',t,gama.Open,'b');
title('Gama band')
legend('Close','Open')
subplot(4,1,4)

stamp=linspace(-2,2,size(aveBehv.Close,1));
stamp=reshape(stamp,length(stamp),1);
plot(repmat(stamp(1:end-1),1,size(aveBehv.Close,2)),abs(diff(aveBehv.Close,1,1)),'r');
hold on
plot(repmat(stamp(1:end-1),1,size(aveBehv.Open,2)),abs(diff(aveBehv.Open,1,1)),'b');

title('absolute velocity')
xlabel('time (s)')

%K-Fold Cross Validation
K=10;

for i=1:length(channelnames)
    if ismember(channelnames{i},channels)
        CloseChannelSeg=squeeze(neuroSeg.Close(:,i,:));
        
        N=size(CloseChannelSeg,2);
        CloseIndices=crossvalind('Kfold',N,K);
        
        OpenChannelSeg=squeeze(neuroSeg.Open(:,i,:));
        N=size(OpenChannelSeg,2);
        OpenIndices=crossvalind('Kfold',N,K);
        
        CloseTest=0;
        CloseTraining=0;
        
        errorPMat=zeros(2,2);
        for j=1:K
            testIndices=find(CloseIndices==j);
            trainIndices=find(CloseIndices~=j);
            
            CloseTest=CloseChannelSeg(:,testIndices);
            CloseTrain=CloseChannelSeg(:,trainIndices);
            
            CloseTestGroup=zeros(size(CloseTest,2),1);
            CloseTrainGroup=zeros(size(CloseTrain,2),1);
            
            testIndices=find(OpenIndices==j);
            trainIndices=find(OpenIndices~=j);
            
            OpenTest=OpenChannelSeg(:,testIndices);
            OpenTrain=OpenChannelSeg(:,trainIndices);
            
            OpenTestGroup=ones(size(OpenTest,2),1);
            OpenTrainGroup=ones(size(OpenTrain,2),1);
            
            
            
            Test=cat(2,CloseTest,OpenTest);
            TestGroup=cat(1,CloseTestGroup,OpenTestGroup);
            
            Train=cat(2,CloseTrain,OpenTrain);
            TrainGroup=cat(1,CloseTrainGroup,OpenTrainGroup);
            
            
            gammaBandTestMap=zeros(size(Test,2),1);
            gammaBandTrainMap=zeros(size(Train,2),1);
            
            for num=1:size(Test,2)
                [TestMap,f,t]=bmi_tfmap(Test(:,num),fs,wd,ov,lc,hc);
                for k=1:length(t)
                    for n=1:length(f)
                        if (f(n)>=Gamma(1))&&(f(n)<Gamma(2))
                            gammaBandTestMap(num,1)=gammaBandTestMap(num,1)+TestMap(n,k);
                        end
                    end
                end
            end
            
            for num=1:size(Train,2)
                [TrainMap,f,t]=bmi_tfmap(Train(:,num),fs,wd,ov,lc,hc);
                for k=1:length(t)
                    for n=1:length(f)
                        if (f(n)>=Gamma(1))&&(f(n)<Gamma(2))
                            gammaBandTrainMap(num,1)=gammaBandTrainMap(num,1)+TrainMap(n,k);
                        end
                    end
                end
            end
            TestFeature=zeros(size(gammaBandTestMap,1),4);
            TrainFeature=zeros(size(gammaBandTrainMap,1),4);
            
            
            onset=round(size(gammaBandTestMap,2)/2);
            TestFeature(:,1)=gammaBandTestMap(:,onset);
            TrainFeature(:,1)=gammaBandTrainMap(:,onset);
            
            TestFeature(:,1)=max(gammaBandTestMap,[],2);
            TrainFeature(:,1)=max(gammaBandTrainMap,[],2);
            
            TestFeature(:,2)=mean(gammaBandTestMap,2);
            TrainFeature(:,2)=mean(gammaBandTrainMap,2);
            
            TestFeature(:,3)=std(gammaBandTestMap,1,2);
            TrainFeature(:,3)=std(gammaBandTrainMap,1,2);
            
            TestFeature(:,4)=sum(gammaBandTestMap,2);
            TrainFeature(:,4)=sum(gammaBandTrainMap,2);
            
            svmstruct=svmtrain(TrainFeature,TrainGroup);
            Group = svmclassify(svmstruct,TestFeature);
            
            
            
            errorMat=zeros(2,2);
            for test=1:length(TestGroup)
                    if TestGroup(test)==0&&Group(test)==0
                        errorMat(1,1)=errorMat(1,1)+1;
                    elseif TestGroup(test)==0&&Group(test)==1
                        errorMat(1,2)=errorMat(1,2)+1;
                    elseif TestGroup(test)==1&&Group(test)==0;
                        errorMat(2,1)=errorMat(2,1)+1;
                    elseif TestGroup(test)==1&&Group(test)==1;
                        errorMat(2,2)=errorMat(2,2)+1;
                    end
            end
            errorMat(1,:)=errorMat(1,:)/sum(TestGroup==0);
            errorMat(2,:)=errorMat(2,:)/sum(TestGroup==1);

            errorPMat=errorPMat+errorMat;
        end
        
        errorPMat=errorPMat/K;
        
    end
end

disp(errorPMat);




