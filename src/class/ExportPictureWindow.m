classdef ExportPictureWindow < handle
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
        multi_exp_
        dest_dir_
        filename_
        format_
        
        multi_exp_radio
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
        
        function val=get.multi_exp(obj)
            val=obj.multi_exp_;
        end
        
        function set.multi_exp(obj,val)
            obj.multi_exp_=val;
            if obj.valid
                set(obj.multi_exp_radio,'value',obj.multi_exp_);
                
                if obj.multi_exp_
                    onoff='on';
                else
                    onoff='off';
                    obj.t_start=obj.smw.act_start;
                    obj.t_end=obj.smw.act_start;
                end
                
                set(obj.t_start_edit,'enable',onoff);
                set(obj.t_end_edit,'enable',onoff);
                set(obj.t_start_slider,'enable',onoff);
                set(obj.t_end_slider,'enable',onoff);
                set(obj.t_step_edit,'enable',onoff);
                set(obj.t_step_slider,'enable',onoff);
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
        function obj=ExportPictureWindow(smw)
            obj.valid=0;
            obj.smw=smw;
            obj.width=300;
            obj.height=280;
            
            obj.multi_exp_=0;
            obj.res_ppi_=300;
            obj.t_start_=get(obj.smw.act_start_slider,'min');
            obj.t_end_=get(obj.smw.act_start_slider,'max');
            obj.t_step_=(obj.smw.stft_winlen-obj.smw.stft_overlap)/obj.smw.fs*1000;
            obj.dest_dir_=obj.smw.bsp.FileDir;
            obj.filename_='Untitled';
            obj.format_=1;%png
            
            obj.format_list={'png','jpg','eps'};
            
        end
        
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            
            obj.valid=1;
            
            figpos=get(obj.smw.fig,'Position');
            
            obj.fig=figure('MenuBar','none','Name','Save Pictures','units','pixels',...
                'Position',[figpos(1)+figpos(3),figpos(2)+figpos(4)-obj.height,obj.width,obj.height],'NumberTitle','off',...
                'CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            hp=uipanel('parent',obj.fig,'units','normalized','Position',[0,0,1,1]);
            
            setp=uipanel('parent',hp,'units','normalized','position',[0,0.1,1,0.9]);
            
            resp=uipanel('parent',setp,'units','normalized','Position',[0,5/6,1,1/6]);
            
            obj.multi_exp_radio=uicontrol('parent',resp,'style','radiobutton','string','Series Save',...
                'units','normalized','position',[0,0.1,0.5,0.8],'value',obj.multi_exp,...
                'callback',@(src,evt) MultiExpCallback(obj,src));
            obj.res_edit=uicontrol('parent',resp,'style','edit','string',num2str(obj.res_ppi),...
                'units','normalized','position',[0.5,0.2,0.35,0.6],'callback',@(src,evt) ResCallback(obj,src));
            uicontrol('parent',resp,'style','text','string','ppi','units','normalized',...
            'position',[0.85,0.2,0.15,0.6],'fontsize',12);
        
            dp=uipanel('parent',setp,'units','normalized','position',[0,2.2/6,1,2.8/6]);
            uicontrol('parent',dp,'style','text','string','Start (ms):','units','normalized','position',[0,0.7,0.25,0.25]);
            obj.t_start_edit=uicontrol('parent',dp,'style','edit','string',num2str(obj.t_start),...
                'units','normalized','position',[0.25,0.7,0.2,0.25],'callback',@(src,evt) TCallback(obj,src));
            obj.t_start_slider=uicontrol('parent',dp,'style','slider','units','normalized',...
                'position',[0.5,0.7,0.45,0.25],...
                'value',obj.t_start,'min',get(obj.smw.act_start_slider,'min'),'max',get(obj.smw.act_start_slider,'max'),...
                'sliderstep',[0.01,0.05],'callback',@(src,evt) TCallback(obj,src));
            
            uicontrol('parent',dp,'style','text','string','End (ms):','units','normalized','position',[0,0.4,0.25,0.25]);
            obj.t_end_edit=uicontrol('parent',dp,'style','edit','string',num2str(obj.t_end),...
                'units','normalized','position',[0.25,0.4,0.2,0.25],'callback',@(src,evt) TCallback(obj,src));
            obj.t_end_slider=uicontrol('parent',dp,'style','slider','units','normalized',...
                'position',[0.5,0.4,0.45,0.25],...
                'value',obj.t_end,'min',get(obj.smw.act_start_slider,'min'),'max',get(obj.smw.act_start_slider,'max'),...
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
            
            obj.multi_exp=obj.multi_exp_;
        end
        
        function OnClose(obj)
            obj.valid=0;
            
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
        end
        
        function MultiExpCallback(obj,src)
            obj.multi_exp=get(src,'value');
        end
        
        function TCallback(obj,src)
            switch src
                case obj.t_start_edit
                    tmp=str2double(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    obj.t_start=min(max(get(obj.smw.act_start_slider,'min'),t),get(obj.smw.act_start_slider,'max'));
                    
                case obj.t_end_edit
                    
                    tmp=str2double(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    obj.t_end=min(max(get(obj.smw.act_start_slider,'min'),t),get(obj.smw.act_start_slider,'max'));
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
            pic_format=obj.format_list{obj.format};
            
            wait_bar_h = waitbar(0,'Saving Pictures...');
            if obj.multi_exp
                for t=obj.t_start:obj.t_step:obj.t_end
                    waitbar((t-obj.t_start)/(obj.t_end-obj.t_start));
                    set(obj.smw.act_start_edit,'string',num2str(t));
                    obj.smw.ActCallback(obj.smw.act_start_edit)
                    for i=1:length(obj.smw.SpatialMapFig)
                        figname=get(obj.smw.SpatialMapFig(i),'Name');
                        fname=fullfile(obj.dest_dir,[obj.filename,'_',figname,'_',num2str(t)]);
                        
                        set(obj.smw.SpatialMapFig(i),'color','white');
                        export_fig(obj.smw.SpatialMapFig(i),['-',pic_format],'-nocrop','-opengl',['-r',num2str(obj.res_ppi)],fname);
                    end
                end
            
            else
                t=obj.smw.act_start;
                for i=1:length(obj.smw.SpatialMapFig)
                    waitbar(i/length(obj.smw.SpatialMapFig));
                    figname=get(obj.smw.SpatialMapFig(i),'Name');
                    fname=fullfile(obj.dest_dir,[obj.filename,'_',figname,'_',num2str(t)]);
                    
                    set(obj.smw.SpatialMapFig(i),'color','white');
                    export_fig(obj.smw.SpatialMapFig(i),['-',pic_format],'-nocrop','-opengl',['-r',num2str(obj.res_ppi)],fname);
                end
            end
            close(wait_bar_h);
        end
        
        function ResCallback(obj,src)
            tmp=round(str2double(get(src,'string')));
            if ~isnan(tmp)
                obj.res_ppi=tmp;
            end
        end
        
    end
    
end

