function SaveMontage(obj)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
omitMask=true;
[chanNames,dataset,~,~,~,groupnames]=get_selected_datainfo(obj,omitMask);
dd=unique(dataset);

if exist([obj.FileDir,'/montage'],'dir')~=7
    mkdir(obj.FileDir,'montage');
end
open_dir=[obj.FileDir,'/montage'];

[FileName,FilePath]=uiputfile({...
    '*.mtg;*.csv;*.txt','Common Data Structure Formats (*.mtg;*.csv;*.txt)';...
    '*.mtg','Montage Text File (*.mtg)';...
    '*.csv','Comma Separated File (*.csv)';...
    '*.txt','Text File (*.txt)'}...
    ,'Merged Montage File',fullfile(open_dir,obj.Montage{dd(1)}(obj.MontageRef(dd(1))).name));

if ~FileName
    return
end

fnames=fullfile(FilePath,FileName);
fid=fopen(fnames,'w');
fprintf(fid,'%s\n%s\n%s\n%s\n','%Rows commented by % will be ignored',...
    '%File needs to be comma(,) delimited',...
    '%File format: ChannelName,Channel Statement,GroupName',...
    '%{Groupname} is optional:'...
    );

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

