function MnuDisplayBuffer(obj,src)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
prompt={'Visualization buffer (MB): '};

def={num2str(obj.VisualBuffer)};

title='Buffer Size';
answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end
tmp=str2double(answer{1});
if isempty(tmp)||isnan(tmp)
    %     buffer_len=obj.BufferLen;
else
    tmp=max(tmp,1);
    obj.VisualBuffer=tmp;
end

%need to reload data buffer

redrawChangeBlock(obj,'time');

end

