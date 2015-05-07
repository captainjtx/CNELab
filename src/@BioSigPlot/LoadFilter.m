function LoadFilter(obj)
[FileName,FilePath]=uigetfile({'*.mat','Matlab Mat File (*.mat)'},...
                                'select your events file',...
                                        obj.FileDir);
if FileName~=0
    for i=1:length(FileName)
        copyfile(fullfile(FilePath,FileName{i}),filefile(obj.FileDir,'db/filters',FileName{i}),'f');
    end
    scanFilterBank(obj);
end

end

