classdef AmplitudeMapWindow < handle
    %AmplitudeMapWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    properties
        bsp
        fig
        AmplitudeMapFig
        
        compute_btn
        
        width
        height
        
        color_bar_
        interp_missing_
        contact_
        disp_channel_names_
        
        color_bar_radio
        contact_radio
        names_radio
        interp_missing_radio
        JTogPlay
        JBtnPlayBack
        JBtnPlayForward
        Toolbar
        JToolbar
        JSpeedSpinner
        JStepSpinner
        
        JSmoothRowSpinner
        JSmoothColSpinner
        
        pos_x
        pos_y
        radius
        
        all_chan_pos
        all_chan_names
        chan_names
        interp_scatter
        
        advance_menu
        map_menu
        map_interp_menu
        map_scatter_menu
        
        channel_sel
        dataset_sel
        resize
        speed_
        VideoTimer
        VideoTimerPeriod_
        
        JColorMapPopup
        JMaxSpinner
        JMinSpinner
        
        extrap_radio
        
        cmax_
        cmin_
        extrap_
        smooth_row_
        smooth_col_
    end
    
    properties (Dependent)
        valid
        fs
        fig_w
        fig_h
        color_bar
        interp_missing
        contact
        disp_channel_names
        speed
        VideoTimerPeriod
        cmax
        cmin
        extrap
        smooth_row
        smooth_col
    end
    
    methods
        function obj=AmplitudeMapWindow(bsp)
            obj.bsp=bsp;
            varinitial(obj);
            addlistener(obj.bsp,'VideoLineChange',@(src,evt) UpdateFigure(obj,[]));
        end
        function varinitial(obj)
            obj.interp_missing_=0;
            obj.color_bar_=0;
            obj.contact_=1;
            obj.disp_channel_names_=0;
            obj.interp_scatter='interp';
            obj.width=300;
            obj.resize=1;
            obj.height=300;
            obj.VideoTimerPeriod_=0.1;
            obj.cmin_=0;
            obj.cmax_=1;
            obj.speed_=10;
            obj.extrap_ = 0;
            obj.smooth_row_ = 4;
            obj.smooth_col_ = 4;
            
        end
        
        function buildfig(obj)
            import javax.swing.JSpinner;
            import javax.swing.SpinnerNumberModel;
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.fig=figure('MenuBar','none','Name','Amplitude Map','units','pixels',...
                'Position',[100 100 300 500],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));
            obj.advance_menu=uimenu(obj.fig,'label','Settings');
            obj.map_menu=uimenu(obj.advance_menu,'label','Visualization');
            obj.map_interp_menu=uimenu(obj.map_menu,'label','Interpolate','callback',@(src,evt) InterpScatterCallback(obj,src));
            obj.map_scatter_menu=uimenu(obj.map_menu,'label','Scatter','callback',@(src,evt) InterpScatterCallback(obj,src));
            
            hp_clim=uipanel('parent',obj.fig,'title','Scale','units','normalized','position',[0,0.85,1,0.15]);
            %volume colormap
            uicontrol('parent',hp_clim,'style','text','units','normalized','position',[0,0.5,0.25,0.5],...
                'string','Colormap','horizontalalignment','left','fontunits','normalized','fontsize',0.35);
            obj.JColorMapPopup = colormap_popup('Parent',hp_clim,'units','normalized','position',[0.25,0.5,0.75,0.5]);
            set(obj.JColorMapPopup,'Value',4,'Callback',@(src,evt)ColormapCallback(obj));
            %%
            % color data limit
            uicontrol('parent',hp_clim,'style','text','units','normalized','position',[0,0,0.12,0.5],...
                'string','Min','horizontalalignment','left','fontunits','normalized','fontsize',0.35);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmin),[],[],java.lang.Double(0.1)));
            obj.JMinSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JMinSpinner,[0,0,1,1],hp_clim);
            set(gh,'Units','Norm','Position',[0.12,0,0.35,0.5]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ScaleSpinnerCallback(obj));
            
            uicontrol('parent',hp_clim,'style','text','units','normalized','position',[0.5,0,0.12,0.5],...
                'string','Max','horizontalalignment','left','fontunits','normalized','fontsize',0.35);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmax),[],[],java.lang.Double(0.1)));
            obj.JMaxSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JMaxSpinner,[0,0,1,1],hp_clim);
            set(gh,'Units','Norm','Position',[0.62,0,0.35,0.5]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ScaleSpinnerCallback(obj));

            hp_smooth=uipanel('parent',obj.fig,'title','Smooth','units','normalized','position',[0,0.74,1,0.1]);
            % color data limit
            uicontrol('parent',hp_smooth,'style','text','units','normalized','position',[0,0,0.1,0.8],...
                'string','Row','horizontalalignment','left','fontunits','normalized','fontsize',0.35);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.smooth_row),java.lang.Double(0.0),[],java.lang.Double(2)));
            obj.JSmoothRowSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JSmoothRowSpinner,[0,0,1,1],hp_smooth);
            set(gh,'Units','Norm','Position',[0.12,0.05,0.35,0.9]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) SmoothSpinnerCallback(obj, gh));
            
            uicontrol('parent',hp_smooth,'style','text','units','normalized','position',[0.5,0,0.1,0.8],...
                'string','Col','horizontalalignment','left','fontunits','normalized','fontsize',0.35);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.smooth_col),java.lang.Double(0),[],java.lang.Double(2)));
            obj.JSmoothColSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JSmoothColSpinner,[0,0,1,1],hp_smooth);
            set(gh,'Units','Norm','Position',[0.62,0.05,0.35,0.9]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) SmoothSpinnerCallback(obj, gh));
            
            
            setgp=uitabgroup(obj.fig,'units','normalized','position',[0,0.06,1,0.3]);
            disp_tab=uitab(setgp,'title','Display');
            obj.color_bar_radio=uicontrol('parent',disp_tab,'style','radiobutton','string','Color Bar',...
                'units','normalized','position',[0,0.66,0.45,0.33],'value',obj.color_bar,...
                'callback',@(src,evts) ColorBarCallback(obj,src));
            
            obj.contact_radio=uicontrol('parent',disp_tab,'style','radiobutton','string','Contact',...
                'units','normalized','position',[0,0.33,0.45,0.33],'value',obj.contact,...
                'callback',@(src,evts) ContactCallback(obj,src));
            
            obj.names_radio=uicontrol('parent',disp_tab,'style','radiobutton','string','Channel Names',...
                'units','normalized','position',[0,0,0.45,0.33],'value',obj.disp_channel_names,...
                'callback',@(src,evts) ChannelNamesCallback(obj,src));
            
            obj.interp_missing_radio=uicontrol('parent',disp_tab,'style','radiobutton','string','Interpolate Missing',...
                'units','normalized','position',[0.5,0.66,0.45,0.33],'value',obj.interp_missing,...
                'callback',@(src,evts) InterpMissingCallback(obj,src));
            
            obj.extrap_radio=uicontrol('parent',disp_tab,'style','radiobutton','string','Extrapolate',...
                'units','normalized','position',[0.5,0.33,0.45,0.33],'value',obj.extrap_,...
                'callback',@(src,evts) ExtrapolateCallback(obj,src));
            
            obj.compute_btn=uicontrol('parent',obj.fig,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.01,0.2,0.04],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            obj.Toolbar=uitoolbar(obj.fig);
            drawnow
            obj.JToolbar=get(get(obj.Toolbar,'JavaContainer'),'ComponentPeer');
            obj.makeToolbar();
            obj.VideoTimer = timer('TimerFcn',@ (src,evts) PlayAmplitudeMap(obj),...
                'ExecutionMode','fixedRate','BusyMode','queue','period',obj.VideoTimerPeriod_);
            obj.ComputeCallback();
        end
        
        function makeToolbar(obj)
            import src.java.PushButton;
            import src.java.TogButton;
            import src.java.ToolbarSpinner;
            import javax.swing.ButtonGroup;
            import javax.swing.SpinnerNumberModel;
            import javax.swing.JComponent;
            import javax.swing.JLabel;
            
            d=obj.JToolbar.getPreferredSize();
            btn_d=java.awt.Dimension();
            btn_d.width=d.height;
            btn_d.height=d.height;
            
            spinner_d=java.awt.Dimension();
            spinner_d.width=d.height*2.5;
            spinner_d.height=d.height;
            
            col=obj.JToolbar.getBackground();
            
            obj.JBtnPlayBack=javaObjectEDT(PushButton([obj.bsp.cnelab_path,'/db/icon/slower.png'],btn_d,char('Previous Step'),col));
            set(handle(obj.JBtnPlayBack,'CallbackProperties'),'MousePressedCallback',@(h,e) PlayBack(obj));
            obj.JToolbar.add(obj.JBtnPlayBack);
            
            obj.JTogPlay=javaObjectEDT(PushButton([obj.bsp.cnelab_path,'/db/icon/play.png'],btn_d,char('Start'),col));
            set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StartPlay(obj));
            obj.JToolbar.add(obj.JTogPlay);
            
            
            obj.JBtnPlayForward=javaObjectEDT(PushButton([obj.bsp.cnelab_path,'/db/icon/faster.png'],btn_d,char('Next Step'),col));
            set(handle(obj.JBtnPlayForward,'CallbackProperties'),'MousePressedCallback',@(h,e) PlayNext(obj));
            obj.JToolbar.add(obj.JBtnPlayForward);
            
            label = javaObjectEDT(JLabel(' FPS '));
            
            obj.JToolbar.add(label);
            
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Integer(obj.speed_),java.lang.Integer(1),java.lang.Integer(100),java.lang.Integer(1)));
            obj.JSpeedSpinner =javaObjectEDT(ToolbarSpinner(model));
            
            obj.JToolbar.add(obj.JSpeedSpinner);
            
            obj.JSpeedSpinner.setMaximumSize(spinner_d);
            obj.JSpeedSpinner.setMinimumSize(spinner_d);
            obj.JSpeedSpinner.setPreferredSize(spinner_d);
            % obj.JChannelNumberSpinner.getEditor().getTextField().setColumns(1);
            set(handle(obj.JSpeedSpinner,'CallbackProperties'),...
                'StateChangedCallback',@(h,e) SpeedSpinnerCallback(obj));
            
            label = javaObjectEDT(JLabel(' Step '));
            
            obj.JToolbar.add(label);
            
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Integer(obj.speed_),java.lang.Integer(1),java.lang.Integer(100),java.lang.Integer(1)));
            obj.JStepSpinner =javaObjectEDT(ToolbarSpinner(model));
            
            obj.JToolbar.add(obj.JStepSpinner);
            
            obj.JStepSpinner.setMaximumSize(spinner_d);
            obj.JStepSpinner.setMinimumSize(spinner_d);
            obj.JStepSpinner.setPreferredSize(spinner_d);
            % obj.JChannelNumberSpinner.getEditor().getTextField().setColumns(1);
            set(handle(obj.JStepSpinner,'CallbackProperties'));
            
            obj.JToolbar.addSeparator();
            
            obj.JToolbar.repaint;
            obj.JToolbar.revalidate;
        end
        
        function val=get.VideoTimerPeriod(obj)
            val=obj.VideoTimerPeriod_;
        end
        function set.VideoTimerPeriod(obj,val)
            obj.VideoTimerPeriod_=val;
            set(obj.VideoTimer,'period',val);
        end
        function val = get.speed(obj)
            val=obj.speed_;
        end
        function set.speed(obj,val)
            obj.speed_=val;
            obj.JSpeedSpinner.setValue(java.lang.Integer(val));
%             obj.JSpeedSpinner.getModel().setStepSize((1,java.lang.Integer(val/5)));
        end
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
            
            h = obj.AmplitudeMapFig;
            if ishandle(h)
                delete(h);
            end
        end
        function StartPlay(obj)
            obj.JTogPlay.setIcon(obj.bsp.IconPause);
            set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) PausePlay(obj));
            if strcmpi(obj.VideoTimer.Running,'off')
                start(obj.VideoTimer);
            end
        end
        
        function PausePlay(obj)
            obj.JTogPlay.setIcon(obj.bsp.IconPlay);
            set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StartPlay(obj));
            if strcmpi(obj.VideoTimer.Running,'on')
                stop(obj.VideoTimer);
            end
        end
        function KeyPress(obj,src,evt)
            
        end
        
        function val = get.smooth_row(obj)
            val = obj.smooth_row_;
        end
        function set.smooth_row(obj, val)
            obj.smooth_row_=val;
            if obj.valid
                obj.JSmoothRowSpinner.setValue(java.lang.Double(val));
                drawnow
            end
        end
        function val = get.smooth_col(obj)
            val = obj.smooth_col_;
        end
        function set.smooth_col(obj,val)
            obj.smooth_col_=val;
            if obj.valid
                obj.JSmoothColSpinner.setValue(java.lang.Double(val));
                drawnow
            end
        end
        
        function val=get.extrap(obj)
            if obj.extrap_
                val = 'linear';
            else
                val = 'none';
            end
        end
        
        function set.extrap(obj,val)
            obj.extrap_=val;
            if obj.valid
                set(obj.extrap_radio,'value',val);
            end
        end
        
        function val=get.interp_missing(obj)
            val=obj.interp_missing_;
        end
        
        function set.interp_missing(obj,val)
            obj.interp_missing_=val;
            if obj.valid
                set(obj.interp_missing_radio,'value',val);
            end
        end
        
        function val=get.contact(obj)
            val=obj.contact_;
        end
        
        function set.contact(obj,val)
            obj.contact_=val;
            
            if obj.valid
                set(obj.contact_radio,'value',val);
            end
        end
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isgraphics(obj.fig);
            catch
                val=0;
            end
        end
        function val=get.color_bar(obj)
            val=obj.color_bar_;
        end
        function set.color_bar(obj,val)
            obj.color_bar_=val;
            if obj.valid
                set(obj.color_bar_radio,'value',val);
            end
        end
        function val=get.fs(obj)
            val=obj.bsp.SRate;
        end
        function val=get.fig_w(obj)
            if obj.color_bar
                val=obj.width+100/400*obj.width;
            else
                val=obj.width+20/400*obj.width;
            end
        end
        
        function val=get.fig_h(obj)
            val=obj.height+30/300*obj.height;
        end
        function val=get.disp_channel_names(obj)
            val=obj.disp_channel_names_;
        end
        
        function set.disp_channel_names(obj,val)
            obj.disp_channel_names_=val;
            if obj.valid
                set(obj.names_radio,'value',val);
            end
        end
        
        function val=get.cmin(obj)
            val=obj.cmin_;
        end
        function val=get.cmax(obj)
            val=obj.cmax_;
        end
        
        function set.cmin(obj,val)
            if(val>obj.cmax)
                return
            end
            obj.cmin_=val;
            if obj.valid
                obj.JMinSpinner.setValue(java.lang.Double(val));
                obj.JMinSpinner.getModel().setStepSize(java.lang.Double(abs(val)/10));
            end
            drawnow
        end
        
        function set.cmax(obj,val)
            if(val<obj.cmin)
                return
            end
            obj.cmax_=val;
            if obj.valid
                obj.JMaxSpinner.setValue(java.lang.Double(val));
                obj.JMaxSpinner.getModel().setStepSize(java.lang.Double(abs(val)/10));
            end
            drawnow
        end
        
        function [map_mapv,map_pos,mapv,chanpos,channames,allchanpos,allchannames]=get_data_info(obj)
            omitMask=true;
            [chanNames,dataset,channel,~,~,~,chanpos]=get_selected_datainfo(obj.bsp,omitMask);
            if isempty(chanpos)||any(all(isnan(chanpos(:,1:2))))
                errordlg('No channel position in the data !');
                map_mapv = [];
                map_pos = [];
                mapv = [];
                chanpos = [];
                channames = [];
                allchanpos = [];
                allchannames = [];
                return
            end
            
            chanind=~isnan(chanpos(:,1))&~isnan(chanpos(:,2));
            
            channames=chanNames(chanind);
            chanpos=chanpos(chanind,:);
            dataset=dataset(chanind);
            channel=channel(chanind);
            
            mapv=zeros(size(channel));
            nt=min(max(floor((obj.bsp.VideoLineTime-obj.bsp.BufferTime)*obj.fs),1),size(obj.bsp.PreprocData{1},1));
            for i=1:length(channel)
                mapv(i)=obj.bsp.PreprocData{dataset(i)}(nt,channel(i));
            end
            
            [chanpos(:,1),chanpos(:,2),chanpos(:,3),obj.width,obj.height] = ...
                get_relative_chanpos(chanpos(:,1),chanpos(:,2),chanpos(:,3),obj.width,obj.height);
            
            %select all channels including masks
            [allchannames,~,~,~,~,~,allchanpos]=get_selected_datainfo(obj.bsp);
            chanind=~isnan(allchanpos(:,1))&~isnan(allchanpos(:,2));
            allchanpos=allchanpos(chanind,:);
            allchannames=allchannames(chanind);
            
            [allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),~,~] = ...
                get_relative_chanpos(allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.width,obj.height);
            
            if obj.interp_missing
                map_pos=chanpos;
                map_mapv=mapv;
            else
                map_pos=allchanpos;
                map_mapv=zeros(size(allchannames));
                %default to zeros
                ind=ismember(allchannames,channames);
                map_mapv(ind)=mapv;
            end
            
            obj.pos_x=chanpos(:,1);
            obj.pos_y=chanpos(:,2);
            obj.radius=chanpos(:,3);
            
            obj.all_chan_pos=allchanpos;
            obj.all_chan_names=allchannames;
            obj.chan_names=channames;
        end
        
        function ComputeCallback(obj)
            [map_mapv,map_pos,mapv,chanpos,~,allchanpos,~]=obj.get_data_info;
            if isempty(map_mapv)
                return
            end
            %draw things
            
            delete(obj.AmplitudeMapFig(ishandle(obj.AmplitudeMapFig)));
            NewAmplitudeMapFig(obj);
            
            obj.cmin=min(map_mapv);
            obj.cmax=max(map_mapv);
            
            spatialmap_grid(obj.AmplitudeMapFig,map_mapv,obj.interp_scatter,...
                map_pos(:,1),map_pos(:,2),obj.width,obj.height,obj.cmin,obj.cmax,obj.color_bar,1, ...
                obj.extrap, obj.smooth_row, obj.smooth_col);
            ColormapCallback(obj);
            h=findobj(obj.AmplitudeMapFig,'-regexp','tag','MapAxes');
            
            if obj.contact||strcmp(obj.interp_scatter,'scatter')
                if obj.disp_channel_names
                    channames=obj.all_chan_names;
                else
                    channames=[];
                end
                
                if strcmp(obj.interp_scatter,'scatter')
                    plot_contact(h,mapv,allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.height,obj.width,channames,...
                        ~ismember(allchanpos,chanpos,'rows'));
                else
                    plot_contact(h,[],allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.height,obj.width,channames,...
                        ~ismember(allchanpos,chanpos,'rows'));
                end
            end
            
        end
        function UpdateFigure(obj,src)
            if ~NoMapFig(obj)
                [map_mapv,map_pos,mapv,chanpos,~,~,~]=obj.get_data_info;
                
                if obj.disp_channel_names
                    channames=obj.all_chan_names;
                else
                    channames=[];
                end
                h=findobj(obj.AmplitudeMapFig,'-regexp','Tag','MapAxes');
                if ~isempty(h)
                    imagehandle=findobj(h,'Tag','ImageMap');
                    
                    if strcmp(obj.interp_scatter,'interp')
                        [x,y]=meshgrid((1:obj.width)/obj.width,(1:obj.height)/obj.height);
                        F= scatteredInterpolant(map_pos(:,1),map_pos(:,2),map_mapv(:),'natural', obj.extrap);
                        mapvq=F(x,y);
                        if ~isempty(obj.smooth_row) && ~isempty(obj.smooth_col)
                                mapvq = smooth2a(mapvq, obj.smooth_row, obj.smooth_col);
                        end
                            
                        if isempty(imagehandle)
                            spatialmap_grid(obj.AmplitudeMapFig,map_mapv,obj.interp_scatter,...
                                map_pos(:,1),map_pos(:,2),obj.width,obj.height,obj.min_clim,obj.max_clim,obj.color_bar,obj.resize, ...
                                obj.extrap, obj.smooth_row, obj.smooth_col);
                            h=findobj(obj.AmplitudeMapFig,'-regexp','Tag','MapAxes');
                        else
                            set(imagehandle,'CData',single(mapvq),'visible','on');
                            set(imagehandle, 'AlphaData', ~isnan(mapvq))
                        end
                        
                        if ismember(src,[obj.map_interp_menu,obj.map_scatter_menu])
                            delete(findobj(h,'Tag','contact'));
                            delete(findobj(h,'Tag','names'));
                            plot_contact(h,[],obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,channames,...
                                ~ismember(obj.all_chan_pos,chanpos,'rows'));
                        end
                    else
                        
                        set(imagehandle,'visible','off');
                        
                        delete(findobj(h,'Tag','contact'));
                        delete(findobj(h,'Tag','names'));
                        plot_contact(h,mapv,obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,channames,...
                            ~ismember(obj.all_chan_pos,chanpos,'rows'));
                    end
                    
                    %                     try
                    %                         set(h,'clim',[obj.min_clim,obj.max_clim]);
                    %                     catch
                    %                     end
                    
                    %                     set(h,'xlim',[1,obj.width]);
                    %                     set(h,'ylim',[1,obj.height]);
                    drawnow
                end
            end
        end
        
        function NewAmplitudeMapFig(obj)
            fpos=get(obj.fig,'position');
            
            obj.AmplitudeMapFig=[];
            obj.AmplitudeMapFig=figure('Name','Raw Map','NumberTitle','off',...
                'units','pixels','position',[fpos(1)+fpos(3)+20,fpos(2),obj.fig_w,obj.fig_h],'Resize','off',...
                'doublebuffer','off','Tag','Act');
        end
        function val=NoMapFig(obj)
            val=isempty(obj.AmplitudeMapFig)||~all(ishandle(obj.AmplitudeMapFig))||~all(strcmpi(get(obj.AmplitudeMapFig,'Tag'),'Act'));
        end
        
        function ColorBarCallback(obj,src)
            obj.color_bar_=get(src,'value');
            if ~NoMapFig(obj)
                for i=1:length(obj.AmplitudeMapFig)
                    ppos=get(obj.AmplitudeMapFig(i),'position');
                    set(obj.AmplitudeMapFig(i),'position',...
                        [ppos(1),ppos(2),obj.fig_w,obj.fig_h]);
                    
                    a=findobj(obj.AmplitudeMapFig(i),'Tag','MapAxes');
                    if ~isempty(a)
                        h=figure(obj.AmplitudeMapFig(i));
                        fpos=get(h,'position');
                        if obj.color_bar
                            %optional color bar
                            cb=colorbar('Units','normalized','FontSize',round(15*obj.resize));
                            cbpos=get(cb,'Position');
                            set(a,'Position',[10/400*obj.width/fpos(3),15/300*obj.height/fpos(4),obj.width/fpos(3),obj.height/fpos(4)],'FontSize',round(15*obj.resize));
                            set(cb,'Position',[(obj.width+20/400*obj.width)/fpos(3),15/300*obj.height/fpos(4),0.04,cbpos(4)]);
                        else
                            colorbar('off');
                            set(a,'Position',[10/400*obj.width/fpos(3),15/300*obj.height/fpos(4),obj.width/fpos(3),obj.height/fpos(4)]);
                        end
                    end
                end
            end
        end
        function InterpMissingCallback(obj,src)
            obj.interp_missing_=get(src,'value');
            UpdateFigure(obj,src);
        end
        function ExtrapolateCallback(obj,src)
            obj.extrap_=get(src,'value');
            UpdateFigure(obj,src);
        end
        
        function ContactCallback(obj,src)
            if ~isempty(src)
                obj.contact_=get(src,'value');
            end
            
            if strcmp(obj.interp_scatter,'scatter')
                return
            end
            
            chanpos=[obj.pos_x,obj.pos_y,obj.radius];
            if ~NoMapFig(obj)
                h=findobj(obj.AmplitudeMapFig,'-regexp','Tag','MapAxes');
                if ~isempty(h)
                    delete(findobj(h,'Tag','contact'));
                    delete(findobj(h,'Tag','names'));
                    figure(obj.AmplitudeMapFig)
                    if obj.contact
                        if obj.disp_channel_names
                            plot_contact(h,[],obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,obj.all_chan_names,...
                                ~ismember(obj.all_chan_pos,chanpos,'rows'));
                        else
                            plot_contact(h,[],obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,[],...
                                ~ismember(obj.all_chan_pos,chanpos,'rows'));
                        end
                    end
                end
            end
        end
        function ChannelNamesCallback(obj,src)
            obj.disp_channel_names_=get(src,'value');
            badchan=~ismember(obj.all_chan_pos,[obj.pos_x,obj.pos_y,obj.radius],'rows');
            
            for i=1:length(obj.AmplitudeMapFig)
                h=findobj(obj.AmplitudeMapFig(i),'-regexp','Tag','MapAxes');
                
                if ~isempty(h)
                    delete(findobj(h,'Tag','names'));
                    if obj.disp_channel_names
                        offset=[0;-10];
                        [azz,~] = view(h);
                        rotation_m=[cosd(-azz),-sind(-azz);sind(-azz),cosd(-azz)];
                        offset=rotation_m*offset;
                        for j=1:length(obj.all_chan_names)
                            if badchan(j)
                                c=[0.5,0.5,0.5];
                            else
                                c=[0,0,0];
                            end
                            text(round(obj.all_chan_pos(j,1)*obj.width)+offset(1),round(obj.all_chan_pos(j,2)*obj.height)+offset(2),obj.all_chan_names{j},...
                                'fontsize',8,'horizontalalignment','center','parent',h,'interpreter','none','tag','names','color',c);
                        end
                    end
                end
            end
        end
        function InterpScatterCallback(obj,src)
            switch src
                case obj.map_interp_menu
                    obj.interp_scatter='interp';
                case obj.map_scatter_menu
                    obj.interp_scatter='scatter';
            end
            UpdateFigure(obj,src);
        end
        function PlayAmplitudeMap(obj)
            obj.bsp.VideoLineTime=obj.bsp.VideoLineTime+obj.JStepSpinner.getValue()/obj.fs;
            if(obj.bsp.VideoLineTime>obj.bsp.Time+obj.bsp.WinLength)
                obj.bsp.Time=obj.bsp.Time+floor((obj.bsp.VideoLineTime-obj.bsp.Time)/obj.bsp.WinLength)*obj.bsp.WinLength;
            end
        end
        
        function PlayNext(obj)
            PlayAmplitudeMap(obj);
        end
        function PlayBack(obj)
            obj.bsp.VideoLineTime=obj.bsp.VideoLineTime-obj.JStepSpinner.getValue()/obj.fs;
            if(obj.bsp.VideoLineTime<obj.bsp.Time)
                obj.bsp.Time=obj.bsp.Time-ceil((obj.bsp.Time-obj.bsp.VideoLineTime)/obj.bsp.WinLength)*obj.bsp.WinLength;
            end
        end
        
        function SpeedSpinnerCallback(obj)
            val=obj.JSpeedSpinner.getValue();
            if val==obj.speed||val==0
                return
            end
            
            obj.speed=val;
            set(obj.VideoTimer,'period',round(1000*(1/val))/1000);
        end
        
        
        
        function ColormapCallback(obj)
            listIdx = get(obj.JColorMapPopup,'Value');

            cmapName=get(obj.JColorMapPopup,'UserData');
            cmapName=cmapName{listIdx};
            
            if ~NoMapFig(obj)
                    h=findobj(obj.AmplitudeMapFig,'-regexp','Tag','MapAxes');
                    if ~isempty(h)
                        colormap(h,lower(cmapName));
                    end
            end
        end
        function ScaleSpinnerCallback(obj)
            min=obj.JMinSpinner.getValue();
            max=obj.JMaxSpinner.getValue();
            
            if min<max
                obj.cmin=min;
                obj.cmax=max;
                
                if ~NoMapFig(obj)
                    h=findobj(obj.AmplitudeMapFig,'-regexp','Tag','MapAxes');
                    if ~isempty(h)
                        set(h,'clim',[obj.cmin,obj.cmax]);
                    end
                end
            end
        end
        function SmoothSpinnerCallback(obj, src)
            Nr=obj.JSmoothRowSpinner.getValue();
            Nc=obj.JSmoothColSpinner.getValue();
            
            obj.smooth_row_=Nr;
            obj.smooth_col_=Nc;
            
            UpdateFigure(obj,src);
            
        end
    end
    
end

