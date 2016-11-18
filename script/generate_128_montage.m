fid=fopen('monopolar.txt','w');

for i=1:128
    fprintf(fid,'C%d,%d,ECOG\n',i,i+1);
end
fclose(fid);