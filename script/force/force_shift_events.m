filename = '/Users/tengi/Desktop/Projects/data/China/force/S2/events/force.txt';
fileID = fopen(filename);
C = textscan(fileID,'%s%s%s%s',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);
%%

fid = fopen('/Users/tengi/Desktop/Projects/data/China/force/S2/events/force_shift.txt','w');
for i = 1:length(C{1})
    if ismember(C{2}{i}, {'Squeeze', 'Squeeze Noise', 'Relax', 'Relax Noise'})
        t = str2double(C{1}{i})-0.2;
    else
        t = str2double(C{1}{i});
    end
    fprintf(fid,'%f,%s\n',t,C{2}{i});
end
fclose(fid);