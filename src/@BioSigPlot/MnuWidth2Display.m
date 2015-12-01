function MnuWidth2Display(obj)
%**************************************************************************
% Dialog box of page time to display
%**************************************************************************
prompt={'Window time length(s)'};
def={num2str(obj.WinLength)};

title='Set window time length';


answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

tmp=str2double(answer{1});
if isempty(tmp)||isnan(tmp)
    tmp=obj.WinLength;
end

if (tmp+obj.Time)>(obj.BufferTime+obj.BufferLength)
    obj.BufferLength=tmp*2;
    %need to reload data buffer
    obj.BufferTime=min(max(0,obj.Time_-obj.BufferLength/10),obj.TotalTime);
    
    for i=1:length(obj.CDS)
        obj.Data{i}=obj.CDS{i}.get_data_by_start_end(obj.CDS{i},obj.BufferStartSample,obj.BufferEndSample);
    end
    recalculate(obj);
end

obj.WinLength=tmp;
end

