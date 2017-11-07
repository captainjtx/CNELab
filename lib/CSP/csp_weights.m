function [W,Lmd,CSP,cx,cy]=csp_weights(X,Y,CHi,mode,varargin)
% function W=CSP_Weights(X,Y,CHi,mode)
% Computes the Common SPatial Pattern Weights for the data given
% in X and Y having a structure (NxTRxCH)
% CHi holds the indices of channels to use.
% as implemented in
% IEEE TRANSACTIONS ON REHABILITATION ENGINEERING, VOL.8, NO. 4, DECEMBER 2000
% Optimal Spatial Filtering of Single Trial EEG During  Imagined Hand Movement
% Herbert Ramoser, Johannes Müller-Gerking, and Gert Pfurtscheller
% Use the inverse of W' to visualize the CSP patterns
% mode=> 0= mean removed, 1=mean not removed.

if nargin <4
    mode=0;
end

TrX=size(X,3);
TrY=size(Y,3);
Nx=size(X,1);
Ny=size(Y,1);
Nch=length(CHi);
cx=zeros(Nch,Nch);
cy=zeros(Nch,Nch);

if nargin <= 4
    X_trial_weight = ones(TrX, 1)/TrX;
    Y_trial_weight = ones(TrY, 1)/TrY;
elseif size(varargin) == 1
    X_trial_weight = varargin{1};
    Y_trial_weight = varargin{1};
elseif size(varargin) == 2
    X_trial_weight = varargin{1};
    Y_trial_weight = varargin{2};
end

for i=1:TrX
    x=X(:,CHi,i);
    x=reshape(x,Nx,Nch);
    if mode
        cv=x'*x;   
    else
        cv=cov(x);
    end
    cx=cx+cv/trace(cv)*X_trial_weight(i);
end

for i=1:TrY
    y=Y(:,CHi,i);
    y=reshape(y,Ny,Nch);
    if mode
        cv=y'*y;   
    else
        cv=cov(y);
    end
    cy=cy+cv/trace(cv)*Y_trial_weight(i);
end

cx=cx/TrX;
cy=cy/TrY;
%Cc=cx+cy;

% [U,D]=eig(Cc);
% P=inv(sqrt(D))*U';
% Sx=P*cx*P';
% [B,Lmd]=eig(Sx);
% [Lmd,ix]=sort(diag(Lmd));   %Sorts in descending order
% D=D(:,ix)'; 
% U=U(:,ix);
% B=B(:,ix);
% W=(B'*P)';        %Spatial Filters

[W,Lmd]=eig(cx,cy);
CSP=[];
% CSP=inv(W');    % Spatial Patterns

% Written by  Nuri F. Ince
% firat@umn.edu
% Updated 08.29.2008