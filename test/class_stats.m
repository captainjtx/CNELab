lines=findobj(gca,'type','line');
hfb_env=get(lines(4),'ydata');
std_hfb_env=get(lines(5),'ydata');
hfb_raw=get(lines(7),'ydata');
std_hfb_raw=get(lines(8),'ydata');
lfb_env=get(lines(10),'ydata');
std_lfb_env=get(lines(11),'ydata');
lfb_raw=get(lines(13),'ydata');
std_lfb_raw=get(lines(14),'ydata');

t=get(lines(4),'xdata');
ind=(t==0);
disp([lfb_raw(ind),lfb_env(ind),hfb_raw(ind),hfb_env(ind);...
       lfb_raw(ind)-std_lfb_raw(ind),lfb_env(ind)-std_lfb_env(ind),hfb_raw(ind)-std_hfb_raw(ind),hfb_env(ind)-std_hfb_env(ind)]);
   
for i=13:-3:4
    [m,ind]=min(get(lines(i),'ydata'));
    std=get(lines(i+1),'ydata');
    disp([m,std(ind)-m])
end