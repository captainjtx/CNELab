function [W,e,D]=pcaWeights(data,typ)
% [W,e]=pcaWeights(data,typ)
% Returns the Principal Component Eigenvectors (W) for projection
% The PCA Vectors are sorted from the largest to the smallest eigenvalue
% (e)
% Each column of data is a variable/feature and each row is an observation
% typ:1 Covarince MAtrix
%     2 Energy Matrix

[m,n]=size(data);
if nargin<2
    typ=1;  %
end
if typ==1
    cv=cov(data);
elseif typ==2
    cv=data'*data;
else
    fprintf('Use 1 for Correlation or two for Covariance matrix computation');
end
[ev,D]=eig(cv);
e=diag(D);  % Get the Eigenvalues

[e,indx]=sort(e);   % Sorts in ascending order
le=length(indx);
e=e(indx(le:-1:1));


W=zeros(n,le);
k=1;

for i=le:-1:1
    W(:,k)=ev(:,indx(i));
    D(k,k)=e(k);
    k=k+1;
end



% Developed by N.Firat INCE
% e-mail: ince_firat@yahoo.com