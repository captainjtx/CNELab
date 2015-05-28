function mtg=ReadMontage(filename)

fileID = fopen(filename);
C = textscan(fileID,'%s%s%s',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);

if length(C)<2
    mtg=[];
    return
else
    mtg.name=C{1};
    mtg.exp=C{2};
end

if length(C)>2
    mtg.group=C{3};
end

end

