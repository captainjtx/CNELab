classdef SpatialMapWindow < handle
    %TFMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    properties
        export_menu
        export_movie_menu
        export_pic_menu
        export_trial_info_menu
        
        advance_menu
        stft_menu
        p_menu
        corr_menu
        xcorr_menu
        threshold_menu
        
        valid
        bind_valid
        
        SpatialMapFig
        bsp
        fig
        bind_fig
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
        scale_event_popup
        scale_event_text
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
        resize_edit
        resize_slider
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
        
        bind_event_btn
        bind_baseline_btn
        
        event_list_listbox
        event_group_listbox
        interp_missing_radio
        symmetric_scale_radio
        
        center_mass_radio
        peak_radio
        contact_radio
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
        normalization_event_
        
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
        
        resize_
        
        scale_by_max_
        
        %         display_mask_channel_
        act_start_
        act_len_
        auto_refresh_
        color_bar_
        interp_missing_
        symmetric_scale_
        center_mass_
        peak_
        contact_
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
        normalization_event
        
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
        
        resize
        
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
        
        Act_ievent
        interp_missing
        symmetric_scale
        center_mass
        peak
        contact
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
        all_chan_names
        chan_names
        
        need_recalculate
        
        event_group
        baseline_group
        erd_center
        ers_center
        
        corr_win
        xcorr_win
        export_picture_win
        export_movie_win
        threshold_win
    end
    methods
        function val=get.event_group(obj)
            if isempty(obj.event_group)
                val={obj.event};
            else
                val=obj.event_group;
            end
        end
        
        function val=get.baseline_group(obj)
            if isempty(obj.baseline_group)
                val={obj.normalization_event};
            else
                val=obj.baseline_group;
            end
        end
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
            end
        end
        function val=get.peak(obj)
            val=obj.peak_;
        end
        
        function set.peak(obj,val)
            obj.peak_=val;
            
            if obj.valid
                set(obj.peak_radio,'value',val);
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
            val=obj.bsp.SRate;
        end
%         function set.fs(obj,val)
%             obj.fs_=val;
%             if obj.valid
%                 set(obj.max_freq_slider,'max',val/2);
%                 set(obj.min_freq_slider,'min',val/2);
%             end
%         end
        function val=get.symmetric_scale(obj)
            val=obj.symmetric_scale_;
        end
        function set.symmetric_scale(obj,val)
            obj.symmetric_scale_=val;
            if obj.valid
                set(obj.symmetric_scale_radio,'value',val);
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
        
        function val=get.cmax(obj)
            val=-inf;
            tf=obj.tfmat;
            
            if ~isempty(tf)
                for j=1:length(tf)
                    for i=1:length(tf(j).mat)
                        val=max(val,max(max(abs(tf(j).mat{i}))));
                    end
                end
            end
        end
        function val=get.Act_ievent(obj)
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
                
                if strcmpi(obj.unit,'dB')
                    mapv=10*log10(mapv);
                end
                if obj.scale_by_max
                    mapv=mapv/max(abs(mapv));
                end
                
                if obj.threshold_win.pos
                    ind=find(mapv>0);
                    [abs_val,I]=sort(abs(mapv(ind)),'descend');
                    cumsum_val=cumsum(abs_val);
                    mapv(ind(I(cumsum_val>cumsum_val(end)*obj.threshold_win.pos_t)))=0;
                end
                if obj.threshold_win.neg
                    ind=find(mapv<0);
                    [abs_val,I]=sort(abs(mapv(ind)),'descend');
                    cumsum_val=cumsum(abs_val);
                    mapv(ind(I(cumsum_val>cumsum_val(end)*obj.threshold_win.neg_t)))=0;
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
                        if ~isempty(event_mat)
                            erd_val=[];
                            
                            for t=1:length(event_mat)
                                erd_val=cat(1,erd_val,mean(mean(event_mat{t}(fi,ti))));
                            end
                            
                            tmp(i)=ttest(erd_val,obj.erd_t,'Tail','Left','Alpha',obj.p);
                        end
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
                        if ~isempty(event_mat)
                            ers_val=[];
                            for t=1:length(event_mat)
                                ers_val=cat(1,ers_val,mean(mean(event_mat{t}(fi,ti))));
                            end
                            
                            tmp(i)=ttest(ers_val,obj.ers_t,'Tail','Right','Alpha',obj.p);
                        end
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
                
                obj.xcorr_win.lag_t=min(obj.xcorr_win.lag_t,floor(val/1000*obj.fs)-1);
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
        
        function val=get.resize(obj)
            val=obj.resize_;
        end
        function set.resize(obj,val)
            oldval=obj.resize;
            obj.resize_=val;
            
            if obj.valid
                set(obj.resize_edit,'string',num2str(val));
                set(obj.resize_slider,'value',val);
            end
            
            obj.width=round(obj.width/oldval*val);
            obj.height=round(obj.height/oldval*val);
            
            chanpos=[obj.pos_x,obj.pos_y,obj.radius];
            
            if ~NoSpatialMapFig(obj)
                for i=1:length(obj.SpatialMapFig)
                    if ishandle(obj.SpatialMapFig(i))
                        fpos=get(obj.SpatialMapFig(i),'position');
                        set(obj.SpatialMapFig(i),'position',[fpos(1),fpos(2),obj.fig_w,obj.fig_h]);
                        h=findobj(obj.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                        if ~isempty(h)
                            if ~obj.erd&&~obj.ers
                                delete(findobj(h,'Tag','contact'));
                                figure(obj.SpatialMapFig(i))
                                if obj.contact
                                    plot_contact(h,obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,[],...
                                        ~ismember(obj.all_chan_pos,chanpos,'rows'));
                                end
                            end
                        end
                    end
                end
            end
            
            if obj.color_bar
                obj.color_bar=0;
                ColorBarCallback(obj,obj.color_bar_radio);
                obj.color_bar=1;
                ColorBarCallback(obj,obj.color_bar_radio);
            end
            
            UpdateFigure(obj,obj.resize_edit);
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
            
            if obj.data_input==1
                [~,~,~,sample,~,~,~]=get_selected_datainfo(obj.bsp);
                if obj.valid
                    set(obj.act_start_slider,'max',length(sample)/obj.fs*1000);
                    set(obj.act_len_slider,'max',length(sample)/obj.fs*1000)
                end
                
                obj.act_start=min(length(sample)/obj.fs*1000,obj.act_start_);
                obj.act_len=min(length(sample)/obj.fs*1000,obj.act_len_);
            else
                if obj.valid
                    set(obj.act_start_slider,'max',obj.ms_after,'min',-obj.ms_before);
                    set(obj.act_len_slider,'max',obj.ms_before+obj.ms_after)
                end
                
                obj.act_start=max(-obj.ms_before,min(obj.ms_after,obj.act_start_));
                obj.act_len=min(obj.ms_before+obj.ms_after,obj.act_len_);
            end
            
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
                set(obj.act_start_slider,'max',obj.ms_after,'min',-obj.ms_before);
                set(obj.act_len_slider,'max',obj.ms_after+obj.ms_before,'min',1);
            end
            
            obj.act_start=max(-obj.ms_before,min(obj.ms_after,obj.act_start_));
            obj.act_len=max(1,min(obj.ms_before+obj.ms_after,obj.act_len_));
            
            
        end
        function val=get.ms_after(obj)
            val=obj.ms_after_;
        end
        function set.ms_after(obj,val)
            obj.ms_after_=val;
            if obj.valid
                set(obj.ms_after_edit,'string',num2str(val));
                
                set(obj.act_start_slider,'max',obj.ms_after,'min',-obj.ms_before);
                set(obj.act_len_slider,'max',obj.ms_before+obj.ms_after,'min',1);
            end
            
            obj.act_start=max(-obj.ms_before,min(obj.ms_after,obj.act_start_));
            obj.act_len=max(1,min(obj.ms_before+obj.ms_after,obj.act_len_));
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
                    if ~isempty(obj.event_list)
                        val=obj.event_list{1};
                    else
                        val=[];
                    end
                end
            end
            obj.event_=val;
        end
        function val=get.normalization_event(obj)
            val=obj.normalization_event_;
        end
        function set.normalization_event(obj,val)
            if obj.valid
                ind=find(ismember(obj.event_list,val));
                if isempty(ind)
                    ind=1;
                end
                set(obj.scale_event_popup,'value',ind);
                
                if ~isempty(obj.event_list)
                    val=obj.event_list{ind};
                else
                    val=[];
                end
            end
            obj.normalization_event_=val;
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
                ind=find(ismember(obj.event_list,val));
                if isempty(ind)
                    ind=1;
                end
                set(obj.scale_start_popup,'value',ind);
                
                if ~isempty(obj.event_list)
                    val=obj.event_list{ind};
                else
                    val=[];
                end
            end
            obj.normalization_start_event_=val;
        end
        
        function val=get.normalization_end(obj)
            val=obj.normalization_end_;
        end
        function set.normalization_end(obj,val)
            val=max(obj.normalization_start+obj.stft_winlen/obj.fs*1000,val);
            
            if obj.valid
                if obj.normalization==2
                    set(obj.scale_end_edit,'string',num2str(val));
                    
                elseif obj.normalization==3
                    set(obj.scale_end_edit,'string',val);
                end
            end
            obj.normalization_end_=val;
        end
        
        function val=get.normalization_end_event(obj)
            val=obj.normalization_end_event_;
        end
        
        function set.normalization_end_event(obj,val)
            if obj.valid
                ind=find(ismember(obj.event_list,val));
                if isempty(ind)
                    ind=1;
                end
                set(obj.scale_end_popup,'value',ind);
                if ~isempty(obj.event_list)
                    val=obj.event_list{ind};
                else
                    val=[];
                end
            end
            obj.normalization_end_event_=val;
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
            %             if isempty(obj.event_list_)
            %                 val={'none'};
            %             else
            val=obj.event_list_;
            %             end
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
                set(obj.scale_event_popup,'value',1);
                set(obj.event_popup,'string',val);
                set(obj.scale_start_popup,'string',val);
                set(obj.scale_end_popup,'string',val);
                set(obj.scale_event_popup,'string',val);
                
                if obj.bind_valid
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
            [ia,ib]=ismember(obj.normalization_event,val);
            if ia
                if obj.valid
                    set(obj.scale_event_popup,'value',ib);
                end
            else
                obj.normalization_event=val{1};
            end
        end
    end
    
    methods
        function obj=SpatialMapWindow(bsp)
            obj.bsp=bsp;
            if ~isempty(bsp.Evts)
                obj.event_list_=unique(bsp.Evts(:,2));
            end
            varinitial(obj);
            addlistener(bsp,'EventListChange',@(src,evts)UpdateEventList(obj));
            addlistener(bsp,'SelectedEventChange',@(src,evts)UpdateEventSelected(obj));
            addlistener(bsp,'SelectionChange',@(src,evts)UpdateSelection(obj));
            %             buildfig(obj);
        end
        function UpdateEventList(obj)
            if ~isempty(obj.bsp.Evts)
                obj.event_list=unique(obj.bsp.Evts(:,2));
            end
        end
        function varinitial(obj)
            obj.valid=0;
            obj.data_input_=3;%average event
            obj.ms_before_=1500;
            obj.ms_after_=1500;
            obj.event_='';
            obj.normalization_=2;%average within segments
            obj.normalization_start_=-1500;
            obj.normalization_end_=-1000;
            obj.normalization_start_event_='';
            obj.normalization_end_event_='';
            obj.normalization_event_='';
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
            obj.resize_=1;
            obj.scale_by_max_=0;
            %             obj.display_mask_channel_=0;
            obj.act_start_=0;
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
            obj.bind_valid=0;
            obj.interp_missing_=0;
            obj.symmetric_scale_=1;
            obj.center_mass_=1;
            obj.peak_=1;
            obj.contact_=1;
            
            obj.corr_win=CorrMapWindow(obj);
            obj.xcorr_win=CrossCorrMapWindow(obj);
            
            obj.export_picture_win=ExportPictureWindow(obj);
            obj.export_movie_win=ExportMovieWindow(obj);
            obj.threshold_win=ThresholdWindow(obj);
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
            obj.export_pic_menu=uimenu(obj.export_menu,'label','Pictures','callback',@(src,evts) ExportPictureCallback(obj));
            obj.export_movie_menu=uimenu(obj.export_menu,'label','Movie','callback',@(src,evts) ExportMovieCallback(obj));
            obj.export_trial_info_menu=uimenu(obj.export_menu,'label','Trial Info','callback',@(src,evts) ExportTrialInfoCallback(obj));
            
            obj.advance_menu=uimenu(obj.fig,'label','Settings');
            obj.threshold_menu=uimenu(obj.advance_menu,'label','Threshold','callback',@(src,evts) ThresholdCallback(obj));
            obj.stft_menu=uimenu(obj.advance_menu,'label','STFT','callback',@(src,evts) STFTCallback(obj));
            obj.p_menu=uimenu(obj.advance_menu,'label','P-Value','callback',@(src,evts) PCallback(obj));
            obj.corr_menu=uimenu(obj.advance_menu,'label','Correlation','callback',@(src,evts) CorrCallback(obj));
            obj.xcorr_menu=uimenu(obj.advance_menu,'label','Cross Correlation','callback',@(src,evts) CrossCorrCallback(obj));
            
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
            
            obj.bind_event_btn=uicontrol('parent',hp_data,'style','pushbutton','string','Bind','units','normalized',...
                'position',[0.79,0.6,0.2,0.35],'callback',@(src,evts) BindCallback(obj,src));
            
            obj.ms_before_edit=uicontrol('Parent',hp_data,'Style','Edit','string',num2str(obj.ms_before),'units','normalized','position',[0.4,0.05,0.29,0.3],...
                'HorizontalAlignment','left','visible','off','callback',@(src,evts) MsBeforeCallback(obj,src));
            obj.ms_after_edit=uicontrol('Parent',hp_data,'Style','Edit','string',num2str(obj.ms_after),'units','normalized','position',[0.7,0.05,0.29,0.3],...
                'HorizontalAlignment','left','visible','off','callback',@(src,evts) MsAfterCallback(obj,src));
            
            hp_scale=uipanel('Parent',hp,'Title','Baseline','units','normalized','position',[0,0.73,1,0.12]);
            
            obj.normalization_popup=uicontrol('Parent',hp_scale,'style','popup','units','normalized',...
                'string',{'None','Average Event','External Baseline'},'callback',@(src,evts) NormalizationCallback(obj,src),...
                'position',[0.01,0.6,0.59,0.35],'value',obj.normalization);
            obj.bind_baseline_btn=uicontrol('parent',hp_scale,'style','pushbutton','string','Bind','units','normalized',...
                'position',[0.79,0.6,0.2,0.35],'callback',@(src,evts) BindCallback(obj,src));
            
            obj.scale_event_text=uicontrol('Parent',hp_scale,'Style','text','string','Event: ','units','normalized','position',[0.01,0.3,0.35,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.scale_event_popup=uicontrol('Parent',hp_scale,'Style','popup','string',obj.event_list,'units','normalized','position',[0.01,0.05,0.35,0.3],...
                'visible','off','callback',@(src,evts) ScaleEventCallback(obj,src));
            obj.scale_start_text=uicontrol('Parent',hp_scale,'style','text','units','normalized',...
                'string','Start (ms): ','position',[0.05,0.3,0.4,0.3],'HorizontalAlignment','center',...
                'visible','off');
            obj.scale_end_text=uicontrol('Parent',hp_scale,'style','text','units','normalized',...
                'string','End (ms): ','position',[0.55,0.3,0.4,0.3],'HorizontalAlignment','center',...
                'visible','off');
            obj.scale_start_edit=uicontrol('parent',hp_scale,'style','edit','units','normalized',...
                'string',obj.normalization_start,'position',[0.4,0.05,0.29,0.3],'HorizontalAlignment','center','visible','off',...
                'callback',@(src,evt)NormalizationStartEndCallback(obj,src));
            obj.scale_start_popup=uicontrol('parent',hp_scale,'style','popup','units','normalized',...
                'string',obj.event_list,'position',[0.05,0.05,0.4,0.3],'visible','off',...
                'callback',@(src,evt)NormalizationStartEndCallback(obj,src));
            
            obj.scale_end_edit=uicontrol('parent',hp_scale,'style','edit','units','normalized',...
                'string',obj.normalization_end,'position',[0.7,0.05,0.29,0.3],'HorizontalAlignment','center','visible','off',...
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
                'min',-obj.ms_before,'max',obj.ms_after,'sliderstep',[0.005,0.02],'value',obj.act_start);
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
                'position',[0,0.6,0.18,0.3],'value',obj.erd,'callback',@(src,evts) ERDSCallback(obj,src),'interruptible','off');
            obj.ers_radio=uicontrol('parent',hp_erds,'style','radiobutton','string','ERS','units','normalized',...
                'position',[0,0.1,0.18,0.3],'value',obj.ers,'callback',@(src,evts) ERDSCallback(obj,src),'interruptible','off');
            obj.erd_edit=uicontrol('parent',hp_erds,'style','edit','string',num2str(obj.erd_t),'units','normalized',...
                'position',[0.2,0.55,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ERDSCallback(obj,src),'interruptible','off');
            obj.erd_slider=uicontrol('parent',hp_erds,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) ERDSCallback(obj,src),...
                'min',0,'max',1,'value',obj.erd_t,'sliderstep',[0.01,0.05],'interruptible','off');
            obj.ers_edit=uicontrol('parent',hp_erds,'style','edit','string',num2str(obj.ers_t),'units','normalized',...
                'position',[0.2,0.05,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ERDSCallback(obj,src),'interruptible','off');
            obj.ers_slider=uicontrol('parent',hp_erds,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) ERDSCallback(obj,src),...
                'min',1,'max',10,'value',obj.ers_t,'sliderstep',[0.01,0.05],'interruptible','off');
            
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
            
            
            hp_resize=uipanel('parent',hp,'title','Window Scale','units','normalized','position',[0,0.21,1,0.07]);
            
            uicontrol('parent',hp_resize,'style','text','string','Ratio','units','normalized',...
                'position',[0,0.2,0.1,0.5]);
            obj.resize_edit=uicontrol('parent',hp_resize,'style','edit','string',num2str(obj.resize),'units','normalized',...
                'position',[0.15,0.2,0.2,0.6],'horizontalalignment','center','callback',@(src,evts) ResizeCallback(obj,src));
            obj.resize_slider=uicontrol('parent',hp_resize,'style','slider','units','normalized',...
                'position',[0.4,0.2,0.55,0.6],'callback',@(src,evts) ResizeCallback(obj,src),...
                'min',0.1,'max',2,'value',obj.resize,'sliderstep',[0.01,0.05]);
            
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
            
            
            obj.interp_missing_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Interpolate Missing',...
                'units','normalized','position',[0,0,0.45,0.25],'value',obj.interp_missing,...
                'callback',@(src,evts) InterpMissingCallback(obj,src));
            
            
            obj.symmetric_scale_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Symmetric Scale',...
                'units','normalized','position',[0.5,0.75,0.45,0.25],'value',obj.symmetric_scale,...
                'callback',@(src,evts) SymmetricScaleCallback(obj,src));
            
            obj.center_mass_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Center Mass',...
                'units','normalized','position',[0.5,0.5,0.45,0.25],'value',obj.center_mass>0,...
                'callback',@(src,evts) CenterMassCallback(obj,src));
            
            
            obj.peak_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Peak',...
                'units','normalized','position',[0.5,0.25,0.45,0.25],'value',obj.peak,...
                'callback',@(src,evts) PeakCallback(obj,src));
            
            obj.contact_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Contact',...
                'units','normalized','position',[0.5,0,0.45,0.25],'value',obj.contact,...
                'callback',@(src,evts) ContactCallback(obj,src));
            
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.005,0.2,0.04],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.005,0.2,0.04],...
                'callback',@(src,evts) NewCallback(obj));
            
            obj.refresh_btn=uicontrol('parent',hp,'style','pushbutton','string','Refresh','units','normalized','position',[0.4,0.005,0.2,0.04],...
                'callback',@(src,evts) UpdateFigure(obj,src));
            
            DataPopUpCallback(obj,obj.data_popup);
            NormalizationCallback(obj,obj.normalization_popup);
            
            obj.event=obj.event_;
            obj.normalization_start_event=obj.normalization_start_event_;
            obj.normalization_end_event=obj.normalization_end_event_;
            obj.erd=obj.erd_;
            obj.ers=obj.ers_;
            obj.normalization_event=obj.event;
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
            
            
            h = obj.bind_fig;
            if ishandle(h)
                delete(h);
            end
            
            if obj.corr_win.valid
                delete(obj.corr_win.fig);
            end
            
            if obj.xcorr_win.valid
                delete(obj.xcorr_win.fig);
            end
            
            if obj.export_picture_win.valid
                delete(obj.export_picture_win.fig);
            end
            
            if obj.export_movie_win.valid
                delete(obj.export_movie_win.fig);
            end
            
            if obj.threshold_win.valid
                delete(obj.threshold_win.fig);
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
                    set(obj.bind_baseline_btn,'visible','off');
                    set(obj.scale_event_popup,'enable','off');
                    set(obj.bind_event_btn,'visible','off');
                case 2
                    %Single Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','off');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
                    set(obj.bind_baseline_btn,'visible','off');
                    set(obj.scale_event_popup,'enable','off');
                    set(obj.bind_event_btn,'visible','off');
                case 3
                    %Average Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','on');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
                    set(obj.bind_baseline_btn,'visible','on');
                    set(obj.scale_event_popup,'enable','on');
                    set(obj.bind_event_btn,'visible','on');
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
                    set(obj.scale_event_popup,'visible','off');
                    set(obj.scale_event_text,'visible','off');
                    set(obj.bind_baseline_btn,'visible','off');
                case 2
                    set(obj.scale_start_text,'visible','on','position',[0.4,0.3,0.3,0.3]);
                    set(obj.scale_start_text,'string','Start (ms): ')
                    set(obj.scale_end_text,'visible','on','position',[0.7,0.3,0.3,0.3]);
                    set(obj.scale_end_text,'string','End (ms): ')
                    set(obj.scale_start_edit,'visible','on');
                    set(obj.scale_end_edit,'visible','on');
                    set(obj.scale_start_popup,'visible','off');
                    set(obj.scale_end_popup,'visible','off');
                    set(obj.scale_event_popup,'visible','on');
                    set(obj.scale_event_text,'visible','on');
                    set(obj.bind_baseline_btn,'visible','on');
                case 3
                    set(obj.scale_start_text,'visible','on','position',[0.05,0.3,0.4,0.3]);
                    set(obj.scale_start_text,'string','Start (event): ')
                    set(obj.scale_end_text,'visible','on','position',[0.55,0.3,0.4,0.3]);
                    set(obj.scale_end_text,'string','End (event): ')
                    set(obj.scale_start_edit,'visible','off');
                    set(obj.scale_end_edit,'visible','off');
                    set(obj.scale_start_popup,'visible','on');
                    set(obj.scale_end_popup,'visible','on');
                    set(obj.scale_event_popup,'visible','off');
                    set(obj.scale_event_text,'visible','off');
                    set(obj.bind_baseline_btn,'visible','off');
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
            
            %             obj.clim_slider_max=obj.cmax*1.5;
            %             obj.clim_slider_min=-obj.cmax*1.5;
            
            if obj.auto_refresh
                UpdateFigure(obj,src)
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
                
                sl=obj.min_clim;
                sh=obj.max_clim;
                
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
                    
                    if obj.data_input==1
                        t=max(0,t);
                    end
                    obj.normalization_start=t;
                case obj.scale_end_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.normalization_end;
                    end
                    
                    if obj.data_input==1
                        t=max(0,t);
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
            obj.normalization_event=obj.event_;
        end
        function ScaleEventCallback(obj,src)
            obj.normalization_event_=obj.event_list{get(src,'value')};
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
                    set(obj.SpatialMapFig(i),'Name',[name ' Old']);
                    set(obj.SpatialMapFig(i),'Tag','Old');
                end
                
            end
            NewSpatialMapFig(obj);
        end
        
        function NewSpatialMapFig(obj)
%             delete(obj.SpatialMapFig(ishandle(obj.SpatialMapFig)));
            
            fpos=get(obj.fig,'position');
            
            if obj.data_input==3
                for i=1:length(obj.event_group)
                    obj.SpatialMapFig(i)=figure('Name',[obj.event_group{i}],'NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),...
                        'units','pixels','position',[fpos(1)+fpos(3)+20+(obj.fig_w+20)*(i-1),fpos(2),obj.fig_w,obj.fig_h],'Resize','off',...
                        'doublebuffer','off','Tag','Act');
                end
            else
                obj.SpatialMapFig=figure('Name',[obj.event],'NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),...
                    'units','pixels','position',[fpos(1)+fpos(3)+20,fpos(2),obj.fig_w,obj.fig_h],'Resize','off',...
                    'doublebuffer','off','Tag','Act');
            end
        end
        function ComputeCallback(obj)
            obj.tfmat=[];
            %==========================================================================
            nL=round(obj.ms_before*obj.fs/1000);
            nR=round(obj.ms_after*obj.fs/1000);
            
            %Data selection************************************************************
            if obj.data_input==1
                evt={'selection'};
                omitMask=true;
                [chanNames,dataset,channel,~,~,~,chanpos]=get_selected_datainfo(obj.bsp,omitMask);
            elseif obj.data_input==2
                if isempty(obj.bsp.SelectedEvent)
                    errordlg('No event selection !');
                    return
                elseif length(obj.bsp.SelectedEvent)>1
                    warndlg('More than one event selected, using the first one !');
                end
                i_label=round(obj.bsp.Evts{obj.bsp.SelectedEvent(1),1}*obj.fs);
                i_label=min(max(1,i_label),obj.bsp.TotalSample);
                
                i_label((i_label+nR)>obj.bsp.TotalSample)=[];
                i_label((i_label-nL)<1)=[];
                if isempty(i_label)
                    errordlg('Illegal selection!');
                    return
                end
                data_tmp_sel=[reshape(i_label-nL,1,length(i_label));reshape(i_label+nR,1,length(i_label))];
                omitMask=true;
                [chanNames,dataset,channel,~,~,~,chanpos]=get_selected_datainfo(obj.bsp,omitMask,data_tmp_sel);
                evt={obj.event};
            elseif obj.data_input==3
                evt=obj.event_group;
                
                t_evt=[obj.bsp.Evts{:,1}];
                txt_evt=obj.bsp.Evts(:,2);
                
                t_label=t_evt(ismember(txt_evt,evt));
                txt_evt=txt_evt(ismember(txt_evt,evt));
                if isempty(t_label)
                    errordlg('Event not found !');
                    return
                end
                i_event=round(t_label*obj.fs);
                i_event=min(max(1,i_event),obj.bsp.TotalSample);
                
                i_event((i_event+nR)>obj.bsp.TotalSample)=[];
                txt_evt((i_event+nR)>obj.bsp.TotalSample)=[];
                
                i_event((i_event-nL)<1)=[];
                txt_evt((i_event-nL)<1)=[];
                
                omitMask=true;
                
                [chanNames,dataset,channel,~,~,~,chanpos]=get_selected_datainfo(obj.bsp,omitMask);
                %need to change the data
            end
            %Channel position******************************************************************
            if isempty(chanpos)
                errordlg('No channel position in the data !');
                return
            end
            
            [allchannames,~,~,~,~,~,allchanpos]=get_selected_datainfo(obj.bsp);
            
            chanind=~isnan(allchanpos(:,1))&~isnan(allchanpos(:,2));
            allchanpos=allchanpos(chanind,:);
            allchannames=allchannames(chanind);
            
            [allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),~,~] = ...
                get_relative_chanpos(allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.width,obj.height);
            
            chanind=~isnan(chanpos(:,1))&~isnan(chanpos(:,2));
            
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
            
            delete(obj.SpatialMapFig(ishandle(obj.SpatialMapFig)));
            NewSpatialMapFig(obj);
            
            wd=obj.stft_winlen;
            ov=obj.stft_overlap;
            
            for i=1:length(obj.SpatialMapFig)
                clf(obj.SpatialMapFig(i));
                set(obj.SpatialMapFig(i),'Name',evt{i});
            end
            
            %Normalizatin**************************************************************
            if obj.normalization==1
                nref=[];
                baseline=[];
            elseif obj.normalization==2
                if obj.normalization_start>obj.normalization_end
                    obj.normalization_start=obj.normalization_end-1;
                end
                nref=[];
                baseline=[];
                
                bevt=obj.baseline_group;
                bt_evt=[obj.bsp.Evts{:,1}];
                bt_label=bt_evt(ismember(obj.bsp.Evts(:,2),bevt));
                if isempty(bt_label)
                    errordlg('Normalization event not found !');
                    return
                end
                bi_event=round(bt_label*obj.fs);
                bi_event=min(max(1,bi_event),obj.bsp.TotalSample);
                
                bi_event((bi_event+round(obj.normalization_start/1000*obj.fs))<1)=[];
                bi_event((bi_event+round(obj.normalization_end/1000*obj.fs))>obj.bsp.TotalSample)=[];
                sel=[];
                for i=1:length(bi_event)
                    tmp_sel=[bi_event(i)+round(obj.normalization_start/1000*obj.fs);bi_event(i)+round(obj.normalization_end/1000*obj.fs)];
                    sel=cat(2,sel,tmp_sel);
                end
                omitMask=true;
                [catbaseline,~,~,~,~,~,~,~,segment]=get_selected_data(obj.bsp,omitMask,sel);
                
                seg=unique(segment);
                
                rtfm=cell(size(catbaseline,2),1);
                for j=1:size(catbaseline,2)
                    tmp=0;
                    for i=1:length(seg)
                        bdata=catbaseline(segment==seg(i),j);
                        [ttmp,~,~]=bsp_tfmap(obj.SpatialMapFig,bdata,[],obj.fs,wd,ov,s,[],chanNames,freq,obj.unit);
                        tmp=tmp+ttmp;
                    end
                    rtfm{j}=tmp/length(seg);
                end
                
            elseif obj.normalization==3
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
                
                data_tmp_sel=[reshape(baseline_start,1,length(i_label));reshape(baseline_end,1,length(i_label))];
                omitMask=true;
                baseline=get_selected_data(obj.bsp,omitMask,data_tmp_sel);
                
            end
            %**************************************************************
            
            sel=[];
            for i=1:length(i_event)
                tmp_sel=[i_event(i)-nL;i_event(i)+nR];
                sel=cat(2,sel,tmp_sel);
            end
            
            [data,~,~,~,~,~,~,~,segment]=get_selected_data(obj.bsp,true,sel);
            data=data(:,chanind);
            
            if ~isempty(baseline)
                baseline=baseline(:,chanind);
            end
            
            if ~isempty(rtfm)
                rtfm=rtfm(chanind);
            end
            
            wait_bar_h = waitbar(0,'STFT Recaculating...');
            if obj.data_input==3%Average Event
                for j=1:length(channames)
                    
                    waitbar(j/length(channames));
                    tmp_tfm=cell(1,length(i_event));
                    %******************************************************
                    raw_data=[];
                    
                    for i=1:length(i_event)
                        data1=data(segment==i,j);
                        
                        if obj.normalization==3
                            tmp_base=baseline(:,j);
                        else
                            tmp_base=[];
                        end
                        
                        raw_data=cat(2,raw_data,data1);
                        
                        [tf,f,t]=bsp_tfmap(obj.SpatialMapFig,data1,tmp_base,obj.fs,wd,ov,[sl,sh],nref,channames,freq,obj.unit);
                        tmp_tfm{i}=tf;
                    end
                    t=t-obj.ms_before/1000;
                    for e=1:length(evt)
                        tfm=0;
                        ind=strcmpi(txt_evt,evt{e});
                        event_tfm=tmp_tfm(ind);
                        
                        for k=1:length(event_tfm)
                            tfm=tfm+event_tfm{k};
                        end
                        tfm=tfm/length(event_tfm);
                        
                        %use baseline from all events**********************
                        if ~isempty(rtfm)
                            tfm=tfm./repmat(mean(rtfm{j},2),1,size(tfm,2));
                            
                            for tmp=1:length(event_tfm)
                                event_tfm{tmp}=event_tfm{tmp}./repmat(mean(rtfm{j},2),1,size(tfm,2));
                            end
                        end
                        %**************************************************
                        
                        obj.tfmat(e).mat{j}=tfm;
                        obj.tfmat(e).t=t;
                        obj.tfmat(e).f=f;
                        obj.tfmat(e).channel=channel(chanind);
                        obj.tfmat(e).dataset=dataset(chanind);
                        obj.tfmat(e).channame=channames;
                        obj.tfmat(e).event=evt{e};
                        obj.tfmat(e).trial_mat{j}=event_tfm;
                        obj.tfmat(e).data(:,j,:)=raw_data(:,ind);
                    end
                end
            else
                for j=1:length(channames)
                    waitbar(j/length(channames));
                    [tfm,f,t]=bsp_tfmap(obj.SpatialMapFig,data(:,j),baseline(:,j),obj.fs,wd,ov,[sl,sh],nref,channames,freq,obj.unit);
                    
                    obj.tfmat.mat{j}=tfm;
                    if obj.data_input==2
                        t=t-obj.ms_before/1000;
                    end
                    obj.tfmat.t=t;
                        
                    obj.tfmat.f=f;
                    obj.tfmat.channel=channel;
                    obj.tfmat.dataset=dataset;
                    obj.tfmat.channame=channames;
                    obj.tfmat.trial_mat{j}=[];
                    obj.tfmat.data(:,j)=data(:,j);
                    obj.tfmat.event=evt{1};
                end
            end
            
            
            
            close(wait_bar_h);
            
            set(obj.act_start_slider,'max',max(t*1000));
            set(obj.act_start_slider,'min',min(t*1000));
            if obj.export_movie_win.valid
                set(obj.export_movie_win.t_start_slider,'max',max(t*1000),'min',min(t*1000),'value',0);
                set(obj.export_movie_win.t_end_slider,'max',max(t*1000),'min',min(t*1000),'value',0);
            end
            
            step=min(diff(t))/(max(t)-min(t));
            set(obj.act_start_slider,'sliderstep',[step,step*5]);
            
            obj.pos_x=chanpos(:,1);
            obj.pos_y=chanpos(:,2);
            obj.radius=chanpos(:,3);
            
            if ~obj.scale_by_max
                obj.clim_slider_max=obj.cmax;
                obj.clim_slider_min=-obj.cmax;
            else
                obj.clim_slider_max=1;
                obj.clim_slider_min=-1;
            end
            mapv=obj.map_val;
            
            erdchan=obj.erd_chan;
            erschan=obj.ers_chan;
            
            obj.all_chan_pos=allchanpos;
            obj.all_chan_names=allchannames;
            obj.chan_names=channames;
            
            if obj.corr_win.pos||obj.corr_win.neg||obj.corr_win.sig||obj.corr_win.multi_pos||obj.corr_win.multi_neg
                % correlation
                obj.corr_win.UpdateCorrelation();
            end
            
            if obj.xcorr_win.pos||obj.xcorr_win.multi_pos||obj.xcorr_win.neg||obj.xcorr_win.multi_neg
                obj.xcorr_win.UpdateCrossCorrelation();
            end
            
            obj.erd_center=cell(size(evt));
            obj.ers_center=cell(size(evt));
            
            
            if obj.interp_missing
                map_pos=chanpos;
                map_channames=channames;
                map_mapv=mapv;
            else
                map_pos=allchanpos;
                map_channames=allchannames;
                map_mapv=cell(length(mapv),1);
                for i=1:length(mapv)
                    %default to zeros
                    map_mapv{i}=zeros(length(map_channames),1);
                    ind=ismember(allchannames,channames);
                    map_mapv{i}(ind)=mapv{i};
                end
            end
            for e=1:length(evt)
                spatialmap_grid(obj.SpatialMapFig(e),map_mapv{e},obj.interp_method,...
                    obj.extrap_method,map_channames,map_pos(:,1),map_pos(:,2),map_pos(:,3),obj.width,obj.height,sl,sh,obj.color_bar,obj.resize);
                h=findobj(obj.SpatialMapFig(e),'-regexp','tag','SpatialMapAxes');
                if obj.contact
                    plot_contact(h,allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.height,obj.width,[],...
                        ~ismember(allchanpos,chanpos,'rows'),erdchan{e},erschan{e});
                end
                if obj.peak
                    [~,I]=max(abs(mapv{e}'));
                    text(obj.pos_x(I)*obj.width,obj.pos_y(I)*obj.height,'p','parent',h,'fontsize',round(20*obj.resize),'color','w',...
                        'tag','peak','horizontalalignment','center','fontweight','bold');
                end
                
                if obj.erd||obj.ers
                    [obj.erd_center{e},obj.ers_center{e}]=plot_mass_center(h,mapv{e},round(chanpos(:,1)*obj.width),...
                        round(chanpos(:,2)*obj.height),erdchan{e},erschan{e},obj.center_mass,obj.resize);
                end
                
                %Correlation Network
                if obj.corr_win.pos
                    tmp_pos_t=obj.corr_win.pos_t;
                elseif obj.corr_win.multi_pos
                    tmp_pos_t=obj.corr_win.multi_pos_t;
                else
                    tmp_pos_t=[];
                end
                
                if obj.corr_win.neg
                    tmp_neg_t=obj.corr_win.neg_t;
                elseif obj.corr_win.multi_neg
                    tmp_neg_t=obj.corr_win.multi_neg_t;
                else
                    tmp_neg_t=[];
                end
                
                if obj.corr_win.neg||obj.corr_win.pos||obj.corr_win.sig||obj.corr_win.multi_neg||obj.corr_win.multi_pos
                    
                    plot_correlation(h,round(chanpos(:,1)*obj.width),round(chanpos(:,2)*obj.height),...
                        obj.corr_win.pos||obj.corr_win.multi_pos,obj.corr_win.neg||obj.corr_win.multi_neg,obj.corr_win.sig,...
                        obj.tfmat(e).corr_matrix,tmp_pos_t,tmp_neg_t,...
                        obj.tfmat(e).p_matrix,obj.corr_win.sig_t);
                end
                
                
                %Cross Correlation Network
                if obj.xcorr_win.pos
                    tmp_pos_t=obj.xcorr_win.pos_t;
                elseif obj.xcorr_win.multi_pos
                    tmp_pos_t=obj.xcorr_win.multi_pos_t;
                else
                    tmp_pos_t=[];
                end
                
                if obj.xcorr_win.neg
                    tmp_neg_t=obj.xcorr_win.neg_t;
                elseif obj.xcorr_win.multi_neg
                    tmp_neg_t=obj.xcorr_win.multi_neg_t;
                else
                    tmp_neg_t=[];
                end
                
                if obj.xcorr_win.neg||obj.xcorr_win.pos||obj.xcorr_win.multi_neg||obj.xcorr_win.multi_pos
                    plot_xcorrelation(h,round(chanpos(:,1)*obj.width),round(chanpos(:,2)*obj.height),...
                        obj.xcorr_win.pos||obj.xcorr_win.multi_pos,obj.xcorr_win.neg||obj.xcorr_win.multi_neg,...
                        obj.tfmat(e).xcorr_matrix,tmp_pos_t,tmp_neg_t);
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
                    t=max(get(obj.erd_slider,'min'),min(get(obj.erd_slider,'max'),t));
                    obj.erd_t=t;
                case obj.ers_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.ers_t;
                    end
                    t=max(get(obj.ers_slider,'min'),min(get(obj.ers_slider,'max'),t));
                    obj.ers_t=t;
                case obj.erd_slider
                    obj.erd_t=get(src,'value');
                case obj.ers_slider
                    obj.ers_t=get(src,'value');
            end
            if obj.auto_refresh
                UpdateFigure(obj,src);
            end
        end
        function ResizeCallback(obj,src)
            switch src
                case obj.resize_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.resize;
                    end
                    t=max(0.1,min(t,3));
                    
                    obj.resize=t;
                case obj.resize_slider
                    obj.resize=get(src,'value');
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
            
            if obj.scale_by_max
                obj.clim_slider_max=1;
                obj.clim_slider_min=-1;
            else
                obj.clim_slider_max=obj.cmax;
                obj.clim_slider_min=-obj.cmax;
            end
            if ~obj.auto_refresh
                return
            end
            UpdateFigure(obj,src);
        end
        
        function ActCallback(obj,src)
            switch src
                case obj.act_start_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.act_start;
                    end
                    
                    t=min(max(get(obj.act_start_slider,'min'),t),get(obj.act_start_slider,'max'));
                    obj.act_start=t;
                case obj.act_len_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.act_len;
                    end
                    t=min(max(get(obj.act_len_slider,'min'),t),get(obj.act_len_slider,'max'));
                    obj.act_len=t;
                case obj.act_start_slider
                    obj.act_start=get(src,'value');
                case obj.act_len_slider
                    obj.act_len=get(src,'value');
            end
            if obj.auto_refresh
                UpdateFigure(obj,src);
            end
        end
        function AutoRefreshCallback(obj,src)
            obj.auto_refresh_=get(src,'value');
        end
        
        
        function KeyPress(obj,src,evt)
            if strcmpi(get(src,'Tag'),'Old')
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
            
            %             if ~obj.auto_refresh
            %                 return
            %             end
            
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
        
        function val=NoSpatialMapFig(obj)
            val=isempty(obj.SpatialMapFig)||~all(ishandle(obj.SpatialMapFig))||~all(strcmpi(get(obj.SpatialMapFig,'Tag'),'Act'));
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
        
        function UpdateFigure(obj,src)
            if ~NoSpatialMapFig(obj)
                
                mapv=obj.map_val;
                erdchan=obj.erd_chan;
                erschan=obj.ers_chan;
                
                chanpos=[obj.pos_x,obj.pos_y,obj.radius];
                
                if (obj.corr_win.pos||obj.corr_win.neg||obj.corr_win.sig||obj.corr_win.multi_pos||obj.corr_win.multi_neg)&&ismember(src,...
                        [obj.act_len_edit,obj.act_len_slider,obj.act_start_edit,obj.act_start_slider,...
                        obj.refresh_btn,obj.min_freq_edit,obj.min_freq_slider,obj.max_freq_edit,obj.max_freq_slider])
                    % correlation
                    obj.corr_win.UpdateCorrelation();
                end
                
                if (obj.xcorr_win.pos||obj.xcorr_win.multi_pos||obj.xcorr_win.neg||obj.xcorr_win.multi_neg)&&ismember(src,...
                        [obj.act_len_edit,obj.act_len_slider,obj.act_start_edit,obj.act_start_slider,...
                        obj.refresh_btn,obj.min_freq_edit,obj.min_freq_slider,obj.max_freq_edit,obj.max_freq_slider])
                    obj.xcorr_win.UpdateCrossCorrelation();
                end
                
                if obj.interp_missing
                    map_pos=chanpos;
                    map_mapv=mapv;
                else
                    map_pos=obj.all_chan_pos;
                    map_mapv=cell(length(mapv),1);
                    for i=1:length(mapv)
                        %default to zeros
                        map_mapv{i}=zeros(length(obj.all_chan_names),1);
                        ind=ismember(obj.all_chan_names,obj.chan_names);
                        map_mapv{i}(ind)=mapv{i};
                    end
                end
                
                for i=1:length(obj.SpatialMapFig)
                    h=findobj(obj.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                    if ~isempty(h)
                        col=obj.pos_x;
                        row=obj.pos_y;
                        if strcmpi(obj.interp_method,'natural')
                            [x,y]=meshgrid((1:obj.width)/obj.width,(1:obj.height)/obj.height);
                            
                            F= scatteredInterpolant(map_pos(:,1),map_pos(:,2),map_mapv{i}(:),obj.interp_method,obj.extrap_method);
                            mapvq=F(x,y);
%                             mapvq = gaussInterpolant(col,row,mapv{i}',x,y);
                            
                        else
                            return
                        end
                        
                        imagehandle=findobj(h,'Tag','ImageMap');
                        set(h,'clim',[obj.min_clim,obj.max_clim]);
                        set(h,'xlim',[1,obj.width]);
                        set(h,'ylim',[1,obj.height]);
                        set(imagehandle,'CData',single(mapvq));
                        delete(findobj(h,'tag','peak'));
                        drawnow
                        
                        if obj.erd||obj.ers||ismember(src,[obj.erd_radio,obj.ers_radio])
                            delete(findobj(h,'Tag','contact'));
                            figure(obj.SpatialMapFig(i))
                            if obj.contact
                                plot_contact(h,obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,[],...
                                    ~ismember(obj.all_chan_pos,chanpos,'rows'),erdchan{i},erschan{i});
                            end
                        end
                        
                        if obj.peak
                            [~,I]=max(abs(mapv{i}'));
                            text(col(I)*obj.width,row(I)*obj.height,'p','parent',h,'fontsize',round(20*obj.resize),'color','w',...
                                'tag','peak','horizontalalignment','center','fontweight','bold');
                        end
                        
                        if obj.erd||obj.ers
                            [obj.erd_center{i},obj.ers_center{i}]=plot_mass_center(h,mapv{i},...
                                round(chanpos(:,1)*obj.width),round(chanpos(:,2)*obj.height),...
                                erdchan{i},erschan{i},obj.center_mass,obj.resize,...
                                obj.erd_center{i},obj.ers_center{i});
                        end
                        
                        %Correlation Network
                        if obj.corr_win.pos
                            tmp_pos_t=obj.corr_win.pos_t;
                        elseif obj.corr_win.multi_pos
                            tmp_pos_t=obj.corr_win.multi_pos_t;
                        else
                            tmp_pos_t=[];
                        end
                        
                        if obj.corr_win.neg
                            tmp_neg_t=obj.corr_win.neg_t;
                        elseif obj.corr_win.multi_neg
                            tmp_neg_t=obj.corr_win.multi_neg_t;
                        else
                            tmp_neg_t=[];
                        end
                        % correlation
                        if obj.corr_win.neg||obj.corr_win.pos||obj.corr_win.sig||obj.corr_win.multi_neg||obj.corr_win.multi_pos
                            plot_correlation(h,round(chanpos(:,1)*obj.width),round(chanpos(:,2)*obj.height),...
                                obj.corr_win.pos||obj.corr_win.multi_pos,obj.corr_win.neg||obj.corr_win.multi_neg,obj.corr_win.sig,...
                                obj.tfmat(i).corr_matrix,tmp_pos_t,tmp_neg_t,...
                                obj.tfmat(i).p_matrix,obj.corr_win.sig_t);
                        end
                        
                        %Cross Correlation Network
                        if obj.xcorr_win.pos
                            tmp_pos_t=obj.xcorr_win.pos_t;
                        elseif obj.xcorr_win.multi_pos
                            tmp_pos_t=obj.xcorr_win.multi_pos_t;
                        else
                            tmp_pos_t=[];
                        end
                        
                        if obj.xcorr_win.neg
                            tmp_neg_t=obj.xcorr_win.neg_t;
                        elseif obj.xcorr_win.multi_neg
                            tmp_neg_t=obj.xcorr_win.multi_neg_t;
                        else
                            tmp_neg_t=[];
                        end
                        
                        if obj.xcorr_win.neg||obj.xcorr_win.pos||obj.xcorr_win.multi_neg||obj.xcorr_win.multi_pos
                            plot_xcorrelation(h,round(chanpos(:,1)*obj.width),round(chanpos(:,2)*obj.height),...
                                obj.xcorr_win.pos||obj.xcorr_win.multi_pos,obj.xcorr_win.neg||obj.xcorr_win.multi_neg,...
                                obj.tfmat(i).xcorr_matrix,tmp_pos_t,tmp_neg_t);
                        end
                    end
                end
            end
        end
        
        function BindCallback(obj,src)
            if obj.bind_valid
                figure(obj.bind_fig);
                set(obj.event_group_listbox,'value',1)
                if src==obj.bind_event_btn
                    set(obj.event_group_listbox,'string',obj.event_group);
                    set(obj.bind_fig,'name','Bind Event');
                elseif src==obj.bind_baseline_btn
                    set(obj.event_group_listbox,'string',obj.baseline_group);
                    set(obj.bind_fig,'name','Bind Baseline');
                end
            else
                pos=get(obj.fig,'Position');
                
                if src==obj.bind_event_btn
                    if isempty(obj.event_group)
                        obj.event_group={obj.event};
                    end
                    evt=obj.event_group;
                    fname='Bind Event';
                elseif src==obj.bind_baseline_btn
                    if isempty(obj.baseline_group)
                        obj.baseline_group={obj.event};
                    end
                    evt=obj.baseline_group;
                    fname='Bind Baseline';
                end
                
                h=figure('name',fname,'units','pixels','position',[pos(1)+pos(3),pos(2)+pos(4)-150,300,150],...
                    'NumberTitle','off','resize','off','menubar','none',...
                    'CloseRequestFcn',@(src,evts) BindCloseCallback(obj,src));
                obj.event_list_listbox=uicontrol('parent',h,'style','listbox','units','normalized','position',[0,0,0.4,1],...
                    'string',obj.event_list,'value',1,'max',3,'min',1);
                obj.event_group_listbox=uicontrol('parent',h,'style','listbox','units','normalized','position',[0.6,0,0.4,1],...
                    'string',evt,'value',1,'max',3,'min',1);
                uicontrol('parent',h,'style','pushbutton','units','normalized','position',[0.45,0.55,0.1,0.1],...
                    'callback',@(src,evts)AddCallback(obj,h),'string','>>');
                
                uicontrol('parent',h,'style','pushbutton','units','normalized','position',[0.45,0.35,0.1,0.1],...
                    'callback',@(src,evts)RemoveCallback(obj,h),'string','<<');
                obj.bind_fig=h;
                obj.bind_valid=1;
            end
        end
        
        
        function AddCallback(obj,h)
            
            ievent=get(obj.event_list_listbox,'value');
            if isempty(ievent)
                return
            end
            
            if strcmp(get(h,'name'),'Bind Event')
                obj.event_group=unique(cat(2,obj.event_group,obj.event_list(ievent)'));
                set(obj.event_group_listbox,'value',1);
                set(obj.event_group_listbox,'string',obj.event_group);
            elseif strcmp(get(h,'name'),'Bind Baseline')
                obj.baseline_group=unique(cat(2,obj.baseline_group,obj.event_list(ievent)'));
                set(obj.event_group_listbox,'value',1);
                set(obj.event_group_listbox,'string',obj.baseline_group);
            end
        end
        function RemoveCallback(obj,h)
            ievent=get(obj.event_group_listbox,'value');
            if isempty(ievent)
                return
            end
            
            if strcmp(get(h,'name'),'Bind Event')
                %                 obj.event_group=get(obj.event_group_listbox,'string');
                if isempty(obj.event_group)
                    return
                end
                obj.event_group(ievent)=[];
                set(obj.event_group_listbox,'value',1);
                set(obj.event_group_listbox,'string',obj.event_group);
            elseif strcmp(get(h,'name'),'Bind Baseline')
                if isempty(obj.baseline_group)
                    return
                end
                obj.baseline_group(ievent)=[];
                set(obj.event_group_listbox,'value',1);
                set(obj.event_group_listbox,'string',obj.baseline_group);
            end
        end
        
        function BindCloseCallback(obj,src)
            obj.bind_valid=0;
            if ishandle(src)
                delete(src);
            end
        end
        
        function InterpMissingCallback(obj,src)
            obj.interp_missing_=get(src,'value');
            if obj.auto_refresh
                UpdateFigure(obj,src);
            end
        end
        function SymmetricScaleCallback(obj,src)
            obj.symmetric_scale_=get(src,'value');
        end
        
        function ExportMovieCallback(obj)
            obj.export_movie_win.buildfig();
            
        end
        function ThresholdCallback(obj)
            obj.threshold_win.buildfig();
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
                            [obj.erd_center{i},obj.ers_center{i}]=plot_mass_center(h,mapv{i},round(chanpos(:,1)*obj.width),...
                                round(chanpos(:,2)*obj.height),erdchan{i},erschan{i},obj.center_mass,obj.resize,...
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
                            text(col(I)*obj.width,row(I)*obj.height,'p','parent',h,'fontsize',round(20*obj.resize),'color','w',...
                                'tag','peak','horizontalalignment','center','fontweight','bold');
                        end
                    end
                end
            end
        end
        
        function CorrCallback(obj)
            obj.corr_win.buildfig();
        end
        
        
        function CrossCorrCallback(obj)
            obj.xcorr_win.buildfig();
        end
        
        function ContactCallback(obj,src)
            obj.contact_=get(src,'value');
            chanpos=[obj.pos_x,obj.pos_y,obj.radius];
            if ~NoSpatialMapFig(obj)
                for i=1:length(obj.SpatialMapFig)
                    h=findobj(obj.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                    if ~isempty(h)
                        delete(findobj(h,'Tag','contact'));
                        figure(obj.SpatialMapFig(i))
                        if obj.contact
                            plot_contact(h,obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,[],...
                                ~ismember(obj.all_chan_pos,chanpos,'rows'),obj.erd_chan{i},obj.ers_chan{i});
                        end
                        
                    end
                end
            end
        end
    end
    
    methods
        function ExportPictureCallback(obj)
            obj.export_picture_win.buildfig();
        end
        
        function UpdateSelection(obj)
            if obj.data_input==1
                [~,~,~,sample,~,~,~]=get_selected_datainfo(obj.bsp);
                if obj.valid
                    set(obj.act_start_slider,'max',length(sample)/obj.fs*1000);
                    set(obj.act_len_slider,'max',length(sample)/obj.fs*1000);
                end
                
                obj.act_start=min(length(sample)/obj.fs*1000,obj.act_start_);
                obj.act_len=min(length(sample)/obj.fs*1000,obj.act_len_);
            end
        end
        function ExportTrialInfoCallback(obj)
            [FileName,FilePath,FilterIndex]=uiputfile({'*.mat','Matlab Files (*.mat)';...
                '*.txt','Text File (*.evt)'}...
                ,'save your trial informations',fullfile(obj.bsp.FileDir,'info'));
            if FileName~=0
                filename=fullfile(FilePath,FileName);
                switch FilterIndex
                    case 1
                        %matlab file
                        erdchan=obj.erd_chan;
                        erschan=obj.ers_chan;
                        for k=1:length(obj.tfmat)
                            %k th event
                            tf=obj.tfmat(k);
                            
                            fi=(tf.f>=obj.min_freq)&(tf.f<=obj.max_freq);
                            ti=(tf.t>=obj.act_start/1000)&(tf.t<=obj.act_start/1000+obj.act_len/1000);
                            
                            
                            for i=1:length(tf.trial_mat)
                                %i th channel
                                event_mat=tf.trial_mat{i};
                                if ~isempty(event_mat)
                                    pow_val=[];
                                    
                                    for t=1:length(event_mat)
                                        %t th trial
                                        pow_val=cat(1,pow_val,mean(mean(event_mat{t}(fi,ti))));
                                    end
                                    
                                    info(k).pow(:,i)=pow_val(:);
                                end
                            end
                            info(k).event=tf.event;
                            info(k).channame=tf.channame;
                            info(k).erd_chan=erdchan{k};
                            info(k).ers_chan=erschan{k};
                        end
                        save(filename,'info');
                        
                        [pathstr,name,ext] = fileparts(filename);
                        assignin('base',name,info);
                        
                    case 2
                        %text file
                        
                end
            else
                return
            end
            
            
        end
    end
    
end

