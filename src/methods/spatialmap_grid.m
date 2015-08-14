function spatialmap_grid(fig,t,f,tf,method,extrap,t_start,t_len,pos_x,pos_y,w,h,sl,sh,freq,colbar)
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

if strcmpi(method,'natural')
    [x,y]=meshgrid(1:w,1:h);
    
    F= scatteredInterpolant(col,row,mapv',method,extrap);
    % mapvq=griddata(col,row,mapv,x,y,method);
    
    mapvq=F(x,y);
else
    return
end
a=axes('units','pixels','position',[10,10,w,h],'Visible','off','parent',fig,...
    'xlimmode','manual','ylimmode','manual');


imagesc('CData',10*log10(flipud(mapvq)),'Parent',a,'Tag','ImageMap');
set(a,'XLim',[1,w]);
set(a,'YLim',[1,h]);
set(a,'CLim',[sl sh]);
colormap(jet);
if colbar
    %optional color bar
    cb=colorbar('Units','Pixels');
    cbpos=get(cb,'Position');
    set(a,'Position',[10,10,w,h]);
    set(cb,'Position',[w+20,10,cbpos(3),cbpos(4)]);
end

for i=1:length(tf)
    hold on;
    plot(a,w-col(i),row(i),'Marker','o','Color','k');
end

set(a,'Tag','SpatialMapAxes');
drawnow
end

