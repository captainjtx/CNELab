classdef SpatialMapWindow < handle
    %TFMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    properties
        export_menu
        export_movie_menu
        advance_menu
        stft_menu
        p_menu
        corr_menu
        
        
        valid
        add_event_valid
        
        SpatialMapFig
        bsp
        fig
        add_event_fig
        data_popup
        event_popup
        ms_before_edit
        ms_after_edit
        event_text
        ms_before_text
        ms_after_text
        
        
        normalization_popup
        scale_start_text
        scale_end_text
        scale_start_edit
        scale_end_edit
        scale_start_popup
        scale_end_popup
        max_freq_edit
        min_freq_edit
        max_clim_edit
        min_clim_edit
        max_freq_slider
        min_freq_slider
        max_clim_slider
        min_clim_slider
        erd_radio
        ers_radio
        erd_edit
        ers_edit
        erd_slider
        ers_slider
        threshold_edit
        threshold_slider
        compute_btn
        refresh_btn
        scale_by_max_radio
        %         display_mask_radio
        new_btn
        act_start_edit
        act_len_edit
        act_start_slider
        act_len_slider
        auto_refresh_radio
        color_bar_radio
        
        add_event_btn
        event_list_listbox
        event_group_listbox
        link_radio
        symmetric_scale_radio
        
        center_mass_radio
        peak_radio
    end
    properties
        
        data_input_
        ms_before_
        ms_after_
        event_
        
        normalization_
        normalization_start_
        normalization_end_
        normalization_start_event_
        normalization_end_event_
        
        max_freq_
        min_freq_
        max_clim_
        min_clim_
        clim_slider_max_
        clim_slider_min_
        event_list_
        
        erd_
        ers_
        erd_t_
        ers_t_
        
        threshold_
        
        scale_by_max_
        
        %         display_mask_channel_
        act_start_
        act_len_
        auto_refresh_
        color_bar_
        link_
        symmetric_scale_
        fs_
        center_mass_
        peak_
    end
    
    properties (Dependent)
        fs
        data_input
        ms_before
        ms_after
        event
        
        normalization
        normalization_start
        normalization_start_event
        normalization_end
        normalization_end_event
        
        max_freq
        min_freq
        max_clim
        min_clim
        clim_slider_max
        clim_slider_min
        event_list
        
        erd
        ers
        erd_t
        ers_t
        
        threshold
        
        scale_by_max
        
        %         display_mask_channel
        act_start
        act_len
        auto_refresh
        color_bar
        
        fig_w
        fig_h
        
        fig_x
        fig_y
        
        map_val
        erd_chan
        ers_chan
        cmax
        
        active_ievent
        link
        symmetric_scale
        center_mass
        peak
    end
    properties
        width
        height
        tfmat
        
        stft_winlen
        stft_overlap
        unit
        p
        interp_method
        extrap_method
        
        pos_x
        pos_y
        radius
        all_chan_pos
        
        need_recalculate
        
        event_group
        erd_center
        ers_center
        
        corr_win
    end
    methods
        
        
        function val=get.peak(obj)
            val=obj.peak_;
        end
        
        function set.peak(obj,val)
            obj.peak_=val;
            
            if obj.valid
                set(obj.peak_radio,'value',val);
            end
        end
        
        function val=get.center_mass(obj)
            val=obj.center_mass_;
        end
        
        function set.center_mass(obj,val)
            obj.center_mass_=val;
            
            if obj.valid
                set(obj.center_mass_radio,'value',val);
            end
        end
        
        function val=get.fs(obj)
            val=obj.fs_;
        end
        function set.fs(obj,val)
            obj.fs_=val;
            if obj.valid
                set(obj.max_freq_slider,'max',val/2);
                set(obj.min_freq_slider,'min',val/2);
            end
        end
        function val=get.symmetric_scale(obj)
            val=obj.symmetric_scale_;
        end
        function set.symmetric_scale(obj,val)
            obj.symmetric_scale_=val;
            if obj.valid
                set(obj.symmetric_scale_radio,'value',val);
            end
        end
        
        
        function val=get.link(obj)
            val=obj.link_;
        end
        
        function set.link(obj,val)
            obj.link_=val;
            if obj.valid
                set(obj.link_radio,'value',val);
            end
        end
        
        function val=get.cmax(obj)
            val=-inf;
            if isempty(obj.active_ievent)
                tf=obj.tfmat;
            else
                tf=obj.tfmat(obj.active_ievent);
            end
            if ~isempty(tf)
                for i=1:length(tf.mat)
                    val=max(val,max(max(abs(tf.mat{i}))));
                end
            end
        end
        function val=get.active_ievent(obj)
            val=find(strcmpi(obj.event_group,obj.event));
        end
        function val=get.map_val(obj)
            
            for k=1:length(obj.tfmat)
                tf=obj.tfmat(k);
                
                fi=(tf.f>=obj.min_freq)&(tf.f<=obj.max_freq);
                ti=(tf.t>=obj.act_start/1000)&(tf.t<=obj.act_start/1000+obj.act_len/1000);
                
                mapv=zeros(1,length(tf.mat));
                for i=1:length(tf.mat)
                    mapv(i)=mean(mean(tf.mat{i}(fi,ti)));
                end
                
                if obj.scale_by_max
                    mapv=mapv/max(abs(mapv));
                end
                
                val{k}=mapv;
            end
        end
        
        function val=get.erd_chan(obj)
            
            for k=1:length(obj.tfmat)
                tf=obj.tfmat(k);
                
                fi=(tf.f>=obj.min_freq)&(tf.f<=obj.max_freq);
                ti=(tf.t>=obj.act_start/1000)&(tf.t<=obj.act_start/1000+obj.act_len/1000);
                
                tmp=zeros(length(tf.mat),1);
                
                if obj.valid&&obj.erd
                    for i=1:length(tf.trial_mat)
                        event_mat=tf.trial_mat{i};
                        erd_val=[];
                        for t=1:length(event_mat)
                            erd_val=cat(1,erd_val,mean(mean(event_mat{t}(fi,ti))));
                        end
                        
                        tmp(i)=ttest(erd_val,obj.erd_t,'Tail','Left','Alpha',obj.p);
                    end
                end
                
                val{k}=tmp;
            end
        end
        
        function val=get.ers_chan(obj)
            for k=1:length(obj.tfmat)
                tf=obj.tfmat(k);
                
                fi=(tf.f>=obj.min_freq)&(tf.f<=obj.max_freq);
                ti=(tf.t>=obj.act_start/1000)&(tf.t<=obj.act_start/1000+obj.act_len/1000);
                
                tmp=zeros(length(tf.mat),1);
                
                if obj.valid&&obj.ers
                    for i=1:length(tf.trial_mat)
                        event_mat=tf.trial_mat{i};
                        ers_val=[];
                        for t=1:length(event_mat)
                            ers_val=cat(1,ers_val,mean(mean(event_mat{t}(fi,ti))));
                        end
                        
                        tmp(i)=ttest(ers_val,obj.ers_t,'Tail','Right','Alpha',obj.p);
                    end
                end
                
                val{k}=tmp;
            end
        end
        
        function val=get.fig_x(obj)
            val=100;
        end
        
        function val=get.fig_y(obj)
            val=100;
        end
        function val=get.fig_w(obj)
            if obj.color_bar
                val=obj.width+80/400*obj.width;
            else
                val=obj.width+20/400*obj.width;
            end
        end
        
        function val=get.fig_h(obj)
            val=obj.height+30/300*obj.height;
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
        function val=get.auto_refresh(obj)
            val=obj.auto_refresh_;
        end
        function set.auto_refresh(obj,val)
            obj.auto_refresh_=val;
            if obj.valid
                set(obj.auto_refresh_radio,'value',val);
            end
        end
        function val=get.act_start(obj)
            val=obj.act_start_;
        end
        function set.act_start(obj,val)
            if isempty(obj.active_ievent)
                tf=obj.tfmat;
            else
                tf=obj.tfmat(obj.active_ievent);
            end
            if ~isempty(tf)
                val=min(max(min(tf.t*1000),val),max(tf.t*1000));
            end
            obj.act_start_=val;
            if obj.valid
                set(obj.act_start_edit,'string',num2str(val));
                set(obj.act_start_slider,'value',val);
            end
        end
        
        function val=get.act_len(obj)
            val=obj.act_len_;
        end
        function set.act_len(obj,val)
            obj.act_len_=val;
            if obj.valid
                set(obj.act_len_edit,'string',num2str(val));
                set(obj.act_len_slider,'value',val);
            end
        end
        
        function val=get.erd(obj)
            val=obj.erd_;
        end
        function set.erd(obj,val)
            obj.erd_=val;
            if obj.valid
                if ~val
                    set(obj.erd_edit,'enable','off');
                    set(obj.erd_slider,'enable','off');
                else
                    set(obj.erd_slider,'enable','on');
                    set(obj.erd_edit,'enable','on');
                end
            end
        end
        
        
        function val=get.ers(obj)
            val=obj.ers_;
        end
        function set.ers(obj,val)
            obj.ers_=val;
            if obj.valid
                if ~val
                    set(obj.ers_edit,'enable','off');
                    set(obj.ers_slider,'enable','off');
                else
                    set(obj.ers_slider,'enable','on');
                    set(obj.ers_edit,'enable','on');
                end
            end
        end
        function val=get.erd_t(obj)
            val=obj.erd_t_;
        end
        function set.erd_t(obj,val)
            old=digits(4);
            %             val=vpa(val);
            obj.erd_t_=val;
            if obj.valid
                set(obj.erd_edit,'string',num2str(val));
                set(obj.erd_slider,'value',val);
            end
            digits(old);
        end
        
        function val=get.ers_t(obj)
            val=obj.ers_t_;
        end
        function set.ers_t(obj,val)
            old=digits(4);
            %             val=vpa(val);
            obj.ers_t_=val;
            if obj.valid
                set(obj.ers_edit,'string',num2str(val));
                set(obj.ers_slider,'value',val);
            end
            digits(old);
        end
        
        function val=get.threshold(obj)
            val=obj.threshold_;
        end
        function set.threshold(obj,val)
            oldval=obj.threshold;
            obj.threshold_=val;
            
            if obj.valid
                set(obj.threshold_edit,'string',num2str(val));
                set(obj.threshold_slider,'value',val);
            end
            
            obj.width=round(obj.width/oldval*val);
            obj.height=round(obj.height/oldval*val);
            
            chanpos=[obj.pos_x,obj.pos_y,obj.radius];
            
            for i=1:length(obj.SpatialMapFig)
                if ishandle(obj.SpatialMapFig(i))
                    fpos=get(obj.SpatialMapFig(i),'position');
                    set(obj.SpatialMapFig(i),'position',[fpos(1),fpos(2),obj.fig_w,obj.fig_h]);
                    h=findobj(obj.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                    if ~isempty(h)
                        if ~obj.erd&&~obj.ers
                            delete(findobj(h,'Tag','contact'));
                            figure(obj.SpatialMapFig(i))
                            plot_contact(h,obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,[],...
                                ~ismember(obj.all_chan_pos,chanpos,'rows'));
                        end
                    end
                end
            end
            
            UpdateFigure(obj);
        end
        
        function val=get.scale_by_max(obj)
            val=obj.scale_by_max_;
        end
        function set.scale_by_max(obj,val)
            obj.scale_by_max_=val;
            if obj.valid
                set(obj.scale_by_max_radio,'value',val);
            end
        end
        
        
        function val=get.data_input(obj)
            val=obj.data_input_;
        end
        function set.data_input(obj,val)
            obj.data_input_=val;
            if obj.valid
                set(obj.data_popup,'value',val);
            end
        end
        function val=get.ms_before(obj)
            val=obj.ms_before_;
        end
        function set.ms_before(obj,val)
            obj.ms_before_=val;
            if obj.valid
                set(obj.ms_before_edit,'string',num2str(val));
            end
        end
        function val=get.ms_after(obj)
            val=obj.ms_after_;
        end
        function set.ms_after(obj,val)
            obj.ms_after_=val;
            if obj.valid
                set(obj.ms_after_edit,'string',num2str(val));
            end
        end
        function val=get.event(obj)
            val=obj.event_;
        end
        function set.event(obj,val)
            if obj.valid
                [ia,ib]=ismember(val,obj.event_list);
                if ia
                    set(obj.event_popup,'value',ib);
                else
                    set(obj.event_popup,'value',1);
                    val=obj.event_list{1};
                end
            end
            obj.event_=val;
        end
        
        function val=get.normalization(obj)
            val=obj.normalization_;
        end
        function set.normalization(obj,val)
            if obj.valid
                set(obj.normalization_popup,'value',val);
            end
            obj.normalization_=val;
        end
        function val=get.normalization_start(obj)
            val=obj.normalization_start_;
        end
        function set.normalization_start(obj,val)
            val=max(0,min((obj.ms_before+obj.ms_after),val));
            if obj.valid
                set(obj.scale_start_edit,'string',num2str(val));
            end
            
            obj.normalization_start_=val;
        end
        
        function val=get.normalization_start_event(obj)
            val=obj.normalization_start_event_;
        end
        
        function set.normalization_start_event(obj,val)
            if obj.valid
                ind=find(ismember(val,obj.event_list));
                if isempty(ind)
                    ind=1;
                end
                set(obj.scale_start_popup,'value',ind);
            end
        end
        
        function val=get.normalization_end(obj)
            val=obj.normalization_end_;
        end
        function set.normalization_end(obj,val)
            val=max(obj.normalization_start+obj.stft_winlen/obj.fs*1000,val);
            val=max(0,min((obj.ms_before+obj.ms_after),val));
            obj.normalization_end_=val;
            if obj.valid
                if obj.normalization==2||obj.normalization==3
                    set(obj.scale_end_edit,'string',num2str(val));
                    
                elseif obj.normalization==4
                    set(obj.scale_end_edit,'string',val);
                end
            end
        end
        
        function val=get.normalization_end_event(obj)
            val=obj.normalization_end_event_;
        end
        
        function set.normalization_end_event(obj,val)
            if obj.valid
                ind=find(ismember(val,obj.event_list));
                if isempty(ind)
                    ind=1;
                end
                set(obj.scale_end_popup,'value',ind);
            end
        end
        
        function val=get.max_freq(obj)
            val=obj.max_freq_;
        end
        function set.max_freq(obj,val)
            if val>obj.fs/2
                val=obj.fs/2;
            elseif val<1
                val=1;
            end
            if obj.min_freq>=val
                obj.min_freq=val-1;
            end
            if obj.valid
                set(obj.max_freq_edit,'string',num2str(val));
                set(obj.max_freq_slider,'value',val);
            end
            obj.max_freq_=val;
        end
        
        function val=get.min_freq(obj)
            val=obj.min_freq_;
        end
        function set.min_freq(obj,val)
            if val<0
                val=0;
            elseif val>(obj.fs/2-1)
                val=obj.fs/2-1;
            end
            
            if obj.max_freq<=val
                obj.max_freq=val+1;
            end
            if obj.valid
                set(obj.min_freq_edit,'string',num2str(val));
                set(obj.min_freq_slider,'value',val);
            end
            obj.min_freq_=val;
        end
        
        function val=get.clim_slider_min(obj)
            val=obj.clim_slider_min_;
        end
        function set.clim_slider_min(obj,val)
            obj.clim_slider_min_=val;
            if obj.min_clim<val
                obj.min_clim=val;
            end
            if obj.valid
                set(obj.max_clim_slider,'min',val);
                set(obj.min_clim_slider,'min',val);
                %                 set(obj.erd_slider,'min',val);
                %                 set(obj.ers_slider,'min',val);
            end
        end
        
        function val=get.clim_slider_max(obj)
            val=obj.clim_slider_max_;
        end
        function set.clim_slider_max(obj,val)
            obj.clim_slider_max_=val;
            if obj.max_clim>val
                obj.max_clim=val;
            end
            if obj.valid
                set(obj.max_clim_slider,'max',val);
                set(obj.min_clim_slider,'max',val);
                %                 set(obj.erd_slider,'max',val);
                %                 set(obj.ers_slider,'max',val);
            end
        end
        function val=get.max_clim(obj)
            val=obj.max_clim_;
        end
        function set.max_clim(obj,val)
            if val>obj.clim_slider_max
                val=obj.clim_slider_max;
            elseif val<obj.clim_slider_min
                val=obj.clim_slider_min;
            end
            
            if obj.symmetric_scale
                val=abs(val);
                obj.min_clim_=obj.clim_slider_max+obj.clim_slider_min-val;
            else
                if obj.min_clim>=val
                    obj.min_clim_=val-1;
                end
            end
            if obj.valid
                set(obj.max_clim_edit,'string',num2str(val));
                set(obj.max_clim_slider,'value',val);
                
                set(obj.min_clim_edit,'string',num2str(obj.min_clim_));
                set(obj.min_clim_slider,'value',obj.min_clim_);
            end
            obj.max_clim_=val;
        end
        
        function val=get.min_clim(obj)
            val=obj.min_clim_;
        end
        function set.min_clim(obj,val)
            if val>obj.clim_slider_max
                val=obj.clim_slider_max;
            elseif val<obj.clim_slider_min
                val=obj.clim_slider_min;
            end
            
            if obj.symmetric_scale
                val=-abs(val);
                obj.max_clim_=obj.clim_slider_max+obj.clim_slider_min-val;
            else
                if obj.max_clim<=val
                    obj.max_clim_=val+1;
                end
            end
            
            if obj.valid
                set(obj.min_clim_edit,'string',num2str(val));
                set(obj.min_clim_slider,'value',val);
                
                set(obj.max_clim_edit,'string',num2str(obj.max_clim_));
                set(obj.max_clim_slider,'value',obj.max_clim_);
            end
            obj.min_clim_=val;
        end
        
        function val=get.event_list(obj)
            val=obj.event_list_;
        end
        
        function set.event_list(obj,val)
            
            if (length(obj.event_list)==length(val))&&all(strcmpi(sort(obj.event_list),sort(val)))
                return
            end
            obj.event_list_=val;
            
            if obj.valid
                set(obj.event_popup,'value',1);
                set(obj.scale_start_popup,'value',1);
                set(obj.scale_end_popup,'value',1);
                set(obj.event_popup,'string',val);
                set(obj.scale_start_popup,'string',val);
                set(obj.scale_end_popup,'string',val);
                
                if obj.add_event_valid
                    set(obj.event_list_listbox,'value',1)
                    set(obj.event_list_listbox,'string',val);
                    set(obj.event_group_listbox,'value',1);
                    set(obj.event_group_listbox,'string',obj.event);
                end
            end
            
            [ia,ib]=ismember(obj.event,val);
            if ia
                if obj.valid
                    set(obj.event_popup,'value',ib);
                end
            else
                obj.event=val{1};
            end
            
            [ia,ib]=ismember(obj.normalization_start_event,val);
            if ia
                if obj.valid
                    set(obj.scale_start_popup,'value',ib);
                end
            else
                obj.normalization_start_event=val{1};
            end
            
            
            [ia,ib]=ismember(obj.normalization_end_event,val);
            if ia
                if obj.valid
                    set(obj.scale_end_popup,'value',ib);
                end
            else
                obj.normalization_end_event=val{1};
            end
        end
    end
    
    methods
        function obj=SpatialMapWindow(bsp)
            obj.bsp=bsp;
            obj.fs_=bsp.SRate;
            if ~isempty(bsp.Evts)
                obj.event_list_=unique(bsp.Evts(:,2));
            end
            varinitial(obj);
            addlistener(bsp,'EventListChange',@(src,evts)UpdateEventList(obj));
            addlistener(bsp,'SelectedEventChange',@(src,evts)UpdateEventSelected(obj));
            %             buildfig(obj);
        end
        function UpdateEventList(obj)
            obj.event_list=unique(obj.bsp.Evts(:,2));
        end
        function varinitial(obj)
            obj.valid=0;
            obj.data_input_=1;%selection
            obj.ms_before_=1500;
            obj.ms_after_=1500;
            obj.event_='';
            obj.normalization_=1;%none
            obj.normalization_start_=0;
            obj.normalization_end_=500;
            obj.normalization_start_event_='';
            obj.normalization_end_event_='';
            obj.max_freq_=obj.fs/2;
            obj.min_freq_=0;
            obj.clim_slider_max_=10;
            obj.clim_slider_min_=-10;
            obj.max_clim_=10;
            obj.min_clim_=-10;
            obj.erd_=0;
            obj.ers_=0;
            obj.erd_t_=1;
            obj.ers_t_=1;
            obj.threshold_=1;
            obj.scale_by_max_=0;
            %             obj.display_mask_channel_=0;
            obj.act_start_=obj.ms_before;
            obj.act_len_=500;
            obj.auto_refresh_=1;
            obj.color_bar_=0;
            obj.width=300;
            obj.height=300;
            obj.stft_winlen=round(obj.fs/3);
            obj.stft_overlap=round(obj.stft_winlen*0.9);
            obj.unit='dB';
            obj.p=0.05;
            obj.interp_method='natural';
            obj.extrap_method='linear';
            obj.add_event_valid=0;
            obj.link_=1;
            obj.symmetric_scale_=1;
            obj.center_mass_=1;
            obj.peak_=1;
            
            obj.corr_win=CorrMapWindow(obj);
        end
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.valid=1;
            obj.fig=figure('MenuBar','none','Name','Spatial-Spectral Map','units','pixels',...
                'Position',[500 100 300 700],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            
            obj.export_menu=uimenu(obj.fig,'label','Export');
            obj.export_movie_menu=uimenu(obj.export_menu,'label','Movie','callback',@(src,evts) ExportMovieCallback(obj));
            obj.advance_menu=uimenu(obj.fig,'label','Settings');
            
            obj.stft_menu=uimenu(obj.advance_menu,'label','STFT','callback',@(src,evts) STFTCallback(obj));
            obj.p_menu=uimenu(obj.advance_menu,'label','P-Value','callback',@(src,evts) PCallback(obj));
            obj.corr_menu=uimenu(obj.advance_menu,'label','Correlation','callback',@(src,evts) CorrCallback(obj));
            
            hp=uipanel('units','normalized','Position',[0,0,1,1]);
            
            hp_data=uipanel('Parent',hp,'Title','Raw Data','Units','normalized','Position',[0,0.86,1,0.13]);
            
            obj.data_popup=uicontrol('Parent',hp_data,'Style','popup',...
                'String',{'Selection','Single Event','Average Event'},'units','normalized','position',[0.01,0.6,0.59,0.35],...
                'Callback',@(src,evts) DataPopUpCallback(obj,src),'value',obj.data_input);
            
            
            
            obj.event_text=uicontrol('Parent',hp_data,'Style','text','string','Event: ','units','normalized','position',[0.01,0.3,0.35,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.ms_before_text=uicontrol('Parent',hp_data,'Style','text','string','Before (ms): ','units','normalized','position',[0.4,0.3,0.3,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.ms_after_text=uicontrol('Parent',hp_data,'Style','text','string','After (ms): ','units','normalized','position',[0.7,0.3,0.3,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.event_popup=uicontrol('Parent',hp_data,'Style','popup','string',obj.event_list,'units','normalized','position',[0.01,0.05,0.35,0.3],...
                'visible','off','callback',@(src,evts) EventCallback(obj,src));
            obj.ms_before_edit=uicontrol('Parent',hp_data,'Style','Edit','string',num2str(obj.ms_before),'units','normalized','position',[0.4,0.05,0.29,0.3],...
                'HorizontalAlignment','left','visible','off','callback',@(src,evts) MsBeforeCallback(obj,src));
            obj.ms_after_edit=uicontrol('Parent',hp_data,'Style','Edit','string',num2str(obj.ms_after),'units','normalized','position',[0.7,0.05,0.29,0.3],...
                'HorizontalAlignment','left','visible','off','callback',@(src,evts) MsAfterCallback(obj,src));
            
            hp_scale=uipanel('Parent',hp,'Title','Baseline','units','normalized','position',[0,0.73,1,0.12]);
            
            obj.normalization_popup=uicontrol('Parent',hp_scale,'style','popup','units','normalized',...
                'string',{'None','Individual Within Segment','Average Within Sgement','External Baseline'},'callback',@(src,evts) NormalizationCallback(obj,src),...
                'position',[0.01,0.6,0.59,0.35],'value',obj.normalization);
            obj.add_event_btn=uicontrol('parent',hp_scale,'style','pushbutton','string','Bind','units','normalized',...
                'position',[0.79,0.6,0.2,0.35],'callback',@(src,evts) AddEventCallback(obj,src));
            
            obj.scale_start_text=uicontrol('Parent',hp_scale,'style','text','units','normalized',...
                'string','Start (ms): ','position',[0.05,0.3,0.4,0.3],'HorizontalAlignment','center',...
                'visible','off');
            obj.scale_end_text=uicontrol('Parent',hp_scale,'style','text','units','normalized',...
                'string','End (ms): ','position',[0.55,0.3,0.4,0.3],'HorizontalAlignment','center',...
                'visible','off');
            obj.scale_start_edit=uicontrol('parent',hp_scale,'style','edit','units','normalized',...
                'string',obj.normalization_start,'position',[0.05,0.05,0.4,0.3],'HorizontalAlignment','center','visible','off',...
                'callback',@(src,evt)NormalizationStartEndCallback(obj,src));
            obj.scale_start_popup=uicontrol('parent',hp_scale,'style','popup','units','normalized',...
                'string',obj.event_list,'position',[0.05,0.05,0.4,0.3],'visible','off',...
                'callback',@(src,evt)NormalizationStartEndCallback(obj,src));
            
            obj.scale_end_edit=uicontrol('parent',hp_scale,'style','edit','units','normalized',...
                'string',obj.normalization_end,'position',[0.55,0.05,0.4,0.3],'HorizontalAlignment','center','visible','off',...
                'callback',@(src,evt)NormalizationStartEndCallback(obj,src));
            obj.scale_end_popup=uicontrol('parent',hp_scale,'style','popup','units','normalized',...
                'string',obj.event_list,'position',[0.55,0.05,0.4,0.3],'visible','off',...
                'callback',@(src,evt)NormalizationStartEndCallback(obj,src));
            
            hp_act=uipanel('parent',hp,'title','Activation','units','normalized','position',[0,0.62,1,0.1]);
            
            uicontrol('parent',hp_act,'style','text','string','Start (ms)','units','normalized',...
                'position',[0,0.6,0.18,0.3]);
            uicontrol('parent',hp_act,'style','text','string','Len (ms)','units','normalized',...
                'position',[0,0.1,0.18,0.3]);
            
            obj.act_start_edit=uicontrol('parent',hp_act,'style','edit','string',num2str(obj.act_start),'units','normalized',...
                'position',[0.2,0.55,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ActCallback(obj,src));
            obj.act_start_slider=uicontrol('parent',hp_act,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) ActCallback(obj,src),...
                'min',0,'max',obj.ms_before+obj.ms_after,'sliderstep',[0.005,0.02],'value',obj.act_start);
            obj.act_len_edit=uicontrol('parent',hp_act,'style','edit','string',num2str(obj.act_len),'units','normalized',...
                'position',[0.2,0.05,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ActCallback(obj,src));
            obj.act_len_slider=uicontrol('parent',hp_act,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) ActCallback(obj,src),...
                'min',1,'max',obj.ms_before+obj.ms_after,'sliderstep',[0.005,0.02],'value',obj.act_len);
            
            hp_freq=uipanel('parent',hp,'title','Frequency','units','normalized','position',[0,0.51,1,0.1]);
            
            uicontrol('parent',hp_freq,'style','text','string','Min','units','normalized',...
                'position',[0,0.6,0.1,0.3]);
            uicontrol('parent',hp_freq,'style','text','string','Max','units','normalized',...
                'position',[0,0.1,0.1,0.3]);
            
            obj.min_freq_edit=uicontrol('parent',hp_freq,'style','edit','string',num2str(obj.min_freq),'units','normalized',...
                'position',[0.15,0.55,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) FreqCallback(obj,src));
            obj.min_freq_slider=uicontrol('parent',hp_freq,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) FreqCallback(obj,src),...
                'min',0,'max',obj.fs/2,'sliderstep',[0.005,0.02],'value',obj.min_freq);
            obj.max_freq_edit=uicontrol('parent',hp_freq,'style','edit','string',num2str(obj.max_freq),'units','normalized',...
                'position',[0.15,0.05,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) FreqCallback(obj,src));
            obj.max_freq_slider=uicontrol('parent',hp_freq,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) FreqCallback(obj,src),...
                'min',0,'max',obj.fs/2,'sliderstep',[0.005,0.02],'value',obj.max_freq);
            
            hp_erds=uipanel('parent',hp,'title','ERD/ERS T-Test','units','normalized','position',[0,0.4,1,0.1]);
            
            obj.erd_radio=uicontrol('parent',hp_erds,'style','radiobutton','string','ERD','units','normalized',...
                'position',[0,0.6,0.18,0.3],'value',obj.erd,'callback',@(src,evts) ERDSCallback(obj,src));
            obj.ers_radio=uicontrol('parent',hp_erds,'style','radiobutton','string','ERS','units','normalized',...
                'position',[0,0.1,0.18,0.3],'value',obj.ers,'callback',@(src,evts) ERDSCallback(obj,src));
            obj.erd_edit=uicontrol('parent',hp_erds,'style','edit','string',num2str(obj.erd_t),'units','normalized',...
                'position',[0.2,0.55,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ERDSCallback(obj,src));
            obj.erd_slider=uicontrol('parent',hp_erds,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) ERDSCallback(obj,src),...
                'min',0,'max',1,'value',obj.erd_t,'sliderstep',[0.01,0.05]);
            obj.ers_edit=uicontrol('parent',hp_erds,'style','edit','string',num2str(obj.ers_t),'units','normalized',...
                'position',[0.2,0.05,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ERDSCallback(obj,src));
            obj.ers_slider=uicontrol('parent',hp_erds,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) ERDSCallback(obj,src),...
                'min',1,'max',10,'value',obj.ers_t,'sliderstep',[0.01,0.05]);
            
            hp_clim=uipanel('parent',hp,'title','Scale','units','normalized','position',[0,0.29,1,0.1]);
            
            uicontrol('parent',hp_clim,'style','text','string','Min','units','normalized',...
                'position',[0,0.6,0.1,0.3]);
            uicontrol('parent',hp_clim,'style','text','string','Max','units','normalized',...
                'position',[0,0.1,0.1,0.3]);
            obj.min_clim_edit=uicontrol('parent',hp_clim,'style','edit','string',num2str(obj.min_clim),'units','normalized',...
                'position',[0.15,0.55,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) ClimCallback(obj,src));
            obj.min_clim_slider=uicontrol('parent',hp_clim,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) ClimCallback(obj,src),...
                'min',obj.clim_slider_min,'max',obj.clim_slider_max,'value',obj.min_clim,'sliderstep',[0.01,0.05]);
            obj.max_clim_edit=uicontrol('parent',hp_clim,'style','edit','string',num2str(obj.max_clim),'units','normalized',...
                'position',[0.15,0.05,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) ClimCallback(obj,src));
            obj.max_clim_slider=uicontrol('parent',hp_clim,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) ClimCallback(obj,src),...
                'min',obj.clim_slider_min,'max',obj.clim_slider_max,'value',obj.max_clim,'sliderstep',[0.01,0.05]);
            
            
            hp_threshold=uipanel('parent',hp,'title','Window Scale','units','normalized','position',[0,0.21,1,0.07]);
            
            uicontrol('parent',hp_threshold,'style','text','string','Ratio','units','normalized',...
                'position',[0,0.2,0.1,0.5]);
            obj.threshold_edit=uicontrol('parent',hp_threshold,'style','edit','string',num2str(obj.threshold),'units','normalized',...
                'position',[0.15,0.2,0.2,0.6],'horizontalalignment','center','callback',@(src,evts) ThresholdCallback(obj,src));
            obj.threshold_slider=uicontrol('parent',hp_threshold,'style','slider','units','normalized',...
                'position',[0.4,0.2,0.55,0.6],'callback',@(src,evts) ThresholdCallback(obj,src),...
                'min',0.1,'max',2,'value',obj.threshold,'sliderstep',[0.01,0.05]);
            
            hp_display=uipanel('parent',hp,'title','Display','units','normalized','position',[0,0.05,1,0.15]);
            
            obj.scale_by_max_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Scale By Maximum',...
                'units','normalized','position',[0,0.75,0.45,0.25],'value',obj.scale_by_max,...
                'callback',@(src,evts) ScaleByMaxCallback(obj,src));
            %             obj.display_mask_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Dispaly Mask Channels',...
            %                 'units','normalized','position',[0,0.5,0.45,0.25],'value',obj.display_mask_channel,...
            %                 'callback',@(src,evts) DisplayMaskCallback(obj,src));
            obj.auto_refresh_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Auto Refresh',...
                'units','normalized','position',[0,0.5,0.45,0.25],'value',obj.auto_refresh,...
                'callback',@(src,evts) AutoRefreshCallback(obj,src));
            obj.color_bar_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Color Bar',...
                'units','normalized','position',[0,0.25,0.45,0.25],'value',obj.color_bar,...
                'callback',@(src,evts) ColorBarCallback(obj,src));
            
            
            obj.link_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Link',...
                'units','normalized','position',[0,0,0.45,0.25],'value',obj.link,...
                'callback',@(src,evts) LinkCallback(obj,src));
            
            
            obj.symmetric_scale_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Symmetric Scale',...
                'units','normalized','position',[0.5,0.75,0.45,0.25],'value',obj.symmetric_scale,...
                'callback',@(src,evts) SymmetricScaleCallback(obj,src));
            
            obj.center_mass_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Center Mass',...
                'units','normalized','position',[0.5,0.5,0.45,0.25],'value',obj.center_mass>0,...
                'callback',@(src,evts) CenterMassCallback(obj,src));
            
            
            obj.peak_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Peak',...
                'units','normalized','position',[0.5,0.25,0.45,0.25],'value',obj.peak,...
                'callback',@(src,evts) PeakCallback(obj,src));
            
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.005,0.2,0.04],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.005,0.2,0.04],...
                'callback',@(src,evts) NewCallback(obj));
            
            obj.refresh_btn=uicontrol('parent',hp,'style','pushbutton','string','Refresh','units','normalized','position',[0.4,0.005,0.2,0.04],...
                'callback',@(src,evts) UpdateFigure(obj));
            
            DataPopUpCallback(obj,obj.data_popup);
            NormalizationCallback(obj,obj.normalization_popup);
            
            obj.event=obj.event_;
            obj.normalization_start_event=obj.normalization_start_event_;
            obj.normalization_end_event=obj.normalization_end_event_;
            obj.erd=obj.erd_;
            obj.ers=obj.ers_;
        end
        function OnClose(obj)
            obj.valid=0;
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
            
            h = obj.SpatialMapFig;
            if ishandle(h)
                delete(h);
            end
            
            
            h = obj.add_event_fig;
            if ishandle(h)
                delete(h);
            end
            
            if obj.corr_win.valid
                delete(obj.corr_win.fig);
            end
            
        end
        
        function DataPopUpCallback(obj,src)
            obj.data_input=get(src,'value');
            switch get(src,'value')
                case 1
                    %Selection
                    set(obj.event_text,'visible','off');
                    set(obj.ms_before_text,'visible','off');
                    set(obj.ms_after_text,'visible','off');
                    set(obj.event_popup,'visible','off');
                    set(obj.ms_before_edit,'visible','off');
                    set(obj.ms_after_edit,'visible','off');
                    set(obj.add_event_btn,'visible','off');
                case 2
                    %Single Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','off');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
                    set(obj.add_event_btn,'visible','off');
                case 3
                    %Average Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','on');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
                    set(obj.add_event_btn,'visible','on');
            end
        end
        
        function MsBeforeCallback(obj,src)
            t=str2double(get(src,'string'));
            if isnan(t)
                t=obj.ms_before;
            end
            obj.ms_before=t;
        end
        function MsAfterCallback(obj,src)
            t=str2double(get(src,'string'));
            if isnan(t)
                t=obj.ms_after;
            end
            obj.ms_after=t;
        end
        
        function NormalizationCallback(obj,src)
            obj.normalization=get(src,'value');
            switch get(src,'value')
                case 1
                    set(obj.scale_start_text,'visible','off');
                    set(obj.scale_end_text,'visible','off');
                    set(obj.scale_start_edit,'visible','off');
                    set(obj.scale_end_edit,'visible','off');
                    set(obj.scale_start_popup,'visible','off');
                    set(obj.scale_end_popup,'visible','off');
                case 2
                    set(obj.scale_start_text,'visible','on');
                    set(obj.scale_start_text,'string','Start (ms): ')
                    set(obj.scale_end_text,'visible','on');
                    set(obj.scale_end_text,'string','End (ms): ')
                    set(obj.scale_start_edit,'visible','on');
                    set(obj.scale_end_edit,'visible','on');
                    set(obj.scale_start_popup,'visible','off');
                    set(obj.scale_end_popup,'visible','off');
                case 3
                    set(obj.scale_start_text,'visible','on');
                    set(obj.scale_start_text,'string','Start (ms): ')
                    set(obj.scale_end_text,'visible','on');
                    set(obj.scale_end_text,'string','End (ms): ')
                    set(obj.scale_start_edit,'visible','on');
                    set(obj.scale_end_edit,'visible','on');
                    set(obj.scale_start_popup,'visible','off');
                    set(obj.scale_end_popup,'visible','off');
                case 4
                    set(obj.scale_start_text,'visible','on');
                    set(obj.scale_start_text,'string','Start (event): ')
                    set(obj.scale_end_text,'visible','on');
                    set(obj.scale_end_text,'string','End (event): ')
                    set(obj.scale_start_edit,'visible','off');
                    set(obj.scale_end_edit,'visible','off');
                    set(obj.scale_start_popup,'visible','on');
                    set(obj.scale_end_popup,'visible','on');
            end
        end
        
        
        
        function FreqCallback(obj,src)
            switch src
                case obj.max_freq_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.max_freq;
                    end
                    obj.max_freq=round(t*10)/10;
                case obj.min_freq_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.min_freq;
                    end
                    obj.min_freq=round(t*10)/10;
                case obj.max_freq_slider
                    obj.max_freq=round(get(src,'value')*10)/10;
                case obj.min_freq_slider
                    obj.min_freq=round(get(src,'value')*10)/10;
            end
            if obj.auto_refresh
                UpdateFigure(obj)
            end
        end
        function ClimCallback(obj,src)
            switch src
                case obj.max_clim_slider
                    obj.max_clim=get(src,'value');
                case obj.min_clim_slider
                    obj.min_clim=get(src,'value');
                case obj.max_clim_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.max_clim;
                    end
                    obj.max_clim=t;
                case obj.min_clim_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.min_clim;
                    end
                    obj.min_clim=t;
            end
            
            if ~obj.auto_refresh
                return
            end
            
            if ~NoSpatialMapFig(obj)
                h=findobj(obj.SpatialMapFig,'-regexp','Tag','SpatialMapAxes');
                
                if obj.scale_by_max
                    sl=obj.min_clim/obj.cmax;
                    sh=obj.max_clim/obj.cmax;
                else
                    sl=obj.min_clim;
                    sh=obj.max_clim;
                end
                
                if sl<sh
                    set(h,'CLim',[sl,sh]);
                end
                %                 figure(obj.SpatialMapFig);
            end
        end
        
        function NormalizationStartEndCallback(obj,src)
            switch src
                case obj.scale_start_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.normalization_start;
                    end
                    
                    obj.normalization_start=t;
                case obj.scale_end_edit
                    
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.normalization_end;
                    end
                    
                    obj.normalization_end=t;
                    
                case obj.scale_start_popup
                    obj.normalization_start_event_=obj.event_list{get(src,'value')};
                case obj.scale_end_popup
                    obj.normalization_end_event_=obj.event_list{get(src,'value')};
            end
        end
        
        function EventCallback(obj,src)
            obj.event_=obj.event_list{get(src,'value')};
        end
        
        function UpdateEventSelected(obj)
            if ~isempty(obj.bsp.SelectedEvent)
                obj.event=obj.bsp.Evts{obj.bsp.SelectedEvent(1),2};
            end
        end
        function NewCallback(obj)
            if ~NoSpatialMapFig(obj)
                for i=1:length(obj.SpatialMapFig)
                    name=get(obj.SpatialMapFig,'Name');
                    set(obj.SpatialMapFig(i),'Name',[name(1:end-6) 'Obsolete']);
                    set(obj.SpatialMapFig(i),'Tag','Obsolete');
                end
                
            end
            NewSpatialMapFig(obj);
        end
        
        function NewSpatialMapFig(obj)
            if any(strcmpi(obj.event,obj.event_group))
                for i=1:length(obj.event_group)
                    obj.SpatialMapFig(i)=figure('Name',[obj.event_group{i},' Active'],'NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),...
                        'units','pixels','position',[obj.fig_x+(obj.fig_w+10)*(i-1),obj.fig_y,obj.fig_w,obj.fig_h],'Resize','off',...
                        'doublebuffer','off','Tag','Active');
                end
            else
                obj.SpatialMapFig=figure('Name',[obj.event,' Active'],'NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),...
                    'units','pixels','position',[obj.fig_x,obj.fig_y,obj.fig_w,obj.fig_h],'Resize','off',...
                    'doublebuffer','off','Tag','Active');
            end
        end
        function ComputeCallback(obj)
            obj.tfmat=[];
            obj.erd_center={};
            obj.ers_center={};
            %==========================================================================
            nL=round(obj.ms_before*obj.fs/1000);
            nR=round(obj.ms_after*obj.fs/1000);
            
            %Data selection************************************************************
            if obj.data_input==1
                omitMask=true;
                [data,chanNames,dataset,channel,~,~,~,chanpos]=get_selected_data(obj,omitMask);
            elseif obj.data_input==2
                if isempty(obj.bsp.SelectedEvent)
                    errordlg('No event selection !');
                    return
                elseif length(obj.bsp.SelectedEvent)>1
                    warndlg('More than one event selected, using the first one !');
                end
                i_label=round(obj.bsp.Evts{obj.bsp.SelectedEvent(1),1}*obj.fs);
                i_label=min(max(1,i_label),size(obj.bsp.Data{1},1));
                
                i_label((i_label+nR)>size(obj.bsp.Data{1},1))=[];
                i_label((i_label-nL)<1)=[];
                if isempty(i_label)
                    errordlg('Illegal selection!');
                    return
                end
                tmp_sel=[reshape(i_label-nL,1,length(i_label));reshape(i_label+nR,1,length(i_label))];
                omitMask=true;
                [data,chanNames,dataset,channel,~,~,~,chanpos]=get_selected_data(obj.bsp,omitMask,tmp_sel);
            elseif obj.data_input==3
                if isempty(obj.active_ievent)
                    evt=obj.event;
                else
                    evt=obj.event_group;
                end
                
                t_evt=[obj.bsp.Evts{:,1}];
                txt_evt=obj.bsp.Evts(:,2);
                
                t_label=t_evt(ismember(txt_evt,evt));
                txt_evt=txt_evt(ismember(txt_evt,evt));
                if isempty(t_label)
                    errordlg('Event not found !');
                    return
                end
                i_event=round(t_label*obj.fs);
                i_event=min(max(1,i_event),size(obj.bsp.Data{1},1));
                
                i_event((i_event+nR)>size(obj.bsp.Data{1},1))=[];
                txt_evt((i_event+nR)>size(obj.bsp.Data{1},1))=[];
                
                i_event((i_event-nL)<1)=[];
                txt_evt((i_event-nL)<1)=[];
                
                omitMask=true;
                [data,chanNames,dataset,channel,~,~,~,chanpos]=get_selected_data(obj.bsp,omitMask);
                %need to change the data
            end
            %Channel position******************************************************************
            if isempty(chanpos)
                errordlg('No channel position in the data !');
                return
            end
            [~,~,~,~,~,~,~,allchanpos]=get_selected_data(obj.bsp);
            chanind=~isnan(allchanpos(:,1))&~isnan(allchanpos(:,2));
            allchanpos=allchanpos(chanind,:);
            [allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),~,~] = ...
                get_relative_chanpos(allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.width,obj.height);
            
            chanind=~isnan(chanpos(:,1))&~isnan(chanpos(:,2));
            data=data(:,chanind);
            channames=chanNames(chanind);
            chanpos=chanpos(chanind,:);
            
            [chanpos(:,1),chanpos(:,2),chanpos(:,3),obj.width,obj.height] = ...
                get_relative_chanpos(chanpos(:,1),chanpos(:,2),chanpos(:,3),obj.width,obj.height);
            %set default parameter*****************************************************
            
            s=[obj.min_clim obj.max_clim];
            if s(1)>=s(2)
                s(1)=s(2)-abs(s(2))*0.1;
                obj.min_clim=s(1);
            end
            
            sl=obj.min_clim;
            sh=obj.max_clim;
            
            freq=[obj.min_freq obj.max_freq];
            if freq(1)>=freq(2)
                freq(1)=freq(2)-1;
                obj.min_freq=freq(1);
            end
            
            if NoSpatialMapFig(obj)
                NewSpatialMapFig(obj);
            else
                for i=1:length(obj.SpatialMapFig)
                    set(obj.SpatialMapFig(i),'position',[obj.fig_x+(i-1)*(obj.fig_w+10),obj.fig_y,obj.fig_w,obj.fig_h]);
                end
            end
            
            wd=obj.stft_winlen;
            ov=obj.stft_overlap;
            
            if isempty(obj.active_ievent)
                evt={obj.event};
            else
                evt=obj.event_group;
            end
            for i=1:length(obj.SpatialMapFig)
                clf(obj.SpatialMapFig(i));
                set(obj.SpatialMapFig(i),'Name',[evt{i} ' Active']);
            end
            
            %Normalizatin**************************************************************
            if obj.normalization==1
                nref=[];
                baseline=[];
            elseif obj.normalization==2||obj.normalization==3
                nref=round([obj.normalization_start,obj.normalization_end]/1000*obj.fs);
                
                needupdate=0;
                if nref(2)>=size(data,1)
                    nref(2)=size(data,1);
                    needupdate=1;
                end
                if nref(1)>=nref(2)
                    nref(1)=1;
                    needupdate=1;
                end
                if nref(1)<0;
                    nref(1)=1;
                    needupdate=1;
                end
                baseline=[];
                if needupdate
                    obj.normalization_start=nref(1)*1000/obj.fs;
                    obj.normalization_end=nref(2)*1000/obj.fs;
                end
            elseif obj.normalization==4
                nref=[];
                
                t_evt=[obj.bsp.Evts{:,1}];
                t_label=t_evt(strcmpi(obj.bsp.Evts(:,2),obj.normalization_start_event));
                i_label=round(t_label*obj.fs);
                i_label=min(max(1,i_label),size(obj.bsp.Data{1},1));
                
                baseline_start=i_label;
                
                t_label=t_evt(strcmpi(obj.bsp.Evts(:,2),obj.normalization_end_event));
                i_label=round(t_label*obj.fs);
                i_label=min(max(1,i_label),size(obj.bsp.Data{1},1));
                
                baseline_end=i_label;
                
                tmp_sel=[reshape(baseline_start,1,length(i_label));reshape(baseline_end,1,length(i_label))];
                omitMask=true;
                baseline=get_selected_data(obj.bsp,omitMask,tmp_sel);
                
            end
            %**************************************************************
            nref_tmp=nref;
            wait_bar_h = waitbar(0,'STFT Recaculating...');
            
            if obj.data_input==3%Average Event
                for j=1:length(channames)
                    waitbar(j/length(channames));
                    tmp_tfm=cell(1,length(i_event));
                    
                    if obj.normalization==3
                        nref_tmp=[];
                    end
                    %******************************************************
                    raw_data=[];
                    
                    for i=1:length(i_event)
                        tmp_sel=[i_event(i)-nL;i_event(i)+nR];
                        data=get_selected_data(obj.bsp,true,tmp_sel);
                        data=data(:,chanind);
                        data=data(:,j);
                        
                        if obj.normalization==4
                            tmp_base=baseline(:,chanind);
                            tmp_base=tmp_base(:,j);
                        else
                            tmp_base=[];
                        end
                        
                        raw_data=cat(2,raw_data,data);
                        
                        [tf,f,t]=bsp_tfmap(obj.SpatialMapFig,data,tmp_base,obj.fs,wd,ov,[sl,sh],nref_tmp,channames,freq,obj.unit);
                        tmp_tfm{i}=tf;
                    end
                    
                    for e=1:length(evt)
                        tfm=0;
                        ind=strcmpi(txt_evt,evt{e});
                        event_tfm=tmp_tfm(ind);
                        
                        for k=1:length(event_tfm)
                            tfm=tfm+event_tfm{k};
                        end
                        tfm=tfm/length(event_tfm);
                        
                        %use baseline from all events**********************
                        if obj.normalization==3
                            rtfm=0;
                            for i=1:length(tmp_tfm)
                                rtfm=rtfm+mean(tmp_tfm{i}(:,(t>=nref(1)/obj.fs)&(t<=nref(2)/obj.fs)),2);
                            end
                            
                            rtfm=rtfm/length(tmp_tfm);
                            tfm=tfm./repmat(rtfm,1,size(tfm,2));
                            
                            for tmp=1:length(event_tfm)
                                event_tfm{tmp}=event_tfm{tmp}./repmat(rtfm,1,size(tfm,2));
                            end
                        end
                        %**************************************************
                        if strcmpi(obj.unit,'dB')
                            tfm=10*log10(tfm);
                            %                             for tmp=1:length(event_tfm)
                            %                                 event_tfm{tmp}=10*log10(event_tfm{tmp});
                            %                             end
                        end
                        
                        obj.tfmat(e).mat{j}=tfm;
                        obj.tfmat(e).t=t;
                        obj.tfmat(e).f=f;
                        obj.tfmat(e).channel=channel;
                        obj.tfmat(e).dataset=dataset;
                        obj.tfmat(e).channame=chanNames;
                        obj.tfmat(e).event=evt(e);
                        obj.tfmat(e).trial_mat{j}=event_tfm;
                        obj.tfmat(e).data(:,j,:)=raw_data(:,ind);
                    end
                end
            else
                for j=1:length(channames)
                    waitbar(j/length(channames));
                    [tfm,f,t]=bsp_tfmap(obj.SpatialMapFig,data(:,j),baseline,obj.fs,wd,ov,[sl,sh],nref,channames,freq,obj.unit);
                    
                    if strcmpi(obj.unit,'dB')
                        tfm=10*log10(tfm);
                    end
                    
                    obj.tfmat.mat{j}=tfm;
                    obj.tfmat.t=t;
                    obj.tfmat.f=f;
                    obj.tfmat.channel=channel;
                    obj.tfmat.dataset=dataset;
                    obj.tfmat.channame=channames;
                    obj.tfmat.event=obj.event;
                    obj.tfmat.data(:,j)=data(:,j);
                end
                
                
            end
            
            close(wait_bar_h);
            
            set(obj.act_start_slider,'max',max(t*1000));
            set(obj.act_start_slider,'min',min(t*1000));
            step=min(diff(t))/(max(t)-min(t));
            set(obj.act_start_slider,'sliderstep',[step,step*5]);
            
            obj.pos_x=chanpos(:,1);
            obj.pos_y=chanpos(:,2);
            obj.radius=chanpos(:,3);
            
            
            if obj.scale_by_max
                sl=sl/obj.cmax;
                sh=sh/obj.cmax;
            end
            
            obj.clim_slider_max=obj.cmax;
            obj.clim_slider_min=-obj.cmax;
            mapv=obj.map_val;
            
            erdchan=obj.erd_chan;
            erschan=obj.ers_chan;
            
            obj.all_chan_pos=allchanpos;
            for e=1:length(evt)
                spatialmap_grid(obj.SpatialMapFig(e),mapv{e},obj.interp_method,...
                    obj.extrap_method,channames,chanpos(:,1),chanpos(:,2),chanpos(:,3),obj.width,obj.height,sl,sh,obj.color_bar);
                h=findobj(obj.SpatialMapFig(e),'-regexp','tag','SpatialMapAxes');
                plot_contact(h,allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.height,obj.width,[],...
                    ~ismember(allchanpos,chanpos,'rows'),erdchan{e},erschan{e});
                if obj.peak
                    [~,I]=max(abs(mapv{e}'));
                    text(obj.pos_x(I)*obj.width,obj.pos_y(I)*obj.height,'p','parent',h,'fontsize',12,'color','w',...
                        'tag','peak');
                end
                
                if obj.erd||obj.ers
                    [obj.erd_center{e},obj.ers_center{e}]=plot_mass_center(h,mapv{e},round(chanpos(:,1)*obj.width),round(chanpos(:,2)*obj.height),erdchan{e},erschan{e},obj.center_mass);
                end
            end
        end
        
        function ERDSCallback(obj,src)
            switch src
                case obj.erd_radio
                    obj.erd=get(src,'value');
                case obj.ers_radio
                    obj.ers=get(src,'value');
                case obj.erd_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.erd_t;
                    end
                    t=max(obj.clim_slider_min,min(obj.clim_slider_max,t));
                    obj.erd_t=t;
                case obj.ers_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.ers_t;
                    end
                    t=max(obj.clim_slider_min,min(obj.clim_slider_max,t));
                    obj.ers_t=t;
                case obj.erd_slider
                    obj.erd_t=get(src,'value');
                case obj.ers_slider
                    obj.ers_t=get(src,'value');
            end
            
            UpdateFigure(obj);
        end
        function ThresholdCallback(obj,src)
            switch src
                case obj.threshold_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.threshold;
                    end
                    t=max(0.1,min(t,3));
                    
                    obj.threshold=t;
                case obj.threshold_slider
                    obj.threshold=get(src,'value');
            end
        end
        
        %         function DisplayMaskCallback(obj,src)
        %             obj.display_mask_channel_=get(src,'value');
        %
        %             if ~NoSpatialMapFig(obj)
        %
        %                h=findobj(obj.SpatialMapFig,'-regexp','Tag','SpatialMapAxes');
        %                if ~isempty(h)
        %                    circles=findobj(obj.SpatialMapFig,'-regexp','Tag','contact*');
        %
        %                    if ~isempty(circles)
        %                        delete(circles);
        %                    end
        %
        %                    col=max(1,round(obj.pos_x*obj.width));
        %                    row=max(1,round(obj.pos_y*obj.height));
        %                    for i=1:length(col)
        %
        %                        hold on;
        %                        h=plot(h,col(i),row(i),'Marker','o','Color','k');
        %                        set(h,'Tag',['contact_',obj.tfmat_channame{i}]);
        %                    end
        %
        %
        %                end
        %             end
        %         end
        function ScaleByMaxCallback(obj,src)
            obj.scale_by_max_=get(src,'value');
            
            if ~obj.auto_refresh
                return
            end
            UpdateFigure(obj);
        end
        
        function ActCallback(obj,src)
            switch src
                case obj.act_start_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.act_start;
                    end
                    obj.act_start=t;
                case obj.act_len_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.act_len;
                    end
                    obj.act_len=t;
                case obj.act_start_slider
                    obj.act_start=get(src,'value');
                case obj.act_len_slider
                    obj.act_len=get(src,'value');
            end
            if obj.auto_refresh
                UpdateFigure(obj);
            end
        end
        function AutoRefreshCallback(obj,src)
            obj.auto_refresh_=get(src,'value');
            
            if obj.auto_refresh
                UpdateFigure(obj);
            end
        end
        
        
        function KeyPress(obj,src,evt)
            if strcmpi(get(src,'Name'),'Obsolete SpatialMap')
                return
            end
            if ~isempty(evt.Modifier)
                if length(evt.Modifier)==1
                    if ismember('command',evt.Modifier)||ismember('control',evt.Modifier)
                        if strcmpi(evt.Key,'t')
                            obj.NewCallback();
                        end
                        
                    end
                end
            end
        end
        function ColorBarCallback(obj,src)
            obj.color_bar_=get(src,'value');
            
            if ~obj.auto_refresh
                return
            end
            
            if ~NoSpatialMapFig(obj)
                for i=1:length(obj.SpatialMapFig)
                    pos=get(obj.SpatialMapFig(i),'position');
                    set(obj.SpatialMapFig(i),'position',...
                        [pos(1),pos(2),obj.fig_w,obj.fig_h]);
                    
                    a=findobj(obj.SpatialMapFig(i),'Tag','SpatialMapAxes');
                    if ~isempty(a)
                        h=figure(obj.SpatialMapFig(i));
                        fpos=get(h,'position');
                        if obj.color_bar
                            %optional color bar
                            cb=colorbar('Units','normalized','FontSize',14);
                            cbpos=get(cb,'Position');
                            set(a,'Position',[10/400*obj.width/fpos(3),15/300*obj.height/fpos(4),obj.width/fpos(3),obj.height/fpos(4)],'FontSize',14);
                            set(cb,'Position',[(obj.width+20/400*obj.width)/fpos(3),15/300*obj.height/fpos(4),0.04,cbpos(4)]);
                        else
                            colorbar('off');
                            set(a,'Position',[10/400*obj.width/fpos(3),15/300*obj.height/fpos(4),obj.width/fpos(3),obj.height/fpos(4)]);
                        end
                    end
                end
            end
        end
        
        function val=NoSpatialMapFig(obj)
            val=isempty(obj.SpatialMapFig)||~all(ishandle(obj.SpatialMapFig))||~all(strcmpi(get(obj.SpatialMapFig,'Tag'),'Active'));
        end
        
        function STFTCallback(obj)
            prompt={'STFT Window Length (sample): ','STFT Overlap (sample): '};
            def={num2str(obj.stft_winlen),num2str(obj.stft_overlap)};
            
            title='STFT Settings';
            
            answer=inputdlg(prompt,title,1,def);
            
            if isempty(answer)
                return
            end
            tmp=str2double(answer{1});
            if isempty(tmp)||isnan(tmp)
                tmp=obj.stft_winlen;
            end
            
            obj.stft_winlen=tmp;
            
            
            tmp=str2double(answer{2});
            if isempty(tmp)||isnan(tmp)
                tmp=obj.stft_overlap;
            end
            
            obj.stft_overlap=tmp;
        end
        function PCallback(obj)
            prompt={'p value for t-test'};
            def={num2str(obj.p)};
            
            title='T-Test Settings';
            
            answer=inputdlg(prompt,title,1,def);
            
            if isempty(answer)
                return
            end
            tmp=str2double(answer{1});
            if isempty(tmp)||isnan(tmp)
                tmp=obj.p;
            end
            
            obj.p=max(0,min(tmp,1));
        end
        
        function UpdateFigure(obj)
            if ~NoSpatialMapFig(obj)
                
                mapv=obj.map_val;
                erdchan=obj.erd_chan;
                erschan=obj.ers_chan;
                
                chanpos=[obj.pos_x,obj.pos_y,obj.radius];
                
                for i=1:length(obj.SpatialMapFig)
                    h=findobj(obj.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                    if ~isempty(h)
                        col=obj.pos_x;
                        row=obj.pos_y;
                        if strcmpi(obj.interp_method,'natural')
                            [x,y]=meshgrid((1:obj.width)/obj.width,(1:obj.height)/obj.height);
                            
                            F= scatteredInterpolant(col,row,mapv{i}',obj.interp_method,obj.extrap_method);
                            mapvq=F(x,y);
                        else
                            return
                        end
                        
                        imagehandle=findobj(h,'Tag','ImageMap');
                        
                        if obj.scale_by_max
                            set(h,'clim',[obj.min_clim/obj.cmax,obj.max_clim/obj.cmax]);
                        else
                            set(h,'clim',[obj.min_clim,obj.max_clim]);
                        end
                        set(h,'xlim',[1,obj.width]);
                        set(h,'ylim',[1,obj.height]);
                        set(imagehandle,'CData',single(mapvq));
                        delete(findobj(h,'tag','peak'));
                        drawnow
                        
                        if obj.erd||obj.ers
                            delete(findobj(h,'Tag','contact'));
                            figure(obj.SpatialMapFig(i))
                            plot_contact(h,obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,[],...
                                ~ismember(obj.all_chan_pos,chanpos,'rows'),erdchan{i},erschan{i});
                        end
                        
                        if obj.peak
                            [~,I]=max(abs(mapv{i}'));
                            text(col(I)*obj.width,row(I)*obj.height,'p','parent',h,'fontsize',12,'color','w',...
                                'tag','peak');
                        end
                        
                        if obj.erd||obj.ers
                            [obj.erd_center{i},obj.ers_center{i}]=plot_mass_center(h,mapv{i},...
                                round(chanpos(:,1)*obj.width),round(chanpos(:,2)*obj.height),...
                                erdchan{i},erschan{i},obj.center_mass,...
                                obj.erd_center{i},obj.ers_center{i});
                        end
                        
                        %Correlation Network
                        if obj.corr_win.pos||obj.corr_win.neg||obj.corr_win.sig
                            % correlation
                            UpdateCorrelation(obj);
                            plot_correlation(h,round(chanpos(:,1)*obj.width),round(chanpos(:,2)*obj.height),...
                                obj.corr_win.pos,obj.corr_win.neg,obj.corr_win.sig,...
                                obj.tfmat(i).corr_matrix,obj.corr_win.pos_t,obj.corr_win.neg_t,...
                                obj.tfmat(i).p_matrix,obj.corr_win.sig_t);
                        end
                        
                    end
                end
            end
        end
        
        function AddEventCallback(obj,src)
            
            if obj.add_event_valid
                figure(obj.add_event_fig);
            else
                pos=get(obj.fig,'Position');
                if isempty(obj.event_group)
                    obj.event_group={obj.event};
                end
                h=figure('name','Bind Events','units','pixels','position',[pos(1)+pos(3),pos(2)+pos(4)-150,300,150],...
                    'NumberTitle','off','resize','off','menubar','none',...
                    'CloseRequestFcn',@(src,evts) AddEventCloseCallback(obj,src));
                obj.event_list_listbox=uicontrol('parent',h,'style','listbox','units','normalized','position',[0,0,0.4,1],...
                    'string',obj.event_list,'value',1,'max',3,'min',1);
                obj.event_group_listbox=uicontrol('parent',h,'style','listbox','units','normalized','position',[0.6,0,0.4,1],...
                    'string',obj.event_group,'value',1,'max',3,'min',1);
                uicontrol('parent',h,'style','pushbutton','units','normalized','position',[0.45,0.55,0.1,0.1],...
                    'callback',@(src,evts)AddCallback(obj,src),'string','>>');
                
                uicontrol('parent',h,'style','pushbutton','units','normalized','position',[0.45,0.35,0.1,0.1],...
                    'callback',@(src,evts)RemoveCallback(obj,src),'string','<<');
                obj.add_event_fig=h;
                obj.add_event_valid=1;
            end
        end
        
        function AddCallback(obj,src)
            
            ievent=get(obj.event_list_listbox,'value');
            if isempty(ievent)
                return
            end
            
            obj.event_group=unique(cat(2,obj.event_group,obj.event_list(ievent)'));
            
            set(obj.event_group_listbox,'value',1);
            set(obj.event_group_listbox,'string',obj.event_group);
            
            
        end
        function RemoveCallback(obj,src)
            ievent=get(obj.event_group_listbox,'value');
            if isempty(ievent)
                return
            end
            
            if isempty(obj.event_group)
                return
            end
            obj.event_group(ievent)=[];
            set(obj.event_group_listbox,'value',1);
            set(obj.event_group_listbox,'string',obj.event_group);
        end
        
        function AddEventCloseCallback(obj,src)
            obj.add_event_valid=0;
            if ishandle(src)
                delete(src);
            end
        end
        
        function LinkCallback(obj,src)
            obj.link_=get(src,'value');
        end
        function SymmetricScaleCallback(obj,src)
            obj.symmetric_scale_=get(src,'value');
        end
        
        function ExportMovieCallback(obj)
            %recalculating stft********************************************
            if NoSpatialMapFig(obj)
                ComputeCallback(obj);
            end
            %**************************************************************
            %             profile='Motion JPEG AVI';
            profile='MPEG-4';
            framerate=20;
            quality=100;
            %             t_start=500; %ms
            t_start=get(obj.act_start_slider,'min');
            t_end=get(obj.act_start_slider,'max');
            %**************************************************************
            [FileName,FilePath,FilterIndex]=uiputfile({'*.avi;*.mp4','Video Files (*.avi;*.mp4)';...
                '*.avi','AVI file (*.avi)';
                '*.mp4','MPEG-4 file(*.mp4)'}...
                ,'save your video',fullfile(obj.bsp.FileDir,'untitled'));
            
            if FileName~=0
                filename=fullfile(FilePath,FileName);
            else
                return
            end
            %**************************************************************
            
            set(obj.act_start_slider,'value',t_start);
            step=get(obj.act_start_slider,'sliderstep');
            loops = floor(1/step(1));
            
            step=(get(obj.act_start_slider,'max')-get(obj.act_start_slider,'min'))*step(1);
            
            t=t_start;
            %make a new movie figuer***************************************
            mov_width=0;
            mov_height=0;
            
            
            mov_fig=figure('Name','Movie','NumberTitle','off','Resize','off','units','pixels');
            panel=zeros(length(obj.SpatialMapFig),1);
            
            for i=1:length(obj.SpatialMapFig)
                delete(findobj(obj.SpatialMapFig(i),'tag','mass'));
                pos=get(obj.SpatialMapFig(i),'position');
                
                
                panel(i)=uipanel('parent',mov_fig,'units','pixels','Position',[mov_width,45,pos(3),pos(4)]);
                mov_height=pos(4);
                mov_width=mov_width+pos(3)+10;
                
                child_axes=findobj(obj.SpatialMapFig(i),'type','axes');
                for m=1:length(child_axes)
                    newh=copyobj(child_axes(m),panel(i));
                    set(newh,'position',get(child_axes(m),'position'));
                end
            end
            name_panel=uipanel('parent',mov_fig,'units','pixels','position',[0,45+pos(4),mov_width,30]);
            axes('parent',name_panel,'units','normalized','position',[0,0,1,1],'xlim',[0,1],'ylim',[0,1],'visible','off');
            for i=1:length(obj.SpatialMapFig)
                text('position',[(2*i-1)/(2*length(obj.SpatialMapFig)),0.5],'string',...
                    get(obj.SpatialMapFig(i),'name'),'FontSize',12,'HorizontalAlignment','center');
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
            wait_bar=waitbar(0,'Time: 0');
            
            time_left=uicontrol('parent',wait_bar,'style','text','string','Estimated time left: 0 h 0 min 0 s',...
                'units','normalized','position',[0,0,1,0.2],...
                'backgroundcolor',get(wait_bar,'color'),'horizontalalignment','center');
            %**************************************************************
            
            
            writerObj = VideoWriter(filename,profile);
            writerObj.FrameRate = framerate;
            writerObj.Quality=quality;
            open(writerObj);
            
            loop_start=floor(t_start/step);
            loop_end=floor(t_end/step);
            
            if obj.center_mass
                obj.center_mass_=3;
            end
            
            delta_t=[];
            for k=loop_start:loop_end
                tElapsed=clock;
                
                waitbar(k/loops,wait_bar,['Time: ',num2str(t),' ms']);
                
                delete(allchild(time_panel));
                
                new_handle=copyobj(findobj(wait_bar,'type','axes'),time_panel);
                set(new_handle,'units','normalized','position',[0.02,0.1,0.96,0.3],'FontSize',12);
                
                set(obj.act_start_slider,'value',t);
                ActCallback(obj,obj.act_start_slider);
                for i=1:length(obj.SpatialMapFig)
                    delete(findobj(panel(i),'-regexp','tag','SpatialMapAxes'));
                    child_axes=findobj(obj.SpatialMapFig(i),'-regexp','tag','SpatialMapAxes');
                    newh=copyobj(child_axes,panel(i));
                    set(newh,'position',get(child_axes,'position'));
                end
                
                t=t+step;
                F = im2frame(export_fig(mov_fig, '-nocrop','-r150'));
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
            
            obj.center_mass_=get(obj.center_mass_radio,'value');
        end
        
        function CenterMassCallback(obj,src)
            obj.center_mass_=get(src,'value');
            
            if ~NoSpatialMapFig(obj)
                mapv=obj.map_val;
                chanpos=[obj.pos_x,obj.pos_y,obj.radius];
                erdchan=obj.erd_chan;
                erschan=obj.ers_chan;
                for i=1:length(obj.SpatialMapFig)
                    delete(findobj(obj.SpatialMapFig(i),'tag','mass'));
                    
                    h=findobj(obj.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                    if ~isempty(h)
                        if obj.erd||obj.ers
%                             figure(obj.SpatialMapFig(i))
                            [obj.erd_center{i},obj.ers_center{i}]=plot_mass_center(h,mapv{i},round(chanpos(:,1)*obj.width),round(chanpos(:,2)*obj.height),erdchan{i},erschan{i},obj.center_mass,...
                                obj.erd_center{i},obj.ers_center{i});
                        end
                    end
                end
            end
        end
        
        
        function PeakCallback(obj,src)
            obj.peak_=get(src,'value');
            if ~NoSpatialMapFig(obj)
                mapv=obj.map_val;
                for i=1:length(obj.SpatialMapFig)
                    h=findobj(obj.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                    if ~isempty(h)
                        col=obj.pos_x;
                        row=obj.pos_y;
                        delete(findobj(h,'tag','peak'));
                        if obj.peak
                            [~,I]=max(abs(mapv{i}'));
                            text(col(I)*obj.width,row(I)*obj.height,'p','parent',h,'fontsize',12,'color','w',...
                                'tag','peak');
                        end
                    end
                end
            end
        end
        
        function CorrCallback(obj)
            obj.corr_win.buildfig();
        end
    end
    
    methods
        
        function UpdateCorrelation(obj)
            
            t1=round(obj.act_start/1000*obj.fs);
            t2=t1+round(obj.act_len/1000*obj.fs);
            for i=1:length(obj.tfmat)
                %different movement
                
                corr_matrix=0;
                p_matrix=0;
                tf=obj.tfmat(i);
                for trial=1:size(tf.data,3)
                    [b,a]=butter(2,[obj.min_freq,obj.max_freq]/(obj.fs/2));
                    dt=tf.data(:,:,trial);
                    fdata=filter_symmetric(b,a,dt,obj.fs,0,'iir');
                    
                    t_start=min(t1,size(fdata,1));
                    t_end=min(t2,size(fdata,1));
                    move_data=fdata(t_start:t_end,:);
                    [corr,pval]=corrcoef(move_data);
                    
                    corr_matrix=corr_matrix+corr;
                    p_matrix=p_matrix+pval;
                end
                
                obj.tfmat(i).corr_matrix=corr_matrix/size(tf.data,3);
                obj.tfmat(i).p_matrix=p_matrix/size(tf.data,3);
                
            end
            
        end
        
        function ExportMovieWin(obj)
            
            
        end
    end
    
end

