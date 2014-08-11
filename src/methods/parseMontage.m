function [montage_channames,mat,group_name]=parseMontage(montage,channames)
%For example:
%ECG_L-ECG_R
%Note: + - * is reserved for montage expression
%mat is a row-wise projection matrix
chanNum=length(channames);

montage_channames=cell(length(montage),1);
mat=zeros(length(montage),chanNum);
group_name=cell(length(montage),1);
for i=1:length(montage)
    if isfield(montage{i},'name')
        montage_channames{i}=montage{i}.name;
    end
    
    if isfield(montage{i},'exp')
        mat(i,:)=parseMontageExpStr(montage{i}.exp,channames);
    elseif isfield(montage{i},'vector')
    end
    
    if isfield(montage{i},'group')
        group_name{i}=montage{i}.group;
    end
end

end

