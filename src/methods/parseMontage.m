function [montage_channames,mat,group_name]=parseMontage(montage,channames)
%For example:
%ECG_L-ECG_R
%Note: + - * is reserved for montage expression
%mat is a row-wise projection matrix


if ~isfield(montage,'name')
    msgbox('No name field in montage!','parseMontage','error');
    return
end

chanNum=length(channames);
montage_channames=cell(length(montage.name),1);
mat=zeros(length(montage.name),chanNum);
group_name=cell(length(montage.name),1);

if isfield(montage,'exp')
    for i=1:length(montage.exp)
        mat(i,:)=parseMontageExpStr(montage.exp{i},channames);
    end
elseif isfield(montage,'mat')
    mat=montage.mat';
end

if isfield(montage,'group')
    group_name=montage.group;
else
    group_name=cell(length(montage.name),1);
    group_name(:)={'EEG'};
end

if isfield(montage,'name')
    montage_channames=montage.name;
end


