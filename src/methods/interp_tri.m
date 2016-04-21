function newpos=interp_tri(pos,k)

if k==0
    newpos=pos;
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
    
    newpos=cat(1,pos,newpos);
    
    newpos=unique(newpos,'rows');
    
    newpos=interp_tri(newpos,k-1);
end

end