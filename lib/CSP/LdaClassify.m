function [co,dist]=LdaClassify(w,th,x)
% function [co,dist]=LdaClassify(w,th,x)
% w is the projection vector
% th is the threshold for classification
% x= Input Pattern
% Where each column is a varible and each row is an observation
% See LdaWeights

X=x*w';
co=sign(X-th);
dist=X-th;