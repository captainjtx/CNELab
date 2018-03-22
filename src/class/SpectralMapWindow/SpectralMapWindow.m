classdef SpectralMapWindow < handle
    %TFMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    properties
        export_menu
        export_movie_menu
        export_pic_menu
        export_trial_info_menu
        export_map_menu
        
        advance_menu
        p_menu
        fdr_menu
        
        more_menu
        corr_menu
        xcorr_menu
        map_menu
        map_interp_menu
        map_scatter_menu
        cov_menu
        smooth_menu
        
        valid
        bind_valid
        
        SpectralMapFig
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
        max_freq_slider
        min_freq_slider
        JMinSpinner
        JMaxSpinner
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
        extrap_radio
        symmetric_scale_radio
        
        center_mass_radio
        peak_radio
        contact_radio
        names_radio
        smooth_radio
        
        pos_radio
        pos_edit
        pos_slider
        
        neg_radio
        neg_edit
        neg_slider
        
        stft_winlen_edit
        stft_overlap_edit
        
        az_edit
        el_edit
        
        fdr %false discovery rate level
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
        cmax_
        cmin_
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
        extrap_
        symmetric_scale_
        center_mass_
        peak_
        contact_
        disp_channel_names_
        
        neg_t
        pos_t
        
        pos_
        neg_
        
        stft_winlen_
        stft_overlap_
        az_
        el_
        
        interp_scatter_
        smooth_
        smooth_row_
        smooth_col_
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
        cmin
        cmax
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
        vmax
        
        Act_ievent
        interp_missing
        extrap
        symmetric_scale
        center_mass
        peak
        contact
        disp_channel_names
        
        pos
        neg
        
        stft_winlen
        stft_overlap
        
        az
        el
        
        interp_scatter
        smooth
        smooth_row
        smooth_col
    end
    properties
        width
        height
        tfmat
        unit
        p
        
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
        cov_win
        export_picture_win
        export_movie_win
        OldFig
    end
    methods
        function val = get.smooth(obj)
            val = obj.smooth_;
        end
        
        function set.smooth(obj, val)
            obj.smooth_=val;
            
            if obj.valid
                set(obj.smooth_radio,'value',val);
            end
        end
        
        function val = get.smooth_row(obj)
            if obj.smooth_
                val = obj.smooth_row_;
            else
                val = [];
            end
        end
        
        function set.smooth_row(obj, val)
            obj.smooth_row_=val;
        end
        function val = get.smooth_col(obj)
            if obj.smooth_
                val = obj.smooth_col_;
            else
                val = [];
            end
        end
        
        function set.smooth_col(obj, val)
            obj.smooth_col_=val;
        end
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
                val=ishandle(obj.fig)&&isgraphics(obj.fig);
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
        
        function val=get.stft_winlen(obj)
            val=obj.stft_winlen_;
        end
        
        function set.stft_winlen(obj,val)
            obj.stft_winlen_=val;
            
            if obj.valid
                set(obj.stft_winlen_edit,'value',val);
            end
        end
        
        function val=get.stft_overlap(obj)
            val=obj.stft_overlap_;
        end
        
        function set.stft_overlap(obj,val)
            obj.stft_overlap_=val;
            
            if obj.valid
                set(obj.stft_overlap_edit,'value',val);
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
        
        function val=get.az(obj)
            val=obj.az_;
        end
        function set.az(obj,val)
            obj.az_=val;
            if obj.valid
                set(obj.az_edit,'string',num2str(val));
            end
        end
        function val=get.el(obj)
            val=obj.el_;
        end
        function set.el(obj,val)
            obj.el_=val;
            if obj.valid
                set(obj.el_edit,'string',num2str(val));
            end
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
        
        function val=get.vmax(obj)
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
            %**************************************************
            
            for k=1:length(obj.tfmat)
                tf=obj.tfmat(k);
            
                fi=(tf.f>=obj.min_freq)&(tf.f<=obj.max_freq);
                ti=(tf.t>=obj.act_start/1000)&(tf.t<=obj.act_start/1000+obj.act_len/1000);
                
                mapv=zeros(1,length(tf.mat));
                basev=zeros(1,length(tf.mat));
                for i=1:length(tf.mat)
                    basev(i)=mean(mean(tf.ref_mat{i}(fi,:),2));
                    mapv(i)=mean(mean(tf.mat{i}(fi,ti)));
                end
                mapv=mapv./basev;
                
                if strcmpi(obj.unit,'dB')
                    mapv=10*log10(mapv);
                end
                if obj.scale_by_max
                    mapv=mapv/max(abs(mapv));
                end
                
                if obj.pos
                    ind=find(mapv>=0);
                    [abs_val,I]=sort(abs(mapv(ind)),'descend');
                    cumsum_val=cumsum(abs_val);
                    mapv(ind(I(cumsum_val>cumsum_val(end)*obj.pos_t)))=0;
                end
                if obj.neg
                    ind=find(mapv<=0);
                    [abs_val,I]=sort(abs(mapv(ind)),'descend');
                    cumsum_val=cumsum(abs_val);
                    mapv(ind(I(cumsum_val>cumsum_val(end)*obj.neg_t)))=0;
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
                                erd_val=cat(1,erd_val,mean(mean(event_mat{t}(fi,ti)))./mean(mean(tf.ref_mat{i}(fi,:))));
                            end
                            %transform to log10 scale before ttest
                            [~,tmp(i)]=ttest(log10(erd_val),log10(obj.erd_t),'Tail','Left','Alpha',obj.p);
                        end
                    end
                end
                [~,pN]=FDR(tmp,obj.fdr);
                
                if(~isempty(pN))
                    tmp=tmp<pN;
                else
                    tmp(:)=0;
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
                                ers_val=cat(1,ers_val,mean(mean(event_mat{t}(fi,ti)))./mean(mean(tf.ref_mat{i}(fi,:))));
                            end
                            %transform to log10 scale before ttest
                            [~,tmp(i)]=ttest(log10(ers_val),log10(obj.ers_t),'Tail','Right','Alpha',obj.p);
                        end
                    end
                end
                [pID,pN]=FDR(tmp,obj.fdr);
                
                if(~isempty(pN))
                    tmp=tmp<pN;
                else
                    tmp(:)=0;
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
            
            erdchan=obj.erd_chan;
            erschan=obj.ers_chan;
            
            if ~NoSpectralMapFig(obj)
                mapv=obj.map_val;
                
                for i=1:length(obj.SpectralMapFig)
                    if ishandle(obj.SpectralMapFig(i))
                        fpos=get(obj.SpectralMapFig(i),'position');
                        set(obj.SpectralMapFig(i),'position',[fpos(1),fpos(2),obj.fig_w,obj.fig_h]);
                        h=findobj(obj.SpectralMapFig(i),'-regexp','Tag','MapAxes');
                        if ~isempty(h)
                            if ~obj.erd&&~obj.ers
                                delete(findobj(h,'Tag','contact'));
                                delete(findobj(h,'Tag','names'));
                                figure(obj.SpectralMapFig(i))
                                if obj.disp_channel_names
                                    channames=obj.all_chan_names;
                                else
                                    channames=[];
                                end
                                
                                if obj.contact||strcmp(obj.interp_scatter,'scatter')
                                    if strcmp(obj.interp_scatter,'scatter')
                                        plot_contact(h,mapv{i},obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,channames,...
                                            ~ismember(obj.all_chan_pos,chanpos,'rows'),erdchan{i},erschan{i});
                                    else
                                        plot_contact(h,[],obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,channames,...
                                            ~ismember(obj.all_chan_pos,chanpos,'rows'),erdchan{i},erschan{is});
                                    end
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
            obj.JMinSpinner.setValue(java.lang.Double(val));
            obj.JMinSpinner.getModel().setStepSize(java.lang.Double(abs(val)/10));
            drawnow
        end
        
        function set.cmax(obj,val)
            if(val<obj.cmin)
                return
            end
            obj.cmax_=val;
            obj.JMaxSpinner.setValue(java.lang.Double(val));
            obj.JMaxSpinner.getModel().setStepSize(java.lang.Double(abs(val)/10));
            drawnow
        end
        
        function val=get.event_list(obj)
            if isempty(obj.event_list_)
               val={'none'};
            else
                val=obj.event_list_;
            end
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
        
        
        function val=get.pos(obj)
            val=obj.pos_;
        end
        
        function set.pos(obj,val)
            obj.pos_=val;
            if obj.valid
                if obj.pos
                    set(obj.pos_edit,'enable','on');
                    set(obj.pos_slider,'enable','on');
                else
                    set(obj.pos_edit,'enable','off');
                    set(obj.pos_slider,'enable','off');
                end
            end
        end
        
        function val=get.neg(obj)
            val=obj.neg_;
        end
        
        function set.neg(obj,val)
            obj.neg_=val;
            if obj.valid
                if obj.neg
                    set(obj.neg_edit,'enable','on');
                    set(obj.neg_slider,'enable','on');
                else
                    set(obj.neg_edit,'enable','off');
                    set(obj.neg_slider,'enable','off');
                end
            end
        end
        
        function val=get.interp_scatter(obj)
            val=obj.interp_scatter_;
        end
        
        function set.interp_scatter(obj,val)
            obj.interp_scatter_=val;
            
            if obj.valid
                switch val
                    case 'interp'
                        set(obj.map_interp_menu,'checked','on');
                        set(obj.map_scatter_menu,'checked','off');
                    case 'scatter'
                        set(obj.map_scatter_menu,'checked','on');
                        set(obj.map_interp_menu,'checked','off');
                end
            end
        end
    end
    
    methods
        function obj=SpectralMapWindow(bsp)
            obj.bsp=bsp;
            varinitial(obj);
            addlistener(bsp,'EventListChange',@(src,evts)UpdateEventList(obj));
            addlistener(bsp,'SelectedEventChange',@(src,evts)UpdateEventSelected(obj));
            addlistener(bsp,'SelectionChange',@(src,evts)UpdateSelection(obj));
            %             buildfig(obj);
        end
        function UpdateEventList(obj)
            if ~isempty(obj.bsp.Evts)
                if isempty(obj.event_list_)
                    if obj.valid
                        set(obj.data_popup,'String',{'Selection', 'Single Event', 'Average Event'});
                        set(obj.normalization_popup,'String',{'None','Average Event','External Baseline'});
                    end
                end
                obj.event_list = unique(obj.bsp.Evts(:,2));
            else
                if obj.valid
                    set(obj.data_popup,'String',{'Selection'}, 'Value', 1);
                    set(obj.normalization_popup, 'String', {'None'}, 'Value', 1);
                    DataPopUpCallback(obj, obj.data_popup);
                    NormalizationCallback(obj, obj.normalization_popup);
                end
                obj.event_list_ = {};
            end
        end
        function varinitial(obj)
            if ~isempty(obj.bsp.Evts)
                obj.event_list_=unique(obj.bsp.Evts(:,2));
            else
                obj.event_list_ = {};
            end
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
            obj.cmin_=-10;
            obj.cmax_=10;
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
            obj.stft_winlen_=round(obj.fs/3);
            obj.stft_overlap_=round(obj.stft_winlen*0.9);
            obj.unit='dB';
            obj.p=0.05;
            obj.bind_valid=0;
            obj.interp_missing_ = 0;
            obj.extrap_ = 0;
            obj.symmetric_scale_=1;
            obj.center_mass_=0;
            obj.peak_=1;
            obj.contact_=1;
            obj.disp_channel_names_=0;
            
            obj.neg_=0;
            obj.pos_=0;
            obj.neg_t=1;
            obj.pos_t=1;
            
            obj.az_=0;
            obj.el_=90;
            
            obj.corr_win=CorrMapWindow(obj);
            obj.xcorr_win=CrossCorrMapWindow(obj);
            obj.cov_win=CovMapWindow(obj);
            
            obj.export_picture_win=ExportPictureWindow(obj);
            obj.export_movie_win=ExportMovieWindow(obj);
            
            obj.interp_scatter='interp';
            obj.fdr = obj.p;
            obj.smooth_ = 0;
            obj.smooth_row_ = 5;
            obj.smooth_col_ = 5;
        end
        function buildfig(obj)
            import javax.swing.JSpinner;
            import javax.swing.SpinnerNumberModel;
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.valid=1;
            obj.fig=figure('MenuBar','none','Name','Spatial-Spectral Map','units','pixels',...
                'Position',[100 100 300 700],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));
            
            obj.export_menu=uimenu(obj.fig,'label','Export');
            obj.export_pic_menu=uimenu(obj.export_menu,'label','Pictures','callback',@(src,evts) ExportPictureCallback(obj),'Accelerator','p');
            obj.export_movie_menu=uimenu(obj.export_menu,'label','Movie','callback',@(src,evts) ExportMovieCallback(obj),'Accelerator','n');
            obj.export_trial_info_menu=uimenu(obj.export_menu,'label','Trial Info','callback',@(src,evts) ExportTrialInfoCallback(obj));
            obj.export_map_menu=uimenu(obj.export_menu,'label','Map','callback',@(src,evts) ExportMapCallback(obj));
            
            obj.advance_menu=uimenu(obj.fig,'label','Settings');
            obj.map_menu=uimenu(obj.advance_menu,'label','Visualization');
            obj.map_interp_menu=uimenu(obj.map_menu,'label','Interpolate','callback',@(src,evt) MapCallback(obj,src));
            obj.map_scatter_menu=uimenu(obj.map_menu,'label','Scatter','callback',@(src,evt) MapCallback(obj,src));
            
            obj.p_menu=uimenu(obj.advance_menu,'label','P-Value','callback',@(src,evts) PCallback(obj));
            obj.fdr_menu=uimenu(obj.advance_menu,'label','FDR-Level','callback',@(src,evts) FDRCallback(obj));
            
            obj.smooth_menu = uimenu(obj.advance_menu, 'label', 'Smooth Kernel', 'callback', @(src, evts) SmoothMenuCallback(obj, src));
            
            obj.more_menu=uimenu(obj.fig,'label','More');
            
            obj.corr_menu=uimenu(obj.more_menu,'label','Correlation','callback',@(src,evts) CorrCallback(obj));
            obj.xcorr_menu=uimenu(obj.more_menu,'label','Cross Correlation','callback',@(src,evts) CrossCorrCallback(obj));
            obj.cov_menu=uimenu(obj.more_menu,'label','Covariance','callback',@(src,evts) CovCallback(obj));
            
            hp=uipanel('units','normalized','Position',[0,0,1,1]);
            
            hp_data=uipanel('Parent',hp,'Title','Data','Units','normalized','Position',[0,0.86,1,0.13]);
            
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
            
            obj.bind_event_btn=uicontrol('Parent',hp_data,'style','pushbutton','string','Bind','units','normalized',...
                'position',[0.79,0.65,0.2,0.32],'callback',@(src,evts) BindCallback(obj,src));
            
            obj.ms_before_edit=uicontrol('Parent',hp_data,'Style','Edit','string',num2str(obj.ms_before),'units','normalized','position',[0.4,0.05,0.29,0.3],...
                'HorizontalAlignment','left','visible','off','callback',@(src,evts) MsBeforeCallback(obj,src));
            obj.ms_after_edit=uicontrol('Parent',hp_data,'Style','Edit','string',num2str(obj.ms_after),'units','normalized','position',[0.7,0.05,0.29,0.3],...
                'HorizontalAlignment','left','visible','off','callback',@(src,evts) MsAfterCallback(obj,src));
            
            hp_scale=uipanel('Parent',hp,'Title','Baseline','units','normalized','position',[0,0.72,1,0.13]);
            
            obj.normalization_popup=uicontrol('Parent',hp_scale,'style','popup','units','normalized',...
                'string',{'None','Average Event','External Baseline'},'callback',@(src,evts) NormalizationCallback(obj,src),...
                'position',[0.01,0.6,0.59,0.35],'value',obj.normalization);
            obj.bind_baseline_btn=uicontrol('parent',hp_scale,'style','pushbutton','string','Bind','units','normalized',...
                'position',[0.79,0.65,0.2,0.32],'callback',@(src,evts) BindCallback(obj,src));
            
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
            
            hp_act=uipanel('parent',hp,'title','Activation (ms)','units','normalized','position',[0,0.61,1,0.1]);
            
            uicontrol('parent',hp_act,'style','text','string','Start','units','normalized',...
                'position',[0,0.6,0.1,0.3]);
            uicontrol('parent',hp_act,'style','text','string','Len','units','normalized',...
                'position',[0,0.1,0.1,0.3]);
            
            obj.act_start_edit=uicontrol('parent',hp_act,'style','edit','string',num2str(obj.act_start),'units','normalized',...
                'position',[0.15,0.55,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) ActCallback(obj,src));
            obj.act_start_slider=uicontrol('parent',hp_act,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) ActCallback(obj,src),...
                'min',-obj.ms_before,'max',obj.ms_after,'sliderstep',[0.005,0.02],'value',obj.act_start);
            obj.act_len_edit=uicontrol('parent',hp_act,'style','edit','string',num2str(obj.act_len),'units','normalized',...
                'position',[0.15,0.05,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) ActCallback(obj,src));
            obj.act_len_slider=uicontrol('parent',hp_act,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) ActCallback(obj,src),...
                'min',1,'max',obj.ms_before+obj.ms_after,'sliderstep',[0.005,0.02],'value',obj.act_len);
            
            hp_freq=uipanel('parent',hp,'title','Frequency','units','normalized','position',[0,0.5,1,0.1]);
            
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
            
            
            hp_scale=uipanel('parent',hp,'title','Scale','units','normalized','position',[0,0.39,1,0.1]);
            
            uicontrol('parent',hp_scale,'style','text','units','normalized','position',[0,0.2,0.12,0.5],...
                'string','Min','horizontalalignment','left','fontunits','normalized','fontsize',0.4);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmin),[],[],java.lang.Double(abs(obj.cmin)/10)));
            obj.JMinSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JMinSpinner,[0,0,1,1],hp_scale);
            set(gh,'Units','Norm','Position',[0.12,0.2,0.35,0.6]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ScaleSpinnerCallback(obj));
            
            uicontrol('parent',hp_scale,'style','text','units','normalized','position',[0.5,0.2,0.12,0.5],...
                'string','Max','horizontalalignment','left','fontunits','normalized','fontsize',0.4);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmax),[],[],java.lang.Double(abs(obj.cmax)/10)));
            obj.JMaxSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JMaxSpinner,[0,0,1,1],hp_scale);
            set(gh,'Units','Norm','Position',[0.62,0.2,0.35,0.6]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ScaleSpinnerCallback(obj));
            
            
            tgp=uitabgroup(hp,'units','normalized','position',[0,0.24,1,0.14],'tablocation','top');
            
            tab_stft=uitab(tgp,'title','STFT');
            
            uicontrol('parent',tab_stft,'style','text','string','Window (sample): ','units','normalized',...
                'position',[0,0.6,0.5,0.3]);
            obj.stft_winlen_edit=uicontrol('parent',tab_stft,'style','edit','string',num2str(obj.stft_winlen),...
                'units','normalized','position',[0.1,0.1,0.3,0.45],'HorizontalAlignment','center',...
                'callback',@(src,evts) STFTCallback(obj,src));
            uicontrol('parent',tab_stft,'style','text','string','Overlap (sample): ',...
                'units','normalized','position',[0.5,0.6,0.5,0.3]);
            obj.stft_overlap_edit=uicontrol('parent',tab_stft,'style','edit','string',num2str(obj.stft_overlap),...
                'units','normalized','position',[0.6,0.1,0.3,0.45],'HorizontalAlignment','center',...
                'callback',@(src,evts) STFTCallback(obj,src));
            
            tab_t=uitab(tgp,'title','Threshold');
            
            obj.pos_radio=uicontrol('parent',tab_t,'style','radiobutton','string','++','units','normalized',...
                'position',[0,0.55,0.18,0.4],'value',obj.pos,'callback',@(src,evts) TCallback(obj,src),'fontsize',10);
            obj.pos_edit=uicontrol('parent',tab_t,'style','edit','string',num2str(obj.pos_t),'units','normalized',...
                'position',[0.2,0.55,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) TCallback(obj,src));
            obj.pos_slider=uicontrol('parent',tab_t,'style','slider','units','normalized',...
                'position',[0.4,0.55,0.55,0.4],'callback',@(src,evts) TCallback(obj,src),...
                'min',0,'max',1,'value',obj.pos_t,'sliderstep',[0.01,0.05]);
            
            obj.neg_radio=uicontrol('parent',tab_t,'style','radiobutton','string','---','units','normalized',...
                'position',[0,0.05,0.18,0.4],'value',obj.neg,'callback',@(src,evts) TCallback(obj,src),'fontsize',10);
            obj.neg_edit=uicontrol('parent',tab_t,'style','edit','string',num2str(obj.neg_t),'units','normalized',...
                'position',[0.2,0.05,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) TCallback(obj,src));
            obj.neg_slider=uicontrol('parent',tab_t,'style','slider','units','normalized',...
                'position',[0.4,0.05,0.55,0.4],'callback',@(src,evts) TCallback(obj,src),...
                'min',0,'max',1,'value',obj.neg_t,'sliderstep',[0.01,0.05]);
            
            tab_erds=uitab(tgp,'title','T-Test');
            
            obj.erd_radio=uicontrol('parent',tab_erds,'style','radiobutton','string','ERD','units','normalized',...
                'position',[0,0.05,0.18,0.4],'value',obj.erd,'callback',@(src,evts) ERDSCallback(obj,src),'interruptible','off');
            obj.ers_radio=uicontrol('parent',tab_erds,'style','radiobutton','string','ERS','units','normalized',...
                'position',[0,0.55,0.18,0.4],'value',obj.ers,'callback',@(src,evts) ERDSCallback(obj,src),'interruptible','off');
            obj.erd_edit=uicontrol('parent',tab_erds,'style','edit','string',num2str(obj.erd_t),'units','normalized',...
                'position',[0.2,0.05,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ERDSCallback(obj,src),'interruptible','off');
            obj.erd_slider=uicontrol('parent',tab_erds,'style','slider','units','normalized',...
                'position',[0.4,0.05,0.55,0.4],'callback',@(src,evts) ERDSCallback(obj,src),...
                'min',0,'max',1,'value',obj.erd_t,'sliderstep',[0.01,0.05],'interruptible','off');
            obj.ers_edit=uicontrol('parent',tab_erds,'style','edit','string',num2str(obj.ers_t),'units','normalized',...
                'position',[0.2,0.55,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ERDSCallback(obj,src),'interruptible','off');
            obj.ers_slider=uicontrol('parent',tab_erds,'style','slider','units','normalized',...
                'position',[0.4,0.55,0.55,0.4],'callback',@(src,evts) ERDSCallback(obj,src),...
                'min',1,'max',10,'value',obj.ers_t,'sliderstep',[0.01,0.05],'interruptible','off');
            
            hp_shape=uitab(tgp,'title','Shape');
            
            uicontrol('parent',hp_shape,'style','text','string','Size','units','normalized',...
                'position',[0,0.6,0.18,0.36]);
            obj.resize_edit=uicontrol('parent',hp_shape,'style','edit','string',num2str(obj.resize),'units','normalized',...
                'position',[0.2,0.55,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ResizeCallback(obj,src));
            obj.resize_slider=uicontrol('parent',hp_shape,'style','slider','units','normalized',...
                'position',[0.4,0.55,0.55,0.4],'callback',@(src,evts) ResizeCallback(obj,src),...
                'min',0.1,'max',2,'value',obj.resize,'sliderstep',[0.01,0.05]);
            
            uicontrol('parent',hp_shape,'style','text','string','View','units','normalized',...
                'position',[0,0.1,0.18,0.36]);
            
            uicontrol('parent',hp_shape,'style','text','string','az: ','units','normalized',...
                'position',[0.2,0.1,0.1,0.36]);
            obj.az_edit=uicontrol('parent',hp_shape,'style','edit','string',num2str(obj.az),'units','normalized',...
                'position',[0.3,0.05,0.2,0.4],'callback',@(src,evts) ViewCallback(obj,src));
            uicontrol('parent',hp_shape,'style','text','string','el: ','units','normalized',...
                'position',[0.6,0.1,0.1,0.36]);
            obj.el_edit=uicontrol('parent',hp_shape,'style','edit','string',num2str(obj.el),'units','normalized',...
                'position',[0.7,0.05,0.2,0.4],'callback',@(src,evts) ViewCallback(obj,src));
            
            setgp=uitabgroup(hp,'units','normalized','position',[0,0.06,1,0.17]);
            disp_tab=uitab(setgp,'title','Display');
            obj.color_bar_radio=uicontrol('parent',disp_tab,'style','radiobutton','string','Color Bar',...
                'units','normalized','position',[0,0.66,0.45,0.33],'value',obj.color_bar,...
                'callback',@(src,evts) ColorBarCallback(obj,src));
            
            obj.peak_radio=uicontrol('parent',disp_tab,'style','radiobutton','string','Peak',...
                'units','normalized','position',[0.5,0.66,0.45,0.33],'value',obj.peak,...
                'callback',@(src,evts) PeakCallback(obj,src));
            
            obj.contact_radio=uicontrol('parent',disp_tab,'style','radiobutton','string','Contact',...
                'units','normalized','position',[0,0.33,0.45,0.33],'value',obj.contact,...
                'callback',@(src,evts) ContactCallback(obj,src));
            
            obj.center_mass_radio=uicontrol('parent',disp_tab,'style','radiobutton','string','Center Mass',...
                'units','normalized','position',[0.5,0.33,0.45,0.33],'value',obj.center_mass>0,...
                'callback',@(src,evts) CenterMassCallback(obj,src));
            
            obj.names_radio=uicontrol('parent',disp_tab,'style','radiobutton','string','Channel Names',...
                'units','normalized','position',[0,0,0.45,0.33],'value',obj.disp_channel_names,...
                'callback',@(src,evts) ChannelNamesCallback(obj,src));
            
            obj.smooth_radio=uicontrol('parent',disp_tab,'style','radiobutton','string','Smooth',...
                'units','normalized','position',[0.5,0,0.45,0.33],'value',obj.smooth,...
                'callback',@(src,evts) SmoothCallback(obj,src));
            
            advance_tab=uitab(setgp,'title','Advance');
            
            obj.scale_by_max_radio=uicontrol('parent',advance_tab,'style','radiobutton','string','Scale By Maximum',...
                'units','normalized','position',[0,0.66,0.45,0.33],'value',obj.scale_by_max,...
                'callback',@(src,evts) ScaleByMaxCallback(obj,src));
            
            obj.symmetric_scale_radio=uicontrol('parent',advance_tab,'style','radiobutton','string','Symmetric Scale',...
                'units','normalized','position',[0.5,0.66,0.45,0.33],'value',obj.symmetric_scale,...
                'callback',@(src,evts) SymmetricScaleCallback(obj,src));
            
            obj.interp_missing_radio=uicontrol('parent',advance_tab,'style','radiobutton','string','Interpolate Missing',...
                'units','normalized','position',[0,0.33,0.45,0.33],'value',obj.interp_missing,...
                'callback',@(src,evts) InterpMissingCallback(obj,src));
            
            obj.extrap_radio=uicontrol('parent',advance_tab,'style','radiobutton','string','Extrapolate',...
                'units','normalized','position',[0,0,0.45,0.33],'value',obj.extrap_,...
                'callback',@(src,evts) ExtrapolateCallback(obj,src));
            
            obj.auto_refresh_radio=uicontrol('parent',advance_tab,'style','radiobutton','string','Auto Refresh',...
                'units','normalized','position',[0.5,0.33,0.45,0.33],'value',obj.auto_refresh,...
                'callback',@(src,evts) AutoRefreshCallback(obj,src));
            
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.005,0.2,0.04],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.005,0.2,0.04],...
                'callback',@(src,evts) NewCallback(obj));
            
            obj.refresh_btn=uicontrol('parent',hp,'style','pushbutton','string','Refresh','units','normalized','position',[0.4,0.005,0.2,0.04],...
                'callback',@(src,evts) UpdateFigure(obj,src));
            
            UpdateEventList(obj);
            NormalizationCallback(obj,obj.normalization_popup);
            
            obj.event=obj.event_;
            obj.normalization_start_event=obj.normalization_start_event_;
            obj.normalization_end_event=obj.normalization_end_event_;
            obj.erd=obj.erd_;
            obj.ers=obj.ers_;
            obj.normalization_event=obj.event;
            obj.pos=obj.pos_;
            obj.neg=obj.neg_;
            
            obj.interp_scatter=obj.interp_scatter_;
        end
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
            
            h = obj.SpectralMapFig;
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
            
            if obj.cov_win.valid
                delete(obj.cov_win.fig);
            end
            
            if obj.export_picture_win.valid
                delete(obj.export_picture_win.fig);
            end
            
            if obj.export_movie_win.valid
                delete(obj.export_movie_win.fig);
            end
            
            
            for i = 1:length(obj.OldFig)
                try
                    delete(obj.OldFig(i))
                catch
                    continue
                end
            end
        end
        
        function DataPopUpCallback(obj,src)
            if isempty(src)
                return
            end
            
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
            if isempty(src)
                return
            end
            
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
        
        function SmoothCallback(obj, src)
            obj.smooth_=get(src,'value');
            if obj.auto_refresh
                UpdateFigure(obj,src);
            end
        end
        
        function SmoothMenuCallback(obj, src)
            prompt={'Row', 'Column'};
            def={num2str(obj.smooth_row_), num2str(obj.smooth_col_)};
            
            title='Smooth Kernal Size';
            
            answer=inputdlg(prompt,title,1,def);
            
            if isempty(answer)
                return
            end
            tmp=str2double(answer{1});
            if isempty(tmp)||isnan(tmp)
                tmp=obj.smooth_row_;
            end
            
            obj.smooth_row_=max(0,tmp);
            
            tmp=str2double(answer{2});
            if isempty(tmp)||isnan(tmp)
                tmp=obj.smooth_col_;
            end
            
            obj.smooth_col_=max(0,tmp);
            
            if obj.auto_refresh
                UpdateFigure(obj,src);
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
                UpdateFigure(obj,src)
            end
        end
        
        function ScaleSpinnerCallback(obj)
            if ~obj.auto_refresh
                return;
            end
            min=obj.JMinSpinner.getValue();
            max=obj.JMaxSpinner.getValue();
            
            if min<max
                obj.cmin=min;
                obj.cmax=max;
                
                if ~NoSpectralMapFig(obj)
                    h=findobj(obj.SpectralMapFig,'-regexp','Tag','MapAxes');
                    if ~isempty(h)
                        set(h,'clim',[obj.cmin,obj.cmax]);
                    end
                end
                if strcmp(obj.interp_scatter,'scatter')
                    UpdateFigure(obj,src)
                end
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
            if ~NoSpectralMapFig(obj)
                for i=1:length(obj.SpectralMapFig)
                    name=get(obj.SpectralMapFig(i),'Name');
                    set(obj.SpectralMapFig(i),'Name',[name ' Old']);
                    set(obj.SpectralMapFig(i),'Tag','Old');
                end
                
            end
            NewSpectralMapFig(obj);
        end
        
        function NewSpectralMapFig(obj)
            %             delete(obj.SpectralMapFig(ishandle(obj.SpectralMapFig)));
            
            fpos=get(obj.fig,'position');
            
            obj.OldFig = cat(1, obj.OldFig, obj.SpectralMapFig(:));
            if obj.data_input==3
                
                for i=1:length(obj.event_group)
                    obj.SpectralMapFig(i)=figure('Name',[obj.event_group{i}],'NumberTitle','off',...
                        'units','pixels','position',[fpos(1)+fpos(3)+20+(obj.fig_w+20)*(i-1),fpos(2),obj.fig_w,obj.fig_h],'Resize','off',...
                        'doublebuffer','off','Tag','Act');
                end
            else
                obj.SpectralMapFig=figure('Name',[obj.event],'NumberTitle','off',...
                    'units','pixels','position',[fpos(1)+fpos(3)+20,fpos(2),obj.fig_w,obj.fig_h],'Resize','off',...
                    'doublebuffer','off','Tag','Act');
            end
        end
        function ComputeCallback(obj)
            obj.tfmat=[];
            i_event = [];
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
                
                ind=ismember(txt_evt,evt);
                t_label=t_evt(ind);
                txt_evt=txt_evt(ind);
                if isempty(t_label)
                    errordlg('Event not found !');
                    return
                end
                i_event=round(t_label*obj.fs);
                i_event=min(max(1,i_event),obj.bsp.TotalSample);
                
                ind=(i_event+nR)>obj.bsp.TotalSample;
                i_event(ind)=[];
                txt_evt(ind)=[];
                
                ind=(i_event-nL)<1;
                i_event(ind)=[];
                txt_evt(ind)=[];
                
                omitMask=true;
                
                [chanNames,dataset,channel,~,~,~,chanpos]=get_selected_datainfo(obj.bsp,omitMask);
                %need to change the data
            end
            %Channel position******************************************************************
            if isempty(chanpos)||any(all(isnan(chanpos(:,1:2))))
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
            
            sl=obj.cmin;
            sh=obj.cmax;
            
            freq=[obj.min_freq obj.max_freq];
            if freq(1)>=freq(2)
                freq(1)=freq(2)-1;
                obj.min_freq=freq(1);
            end
            
            delete(obj.SpectralMapFig(ishandle(obj.SpectralMapFig)));
            NewSpectralMapFig(obj);
            
            wd=obj.stft_winlen;
            ov=obj.stft_overlap;
            
            for i=1:length(obj.SpectralMapFig)
                clf(obj.SpectralMapFig(i));
                set(obj.SpectralMapFig(i),'Name',evt{i});
            end
            %Normalizatin**************************************************************
            if obj.normalization==1
                nref=[];
                baseline=[];
                rtfm=[];
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
                        [ttmp,~,~]=tfpower(bdata,[],obj.fs,wd,ov,[]);
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
                        
                        [tf,f,t]=tfpower(data1,tmp_base,obj.fs,wd,ov,nref);
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
                                               
                        obj.tfmat(e).mat{j}=tfm;
                        obj.tfmat(e).t=t;
                        obj.tfmat(e).f=f;
                        obj.tfmat(e).channel=channel(chanind);
                        obj.tfmat(e).dataset=dataset(chanind);
                        obj.tfmat(e).channame=channames;
                        obj.tfmat(e).event=evt{e};
                        obj.tfmat(e).trial_mat{j}=event_tfm;
                        obj.tfmat(e).data(:,j,:)=raw_data(:,ind);
                        
                        if isempty(rtfm)
                            obj.tfmat(e).ref_mat{j}=ones(size(tfm,1),1);
                        else
                            obj.tfmat(e).ref_mat=rtfm;
                        end
                    end
                end
            else
                for j=1:length(channames)
                    waitbar(j/length(channames));
                    if isempty(baseline)
                        [tfm,f,t]=tfpower(data(:,j),[],obj.fs,wd,ov,nref);
                    else
                        [tfm,f,t]=tfpower(data(:,j),baseline(:,j),obj.fs,wd,ov,nref);
                    end
                    
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
                    obj.tfmat.ref_mat{j}=ones(size(tfm,1),1);
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
            
            if obj.scale_by_max
                obj.cmin=1;
                obj.cmax=-1;
            end
            mapv=obj.map_val;
            
            erdchan=obj.erd_chan;
            erschan=obj.ers_chan;
            
            obj.all_chan_pos=allchanpos;
            obj.all_chan_names=allchannames;
            obj.chan_names=channames;
            
            if obj.corr_win.pos||obj.corr_win.neg||obj.corr_win.sig||obj.corr_win.multi_pos||obj.corr_win.multi_neg
                % correlation
                obj.corr_win.Update();
            end
            
            if obj.cov_win.pos||obj.cov_win.neg||obj.cov_win.multi_pos||obj.cov_win.multi_neg
                % correlation
                obj.cov_win.Update();
            end
            
            if obj.xcorr_win.pos||obj.xcorr_win.multi_pos||obj.xcorr_win.neg||obj.xcorr_win.multi_neg
                obj.xcorr_win.Update();
            end
            
            obj.erd_center=cell(size(evt));
            obj.ers_center=cell(size(evt));
            
            
            if obj.interp_missing
                map_pos=chanpos;
                map_mapv=mapv;
            else
                map_pos=allchanpos;
                map_mapv=cell(length(mapv),1);
                for i=1:length(mapv)
                    %default to zeros
                    map_mapv{i}=zeros(length(allchannames),1);
                    ind=ismember(allchannames,channames);
                    map_mapv{i}(ind)=mapv{i};
                end
            end
            
            for e=1:length(evt)
                spatialmap_grid(obj.SpectralMapFig(e),map_mapv{e},obj.interp_scatter,...
                    map_pos(:,1),map_pos(:,2),obj.width,obj.height,sl,sh,obj.color_bar,obj.resize, ...
                    obj.extrap, obj.smooth_row, obj.smooth_col);
                h=findobj(obj.SpectralMapFig(e),'-regexp','tag','MapAxes');
                
                if obj.contact||strcmp(obj.interp_scatter,'scatter')
                    if obj.disp_channel_names
                        channames=obj.all_chan_names;
                    else
                        channames=[];
                    end
                    
                    if strcmp(obj.interp_scatter,'scatter')
                        plot_contact(h,mapv{e},allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.height,obj.width,channames,...
                            ~ismember(allchanpos,chanpos,'rows'),erdchan{e},erschan{e});
                    else
                        plot_contact(h,[],allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.height,obj.width,channames,...
                            ~ismember(allchanpos,chanpos,'rows'),erdchan{e},erschan{e});
                    end
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
            end
            redrawNetwork(obj);
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
        
        function ScaleByMaxCallback(obj,src)
            obj.scale_by_max_=get(src,'value');
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
            
            if ~NoSpectralMapFig(obj)
                for i=1:length(obj.SpectralMapFig)
                    ppos=get(obj.SpectralMapFig(i),'position');
                    set(obj.SpectralMapFig(i),'position',...
                        [ppos(1),ppos(2),obj.fig_w,obj.fig_h]);
                    
                    a=findobj(obj.SpectralMapFig(i),'Tag','MapAxes');
                    if ~isempty(a)
                        h=figure(obj.SpectralMapFig(i));
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
        
        function val=NoSpectralMapFig(obj)
            val=isempty(obj.SpectralMapFig)||~all(ishandle(obj.SpectralMapFig))||~all(strcmpi(get(obj.SpectralMapFig,'Tag'),'Act'));
        end
        
        function STFTCallback(obj,src)
            
            tmp=str2double(get(src,'string'));
            switch src
                case obj.stft_winlen_edit
                    if isempty(tmp)||isnan(tmp)
                        tmp=obj.stft_winlen;
                    end
                    
                    obj.stft_winlen=tmp;
                case obj.stft_overlap_edit
                    if isempty(tmp)||isnan(tmp)
                        tmp=obj.stft_overlap;
                    end
                    
                    obj.stft_overlap=tmp;
            end
        end
        function FDRCallback(obj)
            prompt={'FDR for Multicomparision Correction'};
            def={num2str(obj.fdr)};
            
            title='FDR Setting';
            
            answer=inputdlg(prompt,title,1,def);
            
            if isempty(answer)
                return
            end
            tmp=str2double(answer{1});
            if isempty(tmp)||isnan(tmp)
                tmp=obj.fdr;
            end
            
            obj.fdr=max(0,min(tmp,1));
            if obj.auto_refresh
                UpdateFigure(obj,[]);
            end
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
            if ~NoSpectralMapFig(obj)
                
                mapv=obj.map_val;
                erdchan=obj.erd_chan;
                erschan=obj.ers_chan;
                
                chanpos=[obj.pos_x,obj.pos_y,obj.radius];
                
                if (obj.corr_win.pos||obj.corr_win.neg||obj.corr_win.sig||obj.corr_win.multi_pos||obj.corr_win.multi_neg)&&ismember(src,...
                        [obj.act_len_edit,obj.act_len_slider,obj.act_start_edit,obj.act_start_slider,...
                        obj.refresh_btn,obj.min_freq_edit,obj.min_freq_slider,obj.max_freq_edit,obj.max_freq_slider])
                    % correlation
                    obj.corr_win.Update();
                end
                if (obj.cov_win.pos||obj.cov_win.neg||obj.cov_win.multi_pos||obj.cov_win.multi_neg)&&ismember(src,...
                        [obj.act_len_edit,obj.act_len_slider,obj.act_start_edit,obj.act_start_slider,...
                        obj.refresh_btn,obj.min_freq_edit,obj.min_freq_slider,obj.max_freq_edit,obj.max_freq_slider])
                    % correlation
                    obj.cov_win.Update();
                end
                
                if (obj.xcorr_win.pos||obj.xcorr_win.multi_pos||obj.xcorr_win.neg||obj.xcorr_win.multi_neg)&&ismember(src,...
                        [obj.act_len_edit,obj.act_len_slider,obj.act_start_edit,obj.act_start_slider,...
                        obj.refresh_btn,obj.min_freq_edit,obj.min_freq_slider,obj.max_freq_edit,obj.max_freq_slider])
                    obj.xcorr_win.Update();
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
                
                if obj.disp_channel_names
                    channames=obj.all_chan_names;
                else
                    channames=[];
                end
                            
                for i=1:length(obj.SpectralMapFig)
                    h=findobj(obj.SpectralMapFig(i),'-regexp','Tag','MapAxes');
                    if ~isempty(h)
                        col=obj.pos_x;
                        row=obj.pos_y;
                        imagehandle=findobj(h,'Tag','ImageMap');
                        
                        if strcmp(obj.interp_scatter,'interp')
                            [x,y]=meshgrid((1:obj.width)/obj.width,(1:obj.height)/obj.height);
                            F= scatteredInterpolant(map_pos(:,1),map_pos(:,2),map_mapv{i}(:),'natural',obj.extrap);
                            mapvq=F(x,y);
                            if ~isempty(obj.smooth_row) && ~isempty(obj.smooth_col)
                                mapvq = smooth2a(mapvq, obj.smooth_row, obj.smooth_col);
                            end
                            
                            if isempty(imagehandle)
                                spatialmap_grid(obj.SpectralMapFig(i),map_mapv{i},obj.interp_scatter,...
                                    map_pos(:,1),map_pos(:,2),obj.width,obj.height,obj.cmin,obj.cmax,obj.color_bar,obj.resize, ...
                                    obj.extrap, obj.smooth_row, obj.smooth_col);
                                h=findobj(obj.SpectralMapFig(i),'-regexp','Tag','MapAxes');
                            else
                                set(imagehandle,'CData',single(mapvq),'visible','on');
                                set(imagehandle, 'AlphaData', ~isnan(mapvq))
                            end
                            
                            if ismember(src,[obj.map_interp_menu,obj.map_scatter_menu])
                                delete(findobj(h,'Tag','contact'));
                                delete(findobj(h,'Tag','names'));
                                plot_contact(h,[],obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,channames,...
                                    ~ismember(obj.all_chan_pos,chanpos,'rows'),erdchan{i},erschan{i});
                            end
                        else
                            
                            set(imagehandle,'visible','off');
                            
                            delete(findobj(h,'Tag','contact'));
                            delete(findobj(h,'Tag','names'));
                            plot_contact(h,mapv{i},obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,channames,...
                                ~ismember(obj.all_chan_pos,chanpos,'rows'),erdchan{i},erschan{i});
                        end
                        
                        set(h,'clim',[obj.cmin,obj.cmax]);
                        set(h,'xlim',[1,obj.width]);
                        set(h,'ylim',[1,obj.height]);
                        
                        delete(findobj(h,'tag','peak'));
                        drawnow
                        
                        if strcmp(obj.interp_scatter,'interp')
                            if obj.erd||obj.ers||ismember(src,[obj.erd_radio,obj.ers_radio])
                                delete(findobj(h,'Tag','contact'));
                                delete(findobj(h,'Tag','names'));
                                figure(obj.SpectralMapFig(i))
                                if obj.contact||strcmp(obj.interp_scatter,'scatter')
                                    plot_contact(h,[],obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,channames,...
                                        ~ismember(obj.all_chan_pos,chanpos,'rows'),erdchan{i},erschan{i});
                                end
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
                    end
                end
                redrawNetwork(obj);
            end
        end
        
        function redrawNetwork(obj)
            chanpos=[obj.pos_x,obj.pos_y,obj.radius];
            for i=1:length(obj.SpectralMapFig)
                h=findobj(obj.SpectralMapFig(i),'-regexp','tag','MapAxes');
                %%
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
                        obj.tfmat(i).corr_matrix,tmp_pos_t,tmp_neg_t,...
                        obj.tfmat(i).p_matrix,obj.corr_win.sig_t);
                end
                %%
                %Covariance Network
                if obj.cov_win.pos
                    tmp_pos_t=obj.cov_win.pos_t;
                elseif obj.cov_win.multi_pos
                    tmp_pos_t=obj.cov_win.multi_pos_t;
                else
                    tmp_pos_t=[];
                end
                
                if obj.cov_win.neg
                    tmp_neg_t=obj.cov_win.neg_t;
                elseif obj.corr_win.multi_neg
                    tmp_neg_t=obj.cov_win.multi_neg_t;
                else
                    tmp_neg_t=[];
                end
                
                if obj.cov_win.neg||obj.cov_win.pos||obj.cov_win.multi_neg||obj.cov_win.multi_pos
                    
                    plot_covariance(h,round(chanpos(:,1)*obj.width),round(chanpos(:,2)*obj.height),...
                        obj.cov_win.pos||obj.cov_win.multi_pos,obj.cov_win.neg||obj.cov_win.multi_neg,...
                        obj.tfmat(i).cov_matrix,tmp_pos_t,tmp_neg_t);
                end
                %%
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
                fpos=get(obj.fig,'Position');
                
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
                
                h=figure('name',fname,'units','pixels','position',[fpos(1)+fpos(3),fpos(2)+fpos(4)-150,300,150],...
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
        
        function ExtrapolateCallback(obj,src)
            obj.extrap_=get(src,'value');
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
        
        function CenterMassCallback(obj,src)
            obj.center_mass_=get(src,'value');
            
            if ~NoSpectralMapFig(obj)
                mapv=obj.map_val;
                chanpos=[obj.pos_x,obj.pos_y,obj.radius];
                erdchan=obj.erd_chan;
                erschan=obj.ers_chan;
                for i=1:length(obj.SpectralMapFig)
                    delete(findobj(obj.SpectralMapFig(i),'tag','mass'));
                    
                    h=findobj(obj.SpectralMapFig(i),'-regexp','Tag','MapAxes');
                    if ~isempty(h)
                        if obj.erd||obj.ers
                            %                             figure(obj.SpectralMapFig(i))
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
            if ~NoSpectralMapFig(obj)
                mapv=obj.map_val;
                for i=1:length(obj.SpectralMapFig)
                    h=findobj(obj.SpectralMapFig(i),'-regexp','Tag','MapAxes');
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
        
        function CovCallback(obj)
            obj.cov_win.buildfig();
        end
        
        function ContactCallback(obj,src)
            if ~isempty(src)
                obj.contact_=get(src,'value');
            end
            
            if strcmp(obj.interp_scatter,'scatter')
                return
            end
            
            chanpos=[obj.pos_x,obj.pos_y,obj.radius];
            if ~NoSpectralMapFig(obj)
                for i=1:length(obj.SpectralMapFig)
                    h=findobj(obj.SpectralMapFig(i),'-regexp','Tag','MapAxes');
                    if ~isempty(h)
                        delete(findobj(h,'Tag','contact'));
                        delete(findobj(h,'Tag','names'));
                        figure(obj.SpectralMapFig(i))
                        if obj.contact
                            if obj.disp_channel_names
                                plot_contact(h,[],obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,obj.all_chan_names,...
                                    ~ismember(obj.all_chan_pos,chanpos,'rows'),obj.erd_chan{i},obj.ers_chan{i});
                            else
                                plot_contact(h,[],obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,[],...
                                    ~ismember(obj.all_chan_pos,chanpos,'rows'),obj.erd_chan{i},obj.ers_chan{i});
                            end
                            
                        end
                        
                    end
                end
            end
        end
        
        function ChannelNamesCallback(obj,src)
            obj.disp_channel_names_=get(src,'value');
            badchan=~ismember(obj.all_chan_pos,[obj.pos_x,obj.pos_y,obj.radius],'rows');
            
            for i=1:length(obj.SpectralMapFig)
                h=findobj(obj.SpectralMapFig(i),'-regexp','Tag','MapAxes');
                
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
    end
    
    methods
        function [events,val,names,pos,erd,ers]=getMapInfo(obj)
            erdchan=obj.erd_chan;
            erschan=obj.ers_chan;
            
            mapv=obj.map_val;
            chanpos=[obj.pos_x,obj.pos_y,obj.radius];
            
            if obj.interp_missing
                pos=chanpos;
                val=mapv;
                names=obj.chan_names;
            else
                pos=obj.all_chan_pos;
                val=cell(length(mapv),1);
                for i=1:length(mapv)
                    %default to zeros
                    val{i}=zeros(length(obj.all_chan_names),1);
                    ind=ismember(obj.all_chan_names,obj.chan_names);
                    val{i}(ind)=mapv{i};
                end
                names=obj.all_chan_names;
            end
            
            for i=1:length(obj.tfmat)
                events{i}=obj.tfmat(i).event;
                erd{i}=ismember(names,obj.chan_names(logical(erdchan{i})));
                ers{i}=ismember(names,obj.chan_names(logical(erschan{i})));
            end
        end
        function ExportPictureCallback(obj)
            obj.export_picture_win.buildfig();
        end
        function ExportMapCallback(obj)
            %export the map values together with the channel name/position
            %for further analysis
            [events,val,names,~,erdd,erss]=getMapInfo(obj);
            if exist([obj.bsp.FileDir,'/app/spatial map'],'dir')~=7
                mkdir(obj.bsp.FileDir,'/app/spatial map');
            end
            open_dir=[obj.bsp.FileDir,'/app/spatial map'];
            
            folder_name = uigetdir(open_dir,'Select a direcotry to export');
            if ~folder_name
                return
            end
            
            suffix=[num2str(obj.min_freq),'-',num2str(obj.max_freq),...
                '_start',num2str(obj.act_start),'_len',num2str(obj.act_len)];
            
            for i=1:length(events)
                fname=[events{i},'_',suffix,'.smw'];
                fid=fopen(fullfile(folder_name,fname),'w');
                
                for j=1:length(names)
                    fprintf(fid,'%s,%f,%d\n',names{j},val{i}(j),erss{i}(j)-erdd{i}(j));
                end
                fclose(fid);
            end
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
            
            if exist([obj.bsp.FileDir,'/app/spatial map'],'dir')~=7
                mkdir(obj.bsp.FileDir,'/app/spatial map');
            end
            open_dir=[obj.bsp.FileDir,'/app/spatial map'];
            
            folder_name = uigetdir(open_dir,'Select a direcotry to export');
            if ~folder_name
                return
            end
            filename=[num2str(obj.min_freq),'-',num2str(obj.max_freq),...
                '_start',num2str(obj.act_start),'_len',num2str(obj.act_len),'_trial'];
            
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
                            pow_val=cat(1,pow_val,mean(mean(event_mat{t}(fi,ti)))./mean(mean(tf.ref_mat{i}(fi,:))));
                        end
                        
                        info(k).pow(:,i)=pow_val(:);
                        
                    end
                    
                    raw_event_mat=tf.trial_mat{i};
                    if ~isempty(raw_event_mat)
                        raw_pow_val=[];
                        
                        for t=1:length(event_mat)
                            %t th trial
                            raw_pow_val=cat(1,raw_pow_val,mean(mean(raw_event_mat{t}(fi,ti))));
                        end
                        
                        info(k).raw_pow(:,i)=raw_pow_val(:);
                        
                    end
                end
                info(k).event=tf.event;
                info(k).channame=tf.channame;
                info(k).erd_chan=erdchan{k};
                info(k).ers_chan=erschan{k};
            end
            save(fullfile(open_dir,filename),'info');
            assignin('base','trial_info',info);
        end
        
        function TCallback(obj,src)
            switch src
                case obj.pos_radio
                    obj.pos=get(src,'value');
                case obj.neg_radio
                    obj.neg=get(src,'value');
                case obj.pos_edit
                    val=str2double(get(src,'string'));
                    if isnan(val)
                        val=obj.pos_t;
                    end
                    val=max(0,min(val,1));
                    
                    set(src,'string',num2str(val));
                    set(obj.pos_slider,'value',val);
                    obj.pos_t=val;
                case obj.neg_edit
                    val=str2double(get(src,'string'));
                    if isnan(val)
                        val=obj.neg_t;
                    end
                    val=max(0,min(val,1));
                    
                    set(src,'string',num2str(val));
                    set(obj.neg_slider,'value',val);
                    obj.neg_t=val;
                    
                case obj.pos_slider
                    val=get(src,'value');
                    set(obj.pos_edit,'string',num2str(val));
                    obj.pos_t=val;
                case obj.neg_slider
                    val=get(src,'value');
                    set(obj.neg_edit,'string',num2str(val));
                    obj.neg_t=val;
            end
            
            if obj.auto_refresh
                obj.UpdateFigure(src);
            end
        end
        function ViewCallback(obj,src)
            switch src
                case obj.az_edit
                    val=str2double(get(src,'string'));
                    if isnan(val)
                        val=obj.az;
                    end
                    obj.az=val;
                case obj.el_edit
                    val=str2double(get(src,'string'));
                    if isnan(val)
                        val=obj.el;
                    end
                    obj.el=val;
            end
            for i=1:length(obj.SpectralMapFig)
                h=findobj(obj.SpectralMapFig(i),'-regexp','Tag','MapAxes');
                if ~isempty(h)
                    view(h,obj.az,obj.el);
                end
            end
            ContactCallback(obj,[]);
        end
        
        function MapCallback(obj,src)
            switch src
                case obj.map_interp_menu
                    obj.interp_scatter='interp';
                case obj.map_scatter_menu
                    obj.interp_scatter='scatter';
            end
            
            UpdateFigure(obj,src);
                
        end
    end
    
end

