function  LoadVolume(obj)
[filename,pathname]=uigetfile({'*.mat','Data format (*.mat)'},'Please select volume data');
fpath=[pathname filename];
if filename==0
    return;
end

if obj.mapObj.isKey(fpath)
    errordlg('Already loaded !');
    return
end

[~,~,type]=fileparts(fpath);

dat=load(fpath);

axis(obj.axis_3d);

LightOffCallback(obj)

% [X,Y,Z]=meshgrid(1:size(dat.volume,2),1:size(dat.volume,1),1:size(dat.volume,3));
% [newX,newY,newZ]=meshgrid(1:0.5:size(dat.volume,2),1:0.5:size(dat.volume,1),1:0.5:size(dat.volume,3));
% newV=interp3(X,Y,Z,dat.volume,newX,newY,newZ);

mapval.volume=dat.volume;
mapval.id='volume';

tmp=vol3d('cdata',dat.volume,'texture','3D','Parent',obj.axis_3d);
mapval.handles=tmp.handles;

colormap gray;
axis vis3d
axis equal off

[az, el]=view(gca);
obj.display_view=[az el];

hold on;

obj.JFileLoadTree.addVolume(fpath,true);
obj.mapObj(fpath)=mapval;

 
end

