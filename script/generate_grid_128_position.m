fid=fopen('grid_16_8.txt','w');
for i=1:16
    for j=1:8
        ind=(j-1)*16+i;
        fprintf(fid,'%s,%f,%f,%f\c\n',['C' num2str(ind)],(i-1)*4,(j-1)*4,1);
    end
end
fclose(fid);