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

if isfield(dat,'PixelSpacing')
    xdata=[0,dat.PixelSpacing(2)*size(dat.volume,2)];
    ydata=[0,dat.PixelSpacing(1)*size(dat.volume,1)];
else
    xdata=[0,size(dat.volume,2)];
    ydata=[0,size(dat.volume,1)];
end
if isfield(dat,'SpacingBetweenSlices')
    zdata=[0,dat.SpacingBetweenSlices*size(dat.volume,3)];
else
    zdata=[0,size(dat.volume,3)];
end

mapval.xrange=xdata;
mapval.yrange=ydata;
mapval.zrange=zdata;

tmp=vol3d('cdata',dat.volume,'texture','3D','Parent',obj.axis_3d,...
    'XData',xdata,'YData',ydata,'ZData',zdata);
mapval.handles=tmp.handles;

ColormapCallback(obj);
axis vis3d
axis equal off
set(obj.axis_3d,'clim',[obj.cmin,obj.cmax]/255);

hold on;

num=obj.JFileLoadTree.addVolume(fpath,true);
mapval.category='Volume';
mapval.file=fpath;
mapval.ind=num;
mapval.checked=true;

obj.mapObj([mapval.category,num2str(num)])=mapval;

material dull
end

