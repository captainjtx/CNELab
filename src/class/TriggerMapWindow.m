classdef TriggerMapWindow < handle
    %TriggerMapWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    properties
        bsp
        fig
        TriggerMapFig
        OldFig
        method_popup
        data_popup
        event_popup
        ms_before_edit
        ms_after_edit
        event_text
        ms_before_text
        ms_after_text
        
        onset_radio
        compute_btn
        new_btn
        plot_error_radio
        auto_scale_radio
        
        file_menu
        save_menu
        save_fig_menu
        export_menu
        
        disp_axis_radio
        names_radio
        background_axe
        
        JMinSpinner
        JMaxSpinner
        mat
    end
    properties
        method_
        data_input_
        ms_before_
        ms_after_
        event_
        display_onset_
        event_list_
        plot_error_
        disp_axis_
        disp_channel_names_
        auto_scale_
        cmin_
        cmax_
    end
    
    properties (Dependent)
        valid
        fs
        method
        data_input
        ms_before
        ms_after
        event

        display_onset

        event_list
        symmetric_scale
        plot_error
        disp_axis
        disp_channel_names
        auto_scale
        cmin
        cmax
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
        
        
        
        function val=get.plot_error(obj)
            val=obj.plot_error_;
        end
        function set.plot_error(obj,val)
            obj.plot_error_=val;
            if obj.valid
                set(obj.plot_error_radio,'value',val);
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
            if(isempty(val))
                val='';
            end
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
        
        function val=get.display_onset(obj)
            val=obj.display_onset_;
        end
        function set.display_onset(obj,val)
            obj.display_onset_=val;
            if obj.valid
                set(obj.onset_radio,'value',val);
            end
        end
        
        function val=get.event_list(obj)
            if isempty(obj.event_list_)
               val={'none'};
            else
                val=obj.event_list_;
            end
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
        function obj=TriggerMapWindow(bsp)
            obj.bsp=bsp;
            varinitial(obj);
            addlistener(bsp,'EventListChange',@(src,evts)UpdateEventList(obj));
            addlistener(bsp,'SelectedEventChange',@(src,evts)UpdateEventSelected(obj));
            %             buildfig(obj);
        end
        function UpdateEventList(obj)
            if ~isempty(obj.bsp.Evts)
                if isempty(obj.event_list_)
                    if obj.valid
                        set(obj.data_popup,'String',{'Selection', 'Single Event', 'Average Event'});
                    end
                end
                obj.event_list = unique(obj.bsp.Evts(:,2));
            else
                if obj.valid
                    set(obj.data_popup,'String',{'Selection'}, 'Value', 1);
                    DataPopUpCallback(obj, obj.data_popup);
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
            obj.method_=1;
            obj.data_input_=1;%selection
            obj.ms_before_=1500;
            obj.ms_after_=1500;
            obj.event_='';
            obj.display_onset_=1;
            obj.plot_error_=1;
            obj.disp_axis_=0;
            obj.disp_channel_names_=1;
            obj.auto_scale_ = 1;
            obj.cmin_ = -1;
            obj.cmax_ = 1;
        end
        function buildfig(obj)
            import javax.swing.JSpinner;
            import javax.swing.SpinnerNumberModel;
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.fig=figure('MenuBar','none','Name','Signal Map','units','pixels',...
                'Position',[100 100 300 400],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));
            obj.file_menu=uimenu(obj.fig,'label','File');
            obj.save_menu=uimenu(obj.file_menu,'label','Save');
            obj.export_menu=uimenu(obj.file_menu,'label','Export','callback',@(src,evts)ExportObjToWorkspace(obj));
            
            hp=uipanel('units','normalized','Position',[0,0,1,1]);
            
            hp_method=uipanel('Parent',hp,'Title','Layout','units','normalized','Position',[0,0.87,1,0.12]);
            obj.method_popup=uicontrol('Parent',hp_method,'Style','popup',...
                'String',{'Average','Grid'},'units','normalized','Position',[0.01,0,0.59,0.92],'value',obj.method,...
                'callback',@(src,evts) MethodCallback(obj,src));
            
            hp_data=uipanel('Parent',hp,'Title','Data','Units','normalized','Position',[0,0.61,1,0.25]);
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
            
            hp_scale=uipanel('Parent',hp,'Title','','units','normalized','position',[0,0.4,1,0.2]);
            uicontrol('parent',hp_scale,'style','text','units','normalized','position',[0,0.4,0.12,0.5],...
                'string','Y Min','horizontalalignment','left','fontunits','normalized','fontsize',0.3);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmin),[],[],java.lang.Double(0.1)));
            obj.JMinSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JMinSpinner,[0,0,1,1],hp_scale);
            set(gh,'Units','Norm','Position',[0.12,0.5,0.35,0.5]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ScaleSpinnerCallback(obj));
            
            uicontrol('parent',hp_scale,'style','text','units','normalized','position',[0.5,0.4,0.12,0.5],...
                'string','Y Max','horizontalalignment','left','fontunits','normalized','fontsize',0.3);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmax),[],[],java.lang.Double(0.1)));
            obj.JMaxSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JMaxSpinner,[0,0,1,1],hp_scale);
            set(gh,'Units','Norm','Position',[0.62,0.5,0.35,0.5]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ScaleSpinnerCallback(obj));
            
            
            tabgp=uitabgroup(hp,'units','normalized','position',[0,0.1,1,0.3]);
            tab_display=uitab(tabgp,'title','Display');
            obj.onset_radio=uicontrol('parent',tab_display,'style','radiobutton','string','Onset','value',obj.display_onset,...
                'units','normalized','position',[0,0.66,0.45,0.33],'callback',@(src,evts) DisplayOnsetCallback(obj,src));
            
            obj.plot_error_radio=uicontrol('parent',tab_display,'style','radiobutton','string','Plot Error','value',obj.plot_error,...
                'units','normalized','position',[0,0.33,0.45,0.33],'callback',@(src,evts) PlotErrorCallback(obj,src));
            obj.disp_axis_radio=uicontrol('parent',tab_display,'style','radiobutton','string','Axis','value',obj.disp_axis,...
                'units','normalized','position',[0.5,0.66,0.45,0.33],'callback',@(src,evts) AxisCallback(obj,src));
            obj.names_radio=uicontrol('parent',tab_display,'style','radiobutton','string','Channel Names',...
                'units','normalized','position',[0.5,0.33,0.45,0.33],'value',obj.disp_channel_names,...
                'callback',@(src,evts) ChannelNamesCallback(obj,src));
            obj.auto_scale_radio = uicontrol('parent',tab_display,'style','radiobutton','string','Auto Scale',...
                'units','normalized','position',[0,0,0.45,0.33],'value',obj.auto_scale,...
                'callback',@(src,evts) AutoScaleCallback(obj,src));
            
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.01,0.2,0.08],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.01,0.2,0.08],...
                'callback',@(src,evts) NewCallback(obj));
            UpdateEventList(obj);
            
            obj.event=obj.event_;
        end
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
            obj.fig=[];
            
            h = obj.TriggerMapFig;
            if ishandle(h)
                delete(h);
            end
            for i = 1:length(obj.OldFig)
                try
                    delete(obj.OldFig(i))
                catch
                    continue
                end
            end
        end
        function MethodCallback(obj,src)
            obj.method=get(src,'value');
            switch obj.method
                case 1
                    obj.data_input=1;
                    DataPopUpCallback(obj,obj.data_popup);
                case 2
                    if ~isempty(obj.event_list_)
                        obj.data_input = 3;
                    else
                        obj.data_input = 1;
                    end
                    DataPopUpCallback(obj,obj.data_popup);
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
        function ExportObjToWorkspace(obj)
            prompt={'Assign a name:'};
            title='Export Object';
            
            def={'mat'};
            answer=inputdlg(prompt,title,1,def);
            
            if isempty(answer)
                return
            end
            
            assignin('base',answer{1},obj.mat);
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
        function DisplayOnsetCallback(obj,src)
            if src == obj.onset_radio
                obj.display_onset_=get(src,'value');
            end
            
            tonset=0;
            if ~isempty(obj.TriggerMapFig) && ishandle(obj.TriggerMapFig)
                h=findobj(obj.TriggerMapFig,'-regexp','Tag','TriggerMapAxes*');
                if obj.display_onset
                    for i=1:length(h)
                        %                         axes(h(i))
                        hold on
                        yl = get(h(i), 'ylim');
                        line([tonset,tonset],yl,'LineStyle',':',...
                            'color','k','linewidth',2,'Parent',h(i),'tag','onset');
                        set(h(i),'ylim',yl);
                    end
                else
                    for i=1:length(h)
                        tmp=findobj(h(i),'tag','onset');
                        delete(tmp);
                    end
                end
            end
        end
        
        function EventCallback(obj,src)
            obj.event_=obj.event_list{get(src,'value')};
            if ~isempty(obj.TriggerMapFig)&&ishandle(obj.TriggerMapFig)
                set(obj.TriggerMapFig,'name',obj.event_);
            end
        end
        function UpdateEventSelected(obj)
            if ~isempty(obj.bsp.SelectedEvent)
                obj.event=obj.bsp.Evts{obj.bsp.SelectedEvent(1),2};
            end
        end
        function CloseTriggerMapFig(obj,src)
            delete(src);
            obj.TriggerMapFig=[];
            
        end
        function NewCallback(obj)
            obj.OldFig = cat(1, obj.OldFig, obj.TriggerMapFig(:));
            if ~isempty(obj.TriggerMapFig)&&ishandle(obj.TriggerMapFig)
                name=get(obj.TriggerMapFig,'Name');
                set(obj.TriggerMapFig,'Tag','Old');
                set(obj.TriggerMapFig,'name',[name,' Old'])
            end
            obj.TriggerMapFig=figure('Name',obj.event,'NumberTitle','off',...
                'color','w','DockControls','off','Tag','Act','CloseRequestFcn',@(src,evts) CloseTriggerMapFig(obj,src));
        end
        
        function ComputeCallback(obj,src)
            option=obj.method;
            obj.mat.data = [];
            obj.mat.fs = [];
            obj.mat.ave_data = [];
            obj.mat.channames = [];
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
            
            if obj.valid
                fpos=get(obj.fig,'position');
            else
                fpos=[100 100 300 600];
            end
            
            if isempty(obj.TriggerMapFig)||~ishandle(obj.TriggerMapFig)
                delete(obj.TriggerMapFig(ishandle(obj.TriggerMapFig)));
                obj.TriggerMapFig=figure('Name',obj.event,'NumberTitle','off',...
                    'color','w','DockControls','off','Tag','Act','position',[fpos(1)+fpos(3)+20,fpos(2),650,450],...
                    'CloseRequestFcn',@(src,evts) CloseTriggerMapFig(obj,src));
            else
                figure(obj.TriggerMapFig);
                clf
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
                        chanind=~isnan(chanpos(:,1)) & ~isnan(chanpos(:,2));
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
            axe = axes('Parent',obj.TriggerMapFig,'units','normalized','Position',[0 0 1 1],...
                'XLim',[0,1],'YLim',[0,1],'visible','off','tag','back');
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
            
            ave_sig = [];
            
            if obj.auto_scale
                yl = [obj.cmin, obj.cmax];
            else
                yl = [];
            end
            for j=1:length(channames)
                sig = [];
                if obj.data_input==3
                    %******************************************************
                    for i=1:length(i_event)
                        sig = cat(2, sig ,data(segment==i,j));
                    end
                    obj.mat.data = cat(3,obj.mat.data,sig);
                else
                    sig = data(:, j);
                    obj.mat.data = cat(2,obj.mat.data,sig);
                end
                
                if option==2
                    if obj.plot_error
                        err = std(sig,0,2);
                    else
                        err = zeros(size(sig,1),1);
                    end
                    triggermap_grid(obj.TriggerMapFig,axe,linspace(-obj.ms_before, obj.ms_after, size(sig,1)),...
                        mean(sig,2),err,chanpos(j,:),dw,dh,channames{j},yl);
                    ave_sig = cat(2, ave_sig, mean(sig,2));
                end
            end
            
            if option==1
                if obj.plot_error
                       err = std(reshape(obj.mat.data,size(obj.mat.data,1),size(obj.mat.data,2)*size(obj.mat.data,3)),0,2);
                 else
                       err = zeros(size(obj.mat.data,1),1);
                end
                triggermap_grid(obj.TriggerMapFig,axe,linspace(-obj.ms_before, obj.ms_after, size(obj.mat.data, 1)),...
                    mean(mean(obj.mat.data,3),2),err,chanpos,dw,dh,'Average',yl);
                ave_sig = mean(mean(obj.mat.data,3),2);
%                 cmax=max(max(abs(ave_sig)));
                a=findobj(obj.TriggerMapFig,'Type','Axes');
                set(a,'visible','on');
                set(axe,'visible','off');
                
                set(a,'fontsize',20);
                xlabel('Time(s)');
                ylabel('Amplitude');
                set(a,'fontweight','bold');
            end
            
            AxisCallback(obj,[]);
            obj.DisplayOnsetCallback([]);
            
            obj.background_axe=axe;
            
            obj.ChannelNamesCallback(obj.names_radio);
            
            obj.mat.channames = channames;
            obj.mat.fs = obj.fs;
            obj.mat.ave_data = ave_sig;
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
        
        function AxisCallback(obj,src)
            if src==obj.disp_axis_radio
                obj.disp_axis_=get(src,'value');
            end
            
            if ~isempty(obj.TriggerMapFig)&&ishandle(obj.TriggerMapFig)
                h=findobj(obj.TriggerMapFig,'-regexp','Tag','TriggerMapAxes*');
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
            if ~isempty(obj.TriggerMapFig)&&ishandle(obj.TriggerMapFig)
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
        
        function PlotErrorCallback(obj, src)
            obj.plot_error_ = get(src,'value');
        end
        
        function AutoScaleCallback(obj,src)
            obj.auto_scale_=get(src,'value');
            
            h=findobj(obj.TriggerMapFig,'-regexp','Tag','TriggerMapAxes*');
            if obj.auto_scale
                axis(h, 'auto y');
            else
            end
        end
        
        function val=NoMapFig(obj)
            val=isempty(obj.TriggerMapFig)||~all(ishandle(obj.TriggerMapFig))||~all(strcmpi(get(obj.TriggerMapFig,'Tag'),'Act'));
        end
        
        function ScaleSpinnerCallback(obj)
            if obj.auto_scale
                return;
            end
            min=obj.JMinSpinner.getValue();
            max=obj.JMaxSpinner.getValue();
            
            if min<max
                obj.cmin=min;
                obj.cmax=max;
                
                if ~NoMapFig(obj)
                    h=findobj(obj.TriggerMapFig,'-regexp','Tag','TriggerMapAxes');
                    if ~isempty(h)
                        set(h,'ylim',[obj.cmin,obj.cmax]);
                    end
                end
            end
        end
        
    end
    
end

