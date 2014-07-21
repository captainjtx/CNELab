function ImportDataSet(obj)
if isempty(obj.Data)
    choice='Replace';
else
    default='Replace';
    
    choice=questdlg('Do you want to replace or append the existed data?','warning',...
        'Replace','Append','Cancel',default);
end


switch choice
    case 'Replace'
        delete(obj);
        superviewer;
    case 'Append'
        
    case 'Cancel'
        return
end

end

