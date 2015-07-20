function SaveMontage(obj)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[data,chanNames,dataset,channel,sample,evts,groupnames]=get_selected_data(obj);
dd=unique(dataset);


[FileName,FilePath]=uiputfile({...
    '*.mtg;*.csv;*.txt','Common Data Structure Formats (*.mtg;*.csv;*.txt)';...
    '*.mtg','Montage Text File (*.mtg)';...
    '*.csv','Comma Separated File (*.csv)';...
    '*.txt','Text File (*.txt)'}...
    ,'Merged Montage File',fullfile(obj.Montage{dd(1)}(obj.MontageRef(dd(1))).name));

if ~FileName
    return
end

fnames=fullfile(FilePath,FileName);
fid=fopen(fnames,'w');

for i=1:length(chanNames)
    if isempty(groupnames)
        gname='Default Group';
    else
        gname=groupnames{i};
    end
    fprintf(fid,'%s,%s,%s\n',chanNames{i},chanNames{i},gname);
end

fclose(fid);

end

