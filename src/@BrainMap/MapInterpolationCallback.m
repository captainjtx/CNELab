function MapInterpolationCallback( obj )
interp=obj.JMapInterpolationSpinner.getValue();

if ~isempty(obj.SelectedElectrode)
    electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
    electrode.coor_interp=interp;
    if is_handle_valid(electrode.map_h)
        
        newpos=interp_tri(electrode.coor,electrode.coor_interp);
        
        newmap=electrode.F(newpos(:,1),newpos(:,2),newpos(:,3));
        
        tri=delaunay(newpos(:,1),newpos(:,2));
        
        cmapv=zeros(length(newmap),3);
        
        cmin=obj.JMapMinSpinner.getValue();
        cmax=obj.JMapMaxSpinner.getValue();
        cmap=colormap(electrode.map_colormap);
        clevel=linspace(cmin,cmax,size(cmap,1));
        for i=1:length(newmap)
            [~,index] = min(abs(clevel-newmap(i)));
            
            cmapv(i,:)=cmap(index,:);
        end
        
        try
            delete(electrode.map_h)
        catch
        end
        
        electrode.map_h=patch('Faces',tri,'Vertices',newpos,'facelighting','gouraud',...
            'FaceVertexCData',cmapv,'FaceColor','interp','EdgeColor','none','FaceAlpha',electrode.map_alpha,...
            'UserData',newmap);
        material dull
    end
   obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)])=electrode;
end

end

