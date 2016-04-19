function SaveElectrode(obj)

if strcmpi(obj.SelectEvt.category,'Electrode')&&obj.SelectEvt.level==2
    electrode=obj.mapObj(char(obj.SelectEvt.getKey()));
    
    [FileName,FilePath,FilterIndex]=uiputfile({'*.mat','Matlab Mat File (*.mat)'}...
        ,'save your electrode',electrode.file);
    
    if FileName~=0
        mapval.category='Electrode';
        mapval.file=fullfile(FilePath,FileName);
        mapval.coor=electrode.coor;
        mapval.radius=electrode.radius;
        mapval.thickness=electrode.thickness;
        mapval.color=electrode.color;
        mapval.norm=electrode.norm;
        mapval.channame=electrode.channame;
        
        save(fullfile(FilePath,FileName),'-struct','mapval');
    end
end

end

