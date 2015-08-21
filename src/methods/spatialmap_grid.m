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
a=axes('units','normalized','position',[10/400*w/fpos(3),10/300*h/fpos(4),w/fpos(3),h/fpos(4)],'Visible','off','parent',fig,...
    'xlimmode','manual','ylimmode','manual');

imagesc('CData',mapvq,'Parent',a,'Tag','ImageMap');
set(a,'XLim',[1,size(mapvq,2)]);
set(a,'YLim',[1,size(mapvq,1)]);
set(a,'CLim',[sl sh]);
set(a,'YDir','reverse');
colormap(a,jet);
if colbar
    %optional color bar
    cb=colorbar('Units','normalized');
    cbpos=get(cb,'Position');
    set(a,'Position',[10/400*w/fpos(3),10/300*h/fpos(4),w/fpos(3),h/fpos(4)]);
    set(cb,'Position',[(w+20/400*w)/fpos(3),10/300*h/fpos(4),cbpos(3),cbpos(4)]);
end

% radio=5;
% t=0:0.01:2*pi;
% for i=1:length(mapv)
%     hold on;
% %     %x_o and y_o = center of circle
% %     x = col(i) + radio*sin(t);
% %     y = row(i) + radio*cos(t);
% %     scatter(x,y,'k','Tag',channames{i});
%     plot(a,col(i)*w,row(i)*h,'Marker','o','Color','k','Tag',['Contact-' channames{i}]);
% end

% for m=1:length(col)
%     hold on;
%     tmp=plot(a,col(m)*w,row(m)*h);
%     set(tmp,'Marker','o','Color','k','Tag','Contact');
% end
% hold off

set(a,'Tag','SpatialMapAxes');

plot_contact(a,col,row,r,h,w);
drawnow
end

