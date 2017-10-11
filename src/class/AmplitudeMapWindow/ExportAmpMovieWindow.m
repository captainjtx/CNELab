classdef ExportAmpMovieWindow<handle
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
        
        t_start_edit
        t_end_edit
        t_start_slider
        t_end_slider
        
        t_start_
        t_end_
    end
    properties(Dependent)
        dest_dir
        filename
        res_ppi
        format
        
        valid
        t_start
        t_end
    end
    methods
        function obj=ExportAmpMovieWindow(p)
            obj.parent=p;
            obj.width=300;
            obj.height=400;
            
            obj.res_ppi_=150;
            obj.t_start_ = 0;
            obj.t_end_ = p.bsp.TotalTime;
            
            if ~isempty(obj.parent.bsp.FileDir)&&exist([obj.parent.bsp.FileDir,'/app/amp'],'dir')~=7
                mkdir(obj.parent.bsp.FileDir,'/app/amp');
            end
            open_dir=[obj.parent.bsp.FileDir,'/app/amp'];
            obj.dest_dir_=open_dir;
            
            obj.filename_='';
            obj.format_=1;%mp4
            
            obj.format_list={'MPEG-4','Motion JPEG AVI'};
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
        
        function val=get.t_start(obj)
            val=obj.t_start_;
        end
        function set.t_start(obj,val)
            obj.t_start_=val;
            
            if obj.t_start>obj.t_end
                obj.t_end=val;
            end
            
            
            if obj.valid
                set(obj.t_start_edit,'string',num2str(obj.t_start_));
                set(obj.t_start_slider,'value',obj.t_start_);
            end
            
        end
        
        function val=get.t_end(obj)
            val=obj.t_end_;
        end
        function set.t_end(obj,val)
            obj.t_end_=val;
            
            if obj.t_start>obj.t_end
                obj.t_start=val;
            end
            if obj.valid
                set(obj.t_end_edit,'string',num2str(obj.t_end_));
                set(obj.t_end_slider,'value',obj.t_end_);
            end
        end
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.width=300;
            obj.height=300;
            
            figpos=get(obj.parent.fig,'Position');
            
            obj.fig=figure('MenuBar','none','Name','Export Pictures','units','pixels',...
                'Position',[figpos(1)+figpos(3),figpos(2)+figpos(4)-obj.height,obj.width,obj.height],'NumberTitle','off',...
                'CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            hp=uipanel('parent',obj.fig,'units','normalized','Position',[0,0,1,1]);
            
            setp=uipanel('parent',hp,'units','normalized','position',[0,0.15,1,0.85]);
            
            rangep = uipanel('parent', setp, 'units', 'normalized', 'Position', [0, 3/5, 1, 2/5]);
            uicontrol('parent',rangep,'style','text','string','Start','units','normalized',...
                'position',[0,0.6,0.1,0.3]);
            uicontrol('parent',rangep,'style','text','string','End','units','normalized',...
                'position',[0,0.1,0.1,0.3]);
            
            total_time = obj.parent.bsp.TotalTime;
            obj.t_start_edit=uicontrol('parent',rangep,'style','edit','string',num2str(obj.t_start),'units','normalized',...
                'position',[0.2,0.6,0.2,0.3],'horizontalalignment','center','callback',@(src,evts) TCallback(obj,src));
            obj.t_start_slider=uicontrol('parent',rangep,'style','slider','units','normalized',...
                'position',[0.45,0.55,0.5,0.3],'callback',@(src,evts) TCallback(obj,src),...
                'min',0,'max',total_time,'sliderstep',[1/50,1/10],'value',obj.t_start);
            obj.t_end_edit=uicontrol('parent',rangep,'style','edit','string',num2str(obj.t_end),'units','normalized',...
                'position',[0.2,0.1,0.2,0.3],'horizontalalignment','center','callback',@(src,evts) TCallback(obj,src));
            obj.t_end_slider=uicontrol('parent',rangep,'style','slider','units','normalized',...
                'position',[0.45,0.05,0.5,0.3],'callback',@(src,evts) TCallback(obj,src),...
                'min',0,'max',total_time,'sliderstep',[1/50,1/10],'value',obj.t_end);
            
            
            resp=uipanel('parent',setp,'units','normalized','Position',[0,2/5,1,1/5]);
            
            obj.res_edit=uicontrol('parent',resp,'style','edit','string',num2str(obj.res_ppi),...
                'units','normalized','position',[0.2,0.2,0.35,0.6],'callback',@(src,evt) ResCallback(obj,src));
            uicontrol('parent',resp,'style','text','string','ppi: ','units','normalized',...
                'position',[0,0.2,0.15,0.6],'fontsize',12);
            
            outp=uipanel('parent',setp,'units','normalized','position',[0,0,1,2/5],'title','Output');
            uicontrol('parent',outp,'style','text','string','Directory: ',...
                'units','normalized','position',[0,0.55,0.2,0.35]);
            obj.dest_dir_edit=uicontrol('parent',outp,'style','edit','string',obj.dest_dir,...
                'units','normalized','position',[0.2,0.55,0.6,0.35],'callback',@(src,evt)DirCallback(obj,src));
            
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
                'units','normalized','position',[0.78,0.01,0.2,0.13],...
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
        
        function ExportCallback(obj)
            %recalculating stft********************************************
            if obj.parent.NoMapFig()
                obj.parent.ComputeCallback();
            end
            
            obj.parent.PausePlay();
            %**************************************************************
            framerate=obj.parent.speed;
            step=obj.parent.JStepSpinner.getValue()/obj.parent.fs;
            obj.parent.bsp.VideoLineTime = obj.t_start;
            
            t=obj.t_start;
            fname=fullfile(obj.dest_dir,obj.filename);
            %**************************************************************
            profile=obj.format_list{obj.format};
            quality=100;
            %make a new movie figure***************************************
            mov_width=0;
            
            mov_fig=figure('Name','Movie','NumberTitle','off','Resize','off','units','pixels');
            
            delete(findobj(obj.parent.AmplitudeMapFig,'tag','mass'));
            pos=get(obj.parent.AmplitudeMapFig,'position');
            
            panel=uipanel('parent',mov_fig,'units','pixels','Position',[mov_width,45,pos(3),pos(4)]);
            mov_height=pos(4);
            mov_width=mov_width+pos(3)+10;
            
            child_axes=findobj(obj.parent.AmplitudeMapFig,'type','axes');
            child_colorbar=findobj(obj.parent.AmplitudeMapFig,'type','colorbar');
            copyobj([child_axes,child_colorbar],panel);
            
            name_panel=uipanel('parent',mov_fig,'units','pixels','position',[0,45+pos(4),mov_width,30]);
            axes('parent',name_panel,'units','normalized','position',[0,0,1,1],'xlim',[0,1],'ylim',[0,1],'visible','off');
            
            text('position',[0.5,0.5],'string',...
                get(obj.parent.AmplitudeMapFig,'name'),'FontSize',12,'HorizontalAlignment','center');
            
            
            time_panel=uipanel('parent',mov_fig,'units','pixels','position',[0,0,mov_width,45]);
            
            mov_width=mov_width-10;
            mov_height=mov_height+80;
            
            if mod(mov_width,2)==1
                mov_width=mov_width+1;
            end
            if mod(mov_height,2)==1
                mov_height=mov_height+1;
            end
            
            set(mov_fig,'position',[50,50,mov_width,mov_height]);
            set(mov_fig,'visible','off');
            
            wait_bar=waitbar(0,['Time: ',num2str(t),' s']);
            
            time_left=uicontrol('parent',wait_bar,'style','text','string','Estimated time left: 0 h 0 min 0 s',...
                'units','normalized','position',[0,0,1,0.2],...
                'backgroundcolor',get(wait_bar,'color'),'horizontalalignment','center');
            %**************************************************************
            %l: length; p: step
            writerObj = VideoWriter(fname,profile);
            writerObj.FrameRate = framerate;
            writerObj.Quality=quality;
            open(writerObj);
            
            loop_start=floor(obj.t_start/step);
            loop_end=floor(obj.t_end/step);
            
            delta_t=[];
            
            new_axes=findobj(panel,'-regexp','tag','MapAxes');
            
            for k=loop_start:loop_end
                
                tElapsed=clock;
                
                waitbar((k-loop_start)/(loop_end-loop_start),wait_bar,['Time: ',num2str(t,'%-5.2f'),' s']);
                
                delete(allchild(time_panel));
                
                new_handle=copyobj(findobj(wait_bar,'type','axes'),time_panel);
                set(new_handle,'units','normalized','position',[0.02,0.1,0.96,0.3],'FontSize',12);
                
                obj.parent.PlayNext();
                
                delete(findobj(panel,'-regexp','tag','ImageMap'));
                new_h=copyobj(findobj(obj.parent.AmplitudeMapFig,'-regexp','tag','ImageMap'),new_axes);
                uistack(new_h,'bottom')
                
                delete(findobj(panel,'-regexp','tag','peak'));
                copyobj(findobj(obj.parent.AmplitudeMapFig,'-regexp','tag','peak'),new_axes);
                
                
                t=t+step;
                F = im2frame(export_fig(mov_fig, '-nocrop',['-r',num2str(obj.res_ppi)]));
                writeVideo(writerObj,F);
                
                delta_t=cat(1,delta_t,etime(clock,tElapsed));
                
                t_left=median(delta_t)*(loop_end-k);
                hr=floor(t_left/3600);
                minu=floor(mod(t_left,3600)/60);
                sec=mod(mod(t_left,3600),60);
                set(time_left,'string',['Estimated time left: ',...
                    num2str(hr),' h ',num2str(minu),' min ',num2str(sec,'%-4.2f'),' s']);
            end
            close(wait_bar);
            close(writerObj);
            delete(mov_fig);
        end
        
        function TCallback(obj,src)
            switch src
                case obj.t_start_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        return
                    end
                    obj.t_start=min(max(get(obj.t_start_slider,'min'),t),get(obj.t_start_slider,'max'));
                    
                case obj.t_end_edit
                    
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        return
                    end
                    obj.t_end=min(max(get(obj.t_end_slider,'min'),t),get(obj.t_end_slider,'max'));
                case obj.t_start_slider
                    obj.t_start=get(src,'value');
                case obj.t_end_slider
                    obj.t_end=get(src,'value');
                case obj.t_step_slider
                    obj.t_step=get(src,'value');
                    
            end
        end
        
    end
    
end

