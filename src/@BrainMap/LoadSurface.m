function LoadSurface(obj)
[filename,pathname]=uigetfile({'*.*','Data format (*,mat,*.dfs,*.surf)'},'Please select surface data');
fpath=[pathname filename];
if filename==0
    return;
end


[~,~,type]=fileparts(fpath);

%set(handles.info,'string','Loading...');
if strcmp(type, '.mat')
    dat=load(fpath);

    obj.surface(obj.surface_overlay+1).faces=dat.faces;
    obj.surface(obj.surface_overlay+1).vertices=dat.vertices;
elseif strcmp(type, '.dfs')
    %set(obj.info,'string','Reading surface data...');
    [NFV,hdr]=readdfs(fpath);
    temp=patch('faces',NFV.faces,'vertices',NFV.vertices);
    
    %set(obj.info,'string','Reducing mesh...');

    obj.surface(obj.surface_overlay+1).vertices=get(temp,'vertices');
    obj.surface(obj.surface_overlay+1).faces=get(temp,'faces');
    delete(temp);
else
    try
        %set(obj.info,'string','Reading surface data...');
        [surf.vertices, surf.faces] = freesurfer_read_surf(fpath);
        temp=patch('faces',surf.faces,'vertices',surf.vertices);
        %set(obj.info,'string','Reducing mesh...');
        if size(surf.vertices,1)>2000000
            surf=reducepatch(temp,0.1);
        elseif size(surf.vertices,1)>1000000
            surf=reducepatch(temp,0.5);
        end
        obj.surface(obj.surface_overlay+1)=surf;
        delete(temp);
    catch
        
        errordlg('Unrecognized data.', 'Wrong data format');
        %                     set(obj.info,'string','');
        return;
    end
end

axis(obj.axis_3d);
obj.surface_plot(obj.surface_overlay+1)=patch('faces',obj.surface(obj.surface_overlay+1).faces,'vertices',obj.surface(obj.surface_overlay+1).vertices,...
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

obj.head_center=[mean(obj.surface(obj.surface_overlay+1).vertices(:,1)) mean(obj.surface(obj.surface_overlay+1).vertices(:,2))...
    (max(obj.surface(obj.surface_overlay+1).vertices(:,3))-min(obj.surface(obj.surface_overlay+1).vertices(:,3)))/3+...
    min(obj.surface(obj.surface_overlay+1).vertices(:,3))];
[az, el]=view(gca);
obj.display_view=[az el];
%             set(obj.alpha_slider,'visible','on','value',0.85);
%             set(obj.text11,'visible','on','enable','on');
obj.alpha(obj.surface_overlay+1)=0.9;
%             set(obj.smooth_slider,'visible','on','value',0);
%             set(obj.text15,'visible','on');
obj.smooth(obj.surface_overlay+1)=0;

%             set(obj.loadBtn,'enable','on');
%             set(obj.regBtn,'enable','on');
%             set(obj.addBtn,'enable','on');
%             for i=1:obj.overlay
%                 list{i}=strcat('Surface',' ',num2str(i));
%             end
%             set(obj.surf_list,'string',list,'visible','on','value',obj.curr_model);
%             set(obj.col_surf_Btn,'visible','on');
%             set(obj.del_surf_Btn,'visible','on');
%             set(obj.gen_outer_Btn,'visible','on');
%             set(obj.export_Btn,'visible','on');
%             set(obj.selBtn,'enable','on');

%             set(obj.show_ct_check,'visible','on');
%             set(obj.info,'string','');

obj.light=camlight(obj.light,'headlight');
obj.JScrollTreeInput.addSurface(fpath);
obj.surface_overlay=obj.surface_overlay+1;

end

