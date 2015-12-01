classdef ExportSingleTrialWin<handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Dependent)
        ms_before
        ms_after
        event
        var
        valid
        event_list
    end
    properties
        bsp
        fig
        
        fs
        
        ms_before_edit
        ms_after_edit
        var_edit
        export_btn
        event_popup
        
        ms_before_
        ms_after_
        event_
        var_
        event_list_
    end
    
    methods
        function obj=ExportSingleTrialWin(bsp)
            obj.bsp=bsp;
            
            obj.fs=bsp.SRate;
            if ~isempty(bsp.Evts)
                obj.event_list_=unique(bsp.Evts(:,2));
            end
            varinitial(obj);
            
            addlistener(bsp,'EventListChange',@(src,evts)UpdateEventList(obj));
        end
        function UpdateEventList(obj)
            if ~isempty(obj.bsp.Evts)
                obj.event_list=unique(obj.bsp.Evts(:,2));
            end
        end
        
        function varinitial(obj)
            
            obj.ms_before_=1500;
            obj.ms_after_=1500;
            obj.event_='';
            
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
        
        
        
        function val=get.var(obj)
            val=obj.var_;
        end
        
        function set.var(obj,val)
            obj.var_=val;
            if obj.valid
                set(obj.var_edit,'string',val);
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
            obj.var=val;
        end
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
            end
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
        
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            
            obj.fig=figure('MenuBar','none','Name','Single Trial Export','units','pixels',...
                'Position',[500 100 200 180],'NumberTitle','off',...
                'Resize','off','CloseRequestFcn',@(src,evts) OnClose(obj),'DockControls','off');
            
            hp=uipanel('units','normalized','Position',[0,0.2,1,0.8]);
            
            uicontrol('Parent',hp,'Style','text','string','Before (ms): ','units','normalized',...
                'position',[0.01,0.5,0.5,0.2]);
            
            obj.ms_before_edit=uicontrol('Parent',hp,'Style','Edit','string',num2str(obj.ms_before),...
                'units','normalized','position',[0.5,0.55,0.45,0.15],'callback',@(src,evt) MSCallback(obj,src));
            
            uicontrol('parent',hp,'style','text','string','After (ms): ','units','normalized',...
                'position',[0.01,0.25,0.5,0.2]);
            
            obj.ms_after_edit=uicontrol('Parent',hp,'Style','Edit','string',num2str(obj.ms_after),...
                'units','normalized','position',[0.5,0.3,0.45,0.15],'callback',@(src,evt) MSCallback(obj,src));
            
            uicontrol('parent',hp,'style','text','string','Var Name: ','units','normalized',...
                'position',[0.01,0,0.5,0.2]);
            
            obj.var_edit=uicontrol('Parent',hp,'Style','Edit','string',obj.event,...
                'units','normalized','position',[0.5,0.05,0.45,0.15]);
            
            obj.export_btn=uicontrol('parent',obj.fig,'style','pushbutton','string','Export','units','normalized',...
                'position',[0.7,0.02,0.25,0.15],'callback',@(src,evt) ExportCallback(obj));
            
            
            uicontrol('Parent',hp,'Style','text','string','Event: ','units','normalized',...
                'position',[0.01,0.75,0.5,0.2]);
            
            %this has to be the last one
            obj.event_popup=uicontrol('Parent',hp,'Style','popup','string',obj.event_list,...
                'units','normalized','position',[0.5,0.75,0.45,0.2],'callback',@(src,evt)EventCallback(obj,src));
            
            obj.event=obj.event_;
        end
        
        function EventCallback(obj,src)
            obj.event=obj.event_list{get(src,'value')};
        end
        
        function ExportCallback(obj)
            t_evt=[obj.bsp.Evts{:,1}];
            t_label=t_evt(strcmpi(obj.bsp.Evts(:,2),obj.event));
            if isempty(t_label)
                errordlg(['Event: ',obj.event,' not found !']);
                return
            end
            
            nL=round(obj.ms_before*obj.fs/1000);
            
            nR=round(obj.ms_after*obj.fs/1000);
            
            i_event=round(t_label*obj.fs);
            i_event=min(max(1,i_event),obj.bsp.TotalSample);
            
            i_event((i_event+nR)>obj.bsp.TotalSample)=[];
            i_event((i_event-nL)<1)=[];
            
            [chanNames,~,channel,~,~,~,~]=get_selected_datainfo(obj.bsp,true);
            
            data=zeros(nL+nR+1,length(channel),length(i_event));
            
            sel=[];
            for i=1:length(i_event)
                sel=cat(2,sel,[i_event(i)-nL;i_event(i)+nR]);
            end
            [alldata,~,~,~,sample,~,~,~]=get_selected_data(obj.bsp,true,sel);
            
            for i=1:length(i_event)
                tmp_sel=i_event(i)-nL:i_event(i)+nR;
                data(:,:,i)=alldata(ismember(sample,tmp_sel),:);
            end
            
            output.channame=chanNames;
            output.data=data;
            output.event=obj.event;
            output.fs=obj.fs;
            output.ms_before=obj.ms_before;
            output.ms_after=obj.ms_after;
            
            assignin('base',obj.var,output);
            
        end
        
        function MSCallback(obj,src)
            switch src
                case obj.ms_before_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.ms_before;
                    end
                    obj.ms_before=t;
                case obj.ms_after_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.ms_after;
                    end
                    obj.ms_after=t;
            end
            
        end
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
        end
    end
    
end

