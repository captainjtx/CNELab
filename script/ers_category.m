
ers_chan=[];

for t=-500:25:1000
    bsp.SpatialMapWin.act_start=t;
    bsp.SpatialMapWin.ActCallback(bsp.SpatialMapWin.act_start_edit);
    
    ers_chan=cat(2,ers_chan,bsp.SpatialMapWin.ers_chan{1});
end

t=-500:25:1000;
%%
first_ers=ones(size(ers_chan,1),1)*nan;
end_ers=ones(size(ers_chan,1),1)*nan;

for i=1:size(ers_chan,1)
    tmp=find(ers_chan(i,:));
    if ~isempty(tmp)
        first_ers(i)=t(tmp(1));
        end_ers(i)=t(tmp(end));
    end
end
%%
names=bsp.SpatialMapWin.chan_names;

onset=names(abs(first_ers)<=100);
early=names(first_ers<=-250);
long=names((end_ers-first_ers)>=1000);