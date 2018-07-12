% %Contritubted by Heet Kaku, hnkaku@uh.edu (01/21/2018)
% function PlayDataAsSound(obj)
% [data,chanNames,~,~,~,~,~,~]=get_selected_data(obj);
% if length(chanNames)>1
%     errdlg('Please select only 1 channel!')
% end
% fs=max(min(obj.SRate,384000),1000);
% sound((data./max(abs(data))),fs)
% end

%Contritubted by Heet Kaku, hnkaku@uh.edu (01/21/2018)
function PlayDataAsSound(obj)
prompt = {'Enter Sampling Rate:','Enter Absolute threshold:'};
title = 'Parameters';
dims = [1 35];
definput = {'0 for default Fs of data','0 for no thresholding'};
answer = inputdlg(prompt,title,dims,definput);
answer = cellfun(@str2num,answer);
if answer(1) == 0
    fs=max(min(obj.SRate,384000),1000);
else
    fs = answer(1);
end
[data,chanNames,~,~,~,~,~,~]=get_selected_data(obj);

threshold = answer(2);
if threshold < 0 %Check if innout threshold is absolute value.
    errordlg('Please select absolute value for thresholding!')
elseif threshold ~= 0
    ind=find(abs(data)<threshold); %Find indices of data less than threshold
    data(ind)=0; %Make all those points 0.
    if isempty(find(data))
        errordlg('Threshold too large!')
    end
end
if length(chanNames)>1
    errordlg('Please select only 1 channel!')
end
sound((data./max(abs(data))),fs)
end
