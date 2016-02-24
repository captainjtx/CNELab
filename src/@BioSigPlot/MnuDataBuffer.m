function MnuDataBuffer(obj,src)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
prompt={'File I/O buffer (MB): '};

data_buffer=zeros(length(obj.Data),1);

for i=1:length(data_buffer)
    data_buffer(i)=obj.BufferLength*obj.SRate*size(obj.Data{i},2)*8/1000/1000;
end
data_buffer=max(data_buffer);
def={num2str(data_buffer)};

title='Buffer Size';
answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end
    
tmp=str2double(answer{1});
if isempty(tmp)||isnan(tmp)
    %     buffer_len=obj.BufferLen;
else
    buffer_len=zeros(length(obj.Data),1);
    
    for i=1:length(buffer_len)
        buffer_len(i)=min(round(tmp*1000*1000/8/size(obj.Data{i},2)/obj.SRate),obj.TotalTime);
    end
    buffer_len=min(buffer_len);
    
    obj.BufferLength=buffer_len;
    
    %need to reload data buffer
    t_start=max(0,obj.Time_-obj.BufferLength/10);
    obj.BufferTime=min(t_start,obj.TotalTime);
    
    for i=1:length(obj.CDS)
        [obj.Data{i},eof]=obj.CDS{i}.get_data_by_start_end...
            (obj.CDS{i},obj.BufferStartSample,obj.BufferEndSample);
    end
    recalculate(obj);
    
    redrawChangeBlock(obj,'time');
end

end

