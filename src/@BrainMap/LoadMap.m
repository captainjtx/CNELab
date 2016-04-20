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
    
    map=zeros(size(electrode.coor,1),1);
    ind=[];
    for i=1:length(maps)
        sm=ReadSpatialMap(maps{i});
        [~,ib]=ismember(sm.name,electrode.channame);
        ind=union(ind,ib);
        map(ib,i)=sm.val;
    end
    %**************************************************************
    %interpolate missing channels
    pos=electrode.coor(ind,:);
    map_channames=electrode.channame(ind);
    map=map(ind,:);
    %**************************************************************
    cmax=6;
    cmin=-6;
    
    [newpos,newmap]=interp_tri(pos,map,5);
    
    tri=delaunay(newpos(:,1),newpos(:,2));
    
    cmap=colormap('jet');
    clevel=linspace(cmin,cmax,size(cmap,1));
    
    cmapv=zeros(length(newmap),3);
    for i=1:length(newmap)
        [~,index] = min(abs(clevel-newmap(i)));
        
        cmapv(i,:)=cmap(index,:);
    end
    
    patch('Faces',tri,'Vertices',newpos,'facelighting','gouraud',...
        'FaceVertexCData',cmapv,'FaceColor','interp','EdgeColor','none','FaceAlpha',0.8);
    material dull
end
end

function [newpos,newmap]=interp_tri(pos,map,k)

if k==0
    newpos=pos;
    newmap=map;
    return
else
    tri=delaunay(pos(:,1),pos(:,2));
    
    edge_pair=[];
    newpos=[];
    for i=1:size(tri,1)
        if ~ismember([tri(i,1),tri(i,2)],edge_pair)
            newpos=cat(1,newpos,(pos(tri(i,1),:)+pos(tri(i,2),:))/2);
            edge_pair=cat(1,edge_pair,[tri(i,1),tri(i,2)]);
        end
        
        if ~ismember([tri(i,1),tri(i,3)],edge_pair)
            newpos=cat(1,newpos,(pos(tri(i,1),:)+pos(tri(i,3),:))/2);
            edge_pair=cat(1,edge_pair,[tri(i,1),tri(i,3)]);
        end
        
        if ~ismember([tri(i,3),tri(i,2)],edge_pair)
            newpos=cat(1,newpos,(pos(tri(i,3),:)+pos(tri(i,2),:))/2);
            edge_pair=cat(1,edge_pair,[tri(i,3),tri(i,2)]);
        end
    end
    
    F= scatteredInterpolant(pos(:,1),pos(:,2),pos(:,3),map,'natural','linear');
    newmap=F(newpos(:,1),newpos(:,2),newpos(:,3));
    
    newpos=cat(1,pos,newpos);
    
    [newpos,ind]=unique(newpos,'rows');
    newmap=cat(1,map(:),newmap(:));
    newmap=newmap(ind);
    
    [newpos,newmap]=interp_tri(newpos,newmap,k-1);
end

end

