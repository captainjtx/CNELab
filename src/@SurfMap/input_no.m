function answer=input_no(varargin)
prompt = {'Enter point numbers:'};
dlg_title = 'Creat Point Set';
defaultans = {'16'};
answer = inputdlg(prompt,dlg_title,1,defaultans);
end