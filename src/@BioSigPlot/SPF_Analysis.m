function SPF_Analysis(obj,src)
%Subspace Projection Filter
omitMask=true;
[data,chanNames,dataset,channel,sample]=get_selected_data(obj,omitMask);
switch src
    case obj.BtnPCA
        method='PCA';
    case obj.BtnICA
        method='ICA';
    case obj.BtnTPCA
        method='TPCA';
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
if strcmpi(method,'pca')
    var=data'*data;
    [V,D]=eig(var);
    
    [e,ID]=sort(diag(D),'descend');
    
    SV=V(:,ID);
    
    subspaceData=data*SV;
    reconData=data;
    
    mix=SV';
    demix=SV;
    weg=e;
elseif strcmpi(method,'tpca')
    
elseif strcmpi(method,'ica')
    
    prompt='Number of ICA:';
    
    title='ICA';
    
    
    answer=inputdlg(prompt,title,1,{num2str(size(data,2))});
    
    if isempty(answer)
        return
    else
        tmp=str2double(answer{1});
        if isempty(tmp)||isnan(tmp)
            tmp=size(data,2);
        end
        
        [icasig, A, W] = fastica(data','verbose', 'off', 'displayMode', 'off','numOfIC', tmp);
        reconData=data;
        subspaceData=icasig';
        
        mix=A';
        demix=W';
        
        weg=[];
    end
end
obj.SPFObj=SPFPlot(method,data,subspaceData,reconData,mix,demix,weg,...
    'SRate',obj.SRate,...
    'WinLength',min(size(data,1)/obj.SRate,15),...
    'DataView',dataview,...
    'Gain',mean(obj.Gain_{obj.DisplayedData(1)}),...
    'ControlPanelDisplay','off',...
    'LockLayout','off',...
    'DisplayGauge','off');
% 'ChanNames',channames,...
if isempty(obj.SPFObj)
    return
end
addlistener(obj.SPFObj,'MaskSubspace',@(src,evt)spf_selected_data(obj,dataset,channel,sample));

end

function spf_selected_data(obj,dataset,channel,sample)
fdata=obj.SPFObj.PreprocData{3};
for i=1:size(fdata,2)
    obj.PreprocData{dataset(i)}(sample,channel(i))=fdata(:,i);
end

obj.redrawChangeBlock('time');

end

