function [w,th]=ldaweights(x,y)
%function [w th]=ldaweights(x,y)
% Calculates the Fisher Linear Discrimination weights
% x= Class 1 patterns 
% y= Class 2 patterns
% where each column is a varible and each row is an observation
% w is the projection vector
% th is the threshold for classification
% See LDAClassify

mx=mean(x);
my=mean(y);
cx=cov(x,1);
cy=cov(y,1);
cm=(0.5*cx+0.5*cy);
R=inv(cm);

w=(my-mx)*R;
w=w./sqrt(sum(w.^2));
X=x*w';
Y=y*w';
mx=mean(X);
my=mean(Y);
stdx=std(X);
stdy=std(Y);
%th=(mx*stdx+my*stdy)/[stdx+stdy];
th=(mx+my)/2;


% Firat INCE
% 06.06.2004
