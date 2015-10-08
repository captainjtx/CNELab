fid=fopen('grid_12_10.txt','w');
for i=1:120
    row=ceil(i/12);
    col=i-(row-1)*12;
    fprintf(fid,'%s,%f,%f,%f\n',['C' num2str(121-i)],(col-1)*4,(row-1)*4,0.6);
end
fclose(fid);
