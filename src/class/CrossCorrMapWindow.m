classdef CrossCorrMapWindow < handle
    %CORRMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        valid
        fig
        env_radio
        raw_radio
        
        pos_radio
        pos_edit
        pos_slider
        
        multi_pos_radio
        multi_pos_edit
        
        neg_radio
        neg_edit
        neg_slider
        
        multi_neg_radio
        multi_neg_edit
        
        lag_edit
        lag_slider
        
        smw
        
        width
        height
        
        multi_pos_
        multi_pos_t_
        
        pos_
        pos_t_
        
        multi_neg_
        multi_neg_t_
        
        neg_
        neg_t_
        
        lag_t_
        
        env_
        raw_
    end
    
    properties(Dependent)
        env
        raw
        multi_pos
        multi_pos_t
        pos
        pos_t
        
        multi_neg
        multi_neg_t
        neg
        neg_t
        
        lag_t
    end
    
    methods
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isgraphics(obj.fig);
            catch
                val=0;
            end
        end
        
        function val=get.env(obj)
            val=obj.env_;
        end
        
        function set.env(obj,val)
            obj.env_=val;
            if obj.valid
                set(obj.env_radio,'value',obj.env_);
            end
        end
        
        function val=get.raw(obj)
            val=obj.raw_;
        end
        
        function set.raw(obj,val)
            obj.raw_=val;
            if obj.valid
                set(obj.raw_radio,'value',obj.raw_);
            end
        end
        
        function val=get.pos(obj)
            val=obj.pos_;
        end
        
        function set.pos(obj,val)
            obj.pos_=val;
            if obj.valid
                if obj.pos
                    set(obj.pos_edit,'enable','on');
                    set(obj.pos_slider,'enable','on');
                else
                    set(obj.pos_edit,'enable','off');
                    set(obj.pos_slider,'enable','off');
                end
                
                set(obj.pos_radio,'value',val);
            end
        end
        
        function val=get.multi_pos(obj)
            val=obj.multi_pos_;
        end
        
        function set.multi_pos(obj,val)
            obj.multi_pos_=val;
            if obj.valid
                if obj.multi_pos
                    set(obj.multi_pos_edit,'enable','on');
                else
                    set(obj.multi_pos_edit,'enable','off');
                end
                
                set(obj.multi_pos_radio,'value',val);
            end
        end
        
        function val=get.neg(obj)
            val=obj.neg_;
        end
        
        function set.neg(obj,val)
            obj.neg_=val;
            if obj.valid
                if obj.neg
                    set(obj.neg_edit,'enable','on');
                    set(obj.neg_slider,'enable','on');
                else
                    set(obj.neg_edit,'enable','off');
                    set(obj.neg_slider,'enable','off');
                end
                
                set(obj.neg_radio,'value',val);
            end
        end
        
        function val=get.multi_neg(obj)
            val=obj.multi_neg_;
        end
        
        function set.multi_neg(obj,val)
            obj.multi_neg_=val;
            if obj.valid
                if obj.multi_neg
                    set(obj.multi_neg_edit,'enable','on');
                else
                    set(obj.multi_neg_edit,'enable','off');
                end
                
                set(obj.multi_neg_radio,'value',val);
            end
        end
        
        function val=get.pos_t(obj)
            val=obj.pos_t_;
        end
        
        function set.pos_t(obj,val)
            
            obj.pos_t_=min(1,max(val,0));
            
            if obj.valid
                set(obj.pos_edit,'string',num2str(obj.pos_t));
                set(obj.pos_slider,'value',obj.pos_t);
            end
        end
        
        
        
        function val=get.multi_pos_t(obj)
            val=obj.multi_pos_t_;
        end
        
        function set.multi_pos_t(obj,val)
            
            obj.multi_pos_t_=min(1,max(val,0));
            
            if obj.valid
                set(obj.multi_pos_edit,'string',num2str(sort(obj.multi_pos_t)));
            end
        end
        
        function val=get.neg_t(obj)
            val=obj.neg_t_;
        end
        
        function set.neg_t(obj,val)
            
            obj.neg_t_=max(-1,min(val,0));
            
            if obj.valid
                set(obj.neg_edit,'string',num2str(obj.neg_t));
                set(obj.neg_slider,'value',obj.neg_t);
            end
        end
        
        function val=get.multi_neg_t(obj)
            val=obj.multi_neg_t_;
        end
        
        function set.multi_neg_t(obj,val)
            
            obj.multi_neg_t_=max(-1,min(val,0));
            
            if obj.valid
                set(obj.multi_neg_edit,'string',num2str(sort(obj.multi_neg_t,'descend')));
            end
        end
        
        function val=get.lag_t(obj)
            val=obj.lag_t_;
        end
        
        function set.lag_t(obj,val)
            
            obj.lag_t_=floor(max(val,0));
            
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
            
            obj.width=300;
            obj.height=270;
            
            obj.pos=0;
            obj.pos_t=0.5;
            
            obj.neg=0;
            obj.neg_t=-0.5;
            
            obj.multi_pos=0;
            obj.multi_pos_t=0.5;
            
            obj.multi_neg=0;
            obj.multi_neg_t=-0.5;
            
            obj.env_=0;
            obj.raw_=1;
            
            obj.lag_t=floor(obj.smw.act_len/1000*obj.smw.fs/2)-1;
        end
        
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.valid=1;
            
            figpos=get(obj.smw.fig,'Position');
            obj.fig=figure('MenuBar','none','Name','Cross Correlation Analysis','units','pixels',...
                'Position',[figpos(1)+figpos(3),figpos(2)+figpos(4)-obj.height,obj.width,obj.height],'NumberTitle','off',...
                'CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off');
            
            enp=uipanel('parent',obj.fig,'units','normalized','Position',[0,230/obj.height,1,1-230/obj.height]);
            obj.raw_radio=uicontrol('parent',enp,'style','radiobutton','string','Raw data','units','normalized',...
                'position',[0,0.2,0.5,0.6],'Callback',@(src,evts) RawEnvCallback(obj,src),'value',obj.raw_);
            
            obj.env_radio=uicontrol('parent',enp,'style','radiobutton','string','Envelope','units','normalized',...
                'position',[0.5,0.2,0.5,0.6],'Callback',@(src,evts) RawEnvCallback(obj,src),'value',obj.env_);
            
            
            hp=uipanel('parent',obj.fig,'units','normalized','Position',[0,0,1,230/obj.height]);
            
            corrp=uipanel('parent',hp,'units','normalized','position',[0,0.22,1,0.78]);
            obj.pos_radio=uicontrol('parent',corrp,'style','radiobutton','string','++ Threshold:','units','normalized',...
                'position',[0,0.75,0.35,0.15],'value',obj.pos,'callback',@(src,evts) CorrCallback(obj,src),'fontsize',10);
            obj.pos_edit=uicontrol('parent',corrp,'style','edit','string',num2str(obj.pos_t),'units','normalized',...
                'position',[0.35,0.75,0.13,0.15],'horizontalalignment','center','callback',@(src,evts) CorrCallback(obj,src));
            obj.pos_slider=uicontrol('parent',corrp,'style','slider','units','normalized',...
                'position',[0.5,0.72,0.45,0.15],'callback',@(src,evts) CorrCallback(obj,src),...
                'min',0,'max',1,'value',obj.pos_t,'sliderstep',[0.01,0.05]);
            
            obj.multi_pos_radio=uicontrol('parent',corrp,'style','radiobutton','string','Multi Threshold:','units','normalized',...
                'position',[0,0.55,0.35,0.15],'value',obj.multi_pos,'callback',@(src,evts) CorrCallback(obj,src),'fontsize',10);
            obj.multi_pos_edit=uicontrol('parent',corrp,'style','edit','string',num2str(obj.multi_pos_t),'units','normalized',...
                'position',[0.35,0.55,0.6,0.15],'horizontalalignment','center','callback',@(src,evts) CorrCallback(obj,src));
            
            
            obj.neg_radio=uicontrol('parent',corrp,'style','radiobutton','string','--- Threshold:','units','normalized',...
                'position',[0,0.25,0.35,0.15],'value',obj.neg,'callback',@(src,evts) CorrCallback(obj,src),'fontsize',10);
            obj.neg_edit=uicontrol('parent',corrp,'style','edit','string',num2str(obj.neg_t),'units','normalized',...
                'position',[0.35,0.25,0.13,0.15],'horizontalalignment','center','callback',@(src,evts) CorrCallback(obj,src));
            obj.neg_slider=uicontrol('parent',corrp,'style','slider','units','normalized',...
                'position',[0.5,0.22,0.45,0.15],'callback',@(src,evts) CorrCallback(obj,src),...
                'min',-1,'max',0,'value',obj.neg_t,'sliderstep',[0.01,0.05]);
            
            obj.multi_neg_radio=uicontrol('parent',corrp,'style','radiobutton','string','Multi Threshold:','units','normalized',...
                'position',[0,0.05,0.35,0.15],'value',obj.multi_neg,'callback',@(src,evts) CorrCallback(obj,src),'fontsize',10);
            obj.multi_neg_edit=uicontrol('parent',corrp,'style','edit','string',num2str(obj.multi_neg_t),'units','normalized',...
                'position',[0.35,0.05,0.6,0.15],'horizontalalignment','center','callback',@(src,evts) CorrCallback(obj,src));
            
            lagp=uipanel('parent',hp,'units','normalized','position',[0,0,1,0.22]);
            uicontrol('parent',lagp,'style','text','string','Max Lag (sample): ','units','normalized',...
                'position',[0,0.25,0.35,0.5],'fontsize',10);
            obj.lag_edit=uicontrol('parent',lagp,'style','edit','string',num2str(obj.lag_t),'units','normalized',...
                'position',[0.35,0.25,0.13,0.5],'horizontalalignment','center','callback',@(src,evts) CorrCallback(obj,src));
            obj.lag_slider=uicontrol('parent',lagp,'style','slider','units','normalized',...
                'position',[0.5,0.25,0.45,0.5],'callback',@(src,evts) CorrCallback(obj,src),...
                'min',0,'max',floor(obj.smw.act_len/1000*obj.smw.fs)-1,'value',obj.lag_t,'sliderstep',[0.01,0.05]);
            
            
            obj.pos=obj.pos_;
            obj.multi_pos=obj.multi_pos_;
            
            obj.neg=obj.neg_;
            obj.multi_neg=obj.multi_neg_;
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
                case obj.raw_radio
                    needupdate=true;
                case obj.env_radio
                    needupdate=true;
                case obj.pos_radio
                    if obj.pos||obj.neg||obj.multi_pos||obj.multi_neg
                        needupdate=false;
                    else
                        needupdate=true;
                    end
                    obj.pos=get(src,'value');
                    
                    obj.multi_pos=0;
                case obj.pos_edit
                    needupdate=false;
                    tmp=str2double(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    
                    obj.pos_t=tmp;
                    
                case obj.pos_slider
                    needupdate=false;
                    obj.pos_t=get(src,'value');
                case obj.multi_pos_radio
                    obj.multi_pos=get(src,'value');
                    
                    if obj.multi_pos&&~obj.pos
                        needupdate=true;
                    else
                        needupdate=false;
                    end
                    
                    obj.pos=0;
                case obj.multi_pos_edit
                    
                    needupdate=false;
                    tmp=str2num(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    
                    obj.multi_pos_t=tmp;
                case obj.neg_radio
                    if obj.pos||obj.neg||obj.multi_pos||obj.multi_neg
                        needupdate=false;
                    else
                        needupdate=true;
                    end
                    obj.neg=get(src,'value');
                    
                    obj.multi_neg=0;
                    
                case obj.neg_edit
                    needupdate=false;
                    tmp=str2double(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    
                    obj.neg_t=tmp;
                case obj.neg_slider
                    needupdate=false;
                    obj.neg_t=get(src,'value');
                case obj.multi_neg_radio
                    obj.multi_neg=get(src,'value');
                    
                    if obj.multi_neg&&~obj.neg
                        needupdate=true;
                    else
                        needupdate=false;
                    end
                    
                    obj.neg=0;
                case obj.multi_neg_edit
                    
                    needupdate=false;
                    tmp=str2num(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    
                    obj.multi_neg_t=tmp;
                case obj.lag_edit
                    if obj.pos||obj.neg||obj.multi_pos||obj.multi_neg
                        needupdate=true;
                    else
                        needupdate=false;
                    end
                    
                    tmp=str2double(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    
                    obj.lag_t=floor(tmp);
                case obj.lag_slider
                    if obj.pos||obj.neg||obj.multi_pos||obj.multi_neg
                        needupdate=true;
                    else
                        needupdate=false;
                    end
                    obj.lag_t=floor(get(src,'value'));
            end
            
            if obj.smw.auto_refresh
                chanpos=[obj.smw.pos_x,obj.smw.pos_y,obj.smw.radius];
                if ~obj.smw.NoSpatialMapFig()
                    if needupdate
                        obj.Update();
                    end
                    
                    for i=1:length(obj.smw.SpatialMapFig)
                        h=findobj(obj.smw.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                        if ~isempty(h)
                            delete(findobj(h,'tag','xcorr'));
                            if obj.pos
                                tmp_pos_t=obj.pos_t;
                            elseif obj.multi_pos
                                tmp_pos_t=obj.multi_pos_t;
                            else
                                tmp_pos_t=[];
                            end
                            
                            if obj.neg
                                tmp_neg_t=obj.neg_t;
                            elseif obj.multi_neg
                                tmp_neg_t=obj.multi_neg_t;
                            else
                                tmp_neg_t=[];
                            end
                            
                            if obj.neg||obj.pos||obj.multi_neg||obj.multi_pos
                                plot_xcorrelation(h,round(chanpos(:,1)*obj.smw.width),round(chanpos(:,2)*obj.smw.height),...
                                    obj.pos||obj.multi_pos,obj.neg||obj.multi_neg,...
                                    obj.smw.tfmat(i).xcorr_matrix,tmp_pos_t,tmp_neg_t);
                            end
                        end
                    end
                end
            end
        end
        function Update(obj)
            t1=round((obj.smw.act_start+obj.smw.ms_before)/1000*obj.smw.fs);
            t2=t1+round(obj.smw.act_len/1000*obj.smw.fs);
            
            movements=length(obj.smw.tfmat);
            for i=1:movements
                %different movement
                
                event=obj.smw.tfmat(i).event;
                wait_bar=waitbar(0,['Computing cross correlations for ',event]);
                
                tf=obj.smw.tfmat(i);
                trial_num=size(tf.data,3);
                move_data=[];
                for trial=1:trial_num
                    
                    dt=tf.data(:,:,trial);
                    %filtering the data
                    w1=obj.smw.min_freq/obj.smw.fs*2;
                    w2=obj.smw.max_freq/obj.smw.fs*2;
                    
                    
                    if w1<=0&&w2>0&&w2<1
                        [b,a]=butter(2,w2,'low');
                        fdata=filter_symmetric(b,a,dt,obj.smw.fs,0,'iir');
                    elseif w2>=1&&w1>0&&w1<1
                        [b,a]=butter(2,w1,'high');
                        fdata=filter_symmetric(b,a,dt,obj.smw.fs,0,'iir');
                    elseif w1==0&&w2==1
                        fdata=dt;
                    else
                        [b,a]=butter(2,[w1,w2],'bandpass');
                        fdata=filter_symmetric(b,a,dt,obj.smw.fs,0,'iir');
                    end
                    %******************************************************
                    
                    t_start=min(t1,size(fdata,1));
                    t_end=min(t2,size(fdata,1));
                    move_data=cat(1,move_data,fdata(max(1,t_start):t_end,:));
                    
                end
                
                corr=zeros(size(move_data,2),size(move_data,2),2*obj.lag_t+1);
                chan_num=size(move_data,2);
                
                for m=1:chan_num
                    waitbar(m/chan_num,wait_bar,event);
                    for n=1:chan_num
                        if obj.raw
                            [tmp_corr,lags]=xcorr(move_data(:,m),move_data(:,n),obj.lag_t,'coef');
                        elseif obj.env
                            [tmp_corr,lags]=xcorr(detrend(abs(hilbert(move_data(:,m))),'constant'),...
                                detrend(abs(hilbert(move_data(:,n))),'constant'),obj.lag_t,'coef');
                        end
                        corr(m,n,:)=tmp_corr;
                    end
                end
                
                [~,max_lag]=max(abs(corr),[],3);
                
                tmp_xcorr=zeros(size(corr,1),size(corr,2));
                for k=1:size(corr,1)
                    for l=1:size(corr,2)
                        tmp_xcorr(k,l)=corr(k,l,max_lag(k,l));
                    end
                end
                obj.smw.tfmat(i).xcorr_matrix=tmp_xcorr;
                obj.smw.tfmat(i).max_lag=lags(max_lag);
                close(wait_bar)
            end
        end
        
        function RawEnvCallback(obj,src)
            needupdate=get(obj.raw_radio,'value')||get(obj.env_radio,'value');
            switch src
                case obj.raw_radio
                    obj.raw=1;
                    obj.env=0;
                case obj.env_radio
                    obj.env=1;
                    obj.raw=0;
            end
            if needupdate
                CorrCallback(obj,src);
            end
        end
    end
    
end

