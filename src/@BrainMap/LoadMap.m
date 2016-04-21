function LoadMap(obj)
import javax.swing.SpinnerNumberModel;

if ~isempty(obj.SelectedElectrode)
    electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
    open_dir=fileparts(electrode.file);
    
    if exist([open_dir,'/app/spatial map'],'dir')==7
        open_dir=[open_dir,'/app/spatial map'];
    else
        open_dir='.';
    end
    
    [FileName,FilePath,FilterIndex]=uigetfile({'*.smw;*.txt;*.csv','Spatial Map Files (*.smw;*.txt;*.csv)';...
        '*.smw;*.txt;*csv','Text File (*.smw;*.txt;*csv)'},...
        'select your spatial map file',...
        'MultiSelect','off',...
        open_dir);
    try
        if FileName==0
            return
        end
    catch
    end
    
    mapfiles={fullfile(FilePath,FileName)};
    map=ones(size(electrode.coor,1),length(mapfiles))*nan;
    
    for i=1:length(mapfiles)
        sm=ReadSpatialMap(mapfiles{i});
        [~,ib]=ismember(sm.name,electrode.channame);
        map(ib,i)=sm.val;
    end
    map=mean(map,2);
    %**************************************************************
    %interpolate missing channels
    pos=electrode.coor;
    %     for i=1:size(pos,1)
    %         pos(i,:)=pos(i,:)-electrode.norm(ind(i),:)/norm(electrode.norm(ind(i),:))*electrode.thickness(ind(i))/2;
    %     end
    %**************************************************************
    %%
    %remake the model of max/min spinner
    max_map=max(map);
    min_map=min(map);
    
    cmax=max(abs(map))*1.1;
    cmin=-max(abs(map))*1.1;
    
    model = javaObjectEDT(SpinnerNumberModel(min_map,cmin,cmax,(max_map-min_map)/20));
    obj.JMapMinSpinner.setModel(model);
    
    model = javaObjectEDT(SpinnerNumberModel(max_map,cmin,cmax,(max_map-min_map)/20));
    obj.JMapMaxSpinner.setModel(model);
    %%
    %set map alpha value
    obj.JMapAlphaSpinner.setValue(electrode.map_alpha*100);
    obj.JMapAlphaSlider.setValue(electrode.map_alpha*100);
    %%
    %set map colormap
    set(obj.MapColorMapPopup,'value',...
        find(strcmpi(electrode.map_colormap,get(obj.MapColorMapPopup,'UserData'))));
    %%
    if isempty(electrode.map_h)
        newpos=interp_tri(pos,electrode.coor_interp);
        electrode.new_coor=newpos;
        
        F= scatteredInterpolant(pos(:,1),pos(:,2),pos(:,3),map,'natural','linear');
        newmap=F(newpos(:,1),newpos(:,2),newpos(:,3));
        
        tri=delaunay(newpos(:,1),newpos(:,2));
        
        cmap=colormap(electrode.map_colormap);
        
        clevel=linspace(min_map,max_map,size(cmap,1));
        
        cmapv=zeros(length(newmap),3);
        for i=1:length(newmap)
            [~,index] = min(abs(clevel-newmap(i)));
            
            cmapv(i,:)=cmap(index,:);
        end
        
        electrode.map_h=patch('Faces',tri,'Vertices',newpos,'facelighting','gouraud',...
            'FaceVertexCData',cmapv,'FaceColor','interp','EdgeColor','none','FaceAlpha',electrode.map_alpha,...
            'UserData',newmap);
        material dull
        
        electrode.map=map;
    else
        newpos=electrode.new_coor;
    end
    obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)])=electrode;
    
end
end



