function  LoadVolume(obj)
[filename,pathname]=uigetfile({'*.mat','Data format (*.mat)'},'Please select volume data');
fpath=[pathname filename];
if filename==0
    return;
end

[~,~,type]=fileparts(fpath);

dat=load(fpath);

axis(obj.axis_3d);

obj.volume{obj.volume_overlay+1}=vol3d('cdata',dat.volume,'texture','3D');
colormap gray;
axis vis3d
axis equal off

obj.light=camlight(obj.light,'headlight');

obj.head_center=[size(dat.volume,1)/2 size(dat.volume,2)/2 size(dat.volume,3)/2];
[az, el]=view(gca);
obj.display_view=[az el];

hold on;

obj.JScrollTreeInput.addVolume(fpath);
obj.volume_overlay=obj.volume_overlay+1;
end

