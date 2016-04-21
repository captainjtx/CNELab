function MapSpinnerCallback(obj)
if ~isempty(obj.SelectedElectrode)
    electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
    
    if is_handle_valid(electrode.map_h)
        cmin=obj.JMapMinSpinner.getValue();
        cmax=obj.JMapMaxSpinner.getValue();
        
        if cmin<cmax
            cmap=colormap(electrode.map_colormap);
            
            clevel=linspace(cmin,cmax,size(cmap,1));
            
            map=get(electrode.map_h,'UserData');
            cmapv=zeros(length(map),3);
            for i=1:length(map)
                [~,index] = min(abs(clevel-map(i)));
                cmapv(i,:)=cmap(index,:);
            end
            
            set(electrode.map_h,'FaceVertexCData',cmapv)
        end
    end
end

end

