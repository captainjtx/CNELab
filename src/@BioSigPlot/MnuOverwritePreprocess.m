function  MnuOverwritePreprocess(obj)
h=questdlg('Overwrite the raw data with preprocessed data, are you sure to continue ?','Overwrite Preprocess',...
    'Yes','No','Yes');
switch h
    case 'Yes'
        obj.Data=obj.PreprocData;
    case 'No'
        return;
end
end

