fid=fopen('grid_12_10.txt','w');
for i=1:120
    row=ceil(i/12);
    col=i-(row-1)*12;
    fprintf(fid,'%s,%f,%f,%f\r\n',['C' num2str(i)],(col-1)*4,(row-1)*4,0);
end
fclose(fid);

%% swapped
fid=fopen('bipolar_swapped.txt','w');
for i=1:120
    if mod(i, 12) == 0
        continue;
    end
    row=11-ceil(i/12);
    col=13-i+(10-row)*12;
    fprintf(fid,'%s,%f,%f,%f\r\n',[num2str(i) '-' num2str(i+1)],(col-1)*4,(row-1)*4,0.6);
end
fclose(fid);