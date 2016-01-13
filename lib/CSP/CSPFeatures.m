function [trR,trL,tstR,tstL] = CSPFeatures(TrainR, TrainL, ValidR, ValidL, NF, Wvec)
% calculates features for training and test data
% INPUT  :
% TrainR : train set R, # of samples X # of trials X # of channels
% TrainL : train set L
% ValidR : test set R
% ValidL : test set L
% NF     : # of features
% sp     : 1 - sparse CSP filters, 0 - traditional (non sparse) CSP filters
% SpL    : Sparsity Level (either via max eigenvalue or number of non zeros in the filters)
% OUTPUT   : # trials X # of features (in order) = log||W*X||2^2

% Calculating CSP Filters on the training data
% W = CSPFilters(TrainR,TrainL, NF, sp, SpL);

% Calculating features: training
[Ns,Nc,NtR] = size(TrainR); 
[Ns,Nc,NtL] = size(TrainL); 
[Ns,Nc,NsR] = size(ValidR); 
[Ns,Nc,NsL] = size(ValidL); 

trR = zeros(NtR,NF); % feature matrix for class R
trL = zeros(NtL,NF); % feature matrix for class L

% extract filters from W
W = zeros(Nc, NF); %
W(:,1:NF/2) = Wvec(:,1:NF/2);
W(:,end-(NF/2)+1:end) = Wvec(:,end-(NF/2)+1:end);

for i=1:NtR
    R  = squeeze(TrainR(:,:,i))*W;
    trR(i,:) = log(sum(R.^2));
end
for i=1:NtL
    L  = squeeze(TrainL(:,:,i))*W;
    trL(i,:) = log(sum(L.^2));
end

% Calculating features: test

tstR = zeros(NsR,NF); % feature matrix for class R
tstL = zeros(NsL,NF); % feature matrix for class L

for i=1:NsR
    R  = squeeze(ValidR(:,:,i))*W;
    tstR(i,:) = log(sum(R.^2));
end
for i=1:NsL
    L  = squeeze(ValidL(:,:,i))*W;
    tstL(i,:) = log(sum(L.^2));
end




