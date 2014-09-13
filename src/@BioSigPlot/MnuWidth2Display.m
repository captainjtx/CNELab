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

obj.WinLength=tmp;
end

