%Contritubted by Heet Kaku, hnkaku@uh.edu (01/21/2018)
function PlayDataAsSound(obj)
[data,chanNames,~,~,~,~,~,~]=get_selected_data(obj);
if length(chanNames)>1
    errdlg('Please select only 1 channel!')
end
fs=max(min(obj.SRate,384000),1000);
sound(data,fs)
end