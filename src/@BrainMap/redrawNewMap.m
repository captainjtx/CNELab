function  electrode=redrawNewMap(obj,electrode)

pos=electrode.coor;
map=electrode.map;
%%
max_map=max(map);
min_map=min(map);

step=(max_map-min_map)/20;

obj.JMapMinSpinner.getModel().setStepSize(java.lang.Double(step));
obj.JMapMaxSpinner.getModel().setStepSize(java.lang.Double(step));

cmin=obj.JMapMinSpinner.getValue();
cmax=obj.JMapMaxSpinner.getValue();
%%
F= scatteredInterpolant(pos(:,1),pos(:,2),pos(:,3),map,'natural','linear');
electrode.F=F;

cmap=colormap(electrode.map_colormap);
clevel=linspace(cmin,cmax,size(cmap,1));

if ~is_handle_valid(electrode.map_h)
    newpos=interp_tri(pos,electrode.coor_interp);
    
    newmap=F(newpos(:,1),newpos(:,2),newpos(:,3));
    
    tri=delaunay(newpos(:,1),newpos(:,2));
    
    cmapv=zeros(length(newmap),3);
    for i=1:length(newmap)
        [~,index] = min(abs(clevel-newmap(i)));
        
        cmapv(i,:)=cmap(index,:);
    end
    
    electrode.map_h=patch('Faces',tri,'Vertices',newpos,'facelighting','gouraud',...
        'FaceVertexCData',cmapv,'FaceColor','interp','EdgeColor','none','FaceAlpha',electrode.map_alpha,...
        'UserData',newmap);
    material dull
else
    newpos=get(electrode.map_h,'Vertices');
    
    newmap=F(newpos(:,1),newpos(:,2),newpos(:,3));
    
    cmapv=zeros(length(newmap),3);
    for i=1:length(newmap)
        [~,index] = min(abs(clevel-newmap(i)));
        
        cmapv(i,:)=cmap(index,:);
    end
    
    set(electrode.map_h,'UserData',newmap,'FaceVertexCData',cmapv);
end


end

