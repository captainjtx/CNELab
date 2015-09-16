function spatialmap_grid(fig,mapv,method,extrap,channames,pos_x,pos_y,r,w,h,sl,sh,colbar)
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

if strcmpi(method,'natural')
    [x,y]=meshgrid((1:w)/w,(1:h)/h);
    
    F= scatteredInterpolant(col,row,mapv',method,extrap);
    % mapvq=griddata(col,row,mapv,x,y,method);
    
    mapvq=F(x,y);
else
    return
end
figure(fig)

fpos=get(fig,'position');
a=axes('units','normalized','position',[10/400*w/fpos(3),15/300*h/fpos(4),w/fpos(3),h/fpos(4)],'Visible','off','parent',fig,...
    'xlimmode','manual','ylimmode','manual');

imagesc('CData',mapvq,'Parent',a,'Tag','ImageMap');
set(a,'XLim',[1,size(mapvq,2)]);
set(a,'YLim',[1,size(mapvq,1)]);
set(a,'CLim',[sl sh]);
set(a,'YDir','reverse','FontSize',16);
colormap(a,jet);
if colbar
    %optional color bar
    cb=colorbar('Units','normalized','FontSize',16);
    cbpos=get(cb,'Position');
    set(a,'Position',[10/400*w/fpos(3),15/300*h/fpos(4),w/fpos(3),h/fpos(4)]);
    set(cb,'Position',[(w+20/400*w)/fpos(3),15/300*h/fpos(4),0.04,cbpos(4)]);
end                
set(a,'Tag','SpatialMapAxes');
drawnow

end

