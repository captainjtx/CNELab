%Contritubted by Heet Kaku, hnkaku@uh.edu (07/17/2018)
function PlayDataAsSound(obj)
if obj.AudioSRate == 0
    fs=max(min(obj.SRate,384000),1000);
else
    fs = obj.AudioSRate;
end
[data,chanNames,~,~,~,~,~,~]=get_selected_data(obj);

if obj.AudioThreshold < 0 %Check if input threshold is absolute value.
    errordlg('Please select absolute value for thresholding!')
    return;
elseif obj.AudioThreshold ~= 0
    ind=find(abs(data)<obj.AudioThreshold); %Find indices of data less than threshold
    data(ind)=0; %Make all those points 0.
    if isempty(find(data))
        errordlg('Threshold too large!')
        return;
    end
end
if length(chanNames)>1
    errordlg('Please select only 1 channel!')
    return;
end
sound((data./max(abs(data))),fs) %Play the audio
end
