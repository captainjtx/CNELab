%%
fid=fopen('grid_12_10.txt','w');
for i=1:120
    row=ceil(i/12);
    col=i-(row-1)*12;
    fprintf(fid,'%s,%f,%f,%f\n',['C' num2str(121-i)],(col-1)*4,(row-1)*4,0.6);
end
fclose(fid);
%%
fid=fopen('grid_hybrid.txt','w');
fprintf(fid,'%%First channel start at the top left corner.\n');
for i=1:64
    row=ceil(i/8);
    col=i-(row-1)*8;
    fprintf(fid,'%s,%f,%f,%f\n',['C' num2str(i),'_L'],(col-1)*10,(row-1)*10,2.7);
end

for i=1:49
    row=ceil(i/7);
    col=i-(row-1)*7;
    fprintf(fid,'%s,%f,%f,%f\n',['C' num2str(i),'_S'],(col-1)*10+5,(row-1)*10+5,1);
end

fclose(fid);