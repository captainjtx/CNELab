classdef CorrMapWindow < handle
    %CORRMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        valid
        fig
        
        sig_radio
        sig_edit
        sig_slider
        
        pos_radio
        pos_edit
        pos_slider
        
        neg_radio
        neg_edit
        neg_slider
        
        smw
        
        width
        height
        
        sig_
        sig_t_
        
        pos_
        pos_t_
        
        neg_
        neg_t_
    end
    
    properties(Dependent)
        sig
        sig_t
        
        pos
        pos_t
        
        neg
        neg_t
    end
    
    methods
        function val=get.sig(obj)
            val=obj.sig_;
        end
        
        function set.sig(obj,val)
            obj.sig_=val;
            if obj.valid
                if obj.sig
                    set(obj.sig_edit,'enable','on');
                    set(obj.sig_slider,'enable','on');
                    
                else
                    set(obj.sig_edit,'enable','off');
                    set(obj.sig_slider,'enable','off');
                end
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
            end
        end
        
        function val=get.sig_t(obj)
            val=obj.sig_t_;
        end
        
        function set.sig_t(obj,val)
            
            obj.sig_t_=min(1,max(val,0));
            
            if obj.valid
                set(obj.sig_edit,'string',num2str(obj.sig_t));
                set(obj.sig_slider,'value',obj.sig_t);
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
    end
    
    methods
        function obj=CorrMapWindow(smw)%spatial map window
            obj.valid=0;
            obj.smw=smw;
            obj.width=300;
            obj.height=140;
            obj.sig=0;
            obj.sig_t=0.05;
            
            obj.pos=0;
            obj.pos_t=0.5;
            
            obj.neg=0;
            obj.neg_t=-0.5;
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
            
            sigp=uipanel('parent',hp,'units','normalized','position',[0,0,1,0.35],'title','Significant Network');
            obj.sig_radio=uicontrol('parent',sigp,'style','radiobutton','string','P-Val','units','normalized',...
                'position',[0,0.1,0.18,0.8],'value',obj.sig,'callback',@(src,evts) CorrCallback(obj,src));
            obj.sig_edit=uicontrol('parent',sigp,'style','edit','string',num2str(obj.sig_t),'units','normalized',...
                'position',[0.2,0.2,0.15,0.6],'horizontalalignment','center','callback',@(src,evts) CorrCallback(obj,src));
            obj.sig_slider=uicontrol('parent',sigp,'style','slider','units','normalized',...
                'position',[0.4,0.2,0.55,0.6],'callback',@(src,evts) CorrCallback(obj,src),...
                'min',0,'max',1,'value',obj.sig_t,'sliderstep',[0.01,0.05]);
            
            
            corrp=uipanel('parent',hp,'units','normalized','position',[0,0.4,1,0.55],'title','Correlation NetWork');
            obj.pos_radio=uicontrol('parent',corrp,'style','radiobutton','string','++','units','normalized',...
                'position',[0,0.6,0.18,0.3],'value',obj.pos,'callback',@(src,evts) CorrCallback(obj,src),'fontsize',12);
            obj.neg_radio=uicontrol('parent',corrp,'style','radiobutton','string','---','units','normalized',...
                'position',[0,0.1,0.18,0.3],'value',obj.neg,'callback',@(src,evts) CorrCallback(obj,src),'fontsize',12);
            obj.pos_edit=uicontrol('parent',corrp,'style','edit','string',num2str(obj.pos_t),'units','normalized',...
                'position',[0.2,0.6,0.15,0.3],'horizontalalignment','center','callback',@(src,evts) CorrCallback(obj,src));
            obj.pos_slider=uicontrol('parent',corrp,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) CorrCallback(obj,src),...
                'min',0,'max',1,'value',obj.pos_t,'sliderstep',[0.01,0.05]);
            obj.neg_edit=uicontrol('parent',corrp,'style','edit','string',num2str(obj.neg_t),'units','normalized',...
                'position',[0.2,0.1,0.15,0.3],'horizontalalignment','center','callback',@(src,evts) CorrCallback(obj,src));
            obj.neg_slider=uicontrol('parent',corrp,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) CorrCallback(obj,src),...
                'min',-1,'max',0,'value',obj.neg_t,'sliderstep',[0.01,0.05]);
            
            obj.sig=obj.sig_;
            obj.pos=obj.pos_;
            obj.neg=obj.neg_;
            
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
                case obj.pos_radio
                    if obj.pos||obj.neg||obj.sig
                        needupdate=false;
                    else
                        needupdate=true;
                    end
                    obj.pos=get(src,'value');
                    
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
                case obj.neg_radio
                    if obj.pos||obj.neg||obj.sig
                        needupdate=false;
                    else
                        needupdate=true;
                    end
                    obj.neg=get(src,'value');
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
                    
                case obj.sig_radio
                    
                    if obj.pos||obj.neg||obj.sig
                        needupdate=false;
                    else
                        needupdate=true;
                    end
                    obj.sig=get(src,'value');
                case obj.sig_edit
                    needupdate=false;
                    tmp=str2double(get(src,'string'));
                    if isnan(tmp)
                        return
                    end
                    
                    obj.sig_t=tmp;
                    
                case obj.sig_slider
                    needupdate=false;
                    obj.sig_t=get(src,'value');
            end
            
            chanpos=[obj.smw.pos_x,obj.smw.pos_y,obj.smw.radius];
            if ~obj.smw.NoSpatialMapFig()
                for i=1:length(obj.smw.SpatialMapFig)
                    h=findobj(obj.smw.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                    if ~isempty(h)
                        
                        delete(findobj(h,'-regexp','tag','corr'));
                        if obj.pos||obj.neg||obj.sig
                            % correlation
                            if needupdate
                                obj.UpdateCorrelation();
                            end
                            plot_correlation(h,round(chanpos(:,1)*obj.smw.width),round(chanpos(:,2)*obj.smw.height),...
                                obj.pos,obj.neg,obj.sig,...
                                obj.smw.tfmat(i).corr_matrix,obj.pos_t,obj.neg_t,...
                                obj.smw.tfmat(i).p_matrix,obj.sig_t);
                        end
                    end
                end
            end
        end
        
        function UpdateCorrelation(obj)
            t1=round(obj.smw.act_start/1000*obj.smw.fs);
            t2=t1+round(obj.smw.act_len/1000*obj.smw.fs);
            for i=1:length(obj.smw.tfmat)
                %different movement
                
                corr_matrix=0;
                p_matrix=0;
                tf=obj.smw.tfmat(i);
                for trial=1:size(tf.data,3)
                    [b,a]=butter(2,[obj.smw.min_freq,obj.smw.max_freq]/(obj.smw.fs/2));
                    dt=tf.data(:,:,trial);
                    fdata=filter_symmetric(b,a,dt,obj.smw.fs,0,'iir');
                    
                    t_start=min(t1,size(fdata,1));
                    t_end=min(t2,size(fdata,1));
                    move_data=fdata(t_start:t_end,:);
                    [corr,pval]=corrcoef(move_data);
                    
                    corr_matrix=corr_matrix+corr;
                    p_matrix=p_matrix+pval;
                end
                
                obj.smw.tfmat(i).corr_matrix=corr_matrix/size(tf.data,3);
                %Bonferroni's correction
                K=size(tf.data,2)*(size(tf.data,2)-1)/2;
                obj.smw.tfmat(i).p_matrix=p_matrix/size(tf.data,3)*K;
            end
        end
    end
    
end

