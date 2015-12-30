classdef PSDWindow < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    properties
        fig
        bsp
        
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
        
        compute_btn
        new_btn
        
        winlen_
        overlap_
        fl_
        fh_
        
        unit_
        layout_
        hold_
        
        fr
        pow
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
    end
    methods
        function obj=PSDWindow(bsp)
            obj.bsp=bsp;
            obj.width=300;
            obj.height=250;
            
            varinitial(obj);
        end
        function varinitial(obj)
            obj.layout_=1;%average
            obj.winlen_=round(obj.fs);
            obj.overlap_=round(obj.winlen*0.5);
            obj.fh_=obj.fs/2;
            obj.fl_=0;
            obj.hold_=0;
            obj.unit_='dB';
        end
        
        
        function buildfig(obj)
            
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.width=300;
            obj.height=250;
            
            obj.fig=figure('MenuBar','none','Name','Power Spectrum Density','units','pixels',...
                'Position',[500 500 obj.width obj.height],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            
            hp=uipanel('units','normalized','Position',[0,0,1,1]);
            
            hp_layout=uipanel('Parent',hp,'Title','','units','normalized','Position',[0,0.85,1,0.14],'title','Layout');
            
            obj.layout_popup=uicontrol('Parent',hp_layout,'Style','popup',...
                'String',{'Average','Channel','Grid'},'units','normalized','Position',[0.1,0.2,0.4,0.8],'value',obj.layout,...
                'callback',@(src,evts) LayoutCallback(obj,src));
            
            obj.hold_radio=uicontrol('Parent',hp_layout,'Style','radiobutton',...
                'String',{'hold on'},'units','normalized','Position',[0.7,0.2,0.3,0.8],'value',obj.hold,...
                'callback',@(src,evts) HoldCallback(obj,src));
            
            hp_unit=uipanel('Parent',hp,'Title','','units','normalized','position',[0,0.7,1,0.14],'title','Unit');
            obj.unit_mag_radio=uicontrol('Parent',hp_unit,'Style','radiobutton','units','normalized','string','Mag','position',[0.1,0,0.3,1],...
                'HorizontalAlignment','left','callback',@(src,evts) UnitRadioCallback(obj,src),'value',1);
            obj.unit_db_radio=uicontrol('Parent',hp_unit,'Style','radiobutton','units','normalized','string','dB','position',[0.6,0,0.3,1],...
                'HorizontalAlignment','left','callback',@(src,evts) UnitRadioCallback(obj,src));
            
            hp_psd=uipanel('parent',hp,'title','PWelch','units','normalized','position',[0,0.45,1,0.24]);
            uicontrol('parent',hp_psd,'style','text','string','Window (sample): ','units','normalized',...
                'position',[0,0.6,0.5,0.3]);
            obj.winlen_edit=uicontrol('parent',hp_psd,'style','edit','string',num2str(obj.winlen),...
                'units','normalized','position',[0.05,0.1,0.4,0.46],'HorizontalAlignment','center',...
                'callback',@(src,evts) WinlenCallback(obj,src));
            uicontrol('parent',hp_psd,'style','text','string','Overlap (sample): ',...
                'units','normalized','position',[0.5,0.6,0.5,0.3]);
            obj.overlap_edit=uicontrol('parent',hp_psd,'style','edit','string',num2str(obj.overlap),...
                'units','normalized','position',[0.55,0.1,0.4,0.46],'HorizontalAlignment','center',...
                'callback',@(src,evts) OverlapCallback(obj,src));
            
            hp_freq=uipanel('parent',hp,'title','Frequency','units','normalized','position',[0,0.2,1,0.24]);
            
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
            
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.01,0.2,0.12],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.01,0.2,0.12],...
                'callback',@(src,evts) NewCallback(obj));
            if strcmpi(obj.unit,'dB')
                UnitRadioCallback(obj,obj.unit_db_radio);
            else
                UnitRadioCallback(obj,obj.unit_mag_radio);
            end
        end
        
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
        end
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
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
            
            
            if isempty(obj.PSDFig)||~ishandle(obj.PSDFig)||~strcmpi(get(obj.PSDFig,'name'),'Active PSD')
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
                set(obj.PSDFig,'Name','Obsolete PSD');
            end
            obj.PSDFig=figure('Name','Active PSD','NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));
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
        
        function ComputeCallback(obj)
            omitMask=true;
            [data,chanNames]=get_selected_data(obj.bsp,omitMask);
            
            wd=round(obj.winlen);
            ov=round(obj.overlap);
            if isempty(wd)||wd>size(data,1)
                wd=round(obj.fs);
                ov=round(wd*0.5);
            end
            
            if ov>wd
                ov=round(wd*0.5);
            end
            
            obj.winlen=wd;
            obj.overlap=ov;
            nfft=wd;
            
            if isempty(obj.PSDFig)||~ishandle(obj.PSDFig)||~strcmpi(get(obj.PSDFig,'name'),'Active PSD')
                obj.PSDFig=figure('Name','Active PSD','NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));
            end
            figure(obj.PSDFig)
            
            if ~obj.hold
                %     clf
            else
                hold on
            end
            
            freq=[obj.fl obj.fh];
            switch obj.layout
                case 1
                    psd=0;
                    for i=1:size(data,2)
                        [tmp,f]=pwelch(data(:,i),wd,ov,nfft,obj.fs,'onesided');
                        psd=psd+tmp;
                    end
                    psd=psd/size(data,2);
                    
                    if strcmpi(obj.unit,'dB')
                        obj.line=plot(f,10*log10(psd));
                    else
                        obj.line=plot(f,psd);
                    end
                    
                    xlim([freq(1),freq(2)])
                    set(gca,'Tag','PSDAxes');
                    title('Power Spectrum Density')
                    
                    xlabel('Frequency (Hz)');
                    ylabel(['Power ',obj.unit])
                    
                    obj.fr=f;
                    obj.pow=psd;
                    
                case 2
                    psd=[];
                    for i=1:size(data,2)
                        [tmp,f]=pwelch(data(:,i),wd,ov,nfft,obj.fs,'onesided');
                        psd=cat(2,psd,tmp(:));
                    end
                    
                    if strcmpi(obj.unit,'dB')
                        obj.line=plot(f(:)*ones(1,size(psd,2)),10*log10(psd));
                    else
                        obj.line=plot(f(:)*ones(1,size(psd,2)),psd);
                    end
                    
                    xlim([freq(1),freq(2)])
                    set(gca,'Tag','PSDAxes');
                    title('Power Spectrum Density')
                    
                    xlabel('Frequency (Hz)');
                    ylabel(['Power ',obj.unit])
                    
                    legend(chanNames)
                    
                    obj.fr=f;
                    obj.pow=psd;
                case 3
                    
            end
        end
    end
    
end

