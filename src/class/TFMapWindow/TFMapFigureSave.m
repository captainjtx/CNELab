classdef TFMapFigureSave<handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fig
        
        parent
        
        dest_dir_
        filename_
        format_
        res_ppi_
        
        res_edit
        format_popup
        
        
        
        dest_dir_edit
        dest_dir_btn
        
        filename_edit
        width
        height
        export_btn
        format_list
    end
    properties(Dependent)
        dest_dir
        filename
        res_ppi
        format
        
        valid
    end
        
    
    methods
        function obj=TFMapFigureSave(p)
            obj.parent=p;
            obj.width=300;
            obj.height=180;
            
            obj.res_ppi_=150;
            
            if ~isempty(obj.parent.bsp.FileDir)&&exist([obj.parent.bsp.FileDir,'/app/tfmap'],'dir')~=7
                mkdir(obj.parent.bsp.FileDir,'/app/tfmap');
            end
            open_dir=[obj.parent.bsp.FileDir,'/app/tfmap'];
            obj.dest_dir_=open_dir;
            obj.filename_='';
            obj.format_=1;%png
            
            obj.format_list={'png','jpg','eps'};
            
        end
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isgraphics(obj.fig);
            catch 
                val=0;
            end
        end
        function val=get.res_ppi(obj)
            val=obj.res_ppi_;
        end
        function set.res_ppi(obj,val)
            obj.res_ppi_=val;
            if obj.valid
                set(obj.res_edit,'string',num2str(obj.res_ppi_));
            end
        end
        
        function val=get.dest_dir(obj)
            val=obj.dest_dir_;
        end
        function set.dest_dir(obj,val)
            obj.dest_dir_=val;
            
            if obj.valid
                set(obj.dest_dir_edit,'string',obj.dest_dir_);
            end
        end
        
        function val=get.filename(obj)
            val=obj.filename_;
        end
        
        function set.filename(obj,val)
            obj.filename_=val;
            if obj.valid
                set(obj.filename_edit,'string',val);
            end
        end
        
        function val=get.format(obj)
            val=obj.format_;
        end
        
        function set.format(obj,val)
            obj.format_=val;
            if obj.valid
                set(obj.format_popup,'value',obj.format_);
            end
        end
         function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            
            obj.width=300;
            obj.height=180;
            
            figpos=get(obj.parent.fig,'Position');
            
            obj.fig=figure('MenuBar','none','Name','Export Pictures','units','pixels',...
                'Position',[figpos(1)+figpos(3),figpos(2)+figpos(4)-obj.height,obj.width,obj.height],'NumberTitle','off',...
                'CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            hp=uipanel('parent',obj.fig,'units','normalized','Position',[0,0,1,1]);
            
            setp=uipanel('parent',hp,'units','normalized','position',[0,0.2,1,0.8]);
            
            resp=uipanel('parent',setp,'units','normalized','Position',[0,2.1/3,1,0.9/3]);
            
            obj.res_edit=uicontrol('parent',resp,'style','edit','string',num2str(obj.res_ppi),...
                'units','normalized','position',[0.2,0.2,0.35,0.6],'callback',@(src,evt) ResCallback(obj,src));
            uicontrol('parent',resp,'style','text','string','ppi: ','units','normalized',...
            'position',[0,0.2,0.15,0.6],'fontsize',12);
            
            outp=uipanel('parent',setp,'units','normalized','position',[0,0,1,2.1/3],'title','Output');
            uicontrol('parent',outp,'style','text','string','Directory: ',...
                'units','normalized','position',[0,0.55,0.2,0.35]);
            obj.dest_dir_edit=uicontrol('parent',outp,'style','edit','string',obj.dest_dir,...
                'units','normalized','position',[0.2,0.55,0.6,0.35],'Callback',@(src,evt)DirCallback(obj,src));
            
            obj.dest_dir_btn=uicontrol('parent',outp,'style','pushbutton','string','...','units','normalized',...
                'position',[0.85,0.6,0.1,0.3],'callback',@(src,evt)DirCallback(obj,src));
            
            uicontrol('parent',outp,'style','text','string','Filename: ',...
                'units','normalized','position',[0,0.1,0.2,0.35]);
            obj.filename_edit=uicontrol('parent',outp,'style','edit','string',obj.filename,...
                'units','normalized','position',[0.2,0.1,0.5,0.35],...
                'callback',@(src,evt) FileNameCallback(obj,src));
            obj.format_popup=uicontrol('parent',outp,'style','popup','string',obj.format_list,...
                'units','normalized','position',[0.75,0.1,0.25,0.35],'value',obj.format,...
                'callback',@(src,evt)FormatCallback(obj,src));
            
            obj.export_btn=uicontrol('parent',hp,'style','pushbutton','string','Export',...
                'units','normalized','position',[0.78,0.01,0.2,0.18],...
                'callback',@(src,evt) ExportCallback(obj));
         end
         
        
        function DirCallback(obj,src)
            switch src
                case obj.dest_dir_edit
                    folder_name=get(src,'string');
                    if isdir(folder_name)
                        obj.dest_dir_=folder_name;
                    end
                case obj.dest_dir_btn
                    start_path=obj.dest_dir;
                    folder_name = uigetdir(start_path,'Select a directory');
                    if folder_name
                        obj.dest_dir=folder_name;
                    end
            end
        end
        function FormatCallback(obj,src)
            obj.format_=get(src,'value');
        end
        
        function FileNameCallback(obj,src)
            
            obj.filename_=get(src,'string');
        end
        
        function ResCallback(obj,src)
            tmp=round(str2double(get(src,'string')));
            if ~isnan(tmp)
                obj.res_ppi=tmp;
            end
        end
        
        function OnClose(obj)
            
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
        end
        
        function fname=auto_file_name(obj)
            fname=['f_',num2str(obj.parent.min_freq),'_',num2str(obj.parent.max_freq),...
                '_c_',num2str(obj.parent.min_clim),'_',num2str(obj.parent.max_clim)];
        end
        
        function ExportCallback(obj)
            pic_format=obj.format_list{obj.format};
            
            wait_bar_h = waitbar(0,'Saving Pictures...');
            for i=1:length(obj.parent.TFMapFig)
                waitbar(i/length(obj.parent.TFMapFig));
                figname=get(obj.parent.TFMapFig(i),'Name');
                fname=fullfile(obj.dest_dir,[obj.filename,'_',figname,'_',obj.auto_file_name]);
                
                set(obj.parent.TFMapFig(i),'color','white');
                export_fig(obj.parent.TFMapFig(i),['-',pic_format],'-nocrop','-opengl',['-r',num2str(obj.res_ppi)],fname);
            end
            close(wait_bar_h);
        end
        
        
    end
    
end

