function  DetrendData(obj,src)
omitMask=true;
[data,~,dataset,channel,sample]=get_selected_data(obj,omitMask);

if src==obj.MenuDetrendConstant
    data=detrend(data,'constant');
elseif src==obj.MenuDetrendLinear
    data=detrend(data);
end

for i=1:size(data,2)
    obj.PreprocData{dataset(i)}(sample,channel(i))=data(:,i);
end

obj.redrawChangeBlock('time');


end

