function ImportMontage(obj)
[FileName,FilePath,FilterIndex]=uigetfile({...
    '*.mtg;*.txt;*.mat',...
    'Supported formats (*.mtg;*.txt;*.mat)';...
    '*.mtg','Montage File';...
    '*.txt','Montage Txt File';...
    '*.mat','Montage Matlab Binary Format'},...
    'Select Montage Files',...
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
            if strcmpi(ext,'.txt')||strcmpi(ext,'.mtg')
                montage{i}=ReadYaml(filename);
            elseif strcmpi(ext,'.mat')
                montage{i}=load(filename,'-mat');
            end
        case 2
            montage{i}=ReadYaml(filename);
        case 3
            montage{i}=ReadYaml(filename);
        case 4
            montage{i}=load(filename,'-mat');
    end
end

tmp=1;
if length(obj.DataNumber)>1
    prompt={'Input the data that you want to link with the montage: '};
    
    def={num2str(obj.DisplayedData(1))};
    
    title='Montage-Data Link';
    
    
    answer=inputdlg(prompt,title,1,def);
    
    if isempty(answer)
        return
    end
    
    tmp=str2double(answer{1});
    if isempty(tmp)||isnan(tmp)||tmp<0||tmp>obj.DataNumber
        tmp=obj.DisplayedData(1);
    end
    
end

for i=1:length(montage)
    [pathstr, name, ext] = fileparts(FileName{i});
    
    [montage_channames,mat]=parseMontage(montage{i},obj.ChanNames{tmp});
    
    num=length(obj.Montage_{tmp});
    obj.Montage_{tmp}(num+1).name=name;
    obj.Montage_{tmp}(num+1).channames=montage_channames;
    obj.Montage_{tmp}(num+1).mat=mat;
    
end

remakeMontage(obj);

end



