function LoadChannelPosition( obj )
%load channel position files

[FileName,FilePath,FilterIndex]=uigetfile({...
    '*.csv;''*.txt;*.pos;*.mat',...
    'Supported formats (*.csv;*.txt;*.pos;*.mat)';...
    '*.csv;*.txt;*.pos','Text File';...
    '*.mat','Montage Matlab Binary Format'},...
    'Select Channel Position Files',...
    obj.FileDir,...
    'MultiSelect','off');

if ~iscell(FileName)
    if ~FileName
        return
    end
end

tmp=obj.DisplayedData;
if length(obj.DisplayedData)>1
    prompt={'Input the data that you want to link with the channel postion file: '};
    
    def={num2str(obj.DisplayedData(1))};
    
    title='Position-Data Link';
    
    
    answer=inputdlg(prompt,title,1,def);
    
    if isempty(answer)
        return
    end
    
    tmp=str2double(answer{1});
    if isempty(tmp)||isnan(tmp)||any(tmp<0)||any(tmp>obj.DataNumber)
        tmp=obj.DisplayedData(1);
    end
    
end

[channelname,pos_x,pos_y,pos_z] = ReadPosition( fullfile(FilePath,FileName) );
OriginalChanNames=obj.Montage{tmp}(obj.MontageRef(tmp)).channames;

pos=cell(length(OriginalChanNames),1);

for i=1:length(pos)
    [Lia,Locb]=ismember(OriginalChanNames{i},channelname);
    
    if Lia
        pos{i}=[pos_x{Locb}, pos_y{Locb}];
    else
        pos{i}=[];
    end
end


obj.Montage{tmp}(obj.MontageRef(tmp)).chanpos=pos;

end