classdef CFCWindow < handle
    
    
    properties
        bsp
        ph_vector_str
        ph_bw
        amp_vector_str
        amp_bw
        surr_num
        CFCmap_counter
        cmin_
        cmax_
        smooth_row_
        smooth_col_
    end
    
    properties  % UI elements
        fig
        CFCMapFig
        OldCFCMapFig
        fig_w
        fig_h
        
        ph_data_popup
        ph_freq_edit
        ph_bw_edit
        
        amp_data_popup
        amp_freq_edit
        amp_bw_edit
        
        surr_num_edit
        
        new_btn
        compute_btn
        
        JMinSpinner
        JMaxSpinner
        JSmoothRowSpinner
        JSmoothColSpinner
            
    end
    
    properties (Dependent)
        valid
        fs
        ph_vector
        amp_vector
        cmax
        cmin
        smooth_row
        smooth_col
    end
    
    methods
        function obj = CFCWindow(bsp)
            obj.bsp=bsp;
            varinitial(obj);
            addlistener(bsp,'SelectionChange',@(src,evts)UpdateChannelList(obj));
            
        end
        
        function varinitial(obj)
            % DEFAULTS
            obj.ph_vector_str = '6:1:40';
            obj.ph_bw = 5;
            obj.amp_vector_str = '150:10:400';
            obj.amp_bw = 50;
            obj.surr_num = 100;
            obj.CFCmap_counter = 0;
            obj.fig_w = 560;
            obj.fig_h = 420;
            obj.cmin_ = 0;
            obj.cmax_ = 1;
            obj.smooth_row_ = 4;
            obj.smooth_col_ = 4;
        end
        
        function buildfig (obj)
            import javax.swing.JSpinner;
            import javax.swing.SpinnerNumberModel;
            if obj.valid
                figure(obj.fig)
                return
            end
            
            [chanNames,~,~,~,~,~,~]=get_selected_datainfo(obj.bsp,true);
            % chanNames={'1','2'};
            if isempty(chanNames)
                errordlg('Channel info returned empty!')
            end
            
            % UI elements defined here
            obj.fig=figure('MenuBar','none','Name','Cross Frequency Analysis','units','pixels',...
                'Position',[100 100 260 420],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','on','DockControls','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));
            
            hp =uipanel('units','normalized','Position',[0,0,1,1]);
            
            % phase erlated parameters
            hp_ph           =uipanel('Parent',hp,'Title', 'Phase','units', 'normalized','position',[0,0.7,1,0.3]);
            obj.ph_data_popup= uicontrol('Parent',hp_ph,'style','popup','String',chanNames,'units','normalized',...
                'position',[0.61 0.67 0.3 0.3]);
            uicontrol('Parent',hp_ph,'style','text','String','Data Channel','units','normalized',...
                'position',[0.01 0.67 0.5 0.3],'HorizontalAlignment','Left');
            obj.ph_freq_edit = uicontrol('parent',hp_ph,'style','edit','string',obj.ph_vector_str,...
                'units', 'normalized','position',[0.61,0.33,0.3,0.3]);
            uicontrol('Parent',hp_ph,'style','text','String','Vector (start:step:end)','units','normalized',...
                'position',[0.01 0.33,0.5,0.3],'HorizontalAlignment','Left');
            obj.ph_bw_edit = uicontrol('parent',hp_ph,'style','edit','string',num2str(obj.ph_bw),...
                'units', 'normalized','position',[0.61,0.01,0.3,0.3]);
            uicontrol('Parent',hp_ph,'style','text','String','Filter BW','units','normalized',...
                'position',[0.01,0.01,0.5,0.3],'HorizontalAlignment','Left');
            
            % amplitude erlated parameters
            hp_amp           =uipanel('Parent',hp,'Title', 'Amplitude','units', 'normalized','position',[0,0.39,1,0.3]);
            obj.amp_data_popup= uicontrol('Parent',hp_amp,'style','popup','String',chanNames,'units','normalized',...
                'position',[0.61 0.67 0.3 0.3]);
            uicontrol('Parent',hp_amp,'style','text','String','Data Channel','units','normalized',...
                'position',[0.01 0.67 0.5 0.3],'HorizontalAlignment','Left');
            obj.amp_freq_edit = uicontrol('parent',hp_amp,'style','edit','string',obj.amp_vector_str,...
                'units', 'normalized','position',[0.61,0.33,0.3,0.3]);
            uicontrol('Parent',hp_amp,'style','text','String','Vector (start:step:end)','units','normalized',...
                'position',[0.01 0.33,0.5,0.3],'HorizontalAlignment','Left');
            obj.amp_bw_edit = uicontrol('parent',hp_amp,'style','edit','string',num2str(obj.amp_bw),...
                'units', 'normalized','position',[0.61,0.01,0.3,0.3]);
            uicontrol('Parent',hp_amp,'style','text','String','Filter BW','units','normalized',...
                'position',[0.01,0.01,0.5,0.3],'HorizontalAlignment','Left');
            
             % surrogate numbers
            hp_surr = uipanel('Parent',hp,'Title', '','units', 'normalized','position',[0,0.285,1,0.1]);
            obj.surr_num_edit = uicontrol('parent',hp_surr,'style','edit','string',num2str(obj.surr_num),...
                'units', 'normalized','position',[0.61,0.05,0.3,0.9]);
            uicontrol('Parent',hp_surr,'style','text','String','Surrogate Number','units','normalized',...
                'position',[0.01,0.05,0.5,0.5],'HorizontalAlignment','Left');
            
            % colorscale controls
            hp_clim = uipanel('Parent',hp,'Title', 'Color Scale','units', 'normalized','position',[0,0.18,1,0.1]);
            uicontrol('parent',hp_clim,'style','text','units','normalized','position',[0,0,0.1,0.8],...
                'string','Min','horizontalalignment','left','fontunits','normalized','fontsize',0.6);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmin),[],[],java.lang.Double(0.1)));
            obj.JMinSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JMinSpinner,[0,0,1,1],hp_clim);
            set(gh,'Units','Norm','Position',[0.12,0.05,0.35,0.9]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ScaleSpinnerCallback(obj));
            
            uicontrol('parent',hp_clim,'style','text','units','normalized','position',[0.5,0,0.1,0.8],...
                'string','Max','horizontalalignment','left','fontunits','normalized','fontsize',0.6);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmax),[],[],java.lang.Double(0.1)));
            obj.JMaxSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JMaxSpinner,[0,0,1,1],hp_clim);
            set(gh,'Units','Norm','Position',[0.62,0.05,0.35,0.9]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ScaleSpinnerCallback(obj));
            
            % smoothing controls
            hp_smooth=uipanel('parent',obj.fig,'title','Smooth','units','normalized','position',[0,0.075,1,0.1]);
            uicontrol('parent',hp_smooth,'style','text','units','normalized','position',[0,0,0.1,0.8],...
                'string','Row','horizontalalignment','left','fontunits','normalized','fontsize',0.6);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.smooth_row),java.lang.Double(0.0),[],java.lang.Double(2)));
            obj.JSmoothRowSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JSmoothRowSpinner,[0,0,1,1],hp_smooth);
            set(gh,'Units','Norm','Position',[0.12,0.05,0.35,0.9]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) SmoothSpinnerCallback(obj, gh));
            
            uicontrol('parent',hp_smooth,'style','text','units','normalized','position',[0.5,0,0.1,0.8],...
                'string','Col','horizontalalignment','left','fontunits','normalized','fontsize',0.6);
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.smooth_col),java.lang.Double(0),[],java.lang.Double(2)));
            obj.JSmoothColSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JSmoothColSpinner,[0,0,1,1],hp_smooth);
            set(gh,'Units','Norm','Position',[0.62,0.05,0.35,0.9]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) SmoothSpinnerCallback(obj, gh));
            
            
            % new and compute buttons
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.01,0.2,0.06],...
                'callback',@(src,evts) NewCallback(obj));
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.01,0.2,0.06],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            
        end
        
        function KeyPress(obj,src,evt)
            % come here later
        end
        
        function ScaleSpinnerCallback(obj)
            min=obj.JMinSpinner.getValue();
            max=obj.JMaxSpinner.getValue();
            
            if min<max
                obj.cmin=min;
                obj.cmax=max;
                
                if ~NoCFCMapFig(obj)
                    h=findobj(obj.CFCMapFig,'-regexp','Tag','CFCMapAxes');
                    if ~isempty(h)
                        set(h,'clim',[obj.cmin,obj.cmax]);
                    end
                end
            end
        end
        
        function SmoothSpinnerCallback(obj, src)
            Nr=obj.JSmoothRowSpinner.getValue();
            Nc=obj.JSmoothColSpinner.getValue();
            
            obj.smooth_row_=Nr;
            obj.smooth_col_=Nc;
            
%             UpdateFigure(obj,src);  % update figure appearance without re-compute, keep the matrix value
        end
        
        function ComputeCallback(obj)
            [data,~,~,~,~,~,~,~,seg_ind]=get_selected_data(obj.bsp,true);
            ph_ch = get(obj.ph_data_popup,'value');
            sig_ph_mat = data(:,ph_ch);
            amp_ch = get(obj.amp_data_popup,'value');
            sig_amp_mat = data(:,amp_ch);
            
            
            [val,ind]=unique(seg_ind);
            for i =1:length(val)
                sig_ph{i} = sig_ph_mat(seg_ind==val(i));
                sig_amp{i} = sig_amp_mat(seg_ind==val(i));
            end
            surr_num =0;
            [pacmat, shf_pacmat_final] = cfc_plv_seg(sig_ph,sig_amp, obj.fs, obj.ph_vector, obj.amp_vector,obj.ph_bw, obj.ph_bw, obj.surr_num);
            
            if ~NoCFCMapFig(obj)
                figure(obj.CFCMapFig);
            else
                fpos=get(obj.fig,'position');
                obj.CFCMapFig=figure('Name','CFCMap','NumberTitle','off',...
                    'units','pixels','position',[fpos(1)+fpos(3)+20,fpos(2),obj.fig_w,obj.fig_h],...
                    'doublebuffer','off','Tag','Act');
            end

            cfc_plot(pacmat,shf_pacmat_final, obj.ph_vector, obj.amp_vector,obj.smooth_row,obj.smooth_col);  % plot cfc
            set(gca,'Tag','CFCMapAxes');
            
            
            obj.cmin=min(min(pacmat));
            obj.cmax=max(max(pacmat));
            
        end 
        
        function UpdateChannelList(obj)
            [chanNames,~,~,~,~,~,~]=get_selected_datainfo(obj.bsp,true);
            if isempty(chanNames)
                errordlg('Channel info returned empty!')
            end
            set(obj.ph_data_popup,'String',chanNames,'value',1);
            set(obj.amp_data_popup,'String',chanNames,'value',1);
        end
        
        function NewCallback(obj)
            NewCFCMapFig(obj);
            ComputeCallback(obj);
        end
        
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
            obj.fig=[];
            
            h = obj.CFCMapFig;
            if ishandle(h)
                delete(h);
            end  
            
            for ind=1:length(obj.OldCFCMapFig)
               try 
                  delete(obj.OldCFCMapFig(ind));
               catch 
                  continue
               end
            end
        end
    end
    
    %% HANDY functions
    methods
        function val=NoCFCMapFig(obj)
            val=isempty(obj.CFCMapFig)||~all(ishandle(obj.CFCMapFig))||~all(strcmpi(get(obj.CFCMapFig,'Tag'),'Act'));
        end
        
        function NewCFCMapFig(obj)
            if ~isempty(obj.CFCMapFig)&&ishandle(obj.CFCMapFig)  %isempty(obj.CFCMapFig)||~all(ishandle(obj.CFCMapFig))||~all(strcmpi(get(obj.CFCMapFig,'Tag'),'Act'));
                obj.CFCmap_counter = obj.CFCmap_counter+1;
                name=get(obj.CFCMapFig,'Name');
                set(obj.CFCMapFig,'Tag','Old');
                set(obj.CFCMapFig,'name',[' Old_' name '_' num2str(obj.CFCmap_counter)])
                obj.OldCFCMapFig(obj.CFCmap_counter)=obj.CFCMapFig;  % save the old handles for closing the old figures
            end
            
            fpos=get(obj.fig,'position');
            obj.CFCMapFig=figure('Name','CFCMap','NumberTitle','off',...
                'units','pixels','position',[fpos(1)+fpos(3)+20,fpos(2),obj.fig_w,obj.fig_h],...
                'doublebuffer','off','Tag','Act');
        end
    end
    
    
    %% GET SET
    methods
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
        
        function val=get.ph_vector(obj)
            val=str2num(obj.ph_vector_str);
        end
        
        function val=get.amp_vector(obj)
            val=str2num(obj.amp_vector_str);
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
        
        
        function val = get.smooth_row(obj)
            val = obj.smooth_row_;
        end
        function set.smooth_row(obj, val)
            obj.smooth_row_=val;
            if obj.valid
                obj.JSmoothRowSpinner.setValue(java.lang.Double(val));
                drawnow
            end
        end
        function val = get.smooth_col(obj)
            val = obj.smooth_col_;
        end
        function set.smooth_col(obj,val)
            obj.smooth_col_=val;
            if obj.valid
                obj.JSmoothColSpinner.setValue(java.lang.Double(val));
                drawnow
            end
        end
        
        
    end
    
end
