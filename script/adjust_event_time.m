filename='Functional_Mapping.txt';
fileID = fopen(filename);
C = textscan(fileID,'%f%s',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);
%%
filename='Functional_Mapping.txt';
fileID = fopen(filename,'w');

for i=1:length(C{1})
    if ~isempty(C{2}{i})
        fprintf(fileID,'%f,%s\n',max(0,C{1}(i)-3926.586667),C{2}{i});
    end
end

fclose(fileID);