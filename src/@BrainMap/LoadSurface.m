function LoadSurface(obj)
[filename,pathname]=uigetfile({'*.*','Data format (*,mat,*.dfs,*.surf)'},'Please select surface data');
fpath=[pathname filename];
if filename==0
    return;
end

if obj.mapObj.isKey(fpath)
    errordlg('Already loaded !');
    return
end

[~,~,type]=fileparts(fpath);



%set(handles.info,'string','Loading...');
if strcmp(type, '.mat')
    dat=load(fpath);

    faces=dat.faces;
    vertices=dat.vertices;
elseif strcmp(type, '.dfs')
    %set(obj.info,'string','Reading surface data...');
    [NFV,hdr]=readdfs(fpath);
    
    faces=NFV.faces;
    vertices=NFV.vertices;

else
    try
        %set(obj.info,'string','Reading surface data...');
        [vertices, faces] = freesurfer_read_surf(fpath);
        %set(obj.info,'string','Reducing mesh...');
        if size(vertices,1)>2000000
            [faces,vertices]=reducepatch(faces,vertices,0.1);
        elseif size(vertices,1)>1000000
            [faces,vertices]=reducepatch(faces,vertices,0.5);
        end
    catch 
        errordlg('Unrecognized data.', 'Wrong data format');
        %                     set(obj.info,'string','');
        return;
    end
end

mapval.vertices=vertices;
mapval.faces=faces;
mapval.id='surface';

axis(obj.axis_3d);
mapval.handles=patch('faces',faces,'vertices',vertices,...
    'edgecolor','none','facecolor',[0.85 0.85 0.85],'clipping','on',...
    'facealpha',0.9,'BackfaceLighting', 'lit', ...
    'AmbientStrength',  0.5, ...
    'DiffuseStrength',  0.5, ...
    'SpecularStrength', 0.2, ...
    'SpecularExponent', 1, ...
    'SpecularColorReflectance', 0.5, ...
    'FaceLighting',     'gouraud', ...
    'EdgeLighting',     'gouraud');
hold on
axis vis3d

obj.light=camlight(obj.light,'headlight');

obj.JFileLoadTree.addSurface(fpath,true);
obj.mapObj(fpath)=mapval;
end

