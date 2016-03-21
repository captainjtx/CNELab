classdef PSDWindow < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    properties
        fig
        bsp
        file_menu
        save_menu
        save_fig_menu
        
        PSDFig
        
        width
        height
        
        line
        
        hold_radio
        unit_db_radio
        unit_mag_radio
        layout_popup
        winlen_edit
        overlap_edit
        fl_edit
        fl_slider
        fh_edit
        fh_slider
        
        data_popup
        event_text
        event_popup
        ms_start_text
        ms_start_edit
        ms_end_text
        ms_end_edit
        
        compute_btn
        new_btn
        
        winlen_
        overlap_
        fl_
        fh_
        
        unit_
        layout_
        hold_
        
        data_input_
        event_list_
        
        ms_start_
        ms_end_
        event_
        
        fr
        pow
        
        PSDSaveWin
        harmonic_popup
        harmonic_radio
        harmonic_
        harmonic_val_
        harmonic_width_edit
        harmonic_width_
        custom_mask_edit
        custom_mask_
    end
    properties(Dependent)
        fs
        unit
        valid
        winlen
        overlap
        fl
        fh
        layout
        hold
        data_input
        event_list
        event
        ms_start
        ms_end
        harmonic
        harmonic_val
        harmonic_width
        custom_mask
    end
    methods
        function obj=PSDWindow(bsp)
            obj.bsp=bsp;
            obj.width=300;
            obj.height=380;
            
            if ~isempty(bsp.Evts)
                obj.event_list_=unique(bsp.Evts(:,2));
            end
            
            varinitial(obj);
            addlistener(bsp,'EventListChange',@(src,evts)UpdateEventList(obj));
            addlistener(bsp,'SelectedEventChange',@(src,evts)UpdateEventSelected(obj));
        end
        
        function UpdateEventList(obj)
            if ~isempty(obj.bsp.Evts)
                obj.event_list=unique(obj.bsp.Evts(:,2));
            end
        end
        
        function UpdateEventSelected(obj)
            if ~isempty(obj.bsp.SelectedEvent)
                obj.event=obj.bsp.Evts{obj.bsp.SelectedEvent(1),2};
            end
        end
        function varinitial(obj)
            obj.layout_=1;%average
            obj.winlen_=round(obj.fs);
            obj.overlap_=round(obj.winlen*0.5);
            obj.fh_=obj.fs/2;
            obj.fl_=0;
            obj.hold_=0;
            obj.unit_='dB';
            obj.data_input_=1;%selection
            obj.ms_start_=0;
            obj.ms_end_=1500;
            obj.event_='';
            obj.harmonic_=0;
            obj.harmonic_val_=2;
            obj.harmonic_width=1;
            obj.custom_mask_=[];
            
            obj.PSDSaveWin=PSDFigureSave(obj);
        end
        
        function buildfig(obj)
            
            if obj.valid
                figure(obj.fig);
                return
            end
            
            obj.width=300;
            obj.height=380;
            
            obj.fig=figure('MenuBar','none','Name','Power Spectrum Density','units','pixels',...
                'Position',[100 400 obj.width obj.height],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            obj.file_menu=uimenu(obj.fig,'label','File');
            obj.save_menu=uimenu(obj.file_menu,'label','Save');
            obj.save_fig_menu=uimenu(obj.save_menu,'label','Figure','callback',@(src,evts) obj.PSDSaveWin.buildfig(),'Accelerator','p');
            hp=uipanel('units','normalized','Position',[0,0,1,1]);
            
            hp_layout=uipanel('Parent',hp,'Title','','units','normalized','Position',[0,0.9,1,0.09],'title','Layout');
            
            obj.layout_popup=uicontrol('Parent',hp_layout,'Style','popup',...
                'String',{'Average','Channel','Grid'},'units','normalized','Position',[0.01,0.2,0.59,0.8],'value',obj.layout,...
                'callback',@(src,evts) LayoutCallback(obj,src));
            
            obj.hold_radio=uicontrol('Parent',hp_layout,'Style','radiobutton',...
                'String',{'hold on'},'units','normalized','Position',[0.7,0.2,0.3,0.8],'value',obj.hold,...
                'callback',@(src,evts) HoldCallback(obj,src));
            
            hp_data=uipanel('Parent',hp,'Title','','units','normalized','Position',[0,0.59,1,0.3],'title','Data');
            obj.data_popup=uicontrol('Parent',hp_data,'Style','popup',...
                'String',{'Selection','Single Event','Average Event'},'units','normalized','position',[0.01,0.6,0.59,0.35],...
                'Callback',@(src,evts) DataPopUpCallback(obj,src),'value',obj.data_input);
            
            obj.event_text=uicontrol('Parent',hp_data,'Style','text','string','Event: ','units','normalized','position',[0.01,0.3,0.35,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.ms_start_text=uicontrol('Parent',hp_data,'Style','text','string','Start (ms): ','units','normalized','position',[0.4,0.3,0.3,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.ms_end_text=uicontrol('Parent',hp_data,'Style','text','string','End (ms): ','units','normalized','position',[0.7,0.3,0.3,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.event_popup=uicontrol('Parent',hp_data,'Style','popup','string',obj.event_list,'units','normalized','position',[0.01,0.05,0.35,0.32],...
                'visible','off','callback',@(src,evts) EventCallback(obj,src));
            obj.ms_start_edit=uicontrol('Parent',hp_data,'Style','Edit','string',num2str(obj.ms_start),'units','normalized','position',[0.4,0.1,0.29,0.28],...
                'HorizontalAlignment','center','visible','off','callback',@(src,evts) MsBeforeCallback(obj,src));
            obj.ms_end_edit=uicontrol('Parent',hp_data,'Style','Edit','string',num2str(obj.ms_end),'units','normalized','position',[0.7,0.1,0.29,0.28],...
                'HorizontalAlignment','center','visible','off','callback',@(src,evts) MsAfterCallback(obj,src));
            
            hp_freq=uipanel('Parent',hp,'Title','','units','normalized','Position',[0,0.41,1,0.17],'title','Frequency');
            uicontrol('parent',hp_freq,'style','text','string','Low','units','normalized',...
                'position',[0,0.6,0.1,0.3]);
            uicontrol('parent',hp_freq,'style','text','string','High','units','normalized',...
                'position',[0,0.1,0.1,0.3]);
            
            obj.fl_edit=uicontrol('parent',hp_freq,'style','edit','string',num2str(obj.fl),'units','normalized',...
                'position',[0.15,0.55,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) FreqCallback(obj,src));
            obj.fl_slider=uicontrol('parent',hp_freq,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) FreqCallback(obj,src),...
                'min',0,'max',obj.fs/2,'sliderstep',[0.005,0.02],'value',obj.fl);
            obj.fh_edit=uicontrol('parent',hp_freq,'style','edit','string',num2str(obj.fh),'units','normalized',...
                'position',[0.15,0.05,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) FreqCallback(obj,src));
            obj.fh_slider=uicontrol('parent',hp_freq,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) FreqCallback(obj,src),...
                'min',0,'max',obj.fs/2,'sliderstep',[0.005,0.02],'value',obj.fh);
            
            setgp=uitabgroup(hp,'units','normalized','position',[0,0.1,1,0.3]);
            pwelch_tab=uitab(setgp,'title','PWelch');
            uicontrol('parent',pwelch_tab,'style','text','string','Window (sample): ','units','normalized',...
                'position',[0,0.6,0.5,0.3]);
            obj.winlen_edit=uicontrol('parent',pwelch_tab,'style','edit','string',num2str(obj.winlen),...
                'units','normalized','position',[0.05,0.1,0.4,0.46],'HorizontalAlignment','center',...
                'callback',@(src,evts) WinlenCallback(obj,src));
            uicontrol('parent',pwelch_tab,'style','text','string','Overlap (sample): ',...
                'units','normalized','position',[0.5,0.6,0.5,0.3]);
            obj.overlap_edit=uicontrol('parent',pwelch_tab,'style','edit','string',num2str(obj.overlap),...
                'units','normalized','position',[0.55,0.1,0.4,0.46],'HorizontalAlignment','center',...
                'callback',@(src,evts) OverlapCallback(obj,src));
            
            unit_tab=uitab(setgp,'title','Unit');
            obj.unit_mag_radio=uicontrol('Parent',unit_tab,'Style','radiobutton','units','normalized','string','Mag','position',[0.1,0,0.3,1],...
                'HorizontalAlignment','left','callback',@(src,evts) UnitRadioCallback(obj,src),'value',1);
            obj.unit_db_radio=uicontrol('Parent',unit_tab,'Style','radiobutton','units','normalized','string','dB','position',[0.6,0,0.3,1],...
                'HorizontalAlignment','left','callback',@(src,evts) UnitRadioCallback(obj,src));
            
            mask_tab=uitab(setgp,'title','Mask');
            obj.harmonic_radio=uicontrol('parent',mask_tab,'style','radiobutton','string','Harmonic','units','normalized',...
                'position',[0.01,0.55,0.3,0.3],'value',obj.harmonic,'Callback',@(src,evt) MaskCallback(obj,src));
            
            obj.harmonic_popup=uicontrol('Parent',mask_tab,'Style','popup','units','normalized','string',{'50 Hz','60 Hz'},...
                'value',obj.harmonic_val,'Callback',@(src,evt) MaskCallback(obj,src),'position',[0.3,0.55,0.3,0.3]);
            
            uicontrol('parent',mask_tab,'style','text','string','width: ','units','normalized','position',[0.01,0.05,0.24,0.3]);
            
            obj.harmonic_width_edit=uicontrol('parent',mask_tab,'style','edit','units','normalized',...
                'position',[0.3,0.05,0.25,0.35],'string',num2str(obj.harmonic_width),'Callback',@(src,evt) MaskCallback(obj,src));
            
            obj.custom_mask_edit=uicontrol('parent',mask_tab,'style','edit','units','normalized','position',[0.65,0.05,0.3,0.9],...
                'string',num2str(obj.custom_mask),'callback',@(src,evt) MaskCallback(obj,src),'max',3,'min',1);
            
            
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.01,0.2,0.08],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.01,0.2,0.08],...
                'callback',@(src,evts) NewCallback(obj));
            if strcmpi(obj.unit,'dB')
                UnitRadioCallback(obj,obj.unit_db_radio);
            else
                UnitRadioCallback(obj,obj.unit_mag_radio);
            end
            DataPopUpCallback(obj,obj.data_popup);
            obj.event=obj.event_;
            MaskCallback(obj,obj.harmonic_radio);
        end
        
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
            
            if ishandle(obj.PSDFig)
                delete(obj.PSDFig);
            end
            
            if obj.PSDSaveWin.valid
                delete(obj.PSDSaveWin.fig);
            end
        end
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
            end
        end
        function val=get.custom_mask(obj)
            val=obj.custom_mask_;
        end
        function set.custom_mask(obj,val)
            obj.custom_mask_=val;
            if obj.valid
                set(obj.custom_mask_edit,'string',num2str(val));
            end
        end
        function val=get.harmonic(obj)
            val=obj.harmonic_;
        end
        
        function set.harmonic(obj,val)
            obj.harmonic_=val;
            if obj.valid
                set(obj.harmonic_radio,'value',val);
            end
        end
        
        function val=get.harmonic_val(obj)
            val=obj.harmonic_val_;
        end
        function set.harmonic_val(obj,val)
            obj.harmonic_val_=val;
            if obj.valid
                set(obj.harmonic_popup,'value',val);
            end
        end
        
        function val=get.harmonic_width(obj)
            val=obj.harmonic_width_;
        end
        function set.harmonic_width(obj,val)
            obj.harmonic_width_=val;
            if obj.valid
                set(obj.harmonic_width_edit,'string',num2str(val));
            end
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
        function val=get.winlen(obj)
            val=obj.winlen_;
        end
        function set.winlen(obj,val)
            obj.winlen_=val;
            if obj.valid
                set(obj.winlen_edit,'string',num2str(val));
            end
        end
        function val=get.overlap(obj)
            val=obj.overlap_;
        end
        function set.overlap(obj,val)
            obj.overlap_=val;
            if obj.valid
                set(obj.overlap_edit,'string',num2str(val));
            end
        end
        function val=get.fs(obj)
            val=obj.bsp.SRate;
        end
        
        function val=get.fh(obj)
            val=obj.fh_;
        end
        function set.fh(obj,val)
            if val>obj.fs/2
                val=obj.fs/2;
            elseif val<1
                val=1;
            end
            if obj.fl>=val
                obj.fl=val-1;
            end
            if obj.valid
                set(obj.fh_edit,'string',num2str(val));
                set(obj.fh_slider,'value',val);
            end
            obj.fh_=val;
        end
        
        function val=get.fl(obj)
            val=obj.fl_;
        end
        function set.fl(obj,val)
            if val<0
                val=0;
            elseif val>(obj.fs/2-1)
                val=obj.fs/2-1;
            end
            
            if obj.fh<=val
                obj.fh=val+1;
            end
            if obj.valid
                set(obj.fl_edit,'string',num2str(val));
                set(obj.fl_slider,'value',val);
            end
            obj.fl_=val;
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
            
            
            if isempty(obj.PSDFig)||~ishandle(obj.PSDFig)||~strcmpi(get(obj.PSDFig,'Tag'),'Act')
            else
                
                if strcmpi(obj.unit,'dB')
                    set(obj.line,'YData',10*log10(obj.pow));
                else
                    set(obj.line,'YData',obj.pow);
                end
            end
        end
        
        
        function val=get.layout(obj)
            val=obj.layout_;
        end
        function set.layout(obj,val)
            obj.layout_=val;
            if obj.valid
                set(obj.layout_popup,'value',val);
            end
        end
        
        function val=get.hold(obj)
            val=obj.hold_;
        end
        
        function set.hold(obj,val)
            obj.hold_=val;
            if obj.valid
                set(obj.hold_radio,'value',val);
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
        function val=get.ms_start(obj)
            val=obj.ms_start_;
        end
        function set.ms_start(obj,val)
            obj.ms_start_=val;
            if obj.valid
                set(obj.ms_start_edit,'string',num2str(val));
            end
        end
        function val=get.ms_end(obj)
            val=obj.ms_end_;
        end
        function set.ms_end(obj,val)
            obj.ms_end_=val;
            if obj.valid
                set(obj.ms_end_edit,'string',num2str(val));
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
        
        
        function val=get.event_list(obj)
            val=obj.event_list_;
        end
        
        function set.event_list(obj,val)
            obj.event_list_=val;
            
            if obj.valid
                set(obj.event_popup,'value',1);
                set(obj.event_popup,'string',val);
            end
            
            [ia,ib]=ismember(obj.event,val);
            if ia
                if obj.valid
                    set(obj.event_popup,'value',ib);
                end
            else
                obj.event=val{1};
            end
        end
        
        function LayoutCallback(obj,src)
            obj.layout_=get(src,'value');
        end
        function WinlenCallback(obj,src)
            t=str2double(get(src,'string'));
            if isnan(t)
                t=obj.winlen;
            end
            obj.winlen=t;
        end
        function OverlapCallback(obj,src)
            t=str2double(get(src,'string'));
            if isnan(t)
                t=obj.overlap;
            end
            obj.overlap=t;
        end
        function FreqCallback(obj,src)
            switch src
                case obj.fh_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.fh;
                    end
                    obj.fh=round(t*10)/10;
                case obj.fl_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.fl;
                    end
                    obj.fl=round(t*10)/10;
                case obj.fh_slider
                    obj.fh=round(get(src,'value')*10)/10;
                case obj.fl_slider
                    obj.fl=round(get(src,'value')*10)/10;
            end
            if ~isempty(obj.PSDFig)&&ishandle(obj.PSDFig)
                h=findobj(obj.PSDFig,'-regexp','Tag','PSDAxes*');
                set(h,'XLim',[obj.fl,obj.fh]);
            end
        end
        
        function HoldCallback(obj,src)
            obj.hold_=get(src,'value');
        end
        
        function NewCallback(obj)
            if ~isempty(obj.PSDFig)&&ishandle(obj.PSDFig)
                set(obj.PSDFig,'Name','PSD Old');
            end
            obj.PSDFig=figure('Name','PSD','NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),'Tag','Act');
        end
        
        function KeyPress(obj,src,evt)
            if strcmpi(get(src,'Name'),'Obsolete PSD')
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
        function DataPopUpCallback(obj,src)
            obj.data_input=get(src,'value');
            switch get(src,'value')
                case 1
                    %Selection
                    set(obj.event_text,'visible','off');
                    set(obj.ms_start_text,'visible','off');
                    set(obj.ms_end_text,'visible','off');
                    set(obj.event_popup,'visible','off');
                    set(obj.ms_start_edit,'visible','off');
                    set(obj.ms_end_edit,'visible','off');
                case 2
                    %Single Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_start_text,'visible','on');
                    set(obj.ms_end_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','off');
                    set(obj.ms_start_edit,'visible','on');
                    set(obj.ms_end_edit,'visible','on');
                case 3
                    %Average Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_start_text,'visible','on');
                    set(obj.ms_end_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','on');
                    set(obj.ms_start_edit,'visible','on');
                    set(obj.ms_end_edit,'visible','on');
            end
        end
        
        function ComputeCallback(obj)
            %==========================================================================
            nL=round(obj.ms_start*obj.fs/1000);
            nR=round(obj.ms_end*obj.fs/1000);
            %Data selection************************************************************
            if obj.data_input==1
                omitMask=true;
                [data,chanNames,~,~,~,~,~,~,segments]=get_selected_data(obj.bsp,omitMask);
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
                i_event((i_event+nL)<1)=[];
                if isempty(i_event)
                    errordlg('Illegal selection!');
                    return
                end
                data_tmp_sel=[reshape(i_event+nL,1,length(i_event));reshape(i_event+nR,1,length(i_event))];
                omitMask=true;
                [data,chanNames,~,~,~,~,~,~,segments]=get_selected_data(obj.bsp,omitMask,data_tmp_sel);
            elseif obj.data_input==3
                t_evt=[obj.bsp.Evts{:,1}];
                t_label=t_evt(strcmpi(obj.bsp.Evts(:,2),obj.event));
                i_event=round(t_label*obj.fs);
                i_event=min(max(1,i_event),obj.bsp.TotalSample);
                
                i_event((i_event+nR)>obj.bsp.TotalSample)=[];
                i_event((i_event+nL)<1)=[];
                
                if isempty(i_event)
                    errordlg(['Event: ',obj.event,' not legal !']);
                    return
                end
                data_tmp_sel=[reshape(i_event+nL,1,length(i_event));reshape(i_event+nR,1,length(i_event))];
                omitMask=true;
                [data,chanNames,~,~,~,~,~,~,segments]=get_selected_data(obj.bsp,omitMask,data_tmp_sel);
                %need to change the data
            end
            %**************************************************************
            wd=round(obj.winlen);
            ov=round(obj.overlap);
            
            seg=unique(segments);
            
            for s=1:length(seg)
                len=sum(segments==seg(s));
                if isempty(wd)||wd>len
                    wd=min(obj.fs,len);
                    ov=round(wd*0.5);
                end
                
                if ov>wd
                    ov=round(wd*0.5);
                end
            end
            
            obj.winlen=wd;
            obj.overlap=ov;
            nfft=wd;
            %**************************************************************
            if obj.valid
                fpos=get(obj.fig,'position');
            else
                fpos=[100 400 obj.width obj.height];
            end
            if isempty(obj.PSDFig)||~ishandle(obj.PSDFig)||~strcmpi(get(obj.PSDFig,'Tag'),'Act')
                obj.PSDFig=figure('Name','PSD','NumberTitle','off',...
                    'WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),'Tag','Act',...
                    'Position',[fpos(1)+fpos(3)+20,fpos(2),400,300]);
            end
            figure(obj.PSDFig)
            if ~obj.hold
                clf
            else
                hold all;
            end
            drawnow
            
            freq=[obj.fl obj.fh];
            switch obj.layout
                case 1
                    psd=0;
                    for s=1:length(seg)
                        dat=data(segments==seg(s),:);
                        tmp_psd=0;
                        for i=1:size(dat,2)
                            [tmp,f]=pwelch(dat(:,i),wd,ov,nfft,obj.fs,'onesided');
                            tmp_psd=tmp_psd+tmp;
                        end
                        psd=tmp_psd/size(dat,2)*size(dat,1)/size(data,1)+psd;
                    end
                    
                    if obj.data_input==1
                        dispName='selection';
                    else
                        dispName=[obj.event,' ',num2str(obj.ms_start),' to ',num2str(obj.ms_end),' ms'];
                    end
                    
                    if strcmpi(obj.unit,'dB')
                        hline=plot(f,10*log10(psd),'DisplayName',dispName);
                    else
                        hline=plot(f,psd,'DisplayName',dispName);
                    end
                case 2
                    psd=zeros(round(nfft/2)+1,size(data,2));
                    for s=1:length(seg)
                        dat=data(segments==seg(s),:);
                        for i=1:size(dat,2)
                            [tmp,f]=pwelch(dat(:,i),wd,ov,nfft,obj.fs,'onesided');
                            psd(:,i)=psd(:,i)+tmp*size(dat,1)/size(data,1);
                        end
                    end
                    
                    if strcmpi(obj.unit,'dB')
                        hline=plot(f(:)*ones(1,size(psd,2)),10*log10(psd),'DisplayName',chanNames);
                    else
                        hline=plot(f(:)*ones(1,size(psd,2)),psd,'DisplayName',chanNames);
                    end
                case 3
            end
            xlim([freq(1),freq(2)])
            set(gca,'Tag','PSDAxes');
            title('Power Spectrum Density');
            xlabel('Frequency (Hz)');
            ylabel(['Power ',obj.unit]);
            legend('-DynamicLegend');
            if obj.hold
                obj.line=cat(1,obj.line,{hline});
                obj.pow=cat(1,obj.pow,{psd});
            else
                obj.line={hline};
                obj.pow={psd};
            end
            obj.fr=f;
            MaskFrequency(obj);
        end
        
        function EventCallback(obj,src)
            obj.event_=obj.event_list{get(src,'value')};
        end
        
        
        function MsBeforeCallback(obj,src)
            t=str2double(get(src,'string'));
            if isnan(t)
                t=obj.ms_start;
            end
            obj.ms_start=t;
        end
        function MsAfterCallback(obj,src)
            t=str2double(get(src,'string'));
            if isnan(t)
                t=obj.ms_end;
            end
            obj.ms_end=t;
        end
        
        function MaskCallback(obj,src)
            switch src
                case obj.harmonic_radio
                    val=get(src,'value');
                    if val
                        set(obj.harmonic_popup,'enable','on');
                        set(obj.harmonic_width_edit,'enable','on');
                    else
                        set(obj.harmonic_popup,'enable','off');
                        set(obj.harmonic_width_edit,'enable','off');
                    end
                    obj.harmonic_=val;
                    
                case obj.harmonic_popup
                    obj.harmonic_val_=get(src,'value');
                case obj.harmonic_width_edit
                    w=str2double(get(src,'string'));
                    if isnan(w)
                        w=obj.harmonic_width_;
                    end
                    obj.harmonic_width=w;
                case obj.custom_mask_edit
                    w=str2num(get(src,'string'));
                    if ~isempty(w)
                        if size(w,2)~=2
                            errordlg('Invalid input !');
                            w=obj.custom_mask_;
                        end
                    end
                    obj.custom_mask=w;
            end
            if isempty(obj.PSDFig)||~ishandle(obj.PSDFig)||~strcmpi(get(obj.PSDFig,'Tag'),'Act')
            else
                MaskFrequency(obj);
            end
        end
        function MaskFrequency(obj)
            for l=1:length(obj.line)
                for m=1:length(obj.line{l})
                    p=obj.pow{l}(:,m);
                    h=obj.line{l}(m);
                    if obj.harmonic
                        fn=[50,60];
                        fn=fn(obj.harmonic_val);
                        for i=1:floor(obj.fs/2/fn)
                            freq=fn*i;
                            p((freq-obj.harmonic_width<=obj.fr)&(freq+obj.harmonic_width>=obj.fr))=nan;
                        end
                    end
                    
                    if ~isempty(obj.custom_mask)
                        for i=1:size(obj.custom_mask,1)
                            p((freq-obj.custom_mask(i,1)<=obj.fr)&(freq+obj.custom_mask(i,2)>=obj.fr))=nan;
                        end
                    end
                    
                    if strcmpi(obj.unit,'dB')
                        set(h,'YData',10*log10(p));
                    else
                        set(h,'YData',p);
                    end
                end
            end
        end
    end
    
end

