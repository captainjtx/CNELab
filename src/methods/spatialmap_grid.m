function h=spatialmap_grid(fig,t,f,tf,t_start,t_len,pos_x,pos_y,w,h,sl,sh,freq,colbar)
%TFMAP_GRID Summary of this function goes here
%   Detailed explanation goes here
%Orign of postion is top left corner

%pos_x,pos_y is ratio from 0 to 1
%w is the width of image in pixels
%h is the height of image in pixels

col=max(1,round(pos_x*w));
row=max(1,round(pos_y*h));

fi=(f>=freq(1))&(f<=freq(2));
ti=(t>=t_start)&(t<=t_start+t_len);

mapv=zeros(1,length(tf));
for i=1:length(tf)
    mapv(i)=mean(mean(tf{i}(fi,ti)));
end

method='linear';

[x,y]=meshgrid(1:w,1:h);
mapvq=griddata(col,row,mapv,x,y,method);

a=axes('units','pixels','position',[10,10,w,h],'Visible','off');


imagesc('CData',10*log10(mapvq),'Parent',a);
set(a,'CLim',[sl sh]);
colormap(jet);
if colbar
    %optional color bar
    cb=colorbar('Units','Pixels','Parent',fig);
    cbpos=get(cb,'Position');
    set(a,'Position',[10,10,w,h]);
    set(cb,'Position',[w+15,10,cbpos(3),cbpos(4)]);
end

set(a,'Tag','SpatialMapAxes');
end

