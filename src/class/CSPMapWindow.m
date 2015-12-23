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
        
        eig_ind%
        
        cov1
        cov2
        
        method_
        
        ms_t_start1_
        ms_t_end1_
        
        ms_t_start2_
        ms_t_end2_
        
        bsp
        fs_
        event_list_
        event1_
        event2_
        
        high_freq_
        low_freq_
    end
    
    properties(Dependent)
        fs
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
        
    end
    
    methods
        function obj=CSPMapWindow(bsp)
            obj.bsp=bsp;
            obj.fs=obj.bsp.SRate;
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
            
        end
        
        function buildfig(obj)
            
            if obj.valid
                figure(obj.fig);
                return
            end
            
            obj.fig=figure('MenuBar','none','Name','Common Spatial Pattern','units','pixels',...
                'Position',[500 100 300 700],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            
            hp=uipanel(obj.fig,'units','normalized','Position',[0,0,1,1]);
            hp_method=uipanel('parent',hp,'units','normalized','Position',[0,0.9,1,0.1],'title','Method');
            
            obj.method_popup=uicontrol('Parent',hp_method,'Style','popup',...
                'String',{'CSP','Sparse CSP'},'units','normalized','position',[0.01,0.6,0.59,0.35],...
                'Callback',@(src,evts) MethodCallback(obj,src),'value',obj.method);
            
            hp_event=uipanel('parent',hp,'units','normalized','Position',[0,0.8,1,0.1],'title','Events')
        end
        
        function MethodCallback(obj,src)
            obj.method_=get(src,'value');
            
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
            val=obj.fs_;
        end
        function set.fs(obj,val)
            obj.fs_=val;
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
    end
    
end
