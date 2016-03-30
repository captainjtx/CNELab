function scanFilterBank(obj)
%This function scans the following folder:
%"db/filters"
%for customized filters


listing=dir([obj.CNELabDir,'/db/filters/*mat']);
popStr=cell(2+length(listing),1);

popStr{1}='Refresh';
popStr{2}='None';

obj.CustomFilters={};

for i=1:length(listing)
    [pathstr, name, ext] = fileparts(listing(i).name);
    obj.CustomFilters{i}=load(listing(i).name,'-mat');
    
    popStr{i+2}=[num2str(i),'-',name];
end

set(obj.PopFilter,'String',popStr);
set(obj.PopFilter,'Value',2);


end

