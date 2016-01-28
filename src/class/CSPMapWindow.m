classdef CSPMapWindow < handle
    %CSPMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    properties
        fig
        bsp
        
        method_popup
        
        event_popup1
        event_popup2
        
        low_freq_edit
        low_freq_slider
        
        high_freq_edit
        high_freq_slider
        
        sparsity_edit
        sparsity_txt
        
        filter_number_edit
        filter_number_txt
        
        ms_t_start_edit1
        ms_t_end_edit1
        
        ms_t_start_edit2
        ms_t_end_edit2
        
        max_radio_btn
        min_radio_btn
        
        new_btn
        compute_btn
        
        eig_ind%
        
        cov1
        cov2
        
        method_
        
        ms_t_start1_
        ms_t_end1_
        
        ms_t_start2_
        ms_t_end2_
        
        event_list_
        event1_
        event2_
        
        high_freq_
        low_freq_
        
        sparsity_
        filter_number_
        
        height
        width
        
        rq_max_
        rq_min_
    end
    
    properties(Dependent)
        fs
        cnum
        event_list
        valid
        event1
        event2
        
        ms_t_start1
        ms_t_end1
        
        ms_t_start2
        ms_t_end2
        
        high_freq
        low_freq
        
        method
        
        sparsity
        filter_number
        
        rq_max
        rq_min
    end
    
    methods
        function obj=CSPMapWindow(bsp)
            obj.bsp=bsp;
            if ~isempty(bsp.Evts)
                obj.event_list_=unique(bsp.Evts(:,2));
            end
            varinitial(obj);
            addlistener(bsp,'EventListChange',@(src,evts)UpdateEventList(obj));
        end
        
        function varinitial(obj)
            obj.method_=1;
            obj.event1_='';
            obj.event2_='';
            obj.width=300;
            obj.height=700;
            obj.sparsity_=5;
            obj.filter_number_=1;
            obj.low_freq_=0;
            obj.high_freq_=obj.fs/2;
            
            obj.ms_t_start1_=-1000;
            obj.ms_t_end1=0;
            obj.ms_t_start2=0;
            obj.ms_t_end2=1000;
            
            obj.rq_max_=1;
            obj.rq_min_=0;
        end
        
        function buildfig(obj)
            
            if obj.valid
                figure(obj.fig);
                return
            end
            
            %             obj.width=300;
            %             obj.height=700;
            %             varinitial(obj);
            obj.fig=figure('MenuBar','none','Name','Common Spatial Pattern','units','pixels',...
                'Position',[500 100 obj.width obj.height],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            
            hp=uipanel(obj.fig,'units','normalized','Position',[0,0,1,1]);
            hp_method=uipanel('parent',hp,'units','normalized','Position',[0,0.9,1,0.1],'title','Method');
            
            obj.method_popup=uicontrol('Parent',hp_method,'Style','popup',...
                'String',{'CSP','Sparse CSP'},'units','normalized','position',[0.01,0.6,0.4,0.35],...
                'Callback',@(src,evts) MethodCallback(obj,src),'value',obj.method);
            
            obj.sparsity_txt=uicontrol('Parent',hp_method,'style','text','string','Sparsity','units','normalized','position',[0,0.1,0.2,0.3]);
            
            obj.sparsity_edit=uicontrol('parent',hp_method,'style','edit','string',num2str(obj.sparsity),'units','normalized',...
                'position',[0.2,0.05,0.2,0.4],'callback',@(src,evts) SparsityCallback(obj,src));
            
            obj.filter_number_txt=uicontrol('Parent',hp_method,'style','text','string','Filter Number','units','normalized','position',[0.45,0.1,0.3,0.3]);
            
            obj.filter_number_edit=uicontrol('parent',hp_method,'style','edit','string',num2str(obj.filter_number),'units','normalized',...
                'position',[0.75,0.05,0.2,0.4],'callback',@(src,evts) FilterNumberCallback(obj,src));
            
            hp_event1=uipanel('parent',hp,'units','normalized','Position',[0,0.8,1,0.09],'title','Event I');
            uicontrol('Parent',hp_event1,'Style','text','string','start (ms): ','units','normalized','position',[0.4,0.6,0.3,0.3],...
                'HorizontalAlignment','left');
            uicontrol('Parent',hp_event1,'Style','text','string','end (ms): ','units','normalized','position',[0.7,0.6,0.3,0.3],...
                'HorizontalAlignment','left');
            obj.event_popup1=uicontrol('Parent',hp_event1,'Style','popup','string',obj.event_list,'units','normalized','position',[0.01,0.1,0.35,0.5],...
                'callback',@(src,evts) EventCallback(obj,src));
            obj.ms_t_start_edit1=uicontrol('Parent',hp_event1,'Style','Edit','string',num2str(obj.ms_t_start1),'units','normalized','position',[0.4,0.1,0.29,0.5],...
                'HorizontalAlignment','left','callback',@(src,evts) MsCallback(obj,src));
            obj.ms_t_end_edit1=uicontrol('Parent',hp_event1,'Style','Edit','string',num2str(obj.ms_t_end1),'units','normalized','position',[0.7,0.1,0.29,0.5],...
                'HorizontalAlignment','left','callback',@(src,evts) MsCallback(obj,src));
            
            hp_event2=uipanel('parent',hp,'units','normalized','Position',[0,0.7,1,0.09],'title','Event II');
            uicontrol('Parent',hp_event2,'Style','text','string','start (ms): ','units','normalized','position',[0.4,0.6,0.3,0.3],...
                'HorizontalAlignment','left');
            uicontrol('Parent',hp_event2,'Style','text','string','end (ms): ','units','normalized','position',[0.7,0.6,0.3,0.3],...
                'HorizontalAlignment','left');
            obj.event_popup2=uicontrol('Parent',hp_event2,'Style','popup','string',obj.event_list,'units','normalized','position',[0.01,0.1,0.35,0.5],...
                'callback',@(src,evts) EventCallback(obj,src));
            obj.ms_t_start_edit2=uicontrol('Parent',hp_event2,'Style','Edit','string',num2str(obj.ms_t_start2),'units','normalized','position',[0.4,0.1,0.29,0.5],...
                'HorizontalAlignment','left','callback',@(src,evts) MsCallback(obj,src));
            obj.ms_t_end_edit2=uicontrol('Parent',hp_event2,'Style','Edit','string',num2str(obj.ms_t_end2),'units','normalized','position',[0.7,0.1,0.29,0.5],...
                'HorizontalAlignment','left','callback',@(src,evts) MsCallback(obj,src));
            
            hp_freq=uipanel('parent',hp,'title','Frequency','units','normalized','position',[0,0.59,1,0.1]);
            
            uicontrol('parent',hp_freq,'style','text','string','Min','units','normalized',...
                'position',[0,0.6,0.1,0.3]);
            uicontrol('parent',hp_freq,'style','text','string','Max','units','normalized',...
                'position',[0,0.1,0.1,0.3]);
            
            obj.low_freq_edit=uicontrol('parent',hp_freq,'style','edit','string',num2str(obj.low_freq),'units','normalized',...
                'position',[0.15,0.55,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) FreqCallback(obj,src));
            obj.low_freq_slider=uicontrol('parent',hp_freq,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) FreqCallback(obj,src),...
                'min',0,'max',obj.fs/2,'sliderstep',[0.005,0.02],'value',obj.low_freq);
            obj.high_freq_edit=uicontrol('parent',hp_freq,'style','edit','string',num2str(obj.high_freq),'units','normalized',...
                'position',[0.15,0.05,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) FreqCallback(obj,src));
            obj.high_freq_slider=uicontrol('parent',hp_freq,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) FreqCallback(obj,src),...
                'min',0,'max',obj.fs/2,'sliderstep',[0.005,0.02],'value',obj.high_freq);
            
            hp_max=uipanel('parent',hp,'title','Event I/Event II','units','normalized','position',[0,0.52,1,0.06]);
            
            obj.max_radio_btn=uicontrol('parent',hp_max,'style','radiobutton','string','Max RQ','units','normalized','position',[0.1,0.1,0.3,0.8],...
                'callback',@(src,evts) MaxMinCallback(obj,src),'value',obj.rq_max_);
            obj.min_radio_btn=uicontrol('parent',hp_max,'style','radiobutton','string','Min RQ','units','normalized','position',[0.6,0.1,0.3,0.8],...
                'callback',@(src,evts) MaxMinCallback(obj,src),'value',obj.rq_min_);
            
            
            
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.005,0.2,0.04],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.005,0.2,0.04],...
                'callback',@(src,evts) NewCallback(obj));
            
            MethodCallback(obj,obj.method_popup);
        end
        
        function MethodCallback(obj,src)
            obj.method_=get(src,'value');
            
            switch obj.method_
                case 1
                    %CSP
                    set(obj.sparsity_txt,'visible','off');
                    set(obj.sparsity_edit,'visible','off');
                    set(obj.filter_number_txt,'visible','off');
                    set(obj.filter_number_edit,'visible','off');
                case 2
                    %Sparse CSP
                    set(obj.sparsity_txt,'visible','on');
                    set(obj.sparsity_edit,'visible','on');
                    set(obj.filter_number_txt,'visible','on');
                    set(obj.filter_number_edit,'visible','on');
            end
            
        end
        
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
        end
        
        function UpdateEventList(obj)
            if ~isempty(obj.bsp.Evts)
                obj.event_list=unique(obj.bsp.Evts(:,2));
            end
        end
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
            end
        end
        
        function val=get.fs(obj)
            val=obj.bsp.SRate;
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
                set(obj.event_popup1,'value',1);
                set(obj.event_popup2,'value',1);
            end
            
            [ia,ib]=ismember(obj.event1,val);
            if ia
                if obj.valid
                    set(obj.event_popup1,'value',ib);
                end
            else
                obj.event1=val{1};
            end
            
            [ia,ib]=ismember(obj.event2,val);
            if ia
                if obj.valid
                    set(obj.event_popup2,'value',ib);
                end
            else
                obj.event2=val{1};
            end
        end
        
        
        
        function val=get.method(obj)
            val=obj.method_;
        end
        function set.method(obj,val)
            obj.method_=val;
        end
        
        function val=get.event1(obj)
            val=obj.event1_;
        end
        function set.event1(obj,val)
            if obj.valid
                [ia,ib]=ismember(val,obj.event_list);
                if ia
                    set(obj.event_popup1,'value',ib);
                else
                    set(obj.event_popup1,'value',1);
                    if ~isempty(obj.event_list)
                        val=obj.event_list{1};
                    else
                        val=[];
                    end
                end
            end
            obj.event1_=val;
        end
        
        function val=get.event2(obj)
            val=obj.event2_;
        end
        function set.event2(obj,val)
            if obj.valid
                [ia,ib]=ismember(val,obj.event_list);
                if ia
                    set(obj.event_popup2,'value',ib);
                else
                    set(obj.event_popup2,'value',1);
                    if ~isempty(obj.event_list)
                        val=obj.event_list{1};
                    else
                        val=[];
                    end
                end
            end
            obj.event2_=val;
        end
        
        function val=get.sparsity(obj)
            val=obj.sparsity_;
        end
        
        function set.sparsity(obj,val)
            if obj.valid
                set(obj.sparsity_edit,'string',num2str(val));
            end
            
            obj.sparsity_=val;
        end
        
        function val=get.filter_number(obj)
            val=obj.filter_number_;
        end
        
        function set.filter_number(obj,val)
            if obj.valid
                set(obj.filter_number_edit,'string',num2str(val));
            end
            
            obj.filter_number_=val;
        end
        
        function val=get.ms_t_start1(obj)
            val=obj.ms_t_start1_;
        end
        
        function set.ms_t_start1(obj,val)
            if obj.valid
                set(obj.ms_t_start_edit1,'string',num2str(val));
            end
            
            obj.ms_t_start1_=val;
        end
        
        function val=get.ms_t_start2(obj)
            val=obj.ms_t_start2_;
        end
        
        function set.ms_t_start2(obj,val)
            if obj.valid
                set(obj.ms_t_start_edit2,'string',num2str(val));
            end
            
            obj.ms_t_start2_=val;
        end
        
        function val=get.ms_t_end1(obj)
            val=obj.ms_t_end1_;
        end
        
        function set.ms_t_end1(obj,val)
            if obj.valid
                set(obj.ms_t_end_edit1,'string',num2str(val));
            end
            
            obj.ms_t_end1_=val;
        end
        
        function val=get.ms_t_end2(obj)
            val=obj.ms_t_end2_;
        end
        
        function set.ms_t_end2(obj,val)
            if obj.valid
                set(obj.ms_t_end_edit2,'string',num2str(val));
            end
            
            obj.ms_t_end2_=val;
        end
        
        function val=get.high_freq(obj)
            val=obj.high_freq_;
        end
        function set.high_freq(obj,val)
            if val>obj.fs/2
                val=obj.fs/2;
            elseif val<1
                val=1;
            end
            if obj.low_freq>=val
                obj.low_freq=val-1;
            end
            if obj.valid
                set(obj.high_freq_edit,'string',num2str(val));
                set(obj.high_freq_slider,'value',val);
            end
            obj.high_freq_=val;
        end
        
        function val=get.low_freq(obj)
            val=obj.low_freq_;
        end
        function set.low_freq(obj,val)
            if val<0
                val=0;
            elseif val>(obj.fs/2-1)
                val=obj.fs/2-1;
            end
            
            if obj.high_freq<=val
                obj.high_freq=val+1;
            end
            if obj.valid
                set(obj.low_freq_edit,'string',num2str(val));
                set(obj.low_freq_slider,'value',val);
            end
            obj.low_freq_=val;
        end
        
        function val=get.rq_max(obj)
            val=obj.rq_max_;
        end
        function set.rq_max(obj,val)
            obj.rq_max_=val;
            if obj.valid
                set(obj.max_radio_btn,'value',val);
            end
        end
        function val=get.rq_min(obj)
            val=obj.rq_min_;
        end
        function set.rq_min(obj,val)
            obj.rq_min_=val;
            if obj.valid
                set(obj.min_radio_btn,'value',val);
            end
        end
        
        function val=get.cnum(obj)
            %the channel number with valid positions
            [~,~,~,~,~,~,chanpos]=get_datainfo(obj.bsp,true);
            val=sum(~isnan(chanpos(:,1))&~isnan(chanpos(:,2)));
        end
        function SparsityCallback(obj,src)
            switch src
                case obj.sparsity_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.sparisty;
                    end
                    obj.sparsity=round(t);
            end
        end
        
        function MSCallback(obj,src)
            switch src
                case obj.ms_t_start_edit1
                    val=str2double(get(src,'string'));
                    if ~isnan(val)
                        obj.ms_t_start1=val;
                    end
                case obj.ms_t_end_edit1
                    val=str2double(get(src,'string'));
                    if ~isnan(val)
                        obj.ms_t_end1=val;
                    end
                case obj.ms_t_start_edit2
                    val=str2double(get(src,'string'));
                    if ~isnan(val)
                        obj.ms_t_start2=val;
                    end
                case obj.ms_t_end_edit2
                    val=str2double(get(src,'string'));
                    if ~isnan(val)
                        obj.ms_t_end2=val;
                    end
            end
        end
        
        function EventCallback(obj,src)
            switch src
                case obj.event_popup1
                    obj.event1_=obj.event_list{get(src,'value')};
                case obj.event_popup2
                    obj.event2_=obj.event_list{get(src,'value')};
            end
        end
        function FreqCallback(obj,src)
            switch src
                case obj.high_freq_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.high_freq;
                    end
                    obj.high_freq=round(t*10)/10;
                case obj.low_freq_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.low_freq;
                    end
                    obj.low_freq=round(t*10)/10;
                case obj.high_freq_slider
                    obj.high_freq=round(get(src,'value')*10)/10;
                case obj.low_freq_slider
                    obj.low_freq=round(get(src,'value')*10)/10;
            end
        end
        function FilterNumberCallback(obj,src)
            val=str2double(get(src,'string'));
            if ~isnan(val)
                obj.filter_number=max(1,round(val));
            end
        end
        function MaxMinCallback(obj,src)
            switch src
                case obj.max_radio_btn
                    obj.rq_max=get(src,'value');
                    obj.rq_min=~obj.rq_max;
                case obj.min_radio_btn
                    obj.rq_min=get(src,'value');
                    obj.rq_max=~obj.rq_min;
            end
        end
        
        function ComputeCallback(obj)
            %first event
            evt1=obj.event1;
            
            t_evt1=[obj.bsp.Evts{:,1}];
            txt_evt1=obj.bsp.Evts(:,2);
            
            ind=ismember(txt_evt1,evt1);
            t_label1=t_evt1(ind);
            txt_evt1=txt_evt1(ind);
            if isempty(t_label1)
                errordlg('Event not found !');
                return
            end
            i_event1=round(t_label1*obj.fs);
            i_event1=min(max(1,i_event1),obj.bsp.TotalSample);
            
            ind=(i_event1+nR)>obj.bsp.TotalSample;
            i_event1(ind)=[];
            txt_evt1(ind)=[];
            
            ind=(i_event1-nL)<1;
            i_event1(ind)=[];
            txt_evt1(ind)=[];
            %second event
            evt2=obj.event2;
            
            t_evt2=[obj.bsp.Evts{:,1}];
            txt_evt2=obj.bsp.Evts(:,2);
            
            ind=ismember(txt_evt2,evt2);
            t_label2=t_evt2(ind);
            txt_evt2=txt_evt2(ind);
            if isempty(t_label2)
                errordlg('Event not found !');
                return
            end
            i_event2=round(t_label2*obj.fs);
            i_event2=min(max(1,i_event2),obj.bsp.TotalSample);
            
            ind=(i_event2+nR)>obj.bsp.TotalSample;
            i_event2(ind)=[];
            txt_evt2(ind)=[];
            
            ind=(i_event2-nL)<1;
            i_event2(ind)=[];
            txt_evt2(ind)=[];
            
        end
        function NewCallback(obj)
        end
    end
    
end
