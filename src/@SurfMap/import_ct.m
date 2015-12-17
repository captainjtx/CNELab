function [v,f]=import_ct(varargin)
name=varargin{1};
type=name(end-2:end);
if strcmp(type,'mat')
    load(name);
    v=vertices;
    f=faces;
else
    if strcmp(type,'nii')
        Vol = spm_read_vols(spm_vol(name));
    elseif strcmp(type,'hdr') || strcmp(type,'img')
        Vol=hdr_read_volume(name);
        Vol=double(Vol);
    end
    ny=200;nx=200;nz=120;
    [y, x, z]=...
    ndgrid(linspace(1,size(Vol,1),ny),...
    linspace(1,size(Vol,2),nx),...
    linspace(1,size(Vol,3),nz));
    vol=interp3(Vol,x,y,z);
   
    vol(vol<0)=0;
    
%    [v,f]=ct_innerskull(vol);
    th=TH_input(vol);
    
    
    vn=vol/th;
    %vn=im2bw(vn,0.8);
    vn(vn<quantile(vn(find(vn)),0.75))=0;
    
    %Vm = bwareaopen(vn, 50);'
    
    %figure;
    for i=1:size(vn,3)
        vnn=im2bw(vn(:,:,i),0.3);
        %vnn = bwareaopen(vnn, 100);
        V(:,:,i)=vnn;
    end
    %V=vn;
    %SE = strel('disk',2);
    fv = isosurface(V);
    %figure;
    h=patch('faces',fv.faces,'vertices',fv.vertices);
    hi=reducepatch(h,0.1);
    delete(h);
    v=hi.vertices;
    f=hi.faces;
end
