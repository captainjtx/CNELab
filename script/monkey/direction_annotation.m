% generate direction annotation
info = load('H564_VCCW_s1_s2_112205_Info_Triggers.mat');
%%
fid = fopen('event/dir.txt','w');
for i = 1:length(info.direc)
    fprintf(fid, '%f, B-%d\n', info.cTrig(1,i)/1000, info.direc(i));
    fprintf(fid, '%f, C-%d\n', info.cTrig(2,i)/1000, info.direc(i));
    fprintf(fid, '%f, G-%d\n', info.cTrig(3,i)/1000, info.direc(i));
    fprintf(fid, '%f, M-%d\n', info.cTrig(4,i)/1000, info.direc(i));
    fprintf(fid, '%f, T-%d\n', info.cTrig(5,i)/1000, info.direc(i));
    fprintf(fid, '%f, E-%d\n', info.cTrig(6,i)/1000, info.direc(i));
end
fclose(fid);