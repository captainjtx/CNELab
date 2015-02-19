function Auto_Remove_Pulse_Artifact(obj)
%Automatically remove the ecg artifact according to ecg channel
%INput the relative channel index in selected channels!!
prompt={'ECG: ','Denoise Channels: ','PCAs to Drop: '};
title='Selected Data';

def={'','','1'};

answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

ECG_Indx=str2num(answer{1});
ECG_Indx=round(ECG_Indx);

[data,chanNames,dataset,channel,sample]=get_selected_data(obj);

if isempty(ECG_Indx)||min(ECG_Indx)<1||max(ECG_Indx)>size(data,2)
    msgbox('Invalid input!','ECG+/-','error');
    return
end

if length(ECG_Indx)>2
    msgbox('More than two ECG channels, will use the first two!','warn'); 
end

LFP_Indx=str2num(answer{2});
LFP_Indx=round(LFP_Indx);

if isempty(LFP_Indx)||min(LFP_Indx)<1||max(LFP_Indx)>size(data,2)
    msgbox('Invalid input!','Denoise Channel Vector','error');
    return
end

S=str2double(answer{3});
if isnan(S)||isempty(S)
    S=1;
end



fdata=Remove_Pulse_Artifact(data,obj.SRate,ECG_Indx,LFP_Indx,S);

for i=1:size(fdata,2)
    obj.PreprocData{dataset(i)}(sample,channel(i))=fdata(:,i);
end

redrawChangeTime(obj);
end

