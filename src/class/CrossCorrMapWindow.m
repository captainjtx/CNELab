classdef CrossCorrMapWindow < handle
    %CORRMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        valid
        fig
        
        t_radio
        t_edit
        t_slider
        
        lag_radio
        lag_edit
        lag_slider
        
        smw
        
        width
        height
        
        t_
        t_t_
        
        lag_
        lag_t_
    end
    
    properties(Dependent)
        t
        t_t
        
        lag
        lag_t
    end
    
    methods
        
        function val=get.t(obj)
            val=obj.t_;
        end
        
        function set.t(obj,val)
            obj.t_=val;
            if obj.valid
                if obj.t
                    set(obj.t_edit,'enable','on');
                    set(obj.t_slider,'enable','on');
                    set(obj.lag_radio,'enable','on');
                    obj.lag=obj.lag_;
                else
                    set(obj.t_edit,'enable','off');
                    set(obj.t_slider,'enable','off');
                    
                    set(obj.lag_radio,'enable','off');
                    
                    set(obj.lag_edit,'enable','off');
                    set(obj.lag_slider,'enable','off');
                end
            end
        end
        
        function val=get.lag(obj)
            val=obj.lag_;
        end
        
        function set.lag(obj,val)
            obj.lag_=val;
            if obj.valid
                if obj.lag
                    set(obj.lag_edit,'enable','on');
                    set(obj.lag_slider,'enable','on');
                else
                    set(obj.lag_edit,'enable','off');
                    set(obj.lag_slider,'enable','off');
                end
            end
        end
        
        function val=get.t_t(obj)
            val=obj.t_t_;
        end
        
        function set.t_t(obj,val)
            
            obj.t_t_=min(1,max(val,0));
            
            if obj.valid
                set(obj.t_edit,'string',num2str(obj.t_t));
                set(obj.t_slider,'value',obj.t_t);
            end
        end
        
        function val=get.lag_t(obj)
            val=obj.lag_t_;
        end
        
        function set.lag_t(obj,val)
            
            obj.lag_t_=max(val,0);
            
            if obj.valid
                set(obj.lag_edit,'string',num2str(obj.lag_t));
                set(obj.lag_slider,'value',obj.lag_t);
            end
        end
    end
    
    methods
        function obj=CrossCorrMapWindow(smw)%spatial map window
            obj.valid=0;
            obj.smw=smw;
            obj.width=350;
            obj.height=80;
            
            
            obj.t=0;
            obj.t_t=0.5;
            
            obj.lag=0;
            obj.lag_t=floor(obj.smw.act_len/1000*obj.smw.fs/2)-1;
        end
        
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.valid=1;
            
            figpos=get(obj.smw.fig,'Position');
            obj.fig=figure('MenuBar','none','Name','Correlation Analysis','units','pixels',...
                'Position',[figpos(1)+figpos(3),figpos(2)+figpos(4)-obj.height,obj.width,obj.height],'NumberTitle','off',...
                'CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            
            hp=uipanel('parent',obj.fig,'units','normalized','Position',[0,0,1,1]);
            
            obj.t_radio=uicontrol('parent',hp,'style','radiobutton','string','Threshould: ','units','normalized',...
                'position',[0,0.6,0.3,0.3],'value',obj.t,'callback',@(src,evts) CorrCallback(obj,src),'fontsize',10);
            obj.lag_radio=uicontrol('parent',hp,'style','radiobutton','string','Max Lag (point): ','units','normalized',...
                'position',[0,0.1,0.3,0.3],'value',obj.lag,'callback',@(src,evts) CorrCallback(obj,src),'fontsize',10);
            obj.t_edit=uicontrol('parent',hp,'style','edit','string',num2str(obj.t_t),'units','normalized',...
                'position',[0.3,0.6,0.18,0.3],'horizontalalignment','center','callback',@(src,evts) CorrCallback(obj,src));
            obj.t_slider=uicontrol('parent',hp,'style','slider','units','normalized',...
                'position',[0.5,0.6,0.45,0.3],'callback',@(src,evts) CorrCallback(obj,src),...
                'min',0,'max',1,'value',obj.t_t,'sliderstep',[0.01,0.05]);
            obj.lag_edit=uicontrol('parent',hp,'style','edit','string',num2str(obj.lag_t),'units','normalized',...
                'position',[0.3,0.1,0.18,0.3],'horizontalalignment','center','callback',@(src,evts) CorrCallback(obj,src));
            obj.lag_slider=uicontrol('parent',hp,'style','slider','units','normalized',...
                'position',[0.5,0.1,0.45,0.3],'callback',@(src,evts) CorrCallback(obj,src),...
                'min',0,'max',floor(obj.smw.act_len/1000*obj.smw.fs)-1,'value',obj.lag_t,'sliderstep',[0.01,0.05]);
            
            obj.t=obj.t_;
            obj.lag=obj.lag_;
            
        end
        
        function OnClose(obj)
            obj.valid=0;
            
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
        end
        
        function CorrCallback(obj,src)
            switch src
                case obj.t_radio
                    
                    obj.t=get(src,'value');
                    if obj.t
                        need_update=true;
                    else
                        need_update=false;
                    end
                case obj.t_edit
                    need_update=false;
                    tmp=str2double(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    
                    obj.t_t=tmp;
                    
                case obj.t_slider
                    need_update=false;
                    obj.t_t=get(src,'value');
                case obj.lag_radio
                    need_update=true;
                    obj.lag=get(src,'value');
                case obj.lag_edit
                    need_update=true;
                    tmp=str2double(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    
                    obj.lag_t=tmp;
                case obj.lag_slider
                    need_update=true;
                    obj.lag_t=get(src,'value');
            end
            
            if obj.smw.auto_refresh
                chanpos=[obj.smw.pos_x,obj.smw.pos_y,obj.smw.radius];
                if ~obj.smw.NoSpatialMapFig()
                    for i=1:length(obj.smw.SpatialMapFig)
                        h=findobj(obj.smw.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                        if ~isempty(h)
                            delete(findobj(h,'-regexp','tag','xcorr'));
                            if obj.t
                                if need_update
                                    obj.UpdateCrossCorrelation();
                                end
                                plot_xcorrelation(h,round(chanpos(:,1)*obj.smw.width),round(chanpos(:,2)*obj.smw.height),...
                                    obj.t,obj.smw.tfmat(i).xcorr_matrix,obj.t_t);
                            end
                        end
                    end
                end
            end
        end
        function UpdateCrossCorrelation(obj)
            t1=round(obj.smw.act_start/1000*obj.smw.fs);
            t2=t1+round(obj.smw.act_len/1000*obj.smw.fs);
            
            movements=length(obj.smw.tfmat);
            for i=1:movements
                %different movement
                wait_bar=waitbar(0,['Computing cross correlations for ',obj.smw.event_group{i}]);
                
                corr_matrix=0;
                tf=obj.smw.tfmat(i);
                trial_num=size(tf.data,3);
                for trial=1:trial_num
                    
                    if ~ishandle(wait_bar)||~isvalid(wait_bar)
                        return
                    end
                    [b,a]=butter(2,[obj.smw.min_freq,obj.smw.max_freq]/(obj.smw.fs/2));
                    dt=tf.data(:,:,trial);
                    fdata=filter_symmetric(b,a,dt,obj.smw.fs,0,'iir');
                    
                    t_start=min(t1,size(fdata,1));
                    t_end=min(t2,size(fdata,1));
                    move_data=fdata(t_start:t_end,:);
                    corr=zeros(size(move_data,2),size(move_data,2));
                    
                    chan_num=size(move_data,2);
                    for m=1:chan_num
                        for n=1:chan_num
                            tmp=chan_num*chan_num-chan_num;
                            waitbar(((trial-1)*tmp+(m-1)*(chan_num-1)+n)/(trial_num*tmp),wait_bar,...
                                [obj.smw.event_group{i},' : Trial ',num2str(trial),' Channel ',num2str(m)]);
                            if n~=m
                                if obj.lag
                                    [tmp_corr,~]=xcorr(move_data(:,m),move_data(:,n),obj.lag_t,'coef');
                                else
                                    [tmp_corr,~]=xcorr(move_data(:,m),move_data(:,n),'coef');
                                end
                                corr(m,n)=max(tmp_corr);
                            end
                        end
                    end
                    
                    corr_matrix=corr_matrix+corr;
                end
                obj.smw.tfmat(i).xcorr_matrix=corr_matrix/trial_num;
                close(wait_bar)
            end
        end
    end
    
end

