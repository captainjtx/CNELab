function scanFilterBank(obj)
%This function scans the following folder:
%"db/filters"
%for customized filters


listing=dir('db/filters/*mat');
popStr=cell(1,1+length(listing));

popStr{1}='None';
for i=1:length(listing)
    [pathstr, name, ext] = fileparts(listing(i).name);
    obj.CustomFilters{i}=load(listing(i).name,'-mat');
    
    popStr{i+1}=[num2str(i),'-',name];
end

set(obj.PopFilter,'String',popStr);

end

