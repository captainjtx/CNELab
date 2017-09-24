fileID = fopen('464_Electrode_Positions.csv');
C = textscan(fileID,'%s%s%s',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);
%%

pos = cell(length(C{1}),4);
for i = 1:size(pos,1)
    pos{i,1} = C{1}{i};
    pos{i,2} = 9-str2double(C{3}{i});
    pos{i,3} = 9-str2double(C{2}{i});
    pos{i,4} = 0.3;
end
%%
cell2csv('464_Electrode_Positions_CNELab.csv',pos,',','a');