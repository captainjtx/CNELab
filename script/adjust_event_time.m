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
        fprintf(fileID,'%f,%s\n',C{1}(i)-1896.761250,C{2}{i});
    end
end

fclose(fileID);