function mtg=ReadMontage(filename)
%Montage file formats:
%NewName,Statements,GroupName
fileID = fopen(filename);
C = textscan(fileID,'%s%s%s',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);

if any(isempty(C{1}))
    mtg=[];
    return
else
    mtg.name=C{1};
end

if length(C{2})==length(C{1})-1
    %to overcome not return at the last line
    C{2}=cat(1,C{2},{''});
end

if length(C{3})==length(C{1})-1
    %to overcome not return at the last line
    C{3}=cat(1,C{3},{''});
end
mtg.exp=C{2};
ind=cellfun(@isempty,C{2},'UniformOutput',true);
mtg.exp(ind)=mtg.name(ind);

    
mtg.group=C{3};
ind=cellfun(@isempty,C{3},'UniformOutput',true);
mtg.group(ind)={'EEG'};

end

