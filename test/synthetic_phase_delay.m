N=10000;

fs=200;

s=zeros(N,4);
delay=0.6;

for i=1:N
    for j=1:4
        s(i,j)=10*sin(2*pi*i/fs-delay*j);
    end
end

ss=rand(N,16);
ss(:,6)=s(:,1);
ss(:,7)=s(:,2);
ss(:,11)=s(:,3);
ss(:,10)=s(:,4);

%%

cds=CommonDataStructure;
cds.fs=200;
cds.Data=ss;

chanpos=zeros(16,3);
for i=1:4
    for j=1:4
        chanpos((i-1)*4+j,:)=[j,i,0.2];
    end
end
cds.Montage.ChannelPosition=chanpos;

cds.save('synthetic_phasedelay.cds');