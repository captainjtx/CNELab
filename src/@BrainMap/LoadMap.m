function LoadMap(obj)
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
    
    maps={fullfile(FilePath,FileName)};
    
    mapv=zeros(size(electrode.coor,1),1);
    ind=[];
    for i=1:length(maps)
        sm=ReadSpatialMap(maps{i});
        [~,ib]=ismember(sm.name,electrode.channame);
        ind=union(ind,ib);
        mapv(ib,i)=sm.val;
    end
    %**************************************************************
    %interpolate missing channels
    map_pos=electrode.coor(ind,:);
    map_channames=electrode.channame(ind);
    mapv=mapv(ind,:);
    %**************************************************************
    cmax=6;
    cmin=-6;
    
    X=map_pos(:,1);
    Y=map_pos(:,2);
    Z=map_pos(:,3);
    
    tri=delaunay(X,Y);
    
    cmap=colormap('jet');
    
    clevel=linspace(cmin,cmax,size(cmap,1));
    
    cmapv=zeros(length(mapv),3);
    for i=1:length(mapv)
        [~,index] = min(abs(clevel-mapv(i)));
        
        cmapv(i,:)=cmap(index,:);
    end
    
    patch('Faces',tri,'Vertices',map_pos,'facelighting','gouraud',...
        'FaceVertexCData',cmapv,'FaceColor','interp','EdgeColor','none');
    material dull
end
end

