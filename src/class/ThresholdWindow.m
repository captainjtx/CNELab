classdef ThresholdWindow <handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        valid
        smw
        width
        height
        fig
        
        pos_radio
        pos_edit
        pos_slider
        
        neg_radio
        neg_edit
        neg_slider
        
        neg_t
        pos_t
        
        pos_
        neg_
    end
    properties (Dependent)
        pos
        neg
    end
    
    methods
        function obj=ThresholdWindow(smw)
            obj.valid=0;
            obj.smw=smw;
            obj.width=300;
            obj.height=100;
            
            obj.neg_=0;
            obj.pos_=0;
            obj.neg_t=1;
            obj.pos_t=1;
        end
        
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            
            figpos=get(obj.smw.fig,'Position');
            obj.fig=figure('MenuBar','none','Name','Thresholding','units','pixels',...
                'Position',[figpos(1)+figpos(3),figpos(2)+figpos(4)-obj.height,obj.width,obj.height],'NumberTitle','off',...
                'CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            
            hp=uipanel('parent',obj.fig,'units','normalized','Position',[0,0,1,1]);
            
            obj.pos_radio=uicontrol('parent',hp,'style','radiobutton','string','++ :','units','normalized',...
                'position',[0,0.55,0.15,0.4],'value',obj.pos,'callback',@(src,evts) TCallback(obj,src),'fontsize',10);
            obj.pos_edit=uicontrol('parent',hp,'style','edit','string',num2str(obj.pos_t),'units','normalized',...
                'position',[0.2,0.6,0.2,0.3],'horizontalalignment','center','callback',@(src,evts) TCallback(obj,src));
            obj.pos_slider=uicontrol('parent',hp,'style','slider','units','normalized',...
                'position',[0.45,0.65,0.5,0.2],'callback',@(src,evts) TCallback(obj,src),...
                'min',0,'max',1,'value',obj.pos_t,'sliderstep',[0.01,0.05]);
            
            obj.neg_radio=uicontrol('parent',hp,'style','radiobutton','string','--- :','units','normalized',...
                'position',[0,0.05,0.15,0.4],'value',obj.neg,'callback',@(src,evts) TCallback(obj,src),'fontsize',10);
            obj.neg_edit=uicontrol('parent',hp,'style','edit','string',num2str(obj.neg_t),'units','normalized',...
                'position',[0.2,0.1,0.2,0.3],'horizontalalignment','center','callback',@(src,evts) TCallback(obj,src));
            obj.neg_slider=uicontrol('parent',hp,'style','slider','units','normalized',...
                'position',[0.45,0.15,0.5,0.2],'callback',@(src,evts) TCallback(obj,src),...
                'min',0,'max',1,'value',obj.neg_t,'sliderstep',[0.01,0.05]);
            
            obj.pos=obj.pos_;
            obj.neg=obj.neg_;
        end
        
        function val=get.pos(obj)
            val=obj.pos_;
        end
        
        function set.pos(obj,val)
            obj.pos_=val;
            if obj.pos
                set(obj.pos_edit,'enable','on');
                set(obj.pos_slider,'enable','on');
            else
                set(obj.pos_edit,'enable','off');
                set(obj.pos_slider,'enable','off');
            end
        end
        
        
        
        function val=get.neg(obj)
            val=obj.neg_;
        end
        
        function set.neg(obj,val)
            obj.neg_=val;
            if obj.neg
                set(obj.neg_edit,'enable','on');
                set(obj.neg_slider,'enable','on');
            else
                set(obj.neg_edit,'enable','off');
                set(obj.neg_slider,'enable','off');
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
        function TCallback(obj,src)
            switch src
                case obj.pos_radio
                    obj.pos=get(src,'value');
                case obj.neg_radio
                    obj.neg=get(src,'value');
                case obj.pos_edit
                    val=str2double(get(src,'string'));
                    if isnan(val)
                        val=obj.pos_t;
                    end
                    val=max(0,min(val,1));
                    
                    set(src,'string',num2str(val));
                    set(obj.pos_slider,'value',val);
                    obj.pos_t=val;
                case obj.neg_edit
                    val=str2double(get(src,'string'));
                    if isnan(val)
                        val=obj.neg_t;
                    end
                    val=max(0,min(val,1));
                    
                    set(src,'string',num2str(val));
                    set(obj.neg_slider,'value',val);
                    obj.neg_t=val;
                    
                case obj.pos_slider
                    val=get(src,'value');
                    set(obj.pos_edit,'string',num2str(val));
                    obj.pos_t=val;
                case obj.neg_slider
                    val=get(src,'value');
                    set(obj.neg_edit,'string',num2str(val));
                    obj.neg_t=val;
            end
            
            obj.smw.UpdateFigure(src);
        end
    end
    
end

