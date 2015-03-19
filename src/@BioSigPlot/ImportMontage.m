function ImportMontage(obj)

[FileName,FilePath,FilterIndex]=uigetfile({...
    '*.txt;*.csv;*.mtg;*.mat',...
    'Supported formats (*.csv;*.txt;*.mtg;*.mat)';...
    '*.csv;*.txt','Montage Txt File';...
    '*.mtg;*.mat','Montage Matlab Binary Format'},...
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

montage=cell(1,length(FileName));
for i=1:length(FileName)
    filename=fullfile(FilePath,FileName{i});
    switch FilterIndex
        case 1
            [pathstr, name, ext] = fileparts(FileName{i});
            if strcmpi(ext,'.txt')||strcmpi(ext,'.csv')
                montage{i}=ReadMontage(filename);
            elseif strcmpi(ext,'.mat')||strcmpi(ext,'.mtg')
                montage{i}=load(filename,'-mat');
            end
        case 2
            montage{i}=ReadMontage(filename);
        case 3
            montage{i}=load(filename,'-mat');
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
    
    tmp=str2num(answer{1});
    if isempty(tmp)||isnan(tmp)||any(tmp<0)||any(tmp>obj.DataNumber)
        tmp=obj.DisplayedData;
    end
    
end

for t=1:length(tmp)
    for i=1:length(montage)
        [pathstr, name, ext] = fileparts(FileName{i});
        
        [montage_channames,mat,groupnames]=parseMontage(montage{i},obj.ChanNames{tmp(t)});
        
        num=length(obj.Montage_{tmp(t)});
        obj.Montage_{tmp(t)}(num+1).name=name;
        obj.Montage_{tmp(t)}(num+1).channames=montage_channames;
        obj.Montage_{tmp(t)}(num+1).mat=mat;
        obj.Montage_{tmp(t)}(num+1).groupnames=groupnames;
        
    end
end

remakeMontage(obj);


for i=1:length(tmp)
    ChangeMontage(obj,obj.MontageOptMenu{tmp(i)}(end),tmp(i),length(obj.Montage_{tmp(i)}));
end

end



