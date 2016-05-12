function  LoadVolume(obj)
[FileName,FilePath,FilterIndex]=uigetfile({...
    '*.mat;*.nii',...
    'Supported formats (*.mat;*.nii)';...
    '*.mat','Matlab Format';...
    '*.nii','Neuroimaging Informatics Technology Initiative (NIfTI)'},...
    'Select your volume file','volume');
if ~FileName
    return
end

[~, ~, ext]=fileparts(FileName);

fpath=fullfile(FilePath,FileName);

if obj.mapObj.isKey(fpath)
    errordlg('Already loaded !');
    return
end

if strcmp(ext,'.nii')
    out= MRIread(fpath);
    volume=out.vol;

    vol_max=max(max(max(volume)));
    vol_min=min(min(min(volume)));
    volume=(volume-vol_min)/(vol_max-vol_min);
    
%     volume(volume==0)=nan;
%     tmp=histeq(reshape(volume,[],size(volume,3)));
%     volume=reshape(tmp,size(volume,1),size(volume,2),size(volume,3));
%     volume(isnan(volume))=0;
    pixdim=out.volres;
   
%     volume(volume>0.7)=0;
    
    
    volume=permute(volume,[3,2,1]);
    pixdim=pixdim([3,2,1]);
    
    volume=fliplr(volume);
%     tmp=[1,0,0;0,-1,0;0,0,1]*[pixdim(1)*size(volume,1);pixdim(2)*size(volume,2);rotate.qfac*pixdim(3)*size(volume,3)];
%     tmp=permute(tmp,[1,3,2]);

    xdata=[0,pixdim(2)*size(volume,2)];
    ydata=[0,pixdim(1)*size(volume,1)];
    zdata=[0,pixdim(3)*size(volume,3)];
elseif strcmp(ext,'.mat')
    dat=load(fpath);
    volume=dat.volume;
    
    vol_max=max(max(max(volume)));
    vol_min=min(min(min(volume)));
    volume=(volume-vol_min)/(vol_max-vol_min);
    
    pixdim=ones(1,3);
    if isfield(dat,'PixelSpacing')
        pixdim(1:2)=dat.PixelSpacing;
    end
    if isfield(dat,'SpacingBetweenSlices')
        pixdim(3)=dat.SpacingBetweenSlices;
    end
    
    xdata=[0,pixdim(2)*size(volume,2)];
    ydata=[0,pixdim(1)*size(volume,1)];
    zdata=[0,pixdim(3)*size(volume,3)];
end

axis(obj.axis_3d);

LightOffCallback(obj)

% [X,Y,Z]=meshgrid(1:size(volume,2),1:size(volume,1),1:size(volume,3));
% [newX,newY,newZ]=meshgrid(1:0.5:size(volume,2),1:0.5:size(volume,1),1:0.5:size(volume,3));
% newV=interp3(X,Y,Z,volume,newX,newY,newZ);
mapval.volume=volume;
mapval.pixdim=pixdim;
mapval.xrange=xdata;
mapval.yrange=ydata;
mapval.zrange=zdata;


if obj.smooth_sigma>0
    img_vol=imgaussfilt3(mapval.volume,obj.smooth_sigma./mapval.pixdim);
else
    img_vol=mapval.volume;
end
    
tmp=vol3d('cdata',img_vol,'texture','3D','Parent',obj.axis_3d,...
    'XData',mapval.xrange,'YData',mapval.yrange,'ZData',mapval.zrange);
mapval.handles=tmp.handles;

VolumeColormapCallback(obj);
axis vis3d
axis equal off
set(obj.axis_3d,'clim',[obj.cmin,obj.cmax]);

hold on;

num=obj.JFileLoadTree.addVolume(fpath,true);
mapval.category='Volume';
mapval.file=fpath;
mapval.ind=num;
mapval.checked=true;


obj.mapObj([mapval.category,num2str(num)])=mapval;

material dull
end

