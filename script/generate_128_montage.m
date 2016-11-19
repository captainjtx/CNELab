fid=fopen('monopolar1.txt','w');

for i=1:128
    fprintf(fid,'C%d,%d,ECOG\n',i,i);
end
fclose(fid);