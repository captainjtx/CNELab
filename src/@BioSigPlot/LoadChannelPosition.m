function LoadChannelPosition( obj )
%load channel position files

if exist([obj.FileDir,'/position'],'dir')==7
    open_dir=[obj.FileDir,'/position'];
else
    open_dir=obj.FileDir;
end
[FileName,FilePath,FilterIndex]=uigetfile({...
    '*.csv;*.txt;*.pos;*.mat',...
    'Supported formats (*.csv;*.txt;*.pos;*.mat)';...
    '*.csv;*.txt;*.pos','Text File';...
    '*.mat','Montage Matlab Binary Format'},...
    'Select Channel Position Files',...
    open_dir,...
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

[channelname,pos_x,pos_y,r] = ReadPosition( fullfile(FilePath,FileName) );
OriginalChanNames=obj.Montage{tmp}(obj.MontageRef(tmp)).channames;

pos=zeros(length(OriginalChanNames),3);

for i=1:length(pos)
    [Lia,Locb]=ismember(OriginalChanNames{i},channelname);
    
    if Lia
        pos(i,1:2)=[pos_x(Locb), pos_y(Locb)];
        if ~isempty(r)
            pos(i,3)=r(Locb);
        end
    else
        pos(i,:)=nan;
    end
end

obj.Montage_{tmp}(obj.MontageRef(tmp)).position=pos;

end
