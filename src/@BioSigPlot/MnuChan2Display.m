function MnuChan2Display(obj)
%**************************************************************************
% Dialog box to change number of channel to display
%**************************************************************************
prompt=cell(1,obj.DataNumber);
def=cell(1,obj.DataNumber);

for i=1:obj.DataNumber
    prompt{i}=['Data ' num2str(i) ' (empty for all):'];
    def{i}=num2str(obj.DispChans(i));
end

title='Channel number to display for one page';


answer=inputdlg(prompt,title,1,def);

for i=1:length(answer)
    tmp=str2double(answer{i});
    if isempty(tmp)||isnan(tmp)
        tmp=obj.ChanNumber(i);
    end
    
    obj.DispChans(i)=tmp;
    
end

end