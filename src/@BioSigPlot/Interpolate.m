function Interpolate(obj)
%INTERPOLATE Summary of this function goes here
%   Detailed explanation goes here

[data,chanNames,dataset,channel,sample,evts,groupnames,pos]=get_selected_data(obj);

if length(chanNames)>1
    msgbox('More than one channel selected!','Interpolate','error');
    return
end

prompt={'Neighbor Channels'};
title='Interpolate';


def={''};


end

