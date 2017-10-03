function spatialmap_grid(fig,mapv,interp_scatter,pos_x,pos_y,w,h,sl,sh,colbar,ratio, extrap, smooth_row, smooth_column)
%TFMAP_GRID Summary of this function goes here
%   Detailed explanation goes here
%Orign of postion is top left corner

%pos_x,pos_y is ratio from 0 to 1
%w is the width of image in pixels
%h is the height of image in pixels

col=pos_x;
row=pos_y;

h=round(h);
w=round(w);

[x,y]=meshgrid((1:w)/w,(1:h)/h);

if isempty(extrap)
    extrap = 'none';
end
F= scatteredInterpolant(col(:),row(:),mapv(:),'natural', extrap);
mapvq=F(x,y);
if ~isempty(smooth_row) && ~isempty(smooth_column)
    mapvq = smooth2a(mapvq, smooth_row, smooth_column);
end
% 
% mapvq = ones(20, round(20*w/h))*nan;
% for i = 1:length(mapv)
%     mapvq(ceil(row(i)*size(mapvq,1)), ceil(col(i)*size(mapvq,2))) = mapv(i);
% end
% 
% mapvq=ezsmoothn(mapvq);


figure(fig)
clf

fpos=get(fig,'position');

a=axes('units','normalized','position',[10/400*w/fpos(3),15/300*h/fpos(4),w/fpos(3),h/fpos(4)],'Visible','off','parent',fig,...
    'xlimmode','manual','ylimmode','manual');

if strcmp(interp_scatter,'interp')
    h=imagesc('CData',mapvq,'Parent',a,'Tag','ImageMap');
    set(h, 'AlphaData', ~isnan(mapvq))
end

set(a,'XLim',[1,size(mapvq,2)]);
set(a,'YLim',[1,size(mapvq,1)]);

if ~isempty(sl)&&~isempty(sh)
    set(a,'CLim',[sl sh]);
end

set(a,'YDir','reverse','FontSize',round(15*ratio));
colormap(a,jet);
if colbar
    %optional color bar
    cb=colorbar('Units','normalized','FontSize',round(15*ratio));
    cbpos=get(cb,'Position');
    set(a,'Position',[10/400*w/fpos(3),15/300*h/fpos(4),w/fpos(3),h/fpos(4)]);
    set(cb,'Position',[(w+20/400*w)/fpos(3),15/300*h/fpos(4),0.04,cbpos(4)]);
end                
set(a,'Tag','MapAxes');
drawnow

end

