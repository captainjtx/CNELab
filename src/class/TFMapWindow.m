classdef TFMapWindow < handle
    %TFMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    properties
        bsp
        fig
        TFMapFig
        method_popup
        data_popup
        event_popup
        ms_before_edit
        ms_after_edit
        event_text
        ms_before_text
        ms_after_text
        unit_mag_radio
        unit_db_radio
        
        normalization_popup
        scale_start_text
        scale_end_text
        scale_start_edit
        scale_end_edit
        scale_start_popup
        scale_end_popup
        scale_event_text
        scale_event_popup
        stft_winlen_edit
        stft_overlap_edit
        max_freq_edit
        min_freq_edit
        max_clim_edit
        min_clim_edit
        max_freq_slider
        min_freq_slider
        max_clim_slider
        min_clim_slider
        onset_radio
        compute_btn
        new_btn
        symmetric_scale_radio
        auto_scale_radio
        
        file_menu
        save_menu
        save_fig_menu
        TFMapSaveWin
        
        disp_axis_radio
        
        smooth_x_edit
        smooth_y_edit
        names_radio
        
        background_axe
        
    end
    properties
        
        method_
        data_input_
        ms_before_
        ms_after_
        event_
        unit_
        normalization_
        normalization_start_
        normalization_end_
        normalization_start_event_
        normalization_end_event_
        normalization_event_
        display_onset_
        stft_winlen_
        stft_overlap_
        max_freq_
        min_freq_
        max_clim_
        min_clim_
        clim_slider_max_
        clim_slider_min_
        event_list_
        symmetric_scale_
        auto_scale_
        smooth_x_
        smooth_y_
        disp_axis_
        disp_channel_names_
    end
    
    properties (Dependent)
        valid
        fs
        method
        data_input
        ms_before
        ms_after
        event
        unit
        normalization
        normalization_start
        normalization_start_event
        normalization_end
        normalization_end_event
        normalization_event
        display_onset
        stft_winlen
        stft_overlap
        max_freq
        min_freq
        max_clim
        min_clim
        clim_slider_max
        clim_slider_min
        event_list
        symmetric_scale
        auto_scale
        smooth_x
        smooth_y
        disp_axis
        disp_channel_names
    end
    properties
        tfmat
        tfmat_t
        tfmat_f
        tfmat_channame
        tfmat_dataset
        tfmat_channel
    end
    methods
        function val=get.disp_axis(obj)
            val=obj.disp_axis_;
        end
        function set.disp_axis(obj,val)
            obj.disp_axis_=val;
            if obj.valid
                set(obj.disp_axis_radio,'value',val);
            end
        end
        function val=get.smooth_x(obj)
            val=obj.smooth_x_;
        end
        function set.smooth_x(obj,val)
            obj.smooth_x_=val;
            
            if obj.valid
                set(obj.smooth_x_edit,'string',num2str(val));
            end
        end
        function val=get.smooth_y(obj)
            val=obj.smooth_y_;
        end
        function set.smooth_y(obj,val)
            obj.smooth_y_=val;
            
            if obj.valid
                set(obj.smooth_y_edit,'string',num2str(val));
            end
        end
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isgraphics(obj.fig);
            catch
                val=0;
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
        
        
        function val=get.auto_scale(obj)
            val=obj.auto_scale_;
        end
        function set.auto_scale(obj,val)
            obj.auto_scale_=val;
            if obj.valid
                set(obj.auto_scale_radio,'value',val);
            end
        end
        
        function val=get.method(obj)
            val=obj.method_;
        end
        function set.method(obj,val)
            obj.method_=val;
            if obj.valid
                set(obj.method_popup,'value',val);
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
                    if ~isempty(obj.event_list)
                        val=obj.event_list{1};
                    else
                        val=[];
                    end
                    
                end
            end
            obj.event_=val;
        end
        function val=get.unit(obj)
            val=obj.unit_;
        end
        function set.unit(obj,val)
            if strcmpi(val,'dB')
                if obj.valid
                    UnitRadioCallback(obj,obj.unit_db_radio);
                end
                obj.unit_='dB';
            else
                if obj.valid
                    UnitRadioCallback(obj,obj.unit_mag_radio);
                end
                obj.unit_='Mag';
            end
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
            obj.normalization_end_=val;
            if obj.valid
                if obj.normalization==2
                    set(obj.scale_end_edit,'string',num2str(val));
                    
                elseif obj.normalization==3
                    set(obj.scale_end_edit,'string',val);
                end
            end
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
        
        function val=get.display_onset(obj)
            val=obj.display_onset_;
        end
        function set.display_onset(obj,val)
            obj.display_onset_=val;
            if obj.valid
                set(obj.onset_radio,'value',val);
            end
        end
        
        function val=get.stft_winlen(obj)
            val=obj.stft_winlen_;
        end
        function set.stft_winlen(obj,val)
            obj.stft_winlen_=val;
            if obj.valid
                set(obj.stft_winlen_edit,'string',num2str(val));
            end
        end
        function val=get.stft_overlap(obj)
            val=obj.stft_overlap_;
        end
        function set.stft_overlap(obj,val)
            obj.stft_overlap_=val;
            if obj.valid
                set(obj.stft_overlap_edit,'string',num2str(val));
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
        
        
        function val=get.disp_channel_names(obj)
            val=obj.disp_channel_names_;
        end
        
        function set.disp_channel_names(obj,val)
            obj.disp_channel_names_=val;
            if obj.valid
                set(obj.names_radio,'value',val);
            end
        end
    end
    
    methods
        function obj=TFMapWindow(bsp)
            obj.bsp=bsp;
            if ~isempty(bsp.Evts)
                obj.event_list_=unique(bsp.Evts(:,2));
            end
            
            varinitial(obj);
            addlistener(bsp,'EventListChange',@(src,evts)UpdateEventList(obj));
            addlistener(bsp,'SelectedEventChange',@(src,evts)UpdateEventSelected(obj));
            %             buildfig(obj);
        end
        function UpdateEventList(obj)
            if ~isempty(obj.bsp.Evts)
                obj.event_list=unique(obj.bsp.Evts(:,2));
            end
        end
        function varinitial(obj)
            obj.method_=1;
            obj.data_input_=1;%selection
            obj.ms_before_=1500;
            obj.ms_after_=1500;
            obj.event_='';
            obj.unit_='dB';
            obj.normalization_=1;%none
            obj.normalization_start_=-1500;
            obj.normalization_end_=-1000;
            obj.normalization_start_event_='';
            obj.normalization_end_event_='';
            obj.normalization_event_='';
            obj.display_onset_=1;
            obj.max_freq_=obj.fs/2;
            obj.min_freq_=0;
            obj.clim_slider_max_=10;
            obj.clim_slider_min_=-10;
            obj.max_clim_=6;
            obj.min_clim_=-6;
            obj.stft_winlen_=round(obj.fs/3);
            obj.stft_overlap_=round(obj.stft_winlen*0.9);
            obj.symmetric_scale_=1;
            obj.auto_scale_=0;
            obj.smooth_x_=8;
            obj.smooth_y_=8;
            obj.disp_axis_=1;
            obj.disp_channel_names_=0;
            obj.TFMapSaveWin=TFMapFigureSave(obj);
        end
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.fig=figure('MenuBar','none','Name','Time-Frequency Map','units','pixels',...
                'Position',[100 100 300 700],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));
            
            obj.file_menu=uimenu(obj.fig,'label','File');
            obj.save_menu=uimenu(obj.file_menu,'label','Save');
            obj.save_fig_menu=uimenu(obj.save_menu,'label','Figure','callback',@(src,evts) obj.TFMapSaveWin.buildfig(),'Accelerator','p');
            
            hp=uipanel('units','normalized','Position',[0,0,1,1]);
            
            hp_method=uipanel('Parent',hp,'Title','Layout','units','normalized','Position',[0,0.93,1,0.06]);
            obj.method_popup=uicontrol('Parent',hp_method,'Style','popup',...
                'String',{'Average','Grid'},'units','normalized','Position',[0.01,0,0.59,0.92],'value',obj.method,...
                'callback',@(src,evts) MethodCallback(obj,src));
            
            hp_data=uipanel('Parent',hp,'Title','Data','Units','normalized','Position',[0,0.795,1,0.125]);
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
                'HorizontalAlignment','center','visible','off','callback',@(src,evts) MsBeforeCallback(obj,src));
            obj.ms_after_edit=uicontrol('Parent',hp_data,'Style','Edit','string',num2str(obj.ms_after),'units','normalized','position',[0.7,0.05,0.29,0.3],...
                'HorizontalAlignment','center','visible','off','callback',@(src,evts) MsAfterCallback(obj,src));
            
            hp_scale=uipanel('Parent',hp,'Title','Baseline','units','normalized','position',[0,0.66,1,0.125]);
            obj.normalization_popup=uicontrol('Parent',hp_scale,'style','popup','units','normalized',...
                'string',{'None','Within Segment','External Baseline'},'callback',@(src,evts) NormalizationCallback(obj,src),...
                'position',[0.01,0.6,0.59,0.35],'value',obj.normalization);
            
            obj.scale_event_text=uicontrol('Parent',hp_scale,'Style','text','string','Event: ','units','normalized','position',[0.01,0.3,0.35,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.scale_start_text=uicontrol('Parent',hp_scale,'Style','text','string','Start (ms): ','units','normalized','position',[0.4,0.3,0.3,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.scale_end_text=uicontrol('Parent',hp_scale,'Style','text','string','End (ms): ','units','normalized','position',[0.7,0.3,0.3,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.scale_event_popup=uicontrol('Parent',hp_scale,'Style','popup','string',obj.event_list,'units','normalized','position',[0.01,0.05,0.35,0.3],...
                'visible','off','callback',@(src,evts) ScaleEventCallback(obj,src));
            
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
            
            hp_mag=uipanel('Parent',hp,'Title','Unit','units','normalized','position',[0,0.6,1,0.05]);
            obj.unit_mag_radio=uicontrol('Parent',hp_mag,'Style','radiobutton','units','normalized','string','Mag','position',[0.4,0,0.29,1],...
                'HorizontalAlignment','left','callback',@(src,evts) UnitRadioCallback(obj,src),'value',1);
            obj.unit_db_radio=uicontrol('Parent',hp_mag,'Style','radiobutton','units','normalized','string','dB','position',[0.7,0,0.29,1],...
                'HorizontalAlignment','left','callback',@(src,evts) UnitRadioCallback(obj,src));
            
            
            hp_freq=uipanel('parent',hp,'title','Frequency','units','normalized','position',[0,0.48,1,0.11]);
            
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
            
            
            
            hp_clim=uipanel('parent',hp,'title','Scale','units','normalized','position',[0,0.36,1,0.11]);
            
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
            
            resgp=uitabgroup(hp,'units','normalized','position',[0,0.22,1,0.13]);
            tab_stft=uitab(resgp,'title','STFT');
            uicontrol('parent',tab_stft,'style','text','string','Window (sample): ','units','normalized',...
                'position',[0,0.6,0.5,0.3]);
            obj.stft_winlen_edit=uicontrol('parent',tab_stft,'style','edit','string',num2str(obj.stft_winlen),...
                'units','normalized','position',[0.1,0.1,0.3,0.45],'HorizontalAlignment','center',...
                'callback',@(src,evts) STFTWinlenCallback(obj,src));
            uicontrol('parent',tab_stft,'style','text','string','Overlap (sample): ',...
                'units','normalized','position',[0.5,0.6,0.5,0.3]);
            obj.stft_overlap_edit=uicontrol('parent',tab_stft,'style','edit','string',num2str(obj.stft_overlap),...
                'units','normalized','position',[0.6,0.1,0.3,0.45],'HorizontalAlignment','center',...
                'callback',@(src,evts) STFTOverlapCallback(obj,src));
            
            tab_smooth=uitab(resgp,'title','Smooth');
            
            uicontrol('parent',tab_smooth,'style','text','string','Width : ','units','normalized',...
                'position',[0,0.6,0.5,0.3]);
            obj.smooth_x_edit=uicontrol('parent',tab_smooth,'style','edit','string',num2str(obj.smooth_x),...
                'units','normalized','position',[0.1,0.1,0.3,0.45],'HorizontalAlignment','center',...
                'callback',@(src,evts) SmoothCallback(obj,src));
            uicontrol('parent',tab_smooth,'style','text','string','Height : ',...
                'units','normalized','position',[0.5,0.6,0.5,0.3]);
            obj.smooth_y_edit=uicontrol('parent',tab_smooth,'style','edit','string',num2str(obj.smooth_y),...
                'units','normalized','position',[0.6,0.1,0.3,0.45],'HorizontalAlignment','center',...
                'callback',@(src,evts) SmoothCallback(obj,src));
            
            tabgp=uitabgroup(hp,'units','normalized','position',[0,0.06,1,0.15]);
            tab_display=uitab(tabgp,'title','Display');
            obj.onset_radio=uicontrol('parent',tab_display,'style','radiobutton','string','Onset','value',obj.display_onset,...
                'units','normalized','position',[0,0.66,0.45,0.33],'callback',@(src,evts) DisplayOnsetCallback(obj,src));
            obj.symmetric_scale_radio=uicontrol('parent',tab_display,'style','radiobutton','string','Symmetric Scale','value',obj.symmetric_scale,...
                'units','normalized','position',[0,0.33,0.45,0.33],'callback',@(src,evts) SymmetricScaleCallback(obj,src));
            
            obj.auto_scale_radio=uicontrol('parent',tab_display,'style','radiobutton','string','Auto Scale','value',obj.auto_scale,...
                'units','normalized','position',[0,0,0.45,0.33],'callback',@(src,evts) AutoScaleCallback(obj,src));
            obj.disp_axis_radio=uicontrol('parent',tab_display,'style','radiobutton','string','Axis','value',obj.disp_axis,...
                'units','normalized','position',[0.5,0.66,0.45,0.33],'callback',@(src,evts) AxisCallback(obj,src));
            obj.names_radio=uicontrol('parent',tab_display,'style','radiobutton','string','Channel Names',...
                'units','normalized','position',[0.5,0.33,0.45,0.33],'value',obj.disp_channel_names,...
                'callback',@(src,evts) ChannelNamesCallback(obj,src));
            
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.01,0.2,0.04],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.01,0.2,0.04],...
                'callback',@(src,evts) NewCallback(obj));
            DataPopUpCallback(obj,obj.data_popup);
            NormalizationCallback(obj,obj.normalization_popup);
            if strcmpi(obj.unit,'dB')
                set(obj.unit_db_radio,'value',1);
                set(obj.unit_mag_radio,'value',0);
            else
                set(obj.unit_db_radio,'value',0);
                set(obj.unit_mag_radio,'value',1);
            end
            
            obj.event=obj.event_;
            obj.normalization_start_event=obj.normalization_start_event_;
            obj.normalization_end_event=obj.normalization_end_event_;
            obj.normalization_event=obj.event;
        end
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
            obj.fig=[];
            
            h = obj.TFMapFig;
            if ishandle(h)
                delete(h);
            end
            
            
            h=obj.TFMapSaveWin;
            
            if h.valid
                delete(h.fig);
            end
            
            
        end
        function MethodCallback(obj,src)
            obj.method=get(src,'value');
            switch obj.method
                case 1
                    obj.data_input=1;
                    DataPopUpCallback(obj,obj.data_popup);
                case 2
                    obj.data_input=3;
                    DataPopUpCallback(obj,obj.data_popup);
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
                    set(obj.scale_event_popup,'enable','off');
                    obj.normalization=1;
                    NormalizationCallback(obj,obj.normalization_popup);
                case 2
                    %Single Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','off');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
                    set(obj.scale_event_popup,'enable','off');
                    obj.normalization=2;
                    NormalizationCallback(obj,obj.normalization_popup);
                case 3
                    %Average Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','on');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
                    set(obj.scale_event_popup,'enable','on');
                    obj.normalization=2;
                    NormalizationCallback(obj,obj.normalization_popup);
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
        
        function STFTWinlenCallback(obj,src)
            t=str2double(get(src,'string'));
            if isnan(t)
                t=obj.stft_winlen;
            end
            obj.stft_winlen=t;
        end
        function STFTOverlapCallback(obj,src)
            t=str2double(get(src,'string'));
            if isnan(t)
                t=obj.stft_overlap;
            end
            obj.stft_overlap=t;
        end
        function UnitRadioCallback(obj,src)
            if src==obj.unit_db_radio
                set(src,'value',1);
                set(obj.unit_mag_radio,'value',0);
                obj.unit_='dB';
            else
                set(src,'value',1);
                set(obj.unit_db_radio,'value',0);
                obj.unit_='Mag';
            end
            ComputeCallback(obj);
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
            if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
                h=findobj(obj.TFMapFig,'-regexp','Tag','TFMapAxes*');
                
                set(h,'YLim',[obj.min_freq,obj.max_freq]);
                DisplayOnsetCallback(obj,obj.onset_radio);
                %                 figure(obj.TFMapFig);
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
            
            if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
                h=findobj(obj.TFMapFig,'-regexp','Tag','TFMapAxes*');
                
                if obj.min_clim<obj.max_clim
                    set(h,'CLim',[obj.min_clim,obj.max_clim]);
                end
                %                 figure(obj.TFMapFig);
            end
        end
        
        function DisplayOnsetCallback(obj,src)
            if src==obj.onset_radio
                obj.display_onset_=get(src,'value');
            end
            
            tonset=0;
            if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
                
                h=findobj(obj.TFMapFig,'-regexp','Tag','TFMapAxes*');
                if obj.display_onset
                    for i=1:length(h)
                        tmp=findobj(h(i),'Type','line');
                        delete(tmp);
                        %                         axes(h(i))
                        line([tonset,tonset],[obj.min_freq,obj.max_freq],'LineStyle',':',...
                            'color','k','linewidth',2,'Parent',h(i))
                    end
                else
                    for i=1:length(h)
                        tmp=findobj(h(i),'Type','line');
                        delete(tmp);
                    end
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
                    if obj.data_input~=1&&strcmp(obj.normalization_event,obj.event)
                        t=max(-obj.ms_before,min(obj.ms_after,t));
                    elseif obj.data_input==1
                        t=max(0,t);
                    end
                    obj.normalization_start=t;
                case obj.scale_end_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.normalization_end;
                    end
                    if obj.data_input~=1&&strcmp(obj.normalization_event,obj.event)
                        t=max(-obj.ms_before,min(obj.ms_after,t));
                    elseif obj.data_input==1
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
            if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
                set(obj.TFMapFig,'name',obj.event_);
            end
            obj.normalization_event=obj.event_;
        end
        
        
        function ScaleEventCallback(obj,src)
            obj.normalization_event_=obj.event_list{get(src,'value')};
        end
        function UpdateEventSelected(obj)
            if ~isempty(obj.bsp.SelectedEvent)
                obj.event=obj.bsp.Evts{obj.bsp.SelectedEvent(1),2};
                obj.normalization_event=obj.event;
            end
        end
        function CloseTFMapFig(obj,src)
            delete(src);
            obj.TFMapFig=[];
            
        end
        function NewCallback(obj)
            if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
                name=get(obj.TFMapFig,'Name');
                set(obj.TFMapFig,'Tag','Old');
                set(obj.TFMapFig,'name',[name,' Old'])
            end
            obj.TFMapFig=figure('Name',obj.event,'NumberTitle','off',...
                'color','w','DockControls','off','Tag','Act','CloseRequestFcn',@(src,evts) CloseTFMapFig(obj,src));
        end
        
        
        function ComputeCallback(obj,src)
            
            option=obj.method;
            obj.tfmat={};
            units=obj.unit;
            %==========================================================================
            nL=round(obj.ms_before*obj.fs/1000);
            nR=round(obj.ms_after*obj.fs/1000);
            
            %Data selection************************************************************
            data_tmp_sel=[];
            i_event=[];
            if obj.data_input==1
                omitMask=true;
                [chanNames,dataset,channel,sample,~,~,chanpos]=get_selected_datainfo(obj.bsp,omitMask);
            elseif obj.data_input==2
                if isempty(obj.bsp.SelectedEvent)
                    errordlg('No event selection !');
                    return
                elseif length(obj.bsp.SelectedEvent)>1
                    warndlg('More than one event selected, using the first one !');
                end
                i_event=round(obj.bsp.Evts{obj.bsp.SelectedEvent(1),1}*obj.fs);
                i_event=min(max(1,i_event),obj.bsp.TotalSample);
                
                i_event((i_event+nR)>obj.bsp.TotalSample)=[];
                i_event((i_event-nL)<1)=[];
                if isempty(i_event)
                    errordlg('Illegal selection!');
                    return
                end
                data_tmp_sel=[reshape(i_event-nL,1,length(i_event));reshape(i_event+nR,1,length(i_event))];
                omitMask=true;
                [chanNames,dataset,channel,sample,~,~,chanpos]=get_selected_datainfo(obj.bsp,omitMask,data_tmp_sel);
            elseif obj.data_input==3
                t_evt=[obj.bsp.Evts{:,1}];
                t_label=t_evt(strcmpi(obj.bsp.Evts(:,2),obj.event));
                if isempty(t_label)
                    errordlg(['Event: ',obj.event,' not found !']);
                    return
                end
                i_event=round(t_label*obj.fs);
                i_event=min(max(1,i_event),obj.bsp.TotalSample);
                
                i_event((i_event+nR)>obj.bsp.TotalSample)=[];
                i_event((i_event-nL)<1)=[];
                
                omitMask=true;
                [chanNames,dataset,channel,sample,~,~,chanpos]=get_selected_datainfo(obj.bsp,omitMask);
                %need to change the data
            end
            %**************************************************************************
            %set default parameter*****************************************************
            wd=round(obj.stft_winlen);
            ov=round(obj.stft_overlap);
            
            if isempty(wd)||wd>length(sample)
                wd=round(obj.fs/3);
                ov=round(wd*0.9);
            end
            
            if ov>wd
                ov=round(wd*0.9);
            end
            obj.stft_winlen=wd;
            obj.stft_overlap=ov;
            %**************************************************************************
            
            s=[obj.min_clim obj.max_clim];
            if s(1)>=s(2)
                s(1)=s(2)-abs(s(2))*0.1;
                obj.min_clim=s(1);
            end
            
            freq=[obj.min_freq obj.max_freq];
            if freq(1)>=freq(2)
                freq(1)=freq(2)-1;
                obj.min_freq=freq(1);
            end
            
            
            
            if obj.valid
                fpos=get(obj.fig,'position');
            else
                fpos=[100 100 300 600];
            end
            
            if isempty(obj.TFMapFig)||~ishandle(obj.TFMapFig)
                delete(obj.TFMapFig(ishandle(obj.TFMapFig)));
                obj.TFMapFig=figure('Name',obj.event,'NumberTitle','off',...
                    'color','w','DockControls','off','Tag','Act','position',[fpos(1)+fpos(3)+20,fpos(2),650,450],...
                    'CloseRequestFcn',@(src,evts) CloseTFMapFig(obj,src));
            else
                figure(obj.TFMapFig);
                clf
            end
            
            
            %Normalizatin**************************************************************
            
            if obj.normalization==1
                nref=[];
                baseline=[];
                rtfm=[];
            elseif obj.normalization==2
                if obj.data_input~=1&&strcmp(obj.event,obj.normalization_event)
                    nref=round((obj.ms_before+[obj.normalization_start,obj.normalization_end])/1000*obj.fs);
                    
                    needupdate=0;
                    if nref(2)>=length(sample)
                        nref(2)=length(sample);
                        needupdate=1;
                    end
                    if nref(1)>=nref(2)
                        nref(1)=1;
                        needupdate=1;
                    end
                    if nref(1)<=0
                        nref(1)=1;
                        needupdate=1;
                    end
                    
                    if needupdate
                        obj.normalization_start=nref(1)*1000/obj.fs-obj.ms_before;
                        obj.normalization_end=nref(2)*1000/obj.fs-obj.ms_before;
                    end
                elseif obj.data_input==1
                    nref=round([obj.normalization_start,obj.normalization_end]/1000*obj.fs);
                    needupdate=0;
                    if nref(2)>=length(sample)
                        nref(2)=length(sample);
                        needupdate=1;
                    end
                    if nref(1)>=nref(2)
                        nref(1)=1;
                        needupdate=1;
                    end
                    if nref(1)<=0
                        nref(1)=1;
                        needupdate=1;
                    end
                    
                    if needupdate
                        obj.normalization_start=nref(1)*1000/obj.fs;
                        obj.normalization_end=nref(2)*1000/obj.fs;
                    end
                else
                    nref=[];
                end
                
                baseline=[];
                
                if obj.data_input~=1&&strcmp(obj.normalization_event,obj.event)
                    rtfm=[];
                elseif obj.data_input==3
                    bt_evt=[obj.bsp.Evts{:,1}];
                    bt_label=bt_evt(strcmpi(obj.bsp.Evts(:,2),obj.normalization_event));
                    if isempty(bt_label)
                        errordlg(['Event: ',obj.normalization_event,' not found !']);
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
                else
                    rtfm=[];
                end
            elseif obj.normalization==3
                nref=[];
                
                t_evt=[obj.bsp.Evts{:,1}];
                t_label=t_evt(strcmpi(obj.bsp.Evts(:,2),obj.normalization_start_event));
                i_event=round(t_label*obj.fs);
                i_event=min(max(1,i_event),obj.bsp.TotalSample);
                
                baseline_start=i_event;
                
                t_label=t_evt(strcmpi(obj.bsp.Evts(:,2),obj.normalization_end_event));
                i_event=round(t_label*obj.fs);
                i_event=min(max(1,i_event),obj.bsp.TotalSample);
                
                baseline_end=i_event;
                
                tmp_sel=[reshape(baseline_start,1,length(i_event));reshape(baseline_end,1,length(i_event))];
                omitMask=true;
                baseline=get_selected_data(obj.bsp,omitMask,tmp_sel);
                rtfm=[];
            end
            %**************************************************************************
            switch option
                case 1
                    chanpos=[0.52,0.45];
                    dw=0.8;
                    dh=0.85;
                    chanind=1:length(chanNames);
                    channames=chanNames;
                case 2
                    if ~isempty(chanpos)
                        chanind=~isnan(chanpos(:,1))&~isnan(chanpos(:,2));
                    end
                    
                    if ~any(chanind)
                        chanpos=zeros(length(chanNames),2);
                        chanind=1:length(chanNames);
                        col=round(sqrt(length(chanNames)));
                        for i=1:length(chanind)
                            chanpos(i,1)=mod(i-1,col);
                            chanpos(i,2)=floor((i-1)/col);
                        end
                    end
                    channames=chanNames(chanind);
                    chanpos=chanpos(chanind,:);
                    
                    chanpos(:,1)=chanpos(:,1)-min(chanpos(:,1));
                    chanpos(:,2)=chanpos(:,2)-min(chanpos(:,2));
                    
                    dx=abs(pdist2(chanpos(:,1),chanpos(:,1)));
                    dx=min(dx(dx~=0));
                    if isempty(dx)
                        dx=1;
                    end
                    
                    dy=abs(pdist2(chanpos(:,2),chanpos(:,2)));
                    dy=min(dy(dy~=0));
                    if isempty(dy)
                        dy=1;
                    end
                    chanpos(:,1)=chanpos(:,1)+dx/2;
                    chanpos(:,2)=chanpos(:,2)+dy*0.6;
                    
                    x_len=max(chanpos(:,1))+dx/2;
                    y_len=max(chanpos(:,2))+dy*0.6;
                    chanpos(:,1)=chanpos(:,1)/x_len;
                    chanpos(:,2)=chanpos(:,2)/y_len;
                    
                    dw=dx/(x_len+dx);
                    dh=dy/(y_len+dy);
                    
            end
            %**************************************************************
            sl=obj.min_clim;
            sh=obj.max_clim;
            cmax=-inf;
            
            axe = axes('Parent',obj.TFMapFig,'units','normalized','Position',[0 0 1 1],'XLim',[0,1],'YLim',[0,1],'visible','off','tag','back');
            
            
            nref_tmp=nref;
            
            sel=[];
            for i=1:length(i_event)
                tmp_sel=[i_event(i)-nL;i_event(i)+nR];
                sel=cat(2,sel,tmp_sel);
            end
            
            if isempty(data_tmp_sel)
                if ~isempty(sel)
                    [data,~,~,~,~,~,~,~,segment]=get_selected_data(obj.bsp,true,sel);
                else
                    [data,~,~,~,~,~,~,~,segment]=get_selected_data(obj.bsp,true);
                end
            else
                [data,~,~,~,~,~,~,~,segment]=get_selected_data(obj.bsp,true,data_tmp_sel);
            end
            
            data=data(:,chanind);
            
            if ~isempty(baseline)
                baseline=baseline(:,chanind,:);
            end
            
            if ~isempty(rtfm)
                rtfm=rtfm(chanind);
            end
            
            average_tf=0;
            for j=1:length(channames)
                if isempty(baseline)
                    bdata=[];
                else
                    bdata=baseline(:,j,:);
                end
                if obj.data_input==3
                    tfm=0;
                    
                    if obj.normalization==2
                        nref_tmp=[];
                    end
                    %******************************************************
                    for i=1:length(i_event)
                        data1=data(segment==i,j);
                        [tf,f,t]=tfpower(data1,bdata,obj.fs,wd,ov,nref_tmp);
                        tfm=tfm+tf;
                    end
                    tfm=tfm/length(i_event);
                    
                    %compute the baseline spectrum
                    
                    if obj.normalization==2
                        if strcmp(obj.normalization_event,obj.event)
                            rtfm1=mean(tfm(:,(t>=nref(1)/obj.fs)&(t<=nref(2)/obj.fs)),2);
                        else
                            rtfm1=mean(rtfm{j},2);
                        end
                        
                        tfm=tfm./repmat(rtfm1,1,size(tfm,2));
                    end
                else
                    [tfm,f,t]=tfpower(data(:,j),bdata,obj.fs,wd,ov,nref);
                end
                
                average_tf=average_tf+tfm;
                
                if strcmpi(units,'dB')
                    %10log10(A/R)
                    tfm=10*log10(tfm);
                else
                    %(A-R)/R
%                     tfm=tfm-1;
                end
                if option==2
                    tfmap_grid(obj.TFMapFig,axe,t-obj.ms_before/1000,f,tfm,chanpos(j,:),dw,dh,channames{j},sl,sh,freq,obj.smooth_x,obj.smooth_y,obj.auto_scale);
                end
                
                obj.tfmat{j}=tfm;
                obj.tfmat_t=t-obj.ms_before/1000;
                obj.tfmat_f=f;
                obj.tfmat_channel=channel(chanind);
                obj.tfmat_dataset=dataset(chanind);
                obj.tfmat_channame=channames;
                if ~isempty(tfm)&&option==2
                    cmax=max(max(max(abs(tfm))),cmax);
                end
            end
            
            if option==1
                average_tf=average_tf/length(channames);
                if strcmpi(units,'dB')
                    %10log10(A/R)
                    average_tf=10*log10(average_tf);
                else
                    %(A-R)/R
%                     average_tf=average_tf-1;
                end

                tfmap_grid(obj.TFMapFig,axe,t-obj.ms_before/1000,f,average_tf,chanpos,dw,dh,'',sl,sh,freq,obj.smooth_x,obj.smooth_y,obj.auto_scale);
                cmax=max(max(abs(average_tf)));
                colorbar
                a=findobj(obj.TFMapFig,'Type','Axes');
                set(a,'visible','on');
                set(axe,'visible','off');
                
                set(a,'fontsize',20);
                xlabel('Time(s)');
                ylabel('Frequency(Hz)');
                set(a,'fontweight','bold');
            end
            
            AxisCallback(obj,[]);
            obj.DisplayOnsetCallback([]);
            
            
            if isnan(cmax)||isempty(cmax)||isinf(cmax)
                cmax=15;
            end
            
            obj.clim_slider_max=cmax;
            obj.clim_slider_min=-cmax;
            
            if obj.auto_scale
                a=findobj(obj.TFMapFig,'-regexp','Tag','TFMapAxes*');
                axes_clim=get(a,'CLim');
                sl=[];
                sh=[];
                if iscell(axes_clim)
                    for i=1:length(axes_clim)
                        sl=[sl,axes_clim{i}(1)];
                        sh=[sh,axes_clim{i}(2)];
                    end
                else
                    sl=axes_clim(1);
                    sh=axes_clim(2);
                end
                obj.min_clim=min(sl);
                obj.max_clim=max(sh);
            end
            
            obj.background_axe=axe;
            
            obj.ChannelNamesCallback(obj.names_radio);
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
        
        function SymmetricScaleCallback(obj,src)
            obj.symmetric_scale_=get(src,'value');
        end
        
        
        
        function AutoScaleCallback(obj,src)
            obj.auto_scale_=get(src,'value');
            if obj.auto_scale
                obj.symmetric_scale=0;
                set(obj.symmetric_scale_radio,'enable','off');
                set(obj.max_clim_edit,'enable','off');
                set(obj.min_clim_edit,'enable','off');
                set(obj.max_clim_slider,'enable','off');
                set(obj.min_clim_slider,'enable','off');
            else
                set(obj.symmetric_scale_radio,'enable','on');
                set(obj.max_clim_edit,'enable','on');
                set(obj.min_clim_edit,'enable','on');
                set(obj.max_clim_slider,'enable','on');
                set(obj.min_clim_slider,'enable','on');
            end
            obj.ComputeCallback();
        end
        
        function SmoothCallback(obj,src)
            
            tmp=str2double(get(src,'string'));
            switch src
                case obj.smooth_x_edit
                    
                    if isempty(tmp)||isnan(tmp)
                        tmp=obj.smooth_x;
                    end
                    
                    obj.smooth_x=tmp;
                    
                case obj.smooth_y_edit
                    
                    if isempty(tmp)||isnan(tmp)
                        tmp=obj.smooth_y;
                    end
                    
                    obj.smooth_y=tmp;
            end
        end
        
        function AxisCallback(obj,src)
            if src==obj.disp_axis_radio
                obj.disp_axis_=get(src,'value');
            end
            
            if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
                h=findobj(obj.TFMapFig,'-regexp','Tag','TFMapAxes*');
                if obj.disp_axis
                    set(h,'visible','on');
                else
                    set(h,'visible','off');
                end
            end
        end
        function ChannelNamesCallback(obj,src)
            if(~isempty(src)&&ishandle(src))
                obj.disp_channel_names_=get(src,'value');
            end
            if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
                if ishandle(obj.background_axe)
                    h=findobj(obj.background_axe,'-regexp','Tag','names');
                    if obj.disp_channel_names
                        set(h,'visible','on');
                    else
                        set(h,'visible','off');
                    end
                end
            end
        end
        
    end
    
end

