function [v,f]=model_outer(model,dim)
%hi.vertices=vertices;
%hi.faces=faces;
J=polygon2voxel(model,dim,'none');
SE = strel('disk',4);
J=imfill(J,'holes');
J=imdilate(J,SE);
outer=isosurface(J,0.8);
ph=patch(outer);
h=reducepatch(ph,0.2);%handle
[v,f]=smoothMesh(h.vertices, h.faces, 15);
delete(ph);
% patch('vertices',v,'faces',f,'facecolor',[0.8 0.8 0.8],'edgecolor','none',...
%     'facealpha',0.5); hold on;camlight;view(3);axis vis3d
% figure;patch('vertices',hi.vertices,'faces',hi.faces,'facecolor',[1 1 0],'edgecolor','none',...
%     'facealpha',0.9); camlight;view(3);axis vis3d