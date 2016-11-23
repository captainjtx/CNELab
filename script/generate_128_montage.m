fid=fopen('monopolar1.txt','w');

for i=1:128
    fprintf(fid,'C%d,%d,ECOG\n',i,i);
end
fclose(fid);
%%
fid=fopen('bipolar.txt','w');

for row=1:8
    for col=1:15
        ind=(row-1)*16+col;
        fprintf(fid,'%d-%d,%d-%d,ECOG\n',ind,ind+1,ind,ind+1);
    end
end
fclose(fid);