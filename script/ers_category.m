ers_chan=[];

for t=-1000:5:1200
    bsp.SpatialMapWin.act_start=t;
    bsp.SpatialMapWin.ActCallback(bsp.SpatialMapWin.act_start_edit);
    
    ers_chan=cat(2,ers_chan,bsp.SpatialMapWin.ers_chan{1});
end

t=-1000:5:1200;
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

onset=names(abs(first_ers)<=50);
early=names(first_ers<=-100);
long=names((end_ers-first_ers)>=1000);