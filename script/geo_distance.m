ufb='/Users/tengi/Desktop/Projects/data/Turkey/s2/app/spatial map/Close_300-800_start-100_len500.smw';
hfb='/Users/tengi/Desktop/Projects/data/Turkey/s2/app/spatial map/Close_60-200_start-100_len500.smw';
lfb='/Users/tengi/Desktop/Projects/data/Turkey/s2/app/spatial map/Close_8-32_start-100_len500.smw';

fpos='/Users/tengi/Desktop/Projects/data/Turkey/s2/position/grid_hybrid_chanpos.txt';

s1_dcs='C67_S';
s2_dcs='C91_S';
[channelname,pos_x,pos_y,r] = ReadPosition(fpos);
sm=ReadSpatialMap(lfb);
%%
center=[0,0];
w=0;
for i=1:length(sm.name)
    if sm.sig(i)
        [~,ind]=ismember(sm.name{i},channelname);
        center=center+[pos_x(ind),pos_y(ind)]*abs(sm.val(i));
        w=w+abs(sm.val(i));
    end
end

center=center/w;

[~,ind]=max(sm.val);
[~,ind]=ismember(sm.name{ind},channelname);
peak=[pos_x(ind),pos_y(ind)];
%%
[~,ind]=ismember(s2_dcs,channelname);
dcs=[pos_x(ind),pos_y(ind)];

sqrt((dcs-center)*(dcs-center)')
sqrt((dcs-peak)*(dcs-peak)')

