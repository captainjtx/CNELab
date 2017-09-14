omitmask=true;
ratio=0.3;

[data,chanNames,dataset,channel,sample,evts,groupnames,pos]=get_selected_data(bsp,omitmask);

fdata=base_bsp.SPFObj.subspacefilter(data,ratio);

% for i=1:length(dataset)
%     bsp.PreprocData{dataset(i)}(sample,channel(i))=fdata(:,i);
% end

%bsp.redrawChangeBlock('time');