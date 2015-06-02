function LoadMontage(obj)

[FileName,FilePath,FilterIndex]=uigetfile({...
    '*.txt;*.csv;*.mtg;*.mat',...
    'Supported formats (*.csv;*.txt;*.mtg;*.mat)';...
    '*.csv;*.txt;*.mtg','Montage Txt File';...
    '*.mat','Montage Matlab Binary Format'},...
    'Select Montage Files',...
    obj.FileDir,...
    'MultiSelect','on');

if ~iscell(FileName)
    if ~FileName
        return
    else
        FileName={FileName};
    end
end

tmp=obj.DisplayedData;
if length(obj.DisplayedData)>1
    prompt={'Input the data that you want to link with the montage: '};
    
    def={num2str(obj.DisplayedData(1))};
    
    title='Montage-Data Link';
    
    
    answer=inputdlg(prompt,title,1,def);
    
    if isempty(answer)
        return
    end
    
    tmp=str2double(answer{1});
    if isempty(tmp)||isnan(tmp)||any(tmp<0)||any(tmp>obj.DataNumber)
        tmp=obj.DisplayedData(1);
    end
    
end

OriginalChanNames=obj.Montage{tmp}(obj.MontageRef(tmp)).channames;

montage=CommonDataStructure.scanMontageFile({OriginalChanNames},FilePath,FileName);

for i=1:length(montage)
    num=length(obj.Montage_{tmp});
    obj.Montage_{tmp}(num+1).name=montage{i}.name;
    obj.Montage_{tmp}(num+1).channames=montage{i}.channames;
    obj.Montage_{tmp}(num+1).mat=montage{i}.mat*obj.Montage_{tmp}(obj.MontageRef(tmp)).mat;
    obj.Montage_{tmp}(num+1).groupnames=montage{i}.groupnames;
end

remakeMontage(obj);

for i=1:length(tmp)
    ChangeMontage(obj,obj.MontageOptMenu{tmp(i)}(end),tmp(i),length(obj.Montage_{tmp(i)}));
end

end



