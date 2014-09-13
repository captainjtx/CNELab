function SPF_Analysis(obj,src)
%Subspace Projection Filter
[data,chanNames,dataset,channel,sample]=get_selected_data(obj);
switch src
    case obj.BtnPCA
        method='PCA';
    case obj.BtnICA
        method='ICA';
end

channames{1}=chanNames;
renames=cell(size(chanNames));
for i=1:length(chanNames)
    renames{i}=['Recon-',chanNames{i}];
end
channames{3}=renames;

spnames=cell(size(chanNames));
for i=1:length(chanNames)
    spnames{i}=[method,'-',num2str(i)];
end
channames{2}=spnames;

if size(data,2)<15
    dataview='Vertical';
else
    dataview='Horizontal';
end
    
obj.SPFObj=SPFPlot(data,method,'SRate',obj.SRate,...
    'WinLength',min(size(data,1)/obj.SRate,15),...
    'DataView',dataview,...
    'DispChans',obj.DispChans,...
    'Gain',mean(obj.Gain_{obj.DisplayedData(1)}),...
    'ChanNames',channames,...
    'ControlPanelDisplay','off',...
    'LockLayout','off',...
    'DisplayGauge','off');

addlistener(obj.SPFObj,'MaskSubspace',@(src,evt)spf_selected_data(obj,dataset,channel,sample));

end

function spf_selected_data(obj,dataset,channel,sample)
fdata=obj.SPFObj.PreprocData{3};
for i=1:size(fdata,2)
    obj.PreprocData{dataset(i)}(sample,channel(i))=fdata(:,i);
end

obj.redrawChangeTime;

end

