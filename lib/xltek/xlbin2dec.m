function [decdata,sz] = xlbin2dec(strbin,nout)
% xlbin2dec(strbin,nout), nout =4 for integers
% 0xAABBCCDDbinaryDataHere, 0xAABBCCDD is the size of stream in binary data
sz = hex2dec(strbin(3:10));
% 
decdata = reshape(strbin(11:end),2,nout,[]);
decdata = reshape(decdata(:,end:-1:1,:),2*nout,[],1)';

