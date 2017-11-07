clear
clc

onset_mat = load('/Users/tengi/Desktop/Projects/data/China/force/S2/squeeze.mat','-mat');
offset_mat = load('/Users/tengi/Desktop/Projects/data/China/force/S2/relax.mat','-mat');
%%
onset = onset_mat.data;
offset = offset_mat.data;
fs = offset_mat.fs;

[b1, a1]=butter(2,[8, 32]/(fs/2));
[b2, a2] = butter(2, [60, 200]/(fs/2));

fonset = onset;
foffset = offset;

for i=1:size(fonset,3)
    fonset(:,:,i)=filter_symmetric(b2, a2, fonset(:,:,i),[],0,'iir');
end

for i=1:size(foffset,3)
    foffset(:,:,i)=filter_symmetric(b2, a2, foffset(:,:,i),[],0,'iir');
end
%%

X = fonset((onset_mat.ms_before/1000-0.15)*fs:(onset_mat.ms_before/1000+0.6)*fs, :, :); %squeeze
Y = foffset((offset_mat.ms_before/1000-0.15)*fs:(offset_mat.ms_before/1000+0.6)*fs, :, :); %relax
% Y = fonset(1:round(0.75*fs), :, :); %baseline

CHi = 1:size(X, 2);

Kfold = 5;
Chi = 1:size(X, 2);
remove_mean = 1;
Nf = 2; % Number of CSP vectors

sessions = 1;

for s=1:sessions
    CVx(s) = cvpartition(size(X,3),'Kfold' ,Kfold);
    CVy(s) = cvpartition(size(Y,3),'Kfold',Kfold);
end

erM=zeros(sessions,1);
for s = 1:sessions
    fprintf('Session%d:\n',s);
    eR=zeros(Kfold,1);
    for n = 1:Kfold
        TrX = CVx(s).training(n);
        TrY = CVy(s).training(n);
        TsX = CVx(s).test(n);
        TsY = CVy(s).test(n);
        
        [W, Lmb, P] = csp_weights(X(:, :, TrX), Y(:, :, TrY), Chi, remove_mean);
        
        [feature_X_train,feature_Y_train,feature_X_test,feature_Y_test]=...
        CSPFeatures(X(:,Chi,TrX), Y(:,Chi,TrY), X(:,Chi,TsX), Y(:,Chi,TsY), Nf, W);
    
        [w,th]=ldaweights(feature_X_train,feature_Y_train);
        [predictX, dist1]=LdaClassify(w,th,feature_X_test);
        [predictY, dist2]=LdaClassify(w,th,feature_Y_test);
        eR(n)=(sum(predictX==1)+sum(predictY==-1))/(length(predictX)+length(predictY))*100;
    end
    erM(s)=mean(eR);
end

