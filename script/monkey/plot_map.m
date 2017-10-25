function plot_map(axe, mapv, chanpos, cmin, cmax, contact, grid_height, grid_width)
extrap = 'none';
smooth_row = 2; %smooth kernel
smooth_col = 2;
ratio = 1;
%%
[x,y]=meshgrid((1:grid_width)/grid_width,(1:grid_height)/grid_height);
F= scatteredInterpolant(chanpos(:, 1), chanpos(:,2), mapv(:), 'natural', extrap);
mapvq=F(x,y);
mapvq = smooth2a(mapvq, smooth_row, smooth_col);
imagehandle=findobj(axe,'Tag','ImageMap');
if isempty(imagehandle)
    imagesc('CData',mapvq,'Parent',axe,'Tag','ImageMap', 'AlphaData', ~isnan(mapvq));
    set(axe,'XLim',[1,size(mapvq,2)]);
    set(axe,'YLim',[1,size(mapvq,1)]);
    set(axe,'CLim',[cmin cmax]);
    set(axe,'YDir','reverse','FontSize',round(15*ratio));
    if contact
        plot_contact(axe,[],chanpos(:,1),chanpos(:,2),chanpos(:,3), grid_height, grid_width,[]);
    end
    colormap(axe, jet)
    
else
    set(imagehandle,'CData',single(mapvq),'visible','on');
    set(imagehandle, 'AlphaData', ~isnan(mapvq))
end
end