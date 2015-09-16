classdef ExportMovieWindow < handle
    %EXPORTPICTUREWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        valid
        fig
        smw
        
        width
        height
        
        t_start_
        t_end_
        t_step_
        
        res_ppi_
        fps_
        
        dest_dir_
        filename_
        format_
        
        
        res_edit
        t_start_edit
        t_end_edit
        t_step_edit
        t_start_slider
        t_end_slider
        t_step_slider
        
        dest_dir_edit
        dest_dir_btn
        
        filename_edit
        format_popup
        
        export_btn
        format_list
        fps_edit
    end
    
    properties(Dependent)
        t_start
        t_end
        t_step
        
        res_ppi
        
        multi_exp
        
        dest_dir
        filename
        format
        fps
    end
    
    methods
        function val=get.res_ppi(obj)
            val=obj.res_ppi_;
        end
        function set.res_ppi(obj,val)
            obj.res_ppi_=val;
            if obj.valid
                set(obj.res_edit,'string',num2str(obj.res_ppi_));
            end
        end
        
        function val=get.fps(obj)
            val=obj.fps_;
        end
        function set.fps(obj,val)
            obj.fps_=val;
            if obj.valid
                set(obj.fps_edit,'string',num2str(obj.fps_));
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
            obj.t_start_=max(0,val);
            
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
            obj.t_end_=max(0,val);
            
            if obj.t_start>obj.t_end
                obj.t_start=val;
            end
            
            
            if obj.valid
                set(obj.t_end_edit,'string',num2str(obj.t_end_));
                set(obj.t_end_slider,'value',obj.t_end_);
            end
                
        end
        
        
        
        function val=get.t_step(obj)
            val=obj.t_step_;
        end
        function set.t_step(obj,val)
            obj.t_step_=max(0,val);
            
            if obj.valid
                set(obj.t_step_edit,'string',num2str(obj.t_step_));
                set(obj.t_step_slider,'value',obj.t_step_);
            end
                
        end
    end
    
    methods
        function obj=ExportMovieWindow(smw)
            obj.valid=0;
            obj.smw=smw;
            obj.width=300;
            obj.height=280;
            
            obj.res_ppi_=150;
            obj.fps_=20;
            obj.t_start_=0;
            obj.t_end_=obj.smw.ms_before+obj.smw.ms_after;
            obj.t_step_=(obj.smw.stft_winlen-obj.smw.stft_overlap)/obj.smw.fs*1000;
            obj.dest_dir_=obj.smw.bsp.FileDir;
            obj.filename_='Untitled';
            obj.format_=1;%mp4
            
            obj.format_list={'MPEG-4','Motion JPEG AVI'};
            
        end
        
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            
            obj.valid=1;
            
            figpos=get(obj.smw.fig,'Position');
            
            obj.fig=figure('MenuBar','none','Name','Save Movies','units','pixels',...
                'Position',[figpos(1)+figpos(3),figpos(2)+figpos(4)-obj.height,obj.width,obj.height],'NumberTitle','off',...
                'CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            hp=uipanel('parent',obj.fig,'units','normalized','Position',[0,0,1,1]);
            
            setp=uipanel('parent',hp,'units','normalized','position',[0,0.1,1,0.9]);
            
            resp=uipanel('parent',setp,'units','normalized','Position',[0,5/6,1,1/6]);
            
            uicontrol('parent',resp,'style','text','string','Resolution (ppi): ',...
                'units','normalized','position',[0,0.1,0.2,0.8]);
            obj.res_edit=uicontrol('parent',resp,'style','edit','string',num2str(obj.res_ppi),...
                'units','normalized','position',[0.25,0.2,0.2,0.6],'Callback',@(src,evt) ResCallback(obj,src));
            
            
            uicontrol('parent',resp,'style','text','string','FPS: ',...
                'units','normalized','position',[0.5,0.1,0.2,0.8]);
            obj.fps_edit=uicontrol('parent',resp,'style','edit','string',num2str(obj.fps),...
                'units','normalized','position',[0.75,0.2,0.2,0.6],'Callback',@(src,evt) FPSCallback(obj,src));
        
            dp=uipanel('parent',setp,'units','normalized','position',[0,2.2/6,1,2.8/6]);
            uicontrol('parent',dp,'style','text','string','Start (ms):','units','normalized','position',[0,0.7,0.25,0.25]);
            obj.t_start_edit=uicontrol('parent',dp,'style','edit','string',num2str(obj.t_start),...
                'units','normalized','position',[0.25,0.7,0.2,0.25],'callback',@(src,evt) TCallback(obj,src));
            obj.t_start_slider=uicontrol('parent',dp,'style','slider','units','normalized',...
                'position',[0.5,0.7,0.45,0.25],...
                'value',obj.t_start,'min',0,'max',obj.smw.ms_before+obj.smw.ms_after,...
                'sliderstep',[0.01,0.05],'callback',@(src,evt) TCallback(obj,src));
            
            uicontrol('parent',dp,'style','text','string','End (ms):','units','normalized','position',[0,0.4,0.25,0.25]);
            obj.t_end_edit=uicontrol('parent',dp,'style','edit','string',num2str(obj.t_end),...
                'units','normalized','position',[0.25,0.4,0.2,0.25],'callback',@(src,evt) TCallback(obj,src));
            obj.t_end_slider=uicontrol('parent',dp,'style','slider','units','normalized',...
                'position',[0.5,0.4,0.45,0.25],...
                'value',obj.t_end,'min',0,'max',obj.smw.ms_before+obj.smw.ms_after,...
                'sliderstep',[0.01,0.05],'callback',@(src,evt) TCallback(obj,src));
            
            uicontrol('parent',dp,'style','text','string','Step (ms):','units','normalized','position',[0,0.05,0.25,0.25]);
            obj.t_step_edit=uicontrol('parent',dp,'style','edit','string',num2str(obj.t_step),...
                'units','normalized','position',[0.25,0.05,0.2,0.25],'callback',@(src,evt) TCallback(obj,src));
            obj.t_step_slider=uicontrol('parent',dp,'style','slider','units','normalized',...
                'position',[0.5,0.05,0.45,0.25],...
                'value',obj.t_step,'min',(obj.smw.stft_winlen-obj.smw.stft_overlap)/obj.smw.fs*1000,'max',obj.smw.ms_before+obj.smw.ms_after,...
                'sliderstep',[0.01,0.05],'callback',@(src,evt) TCallback(obj,src));
            
            outp=uipanel('parent',setp,'units','normalized','position',[0,0,1,2.2/6],'title','Output');
            uicontrol('parent',outp,'style','text','string','Directory: ',...
                'units','normalized','position',[0,0.55,0.2,0.35]);
            obj.dest_dir_edit=uicontrol('parent',outp,'style','edit','string',obj.dest_dir,...
                'units','normalized','position',[0.2,0.55,0.6,0.35]);
            
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
            
            obj.export_btn=uicontrol('parent',hp,'style','pushbutton','string','Save',...
                'units','normalized','position',[0.78,0.01,0.2,0.08],...
                'callback',@(src,evt) ExportCallback(obj));
        end
        
        function OnClose(obj)
            obj.valid=0;
            
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
        end
        
        function TCallback(obj,src)
            switch src
                case obj.t_start_edit
                    tmp=str2double(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    obj.t_start=min(tmp,obj.smw.ms_before+obj.smw.ms_after);
                    
                case obj.t_end_edit
                    
                    tmp=str2double(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    obj.t_end=min(tmp,obj.smw.ms_before+obj.smw.ms_after);
                case obj.t_step_edit
                    tmp=str2double(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    obj.t_step=min(obj.smw.ms_before+obj.smw.ms_after,...
                        max(tmp,(obj.smw.stft_winlen-obj.smw.stft_overlap)/obj.smw.fs*1000));
                case obj.t_start_slider
                    obj.t_start=get(src,'value');
                case obj.t_end_slider
                    obj.t_end=get(src,'value');
                case obj.t_step_slider
                    obj.t_step=get(src,'value');
                    
            end
        end
        
        function DirCallback(obj)
        end
        
        function FormatCallback(obj,src)
            obj.format_=get(src,'value');
        end
        
        function FileNameCallback(obj,src)
            
            obj.filename_=get(src,'string');
        end
        
        function ExportCallback(obj)
            profile=obj.format_list{obj.format};            %recalculating stft********************************************
            if obj.smw.NoSpatialMapFig()
                obj.smw.ComputeCallback();
            end
            %**************************************************************
            %             profile='Motion JPEG AVI';
            framerate=obj.fps;
            quality=100;
            %             t_start=500; %ms

            %**************************************************************
            
            set(obj.smw.act_start_slider,'value',obj.t_start);
            step=obj.t_step;
            
            t=obj.t_start;
            %make a new movie figuer***************************************
            mov_width=0;
            mov_height=0;
            
            
            mov_fig=figure('Name','Movie','NumberTitle','off','Resize','off','units','pixels');
            panel=zeros(length(obj.smw.SpatialMapFig),1);
            
            for i=1:length(obj.smw.SpatialMapFig)
                delete(findobj(obj.smw.SpatialMapFig(i),'tag','mass'));
                pos=get(obj.smw.SpatialMapFig(i),'position');
                
                
                panel(i)=uipanel('parent',mov_fig,'units','pixels','Position',[mov_width,45,pos(3),pos(4)]);
                mov_height=pos(4);
                mov_width=mov_width+pos(3)+10;
                
                child_axes=findobj(obj.smw.SpatialMapFig(i),'type','axes');
                for m=1:length(child_axes)
                    newh=copyobj(child_axes(m),panel(i));
                    set(newh,'position',get(child_axes(m),'position'));
                end
            end
            name_panel=uipanel('parent',mov_fig,'units','pixels','position',[0,45+pos(4),mov_width,30]);
            axes('parent',name_panel,'units','normalized','position',[0,0,1,1],'xlim',[0,1],'ylim',[0,1],'visible','off');
            for i=1:length(obj.smw.SpatialMapFig)
                text('position',[(2*i-1)/(2*length(obj.smw.SpatialMapFig)),0.5],'string',...
                    get(obj.smw.SpatialMapFig(i),'name'),'FontSize',12,'HorizontalAlignment','center');
                %                 uicontrol('style','text','string',get(obj.SpatialMapFig(i),'name'),...
                %                     'units','normalized','position',...
                %                     [(2*i-2)/(2*length(obj.SpatialMapFig)),0.2,1/length(obj.SpatialMapFig),0.6],...
                %                     'FontSize',12,'HorizontalAlignment','center');
                
            end
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
            
            if obj.smw.data_input~=1
                wait_bar=waitbar(0,['Time: ',num2str(-obj.smw.ms_before),' ms']);
            else
                wait_bar=waitbar(0,['Time: ','0',' ms']);
            end
            
            time_left=uicontrol('parent',wait_bar,'style','text','string','Estimated time left: 0 h 0 min 0 s',...
                'units','normalized','position',[0,0,1,0.2],...
                'backgroundcolor',get(wait_bar,'color'),'horizontalalignment','center');
            %**************************************************************
            
            fname=fullfile(obj.dest_dir,obj.filename);
            writerObj = VideoWriter(fname,profile);
            writerObj.FrameRate = framerate;
            writerObj.Quality=quality;
            open(writerObj);
            
            loop_start=floor(obj.t_start/step);
            loop_end=floor(obj.t_end/step);
            
            if obj.smw.center_mass
                obj.smw.center_mass_=3;
            end
            
            delta_t=[];
            
            loops=floor((obj.smw.ms_before+obj.smw.ms_after)/step);
            
            for k=loop_start:loop_end
                
                tElapsed=clock;
                
                if obj.smw.data_input~=1
                    waitbar(k/loops,wait_bar,['Time: ',num2str(t-obj.smw.ms_before),' ms']);
                else
                    waitbar(k/loops,wait_bar,['Time: ',num2str(t),' ms']);
                end
                
                delete(allchild(time_panel));
                
                new_handle=copyobj(findobj(wait_bar,'type','axes'),time_panel);
                set(new_handle,'units','normalized','position',[0.02,0.1,0.96,0.3],'FontSize',12);
                
                set(obj.smw.act_start_slider,'value',t);
                obj.smw.ActCallback(obj.smw.act_start_slider);
                for i=1:length(obj.smw.SpatialMapFig)
                    delete(findobj(panel(i),'-regexp','tag','SpatialMapAxes'));
                    child_axes=findobj(obj.smw.SpatialMapFig(i),'-regexp','tag','SpatialMapAxes');
                    newh=copyobj(child_axes,panel(i));
                    set(newh,'position',get(child_axes,'position'));
                end
                
                t=t+step;
                F = im2frame(export_fig(mov_fig, '-nocrop',['-r',num2str(obj.res_ppi)]));
                writeVideo(writerObj,F);
                
                delta_t=cat(1,delta_t,etime(clock,tElapsed));
                
                t_left=median(delta_t)*(loop_end-k);
                hr=floor(t_left/3600);
                minu=floor(mod(t_left,3600)/60);
                sec=mod(mod(t_left,3600),60);
                set(time_left,'string',['Estimated time left: ',...
                    num2str(hr),' h ',num2str(minu),' min ',num2str(sec),' s']);
            end
            close(wait_bar);
            close(writerObj);
            delete(mov_fig);
            
            obj.smw.center_mass_=get(obj.smw.center_mass_radio,'value');
        end
        
        function ResCallback(obj,src)
            tmp=round(str2double(get(src,'string')));
            if ~isnan(tmp)
                obj.res_ppi=tmp;
            end
        end
        
        
        function FPSCallback(obj,src)
            tmp=round(str2double(get(src,'string')));
            if ~isnan(tmp)
                obj.fps=tmp;
            end
        end
    end
    
end

