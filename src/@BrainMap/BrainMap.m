classdef BrainMap < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties (Dependent)
        valid
    end
    
    properties
        fig
        axes_3d
        
        File_Menu
        Load_Menu
        Load_Surface_Menu
        render
        head_center
        isrender
        overlay
        coor
        electrode
        curr_coor
        ini_coor
        elec_no
        alpha
        smooth
        elec_index
        color
        model
        display_view
        curr_model
        begin
        head_plot
    end
    
    methods
        function obj=BrainMap()
            obj.varinit();
            obj.buildfig();
        end
        
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
            end
        end
        function varinit(obj)
            obj.render=[];
            obj.head_center=[];
            obj.isrender=[];
            obj.overlay=0;
            obj.coor=[];
            obj.electrode.coor=[];
            obj.electrode.col=[];
            obj.electrode.marker=[];
            obj.curr_coor=[];
            obj.ini_coor=[];
            obj.elec_no=0;
            obj.alpha=0.85;
            obj.smooth=0;
            obj.elec_index=0;
            obj.color=[0 0 1];
            obj.model.vertices=[];
            obj.model.faces=[];
        end
        function buildfig(obj)
            screensize=get(0,'ScreenSize');
            obj.fig=figure('Menubar','none','Name','electrode','units','pixels','position',[screensize(3)/2-500,screensize(4)/2-350,1000,700],...
                'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),'resize','off','Dockcontrols','off');
            
            obj.File_Menu=uimenu(obj.fig,'label','File');
            obj.Load_Menu=uimenu(obj.File_Menu,'label','Load');
            obj.Load_Surface_Menu=uimenu(obj.Load_Menu,'label','Surface','callback',@(src,evt) LoadSurface(obj));
            
            view_p=uipanel(obj.fig,'units','normalized','position',[0,0.15,0.7,0.85],'BorderType','none','backgroundcolor','white');
            
            obj.axes_3d=axes('parent',view_p,'units','normalized','position',[0,0,1,1]);
            axis off
            
            
            toolpanel=uipanel(obj.fig,'units','normalized','position',[0.7,0.15,0.3,0.85]);
        end
        
        function OnClose(obj)
            if ishandle(obj.fig)
                delete(obj.fig);
            end
        end
        
        function LoadSurface(obj)
            
            [filename,pathname]=uigetfile({'*.*','Data format (*.mat,*.dfs,*.surf)'},'Please select surface data');
            fpath=[pathname filename];
            if filename==0
                return;
            end
            obj.overlay=obj.overlay+1;
            obj.curr_model=obj.overlay;            
            type=fpath(end-2:end);
            %set(handles.info,'string','Loading...');
            if strcmp(type, 'mat')
                dat=load(fpath);
                try
                    obj.model(obj.overlay).faces=dat.faces;
                    obj.model(obj.overlay).vertices=dat.vertices;
                catch
                    obj.axes_3d;
                    volume=dat.volume;
                    obj.render=vol3d('cdata',volume,'texture','3D');
                    colormap(gray);
                    view(3);
                    rotate3d;
                    axis vis3d
                    axis equal off
                    set(gca,'CameraViewAngle',8);
                    obj.isrender=1;
                    obj.head_center=[size(volume,1)/2 size(volume,2)/2 size(volume,3)/2];
                    [az, el]=view(gca);
                    obj.display_view=[az el];
                    setappdata(gcf,'view',[az el]);
                    obj.alpha(obj.overlay)=0.85;
                    obj.smooth(obj.overlay)=0;
                    %hold on
%                     set(obj.loadBtn,'enable','on');
%                     set(obj.regBtn,'enable','on');
%                     set(obj.addBtn,'enable','on');
%                     for i=1:obj.overlay
%                         list{i}=strcat('Surface',' ',num2str(i));
%                     end
%                     set(obj.surf_list,'string',list,'visible','on','value',obj.curr_model);
%                     set(obj.col_surf_Btn,'visible','on');
%                     set(obj.del_surf_Btn,'visible','on');
%                     set(obj.selBtn,'enable','on');
%                     obj.begin=1;
%                     set(obj.show_ct_check,'visible','on');
%                     set(obj.info,'string','');
                    return;
                end
            elseif strcmp(type, 'dfs')
                %set(obj.info,'string','Reading surface data...');
              
                [NFV,hdr]=readdfs(fpath);
                temp=patch('faces',NFV.faces,'vertices',NFV.vertices);
                
                %set(obj.info,'string','Reducing mesh...');
                %guidata(hObject, obj);
                obj.model.vertices=get(temp,'vertices');
                obj.model.faces=get(temp,'faces');
                %    end
                delete(temp);
                obj.model(obj.overlay).faces=obj.model.faces;
                obj.model(obj.overlay).vertices=obj.model.vertices;
            else
                try
                    %set(obj.info,'string','Reading surface data...');
                    %guidata(hObject, obj);
                    [hi.vertices, hi.faces] = freesurfer_read_surf(fpath);
                    temp=patch('faces',hi.faces,'vertices',hi.vertices);
                    %set(obj.info,'string','Reducing mesh...');
                    %guidata(hObject, obj);
                    if size(hi.vertices,1)>2000000
                        obj.model=reducepatch(temp,0.1);
                    elseif size(hi.vertices,1)>1000000
                        obj.model=reducepatch(temp,0.5);
                        %         elseif size(hi.vertices,1)>500000
                        %             model=reducepatch(temp,0.8);
                    else
                        obj.model.vertices=get(temp,'Vertices');
                        obj.model.faces=get(temp,'Faces');
                    end
                    delete(temp);
                    obj.model(obj.overlay).faces=obj.model.faces;
                    obj.model(obj.overlay).vertices=obj.model.vertices;
                catch
                    
                    errordlg('Unrecognized data.', 'Wrong data format');
                    set(obj.info,'string','');
                    return;
                end
            end
            obj.isrender=0;
            obj.axes_3d;
            obj.head_plot(obj.overlay)=patch('faces',obj.model(obj.overlay).faces,'vertices',obj.model(obj.overlay).vertices,...
                'edgecolor','none','facecolor',[0.85 0.85 0.85],'clipping','on',...
                'facealpha',0.9,'BackfaceLighting', 'lit', ...
                'AmbientStrength',  0.5, ...
                'DiffuseStrength',  0.5, ...
                'SpecularStrength', 0.2, ...
                'SpecularExponent', 1, ...
                'SpecularColorReflectance', 0.5, ...
                'FaceLighting',     'gouraud', ...
                'EdgeLighting',     'gouraud');
            rotate3d on;
            hold on
            if obj.begin==0
                camlight(0,70);camlight(-30,270);daspect([1,1,1]);
            end
            axis vis3d
            obj.head_center=[mean(obj.model(1).vertices(:,1)) mean(obj.model(1).vertices(:,2))...
                (max(obj.model(1).vertices(:,3))-min(obj.model(1).vertices(:,3)))/3+...
                min(obj.model(1).vertices(:,3))];
            [az, el]=view(gca);
            obj.display_view=[az el];
            setappdata(gcf,'view',[az el]);
%             set(obj.alpha_slider,'visible','on','value',0.85);
%             set(obj.text11,'visible','on','enable','on');
            obj.alpha(obj.overlay)=0.85;
%             set(obj.smooth_slider,'visible','on','value',0);
%             set(obj.text15,'visible','on');
            obj.smooth(obj.overlay)=0;
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
            obj.begin=1;
            
%             set(obj.show_ct_check,'visible','on');
%             set(obj.info,'string','');
        end
    end
    
end