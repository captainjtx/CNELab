classdef TFMapWindow < handle
    %TFMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bsp
        fig
        method_popup
        data_popup
        event_edit
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
        stft_winlen_edit
        stft_overlap_edit
        max_freq_edit
        min_freq_edit
        max_clim_edit
        min_clim_edit
        
        method
        data_input
        ms_before
        ms_after
        event
        unit
        normalization_start
        normalization_end
    end
    
    methods
        function obj=TFMapWindow(bsp)
            obj.bsp=bsp;
            
            buildfig(obj);
            
        end
        function buildfig(obj)
            obj.fig=figure('MenuBar','none','Name','Time-Frequency Map','units','pixels',...
                'Position',[500 100 300 500],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','off');
            
            hp=uipanel('units','normalized','Position',[0,0,1,1]);
            
            hp_method=uipanel('Parent',hp,'Title','','units','normalized','Position',[0,0.94,1,0.06]);
            uicontrol('Parent',hp_method,'Style','text','String','Method: ','units','normalized','Position',[0.01,0,0.4,1],...
                'HorizontalAlignment','left');
            obj.method_popup=uicontrol('Parent',hp_method,'Style','popup',...
                'String',{'Channel','Average','Grid'},'units','normalized','Position',[0.4,0,0.59,1]);
            
            hp_data=uipanel('Parent',hp,'Title','','Units','normalized','Position',[0,0.73,1,0.2]);
            uicontrol('Parent',hp_data,'Style','text','String','Input Data: ','units','normalized','Position',[0.01,0.6,0.4,0.4],...
                'HorizontalAlignment','left');
            obj.data_popup=uicontrol('Parent',hp_data,'Style','popup',...
                'String',{'Selection','Single Event','Average Event'},'units','normalized','position',[0.4,0.6,0.59,0.4],...
                'Callback',@(src,evts) DataPopUpCallback(obj,src));
            obj.event_text=uicontrol('Parent',hp_data,'Style','text','string','Event: ','units','normalized','position',[0.01,0.3,0.35,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.ms_before_text=uicontrol('Parent',hp_data,'Style','text','string','Before (ms): ','units','normalized','position',[0.4,0.3,0.3,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.ms_after_text=uicontrol('Parent',hp_data,'Style','text','string','After (ms): ','units','normalized','position',[0.7,0.3,0.3,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.event_edit=uicontrol('Parent',hp_data,'Style','Edit','string','','units','normalized','position',[0.01,0.05,0.35,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.ms_before_edit=uicontrol('Parent',hp_data,'Style','Edit','string','','units','normalized','position',[0.4,0.05,0.29,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.ms_after_edit=uicontrol('Parent',hp_data,'Style','Edit','string','','units','normalized','position',[0.7,0.05,0.29,0.3],...
                'HorizontalAlignment','left','visible','off');
            
            hp_mag=uipanel('Parent',hp,'Title','','units','normalized','position',[0,0.66,1,0.06]);
            uicontrol('Parent',hp_mag,'style','text','units','normalized','string','Unit: ','position',[0.01,0,0.3,1],...
                'HorizontalAlignment','left');
            obj.unit_mag_radio=uicontrol('Parent',hp_mag,'Style','radiobutton','units','normalized','string','dB','position',[0.4,0,0.29,1],...
                'HorizontalAlignment','left','callback',@(src,evts) UnitRadioCallback(obj,src),'value',1);
            obj.unit_db_radio=uicontrol('Parent',hp_mag,'Style','radiobutton','units','normalized','string','Mag','position',[0.7,0,0.29,1],...
                'HorizontalAlignment','left','callback',@(src,evts) UnitRadioCallback(obj,src));
            
            hp_scale=uipanel('Parent',hp,'Title','','units','normalized','position',[0,0.45,1,0.2]);
            uicontrol('Parent',hp_scale,'style','text','units','normalized','string','Normalization: ',...
                'position',[0.01,0.6,0.4,0.4],'HorizontalAlignment','left');
            obj.normalization_popup=uicontrol('Parent',hp_scale,'style','popup','units','normalized',...
                'string',{'None','Within Segment','External Baseline'},'callback',@(src,evts) NormalizationCallback(obj,src),...
                'position',[0.4,0,0.59,1]);
            
            obj.scale_start_text=uicontrol('Parent',hp_scale,'style','text','units','normalized',...
                'string','Start (ms): ','position',[0.01,0.3,0.4,0.3],'HorizontalAlignment','left',...
                'visible','off');
            obj.scale_end_text=uicontrol('Parent',hp_scale,'style','text','units','normalized',...
                'string','End (ms): ','position',[0.5,0.3,0.4,0.3],'HorizontalAlignment','left',...
                'visible','off');
            obj.scale_start_edit=uicontrol('parent',hp_scale,'style','edit','units','normalized',...
                'string','','position',[0.01,0.05,0.4,0.3],'HorizontalAlignment','left','visible','off');
            obj.scale_end_edit=uicontrol('parent',hp_scale,'style','edit','units','normalized',...
                'string','','position',[0.5,0.05,0.4,0.3],'HorizontalAlignment','left','visible','off');
            
            hp_stft=uipanel('parent',hp,'title','','units','normalized','position',[0,0.34,1,0.1]);
            uicontrol('parent',hp_stft,'style','text','string','STFT Window (sample): ','units','normalized',...
                'position',[0,0.6,0.5,0.4]);
            obj.stft_winlen_edit=uicontrol('parent',hp_stft,'style','edit','string','',...
                'units','normalized','position',[0.05,0.1,0.4,0.46],'HorizontalAlignment','center');
            uicontrol('parent',hp_stft,'style','text','string','STFT Overlap (sample): ',...
                'units','normalized','position',[0.5,0.6,0.5,0.4]);
            obj.stft_overlap_edit=uicontrol('parent',hp_stft,'style','edit','string','',...
                'units','normalized','position',[0.55,0.1,0.4,0.46],'HorizontalAlignment','center');
            
            hp_freq=uipanel('parent',hp,'title','Frequency','units','normalized','position',[0,0,0.35,0.33]);
            
            uicontrol('parent',hp_freq,'style','text','string','Min','units','normalized',...
                'position',[0,0.8,0.5,0.2]);
            uicontrol('parent',hp_freq,'style','text','string','Max','units','normalized',...
                'position',[0.5,0.8,0.5,0.2]);
            
            obj.min_freq_edit=uicontrol('parent',hp_freq,'style','edit','string','','units','normalized',...
                'position',[0.05,0.75,0.4,0.15],'horizontalalignment','center');
            obj.max_freq_edit=uicontrol('parent',hp_freq,'style','edit','string','','units','normalized',...
                'position',[0.55,0.75,0.4,0.15],'horizontalalignment','center');
            
            hp_clim=uipanel('parent',hp,'title','Power Limit','units','normalized','position',[0.36,0,0.35,0.33]);
            
            uicontrol('parent',hp_clim,'style','text','string','Min','units','normalized',...
                'position',[0,0.8,0.5,0.2]);
            uicontrol('parent',hp_clim,'style','text','string','Max','units','normalized',...
                'position',[0.5,0.8,0.5,0.2]);
            obj.min_clim_edit=uicontrol('parent',hp_clim,'style','edit','string','','units','normalized',...
                'position',[0.05,0.75,0.4,0.15],'horizontalalignment','center');
            obj.max_clim_edit=uicontrol('parent',hp_clim,'style','edit','string','','units','normalized',...
                'position',[0.55,0.75,0.4,0.15],'horizontalalignment','center');
        end
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            else
                return
            end
        end
        function DataPopUpCallback(obj,src)
            switch get(src,'value')
                case 1
                    %Selection
                    set(obj.event_text,'visible','off');
                    set(obj.ms_before_text,'visible','off');
                    set(obj.ms_after_text,'visible','off');
                    set(obj.event_edit,'visible','off');
                    set(obj.ms_before_edit,'visible','off');
                    set(obj.ms_after_edit,'visible','off');
                case 2
                    %Single Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_edit,'visible','on','enable','off');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
                case 3
                    %Average Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_edit,'visible','on','enable','on');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
            end
        end
        
        function UnitRadioCallback(obj,src)
            if src==obj.unit_db_radio
                set(src,'value',1);
                set(obj.unit_mag_radio,'value',0);
            else
                set(src,'value',1);
                set(obj.unit_db_radio,'value',0);
            end
        end
        
        function NormalizationCallback(obj,src)
            switch get(src,'value')
                case 1
                    set(obj.scale_start_text,'visible','off');
                    set(obj.scale_end_text,'visible','off');
                    set(obj.scale_start_edit,'visible','off');
                    set(obj.scale_end_edit,'visible','off');
                case 2
                    set(obj.scale_start_text,'visible','on');
                    set(obj.scale_start_text,'string','Start (ms): ')
                    set(obj.scale_end_text,'visible','on');
                    set(obj.scale_end_text,'string','End (ms): ')
                    set(obj.scale_start_edit,'visible','on');
                    set(obj.scale_end_edit,'visible','on');
                case 3
                    set(obj.scale_start_text,'visible','on');
                    set(obj.scale_start_text,'string','Start (event): ')
                    set(obj.scale_end_text,'visible','on');
                    set(obj.scale_end_text,'string','End (event): ')
                    set(obj.scale_start_edit,'visible','on');
                    set(obj.scale_end_edit,'visible','on');
            end
        end
        
    end
    
end

