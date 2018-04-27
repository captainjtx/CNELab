clc
%x = zeros(1000,1);
uR=udp('127.0.0.1','LocalPort',21555);
uW=udp('127.0.0.1','RemotePort',21555);
fopen(uR)
fopen(uW)
tic
for i=1:1000
    fwrite(uW,num2str(i))
    data=fread(uR);
   % x(i) = data;
end
toc
fclose(uR);
fclose(uW);
