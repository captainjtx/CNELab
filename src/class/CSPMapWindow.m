classdef CSPMapWindow < handle
    %CSPMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    properties
        fig
        
        method_popup
        
        event_popup1
        event_popup2
        
        low_freq_edit
        low_freq_slider
        
        high_freq_edit
        high_freq_slider
        
        sparsity_edit
        sparsity_txt
        sparsity_slider
        
        ms_t_start_edit1
        ms_t_end_edit1
        
        ms_t_start_edit2
        ms_t_end_edit2
        
        
        eig_ind%
        
        cov1
        cov2
        
        method_
        
        ms_t_start1_
        ms_t_end1_
        
        ms_t_start2_
        ms_t_end2_
        
        bsp
        event_list_
        event1_
        event2_
        
        high_freq_
        low_freq_
        
        sparsity_
        
        height
        width
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
            obj.low_freq_=0;
            obj.high_freq_=obj.fs/2;
        end
        
        function buildfig(obj)
            
            if obj.valid
                figure(obj.fig);
                return
            end
            
%             obj.width=300;
%             obj.height=700;
            varinitial(obj);
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
            
            
            obj.sparsity_slider=uicontrol('parent',hp_method,'style','slider','units','normalized',...
                'position',[0.45,0.1,0.5,0.3],'callback',@(src,evts) SparsityCallback(obj,src),...
                'min',1,'max',obj.cnum,'sliderstep',[0.005,0.02],'value',obj.sparsity_);
            
            hp_event1=uipanel('parent',hp,'units','normalized','Position',[0,0.8,1,0.09],'title','Event I');
            uicontrol('Parent',hp_event1,'Style','text','string','Before (ms): ','units','normalized','position',[0.4,0.6,0.3,0.3],...
                'HorizontalAlignment','left');
            uicontrol('Parent',hp_event1,'Style','text','string','After (ms): ','units','normalized','position',[0.7,0.6,0.3,0.3],...
                'HorizontalAlignment','left');
            obj.event_popup1=uicontrol('Parent',hp_event1,'Style','popup','string',obj.event_list,'units','normalized','position',[0.01,0.1,0.35,0.5],...
                'callback',@(src,evts) EventCallback(obj,src));
            obj.ms_t_start_edit1=uicontrol('Parent',hp_event1,'Style','Edit','string',num2str(obj.ms_t_start1),'units','normalized','position',[0.4,0.1,0.29,0.5],...
                'HorizontalAlignment','left','callback',@(src,evts) MsCallback(obj,src));
            obj.ms_t_end_edit1=uicontrol('Parent',hp_event1,'Style','Edit','string',num2str(obj.ms_t_end1),'units','normalized','position',[0.7,0.1,0.29,0.5],...
                'HorizontalAlignment','left','callback',@(src,evts) MsCallback(obj,src));
            
            hp_event2=uipanel('parent',hp,'units','normalized','Position',[0,0.7,1,0.09],'title','Event II');
            uicontrol('Parent',hp_event2,'Style','text','string','Before (ms): ','units','normalized','position',[0.4,0.6,0.3,0.3],...
                'HorizontalAlignment','left');
            uicontrol('Parent',hp_event2,'Style','text','string','After (ms): ','units','normalized','position',[0.7,0.6,0.3,0.3],...
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
            
            
            MethodCallback(obj,obj.method_popup);
        end
        
        function MethodCallback(obj,src)
            obj.method_=get(src,'value');
            
            switch obj.method_
                case 1
                    %CSP
                    set(obj.sparsity_txt,'visible','off');
                    set(obj.sparsity_edit,'visible','off');
                    set(obj.sparsity_slider,'visible','off');
                case 2
                    %Sparse CSP
                    set(obj.sparsity_txt,'visible','on');
                    set(obj.sparsity_edit,'visible','on');
                    set(obj.sparsity_slider,'visible','on');
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
                set(obj.sparsity_slider,'value',val);
            end
            
            obj.sparsity_=val;
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
        
        function val=get.cnum(obj)
            %the channel number with valid positions
            [~,~,~,~,~,~,chanpos]=get_selected_datainfo(obj.bsp,true);
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
                case obj.sparsity_slider
                    obj.sparsity=round(get(src,'value'));
            end
            
        end
        
        function MSCallback(obj,src)
        end
        
        function EventCallback(obj,src)
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
    end
    
end