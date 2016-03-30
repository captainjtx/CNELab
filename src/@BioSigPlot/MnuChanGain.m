function MnuChanGain(obj,src)
%**************************************************************************
% Dialog box of channel gain
%**************************************************************************
prompt={'Channel gain'};
def={'1'};

title='Change the channel gain';


answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

tmp=str2double(answer{1});
if isempty(tmp)||isnan(tmp)
    tmp=1;
end

obj.Gain=obj.applyPanelVal(obj.Gain_,tmp);


end

