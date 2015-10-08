function ExportObjToWorkspace(obj)

prompt={'Assign a name:'};
title='Export Object';

def={'bsp'};
answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

assignin('base',answer{1},obj);

end

