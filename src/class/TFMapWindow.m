classdef TFMapWindow < handle
    %TFMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        valid
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
    end
    properties
        fs
        
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
    end
    
    properties (Dependent)
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
    end
    methods
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
                    val=obj.event_list{1};
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
            if obj.min_clim>=val
                obj.min_clim=val-1;
            end
            if obj.valid
                set(obj.max_clim_edit,'string',num2str(val));
                set(obj.max_clim_slider,'value',val);
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
            
            if obj.max_clim<=val
                obj.max_clim=val+1;
            end
            if obj.valid
                set(obj.min_clim_edit,'string',num2str(val));
                set(obj.min_clim_slider,'value',val);
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
                set(obj.event_popup,'string',val);
                set(obj.scale_start_popup,'string',val);
                set(obj.scale_end_popup,'string',val);
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
        function obj=TFMapWindow(bsp)
            obj.bsp=bsp;
            obj.fs=bsp.SRate;
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
            obj.method_=1;
            obj.data_input_=1;%selection
            obj.ms_before_=1500;
            obj.ms_after_=1500;
            obj.event_='';
            obj.unit_='dB';
            obj.normalization_=1;%none
            obj.normalization_start_=0;
            obj.normalization_end_=200;
            obj.normalization_start_event_='';
            obj.normalization_end_event_='';
            obj.display_onset_=1;
            obj.max_freq_=obj.fs/2;
            obj.min_freq_=0;
            obj.clim_slider_max_=15;
            obj.clim_slider_min_=-15;
            obj.max_clim_=8;
            obj.min_clim_=-8;
            obj.stft_winlen_=2^nextpow2(round(obj.fs/4));
            obj.stft_overlap_=round(obj.stft_winlen*0.9);
        end
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.valid=1;
            obj.fig=figure('MenuBar','none','Name','Time-Frequency Map','units','pixels',...
                'Position',[500 100 300 600],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','off');
            
            hp=uipanel('units','normalized','Position',[0,0,1,1]);
            
            hp_method=uipanel('Parent',hp,'Title','','units','normalized','Position',[0,0.94,1,0.06]);
            uicontrol('Parent',hp_method,'Style','text','String','Method: ','units','normalized','Position',[0.01,0,0.4,0.9],...
                'HorizontalAlignment','left');
            obj.method_popup=uicontrol('Parent',hp_method,'Style','popup',...
                'String',{'Average','Channel','Grid'},'units','normalized','Position',[0.4,0,0.59,0.92],'value',obj.method,...
                'callback',@(src,evts) MethodCallback(obj,src));
            
            hp_data=uipanel('Parent',hp,'Title','','Units','normalized','Position',[0,0.78,1,0.15]);
            uicontrol('Parent',hp_data,'Style','text','String','Input Data: ','units','normalized','Position',[0.01,0.6,0.4,0.35],...
                'HorizontalAlignment','left');
            obj.data_popup=uicontrol('Parent',hp_data,'Style','popup',...
                'String',{'Selection','Single Event','Average Event'},'units','normalized','position',[0.4,0.6,0.59,0.35],...
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
            
            hp_mag=uipanel('Parent',hp,'Title','','units','normalized','position',[0,0.46,1,0.04]);
            uicontrol('Parent',hp_mag,'style','text','units','normalized','string','Unit: ','position',[0.01,0,0.3,1],...
                'HorizontalAlignment','left');
            obj.unit_mag_radio=uicontrol('Parent',hp_mag,'Style','radiobutton','units','normalized','string','Mag','position',[0.4,0,0.29,1],...
                'HorizontalAlignment','left','callback',@(src,evts) UnitRadioCallback(obj,src),'value',1);
            obj.unit_db_radio=uicontrol('Parent',hp_mag,'Style','radiobutton','units','normalized','string','dB','position',[0.7,0,0.29,1],...
                'HorizontalAlignment','left','callback',@(src,evts) UnitRadioCallback(obj,src));
            
            hp_scale=uipanel('Parent',hp,'Title','','units','normalized','position',[0,0.62,1,0.15]);
            uicontrol('Parent',hp_scale,'style','text','units','normalized','string','Normalization: ',...
                'position',[0.01,0.6,0.4,0.35],'HorizontalAlignment','left');
            obj.normalization_popup=uicontrol('Parent',hp_scale,'style','popup','units','normalized',...
                'string',{'None','Individual Within Segment','Average Within Sgement','External Baseline'},'callback',@(src,evts) NormalizationCallback(obj,src),...
                'position',[0.4,0.6,0.59,0.35],'value',obj.normalization);
            
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
            
            hp_stft=uipanel('parent',hp,'title','','units','normalized','position',[0,0.51,1,0.1]);
            uicontrol('parent',hp_stft,'style','text','string','STFT Window (sample): ','units','normalized',...
                'position',[0,0.6,0.5,0.3]);
            obj.stft_winlen_edit=uicontrol('parent',hp_stft,'style','edit','string',num2str(obj.stft_winlen),...
                'units','normalized','position',[0.05,0.1,0.4,0.46],'HorizontalAlignment','center',...
                'callback',@(src,evts) STFTWinlenCallback(obj,src));
            uicontrol('parent',hp_stft,'style','text','string','STFT Overlap (sample): ',...
                'units','normalized','position',[0.5,0.6,0.5,0.3]);
            obj.stft_overlap_edit=uicontrol('parent',hp_stft,'style','edit','string',num2str(obj.stft_overlap),...
                'units','normalized','position',[0.55,0.1,0.4,0.46],'HorizontalAlignment','center',...
                'callback',@(src,evts) STFTOverlapCallback(obj,src));
            
            
            
            
            hp_freq=uipanel('parent',hp,'title','Frequency','units','normalized','position',[0,0.33,1,0.12]);
            
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
            
            
            
            hp_clim=uipanel('parent',hp,'title','Scale','units','normalized','position',[0,0.2,1,0.12]);
            
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
            
            hp_display=uipanel('parent',hp,'title','Display','units','normalized','position',[0,0.06,1,0.13]);
            obj.onset_radio=uicontrol('parent',hp_display,'style','radiobutton','string','onset','value',obj.display_onset,...
                'units','normalized','position',[0,0.7,0.45,0.3],'callback',@(src,evts) DisplayOnsetCallback(obj,src));
            
            
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.005,0.2,0.05],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.005,0.2,0.05],...
                'callback',@(src,evts) NewCallback(obj));
            DataPopUpCallback(obj,obj.data_popup);
            NormalizationCallback(obj,obj.normalization_popup);
            if strcmpi(obj.unit,'dB')
                UnitRadioCallback(obj,obj.unit_db_radio);
            else
                UnitRadioCallback(obj,obj.unit_mag_radio);
            end
            
            obj.event=obj.event_;
            obj.normalization_start_event=obj.normalization_start_event_;
            obj.normalization_end_event=obj.normalization_end_event_;
        end
        function OnClose(obj)
            obj.valid=0;
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
            
            h = obj.TFMapFig;
            if ishandle(h)
                delete(h);
            end
        end
        function MethodCallback(obj,src)
            obj.method=get(src,'value');
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
                case 2
                    %Single Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','off');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
                case 3
                    %Average Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','on');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
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
            
            tonset=obj.ms_before/1000;
            if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
                
                h=findobj(obj.TFMapFig,'-regexp','Tag','TFMapAxes*');
                if obj.display_onset
                    for i=1:length(h)
                        tmp=findobj(h(i),'Type','line');
                        delete(tmp);
                        line([tonset,tonset],[obj.min_freq,obj.max_freq],'LineStyle',':',...
                            'color','k','linewidth',0.1,'Parent',h(i))
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
            if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
                set(obj.TFMapFig,'Name','Obsolete TFMap');
            end
            obj.TFMapFig=figure('Name','Active TFMap','NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));
        end
        function ComputeCallback(obj,src)
            
            option=obj.method;
            
            unit=obj.unit;
            %==========================================================================
            nL=round(obj.ms_before*obj.fs/1000);
            nR=round(obj.ms_after*obj.fs/1000);
            
            %Data selection************************************************************
            if obj.data_input==1
                omitMask=true;
                [data,chanNames,dataset,channel,sample,evts,groupnames,chanpos]=get_selected_data(obj,omitMask);
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
                [data,chanNames,dataset,channel,sample,evts,groupnames,chanpos]=get_selected_data(obj.bsp,omitMask,tmp_sel);
            elseif obj.data_input==3
                t_evt=[obj.bsp.Evts{:,1}];
                t_label=t_evt(strcmpi(obj.bsp.Evts(:,2),obj.event));
                if isempty(t_label)
                    errordlg(['Event: ',obj.event,' not found !']);
                    return
                end
                i_event=round(t_label*obj.fs);
                i_event=min(max(1,i_event),size(obj.bsp.Data{1},1));
                
                i_event((i_event+nR)>size(obj.bsp.Data{1},1))=[];
                i_event((i_event-nL)<1)=[];
                
                omitMask=true;
                [data,chanNames,dataset,channel,sample,evts,groupnames,chanpos]=get_selected_data(obj.bsp,omitMask);
                %need to change the data
            end
            %**************************************************************************
            %set default parameter*****************************************************
            wd=round(obj.stft_winlen);
            ov=round(obj.stft_overlap);
            
            if isempty(wd)||wd>size(data,1)
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
            sl=obj.min_clim;
            sh=obj.max_clim;
            
            freq=[obj.min_freq obj.max_freq];
            if freq(1)>=freq(2)
                freq(1)=freq(2)-1;
                obj.min_freq=freq(1);
            end
            
            if isempty(obj.TFMapFig)||~ishandle(obj.TFMapFig)||~strcmpi(get(obj.TFMapFig,'name'),'Active TFMap')
                obj.TFMapFig=figure('Name','Active TFMap','NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));
            end
            figure(obj.TFMapFig)
            
            clf
            
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
            %**************************************************************************
            switch option
                case 1
                    [tf,f,t]=bsp_tfmap(obj.TFMapFig,data,baseline,obj.fs,wd,ov,s,nref,chanNames,freq,unit);
                    
                    if strcmpi(unit,'dB')
                        imagesc(t,f,10*log10(tf));
                    else
                        imagesc(t,f,tf);
                    end
                    
                    obj.clim_slider_max=max(max(abs(tf)));
                    obj.clim_slider_min=-max(max(abs(tf)));
                    if ~isempty(s)
                        set(gca,'CLim',s);
                    end
                    set(gca,'YLim',freq);
                    set(gca,'Tag','TFMapAxes');
                    title('Time Frequency Map');
                    colormap(jet);
                    xlabel('time (s)');
                    ylabel('frequency (Hz)')
                    axis xy;
                    colorbar
                    
                case 2
                    tf=bsp_tfmap(obj.TFMapFig,data,baseline,obj.fs,wd,ov,s,nref,chanNames,freq,unit);
                    cmax=max(max(abs(tf)));
                    obj.clim_slider_max=cmax*2;
                    obj.clim_slider_min=-cmax*2;
                case 3
                    if isempty(chanpos)
                        errordlg('No channel position in the data !');
                        return
                    end
                    
                    chanind=~isnan(chanpos(:,1))&~isnan(chanpos(:,2));
                    data=data(:,chanind);
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
                    
                    dw=dx/(x_len+2*dx);
                    dh=dy/(y_len+2*dy);
                    axe = axes('Parent',obj.TFMapFig,'units','normalized','Position',[0 0 1 1],'XLim',[0,1],'YLim',[0,1],'visible','off');
                    
                    cmax=-inf;
                    nref_tmp=nref;
                    for j=1:length(channames)
                        if obj.data_input==3
                            tfm=0;
                            %compute the baseline spectrum
                            if obj.normalization==3
                                rtfm=0;
                                for i=1:length(i_event)
                                    tmp_sel=[i_event(i)-nL+nref(1);i_event(i)-nL+nref(2)];
                                    bdata=get_selected_data(obj.bsp,omitMask,tmp_sel);
                                    bdata=bdata(:,chanind);
                                    bdata=bdata(:,j);
                                    [rtf,f,t]=bsp_tfmap(obj.TFMapFig,bdata,baseline,obj.fs,wd,ov,s,[],channames,freq,unit);
                                    rtfm=rtfm+abs(rtf);
                                end
                                
                                rtfm=rtfm/length(i_event);
                                nref_tmp=[];
                            end
                            %******************************************************
                            for i=1:length(i_event)
                                
                                tmp_sel=[i_event(i)-nL;i_event(i)+nR];
                                data=get_selected_data(obj.bsp,omitMask,tmp_sel);
                                data=data(:,chanind);
                                data=data(:,j);
                                [tf,f,t]=bsp_tfmap(obj.TFMapFig,data,baseline,obj.fs,wd,ov,s,nref_tmp,channames,freq,unit);
                                tfm=tfm+tf;
                            end
                            tfm=tfm/length(i_event);
                            if obj.normalization==3
                                tfm=tfm./repmat(mean(rtfm,2),1,size(tfm,2));
                            end
                        else
                            [tfm,f,t]=bsp_tfmap(obj.TFMapFig,data(:,j),baseline,obj.fs,wd,ov,s,nref,channames,freq,unit);
                        end
                        
                        tfmap_grid(obj.TFMapFig,axe,t,f,tfm,chanpos(j,:),dw,dh,channames{j},sl,sh,freq,unit);
                        
                        
                        if ~isempty(tfm)
                            if strcmpi(unit,'dB')
                                cmax=max(max(max(abs(10*log10(tfm)))),cmax);
                            else
                                cmax=max(max(max(abs(tfm-1))),cmax);
                            end
                        end
                    end
                    if strcmpi(unit,'dB')
                        obj.clim_slider_max=cmax*1.5;
                        obj.clim_slider_min=-cmax*1.5;
                    else
                        obj.clim_slider_max=cmax*1.5;
                        obj.clim_slider_min=-1;
                    end
                    
                    obj.DisplayOnsetCallback([]);
            end
        end
        
        function KeyPress(obj,src,evt)
            if strcmpi(get(src,'Name'),'Obsolete TFMap')
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
        
    end
    
end

