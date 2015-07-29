function  SavePosition(obj)
% [data,chanNames,dataset,channel,sample,evts,groupnames,pos]=get_selected_data(obj);
% dd=unique(dataset);
% 
% 
% [FileName,FilePath]=uiputfile({...
%     '*.mtg;*.csv;*.txt','Common Data Structure Formats (*.mtg;*.csv;*.txt)';...
%     '*.mtg','Montage Text File (*.mtg)';...
%     '*.csv','Comma Separated File (*.csv)';...
%     '*.txt','Text File (*.txt)'}...
%     ,'Merged Montage File',fullfile(obj.FileDir,obj.Montage{dd(1)}(obj.MontageRef(dd(1))).name));
% 
% if ~FileName
%     return
% end
% 
% fnames=fullfile(FilePath,FileName);
% fid=fopen(fnames,'w');
% fprintf(fid,'%s\n%s\n%s\n%s\n','%Rows commented by % will be ignored',...
%     '%File needs to be comma(,) delimited',...
%     '%File format: ChannelName,Pos_X,Pos_Y,Pos_Z',...
%     '%{Pos_Z} is optional:'...
%     );
% 
% for i=1:length(chanNames)
%     fprintf(fid,'%s,%s,%s,%f\n',chanNames{i},chanNames{i},gname);
% end
% 
% fclose(fid);


end

