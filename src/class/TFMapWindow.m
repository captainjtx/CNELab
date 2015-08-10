classdef TFMapWindow < handle
    %TFMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        valid
        bsp
        fig
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
            
            [ia,ib]=ismember(obj.normalization_start,val);
            if ia
                if obj.valid
                    set(obj.event_popup,'value',ib);
                end
            else
                obj.event=val{1};
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
            obj.ms_before_=1000;
            obj.ms_after_=1000;
            obj.event_='';
            obj.unit_='dB';
            obj.normalization_=1;%none
            obj.normalization_start_='';
            obj.normalization_end_='';
            obj.normalization_start_event_='';
            obj.normalization_end_event_='';
            obj.display_onset_=1;
            obj.max_freq_=obj.fs/2;
            obj.min_freq_=0;
            obj.clim_slider_max_=15;
            obj.clim_slider_min_=-15;
            obj.max_clim_=10;
            obj.min_clim_=-10;
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
                'string',{'None','Within Segment','External Baseline'},'callback',@(src,evts) NormalizationCallback(obj,src),...
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
            
            hp_freq=uipanel('parent',hp,'title','Frequency','units','normalized','position',[0,0,0.35,0.45]);
            
            uicontrol('parent',hp_freq,'style','text','string','Min','units','normalized',...
                'position',[0,0.8,0.5,0.2]);
            uicontrol('parent',hp_freq,'style','text','string','Max','units','normalized',...
                'position',[0.5,0.8,0.5,0.2]);
            
            obj.min_freq_edit=uicontrol('parent',hp_freq,'style','edit','string',num2str(obj.min_freq),'units','normalized',...
                'position',[0.05,0.8,0.4,0.1],'horizontalalignment','center','callback',@(src,evts) FreqCallback(obj,src));
            obj.min_freq_slider=uicontrol('parent',hp_freq,'style','slider','units','normalized',...
                'position',[0.15,0.05,0.2,0.7],'callback',@(src,evts) FreqCallback(obj,src),...
                'min',0,'max',obj.fs/2,'sliderstep',[0.005,0.02],'value',obj.min_freq);
            obj.max_freq_edit=uicontrol('parent',hp_freq,'style','edit','string',num2str(obj.max_freq),'units','normalized',...
                'position',[0.55,0.8,0.4,0.1],'horizontalalignment','center','callback',@(src,evts) FreqCallback(obj,src));
            obj.max_freq_slider=uicontrol('parent',hp_freq,'style','slider','units','normalized',...
                'position',[0.65,0.05,0.2,0.7],'callback',@(src,evts) FreqCallback(obj,src),...
                'min',0,'max',obj.fs/2,'sliderstep',[0.005,0.02],'value',obj.max_freq);
            
            hp_clim=uipanel('parent',hp,'title','Power Limit','units','normalized','position',[0.36,0,0.35,0.45]);
            
            uicontrol('parent',hp_clim,'style','text','string','Min','units','normalized',...
                'position',[0,0.8,0.5,0.2]);
            uicontrol('parent',hp_clim,'style','text','string','Max','units','normalized',...
                'position',[0.5,0.8,0.5,0.2]);
            obj.min_clim_edit=uicontrol('parent',hp_clim,'style','edit','string',num2str(obj.min_clim),'units','normalized',...
                'position',[0.05,0.8,0.4,0.1],'horizontalalignment','center','callback',@(src,evts) ClimCallback(obj,src));
            obj.min_clim_slider=uicontrol('parent',hp_clim,'style','slider','units','normalized',...
                'position',[0.15,0.05,0.2,0.7],'callback',@(src,evts) ClimCallback(obj,src),...
                'min',obj.clim_slider_min,'max',obj.clim_slider_max,'value',obj.min_clim,'sliderstep',[0.01,0.05]);
            obj.max_clim_edit=uicontrol('parent',hp_clim,'style','edit','string',num2str(obj.max_clim),'units','normalized',...
                'position',[0.55,0.8,0.4,0.1],'horizontalalignment','center','callback',@(src,evts) ClimCallback(obj,src));
            obj.max_clim_slider=uicontrol('parent',hp_clim,'style','slider','units','normalized',...
                'position',[0.65,0.05,0.2,0.7],'callback',@(src,evts) ClimCallback(obj,src),...
                'min',obj.clim_slider_min,'max',obj.clim_slider_max,'value',obj.max_clim,'sliderstep',[0.01,0.05]);
            
            hp_display=uipanel('parent',hp,'title','Display','units','normalized','position',[0.72,0,0.28,0.45]);
            obj.onset_radio=uicontrol('parent',hp_display,'style','radiobutton','string','onset','value',obj.display_onset,...
                'units','normalized','position',[0.1,0.9,0.9,0.1],'callback',@(src,evts) DisplayOnsetCallback(obj,src));
            
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
            else
                return
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
            obj.ms_before=str2double(get(src,'string'));
            if isnan(obj.ms_before)
                obj.ms_before=1000;
                set(src,'string',num2str(obj.ms_before));
            end
        end
        function MsAfterCallback(obj,src)
            obj.ms_after=str2double(get(src,'string'));
            if isnan(obj.ms_after)
                obj.ms_after=1000;
                set(src,'string',num2str(obj.ms_after));
            end
        end
        
        function STFTWinlenCallback(obj,src)
            obj.stft_winlen=str2double(get(src,'string'));
            if isnan(obj.stft_winlen)
                obj.stft_winlen=round(obj.fs/3);
                set(src,'string',num2str(obj.stft_winlen));
            end
        end
        function STFTOverlapCallback(obj,src)
            obj.stft_overlap=str2double(get(src,'string'));
            if isnan(obj.stft_overlap)
                obj.stft_overlap=round(obj.stft_winlen*0.9);
                set(src,'string',num2str(obj.stft_overlap));
            end
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
                    obj.max_freq=round(str2double(get(src,'string'))*10)/10;
                case obj.min_freq_edit
                    obj.min_freq=round(str2double(get(src,'string'))*10)/10;
                case obj.max_freq_slider
                    obj.max_freq=round(get(src,'value')*10)/10;
                case obj.min_freq_slider
                    obj.min_freq=round(get(src,'value')*10)/10;
            end
            if ~isempty(obj.bsp.TFMapFig)&&ishandle(obj.bsp.TFMapFig)
                h=findobj(obj.bsp.TFMapFig,'-regexp','Tag','TFMapAxes*');
                
                set(h,'YLim',[obj.min_freq,obj.max_freq]);
                DisplayOnsetCallback(obj,obj.onset_radio);
%                 figure(obj.bsp.TFMapFig);
            end
        end
        
        function ClimCallback(obj,src)
            switch src
                case obj.max_clim_slider
                    obj.max_clim=get(src,'value');
                case obj.min_clim_slider
                    obj.min_clim=get(src,'value');
                case obj.max_clim_edit
                    obj.max_clim=str2double(get(src,'string'));
                case obj.min_clim_edit
                    obj.min_clim=str2double(get(src,'string'));
            end
            
            if ~isempty(obj.bsp.TFMapFig)&&ishandle(obj.bsp.TFMapFig)
                h=findobj(obj.bsp.TFMapFig,'-regexp','Tag','TFMapAxes*');
                
                if obj.min_clim<obj.max_clim
                    set(h,'CLim',[obj.min_clim,obj.max_clim]);
                end
%                 figure(obj.bsp.TFMapFig);
            end
        end
        
        function DisplayOnsetCallback(obj,src)
            if src==obj.onset_radio
                obj.display_onset_=get(src,'value');
            end
            
            tonset=obj.ms_before/1000;
            if ~isempty(obj.bsp.TFMapFig)&&ishandle(obj.bsp.TFMapFig)
                
                h=findobj(obj.bsp.TFMapFig,'-regexp','Tag','TFMapAxes*');
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
                    obj.normalization_start=str2double(get(src,'string'));
                case obj.scale_end_edit
                    obj.normalization_end=str2double(get(src,'string'));
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
    end
    
end

