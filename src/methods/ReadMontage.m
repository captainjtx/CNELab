function mtg=ReadMontage(filename)
%Montage file formats:
%NewName,Statements,GroupName
fileID = fopen(filename);
C = textscan(fileID,'%s%s%s',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);

if any(isempty(C{2}))||any(isempty(C{1}))
    mtg=[];
    return
else
    mtg.name=C{1};
    mtg.exp=C{2};
end

mtg.group=C{3};

for i=1:length(C{3})
    if isempty(C{3}{i})
        mtg.group{i}='EEG';
    end
end

end

