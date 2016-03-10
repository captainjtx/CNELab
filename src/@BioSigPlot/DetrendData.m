function  DetrendData(obj,src)
omitMask=true;
[data,~,dataset,channel,sample]=get_selected_data(obj,omitMask);

if src==obj.MenuDetrendConstant
    data=detrend(data,'constant');
elseif src==obj.MenuDetrendLinear
    data=detrend(data);
end

%**************************************************************************
bufferSample=obj.BufferStartSample:obj.BufferEndSample;
[buf_ind,~]=ismember(bufferSample,sample);
for i=1:size(data,2)
    obj.PreprocData{dataset(i)}(buf_ind,channel(i))=data(bufferSample(buf_ind)-sample(1)+1,i);
end

obj.redrawChangeBlock('time');
end

