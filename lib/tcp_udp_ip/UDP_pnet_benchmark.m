%%
clc
clear all
close all

port=21557;
host='127.0.0.1';
udpR=pnet('udpsocket',port);
udpW=pnet('udpsocket',port);
tic
for i=1:1000
    pnet(udpW,'write',[1,2,3,4,5,600,7,8,9,10,12,10000]);
    pnet(udpW,'writepacket',host,port);   
    len=pnet(udpR,'readpacket',1000,'noblock');
    if len>0
        data=pnet(udpR,'read',6,'double','noblock');
    end
end

toc
pnet(udpR,'close');
pnet(udpW,'close');
