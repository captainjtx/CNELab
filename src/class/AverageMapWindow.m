%Class for Average Spatial Maps
%Inspired by EventWindow.m
%Tianxiao Jiang @ CNEL
%tjiang3@uh.edu
classdef AverageMapWindow  < handle
    properties
        valid
        fig
        Table
        SpatialMapFig
        
        file_menu
        load_menu
        load_channel_position_menu
        save_menu
        save_fig_menu
        save_val_menu
        
        pos_edit
        pos_radio
        pos_slider
        neg_edit
        neg_radio
        neg_slider
        
        max_clim_edit
        max_clim_slider
        min_clim_edit
        min_clim_slider
        resize_edit
        resize_slider
        
        position_txt
        position_btn
        
        center_mass_radio
        peak_radio
        contact_radio
        interp_missing_radio
        symmetric_scale_radio
        average_radio
        color_bar_radio
        scale_by_max_radio
        
        BtnDelete
        BtnLoad
        compute_btn
        refresh_btn
        new_btn
        
        bsp
        
        MapFiles_
        select_
        width
        height
        
        pos_
        neg_
        
        max_clim_
        min_clim_
        clim_slider_max_
        clim_slider_min_
        resize_
        
        scale_by_max_
        average_
        color_bar_
        interp_missing_
        symmetric_scale_
        center_mass_
        peak_
        contact_
        unit
        interp_method
        extrap_method
        
        pos_t
        neg_t
        
        position
        position_file
        
        channames
        
    end
    
    properties (Dependent=true)
        MapFiles
        select
        Data
        
        fig_x
        fig_y
        fig_w
        fig_h
        max_clim
        min_clim
        clim_slider_max
        clim_slider_min
        resize
        scale_by_max
        average
        color_bar
        interp_missing
        symmetric_scale
        center_mass
        peak
        contact
        
        pos
        neg
    end
    
    methods
        function obj=AverageMapWindow(varargin)
            if nargin==1
                obj.bsp=varargin{1};
            else
                obj.bsp=[];
            end
            %             obj.buildfig();
            %             addlistener(bsp,'SelectedFastEvtChange',@(src,evt) synchSelect(obj));
            varinitial(obj);
        end
        
        function varinitial(obj)
            obj.clim_slider_max_=10;
            obj.clim_slider_min_=-10;
            obj.max_clim_=10;
            obj.min_clim_=-10;
            obj.resize_=1;
            obj.scale_by_max_=0;
            obj.average_=1;
            obj.color_bar_=0;
            obj.width=300;
            obj.height=300;
            obj.unit='dB';
            obj.interp_method='natural';
            obj.extrap_method='linear';
            obj.interp_missing_=0;
            obj.symmetric_scale_=1;
            obj.center_mass_=1;
            obj.peak_=1;
            obj.contact_=1;
            
            obj.neg_=0;
            obj.pos_=0;
            obj.neg_t=1;
            obj.pos_t=1;
            obj.position_file='None';
            obj.position=[];
            
            obj.average_=1;
        end
        
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.fig=figure('MenuBar','none','position',[100 100 300 700],...
                'NumberTitle','off','Name','Spatial Maps ','DockControls','off',...
                'CloseRequestFcn',@(src,evts) OnClose(obj));
            obj.file_menu=uimenu(obj.fig,'label','File');
            
            obj.load_menu=uimenu(obj.file_menu,'label','Load');
            
            obj.load_channel_position_menu=uimenu(obj.load_menu,'Label','Position','Callback',@(src,evt) obj.LoadChannelPosition);
%             if ~isempty(obj.bsp)&&obj.bsp.valid
%                 set(obj.load_channel_position_menu,'enable','off');
%             end
            obj.save_menu=uimenu(obj.file_menu,'label','Save');
            obj.save_fig_menu=uimenu(obj.save_menu,'label','Figure');
            obj.save_val_menu=uimenu(obj.save_menu,'label','Value');
            
            columnName={'Selected','FileName'};
            columnFormat={'logical','char'};
            columnEditable=[true,true];
            columnWidth={50,210};
            
            hp=uipanel('parent',obj.fig,'title','','units','normalized','position',[0,0,1,1]);
            hp_load=uipanel('parent',hp,'title','Map Files','units','normalized','position',[0,0.59,1,0.4]);
            
            obj.Table=uitable(hp_load,'units','normalized',...
                'position',[0 0.12 1 0.88],...
                'ColumnName',columnName,...
                'ColumnFormat',columnFormat,...
                'ColumnEditable',columnEditable,...
                'ColumnWidth',columnWidth,...
                'Data',[],...
                'CellSelectionCallback',@(src,evt) cellClick(obj,src,evt),...
                'CellEditCallback',@(src,evt) cellEdit(obj,src,evt));
            obj.MapFiles=obj.MapFiles_;
            
            obj.BtnDelete=uicontrol(hp_load,'Style','pushbutton','string','delete',...
                'Units','normalized','Position',[0.79,0.01,0.2,0.1],...
                'tooltipstring','delete the selected event','callback',@(src,evt) deleteMap(obj));
            
            obj.BtnLoad=uicontrol(hp_load,'Style','pushbutton','string','load',...
                'Units','normalized','Position',[0.01,0.01,0.2,0.1],...
                'tooltipstring','load a new map','callback',@(src,evt) loadMap(obj));
            
            hp_pos=uipanel('parent',hp,'title','Channel Position','units','normalized','position',[0,0.51,1,0.07]);
            
            obj.position_txt=uicontrol('parent',hp_pos,'style','text','string',obj.position_file,'units','normalized',...
                'position',[0.05,0.1,0.8,0.8],'HorizontalAlignment','center');
            obj.position_btn=uicontrol('parent',hp_pos,'style','pushbutton','units','normalized','string','...',...
                'position',[0.88,0.2,0.1,0.5],'callback',@(src,evts) LoadChannelPosition(obj));
            
            hp_t=uipanel('parent',hp,'title','Threshold','units','normalized','position',[0,0.4,1,0.1]);
            
            obj.pos_radio=uicontrol('parent',hp_t,'style','radiobutton','string','++ :','units','normalized',...
                'position',[0,0.6,0.18,0.3],'value',obj.pos,'callback',@(src,evts) TCallback(obj,src),'interruptible','off');
            obj.neg_radio=uicontrol('parent',hp_t,'style','radiobutton','string','--- :','units','normalized',...
                'position',[0,0.1,0.18,0.3],'value',obj.neg,'callback',@(src,evts) TCallback(obj,src),'interruptible','off');
            obj.pos_edit=uicontrol('parent',hp_t,'style','edit','string',num2str(obj.pos_t),'units','normalized',...
                'position',[0.2,0.55,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) TCallback(obj,src),'interruptible','off');
            obj.neg_slider=uicontrol('parent',hp_t,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) TCallback(obj,src),...
                'min',0,'max',1,'value',obj.neg_t,'sliderstep',[0.01,0.05],'interruptible','off');
            obj.pos_edit=uicontrol('parent',hp_t,'style','edit','string',num2str(obj.pos_t),'units','normalized',...
                'position',[0.2,0.05,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) TCallback(obj,src),'interruptible','off');
            obj.neg_slider=uicontrol('parent',hp_t,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) TCallback(obj,src),...
                'min',1,'max',10,'value',obj.neg_t,'sliderstep',[0.01,0.05],'interruptible','off');
            
            hp_clim=uipanel('parent',hp,'title','Scale','units','normalized','position',[0,0.29,1,0.1]);
            
            uicontrol('parent',hp_clim,'style','text','string','Min','units','normalized',...
                'position',[0,0.6,0.1,0.3]);
            uicontrol('parent',hp_clim,'style','text','string','Max','units','normalized',...
                'position',[0,0.1,0.1,0.3]);
            obj.min_clim_edit=uicontrol('parent',hp_clim,'style','edit','string',num2str(obj.min_clim),'units','normalized',...
                'position',[0.15,0.55,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) ClimCallback(obj,src));
            obj.min_clim_slider=uicontrol('parent',hp_clim,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) ClimCallback(obj,src),...
                'min',obj.clim_slider_min,'max',obj.clim_slider_max,'value',obj.min_clim,'sliderstep',[0.01,0.05]);
            obj.max_clim_edit=uicontrol('parent',hp_clim,'style','edit','string',num2str(obj.max_clim),'units','normalized',...
                'position',[0.15,0.05,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) ClimCallback(obj,src));
            obj.max_clim_slider=uicontrol('parent',hp_clim,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) ClimCallback(obj,src),...
                'min',obj.clim_slider_min,'max',obj.clim_slider_max,'value',obj.max_clim,'sliderstep',[0.01,0.05]);
            
            
            hp_s=uipanel('parent',hp,'title','Window Scale','units','normalized','position',[0,0.21,1,0.07]);
            
            uicontrol('parent',hp_s,'style','text','string','Ratio','units','normalized',...
                'position',[0,0.2,0.1,0.5]);
            obj.resize_edit=uicontrol('parent',hp_s,'style','edit','string',num2str(obj.resize),'units','normalized',...
                'position',[0.15,0.2,0.2,0.6],'horizontalalignment','center','callback',@(src,evts) ResizeCallback(obj,src));
            obj.resize_slider=uicontrol('parent',hp_s,'style','slider','units','normalized',...
                'position',[0.4,0.2,0.55,0.6],'callback',@(src,evts) ResizeCallback(obj,src),...
                'min',0.1,'max',2,'value',obj.resize,'sliderstep',[0.01,0.05]);
            
            
            hp_display=uipanel('parent',hp,'title','Display','units','normalized','position',[0,0.05,1,0.15]);
            
            obj.scale_by_max_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Scale By Maximum',...
                'units','normalized','position',[0,0.75,0.45,0.25],'value',obj.scale_by_max,...
                'callback',@(src,evts) ScaleByMaxCallback(obj,src));
            %             obj.display_mask_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Dispaly Mask Channels',...
            %                 'units','normalized','position',[0,0.5,0.45,0.25],'value',obj.display_mask_channel,...
            %                 'callback',@(src,evts) DisplayMaskCallback(obj,src));
            obj.average_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Average',...
                'units','normalized','position',[0,0.5,0.45,0.25],'value',obj.average,...
                'callback',@(src,evts) AverageCallback(obj,src));
            obj.color_bar_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Color Bar',...
                'units','normalized','position',[0,0.25,0.45,0.25],'value',obj.color_bar,...
                'callback',@(src,evts) ColorBarCallback(obj,src));
            
            
            obj.interp_missing_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Interpolate Missing',...
                'units','normalized','position',[0,0,0.45,0.25],'value',obj.interp_missing,...
                'callback',@(src,evts) InterpMissingCallback(obj,src));
            
            
            obj.symmetric_scale_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Symmetric Scale',...
                'units','normalized','position',[0.5,0.75,0.45,0.25],'value',obj.symmetric_scale,...
                'callback',@(src,evts) SymmetricScaleCallback(obj,src));
            
            obj.center_mass_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Center Mass',...
                'units','normalized','position',[0.5,0.5,0.45,0.25],'value',obj.center_mass>0,...
                'callback',@(src,evts) CenterMassCallback(obj,src));
            
            
            obj.peak_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Peak',...
                'units','normalized','position',[0.5,0.25,0.45,0.25],'value',obj.peak,...
                'callback',@(src,evts) PeakCallback(obj,src));
            
            obj.contact_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Contact',...
                'units','normalized','position',[0.5,0,0.45,0.25],'value',obj.contact,...
                'callback',@(src,evts) ContactCallback(obj,src));
            
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.005,0.2,0.04],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.005,0.2,0.04],...
                'callback',@(src,evts) NewCallback(obj));
            
            obj.refresh_btn=uicontrol('parent',hp,'style','pushbutton','string','Refresh','units','normalized','position',[0.4,0.005,0.2,0.04],...
                'callback',@(src,evts) UpdateFigure(obj,src));
        end
        
        function OnClose(obj)
            % Delete the figure
            h = obj.fig;
            if ishandle(h)
                delete(h);
            else
                return
            end
        end
        
        
        function cellClick(obj,src,evt)
        end
        
        function cellEdit(obj,src,evt)
            indices=evt.Indices;
            
            %click on the color column
            if size(indices,1)==1&&indices(1,2)==1
                
                if obj.Data{indices(1),1}
                    obj.select_=union(obj.select_,indices(1));
                else
                    obj.select_=setdiff(obj.select_,indices(1));
                end
            end
        end
        
        function loadMap(obj)
            if ~isempty(obj.bsp)
                if exist([obj.bsp.FileDir,'/app/spatial map'],'dir')==7
                    open_dir=[obj.bsp.FileDir,'/app/spatial map'];
                else
                    open_dir=obj.bsp.FileDir;
                end
            else
                open_dir='.';
            end
            
            [FileName,FilePath,FilterIndex]=uigetfile({'*.smw;*.txt;*.csv','Spatial Map Files (*.smw;*.txt;*.csv)';...
                '*.smw;*.txt;*csv','Text File (*.smw;*.txt;*csv)'},...
                'select your spatial map file',...
                'MultiSelect','on',...
                open_dir);
            try
                if FileName==0
                    return
                end
            catch
                
            end
            len=length(obj.MapFiles);
            for i=1:length(FileName)
                obj.MapFiles_{len+i}=fullfile(FilePath,FileName{i});
            end
            obj.MapFiles=obj.MapFiles_;
        end
        
        function ComputeCallback(obj)
            maps=obj.MapFiles(obj.select);
            if isempty(maps)
                return
            end
            %**************************************************************
            allchannames=obj.channames;
            allchanpos=obj.position;
            
            chanind=~isnan(allchanpos(:,1))&~isnan(allchanpos(:,2));
            allchanpos=allchanpos(chanind,:);
            allchannames=allchannames(chanind);
            
            [allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),~,~] = ...
                get_relative_chanpos(allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.width,obj.height);
            %**************************************************************
            mapv=cell(length(obj.select),1);
            average_mapv=zeros(length(allchannames),1);
            for i=1:length(mapv)
                mapv{i}=zeros(length(allchannames),1);
            end
            ind=[];
            for i=1:length(maps)
                sm=ReadSpatialMap(maps{i});
                [~,ib]=ismember(sm.name,allchannames);
                ind=union(ind,ib);
                mapv{i}(ib)=sm.val;
                average_mapv(ib)=average_mapv(ib)+sm.val;
            end
            %**************************************************************
            if obj.interp_missing
                map_pos=allchanpos(ind,:);
                map_channames=allchannames(ind);
                
                for i=1:length(mapv)
                    mapv{i}=mapv{i}(ind);
                end
            else
                map_pos=allchanpos;
                map_channames=allchannames;
            end
            %**************************************************************
            delete(obj.SpatialMapFig(ishandle(obj.SpatialMapFig)));
            NewSpatialMapFig(obj);
            %**************************************************************
            spatialmap_grid(obj.SpatialMapFig,mapv,obj.interp_method,...
                obj.extrap_method,map_channames,map_pos(:,1),map_pos(:,2),map_pos(:,3),obj.width,obj.height,sl,sh,obj.color_bar,obj.resize);
            h=findobj(obj.SpatialMapFig,'-regexp','tag','SpatialMapAxes');
            if obj.contact
                plot_contact(h,allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.height,obj.width,[],...
                    ~ismember(allchanpos,chanpos,'rows'),erdchan{e},erschan{e});
            end
            
            if obj.peak
                [~,I]=max(abs(mapv{e}'));
                text(obj.pos_x(I)*obj.width,obj.pos_y(I)*obj.height,'p','parent',h,'fontsize',round(20*obj.resize),'color','w',...
                    'tag','peak','horizontalalignment','center','fontweight','bold');
            end
        end
        function val=NoSpatialMapFig(obj)
            val=isempty(obj.SpatialMapFig)||~all(ishandle(obj.SpatialMapFig))||~all(strcmpi(get(obj.SpatialMapFig,'Tag'),'Act'));
        end
        
        function NewCallback(obj)
            if ~NoSpatialMapFig(obj)
                for i=1:length(obj.SpatialMapFig)
                    name=get(obj.SpatialMapFig,'Name');
                    set(obj.SpatialMapFig(i),'Name',[name ' Old']);
                    set(obj.SpatialMapFig(i),'Tag','Old');
                end
                
            end
            NewSpatialMapFig(obj);
        end
        function NewSpatialMapFig(obj)
            fpos=get(obj.fig,'position');
            if obj.average
                obj.SpatialMapFig=figure('Name','Average','NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),...
                    'units','pixels','position',[fpos(1)+fpos(3)+20,fpos(2),obj.fig_w,obj.fig_h],'Resize','off',...
                    'doublebuffer','off','Tag','Act');
            else
                for i=1:length(obj.select)
                    obj.SpatialMapFig(i)=figure('Name',['Map: ',num2str(obj.select(i))],'NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),...
                        'units','pixels','position',[fpos(1)+fpos(3)+20+(obj.fig_w+20)*(i-1),fpos(2),obj.fig_w,obj.fig_h],'Resize','off',...
                        'doublebuffer','off','Tag','Act');
                end
            end
        end
        
        function KeyPress(obj,src,evt)
            if strcmpi(get(src,'Tag'),'Old')
                return
            end
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
        
        function deleteMap(obj)
            sel=obj.select;
            obj.select=[];
            obj.MapFiles(sel)=[];
        end
        
        function val=get.MapFiles(obj)
            val=obj.MapFiles_;
        end
        function set.MapFiles(obj,val)
            obj.MapFiles_=val;
            if obj.valid
                tmp=cell(length(val),2);
                for i=1:length(val)
                    tmp{i,1}=false;
                    tmp{i,2}=val{i};
                end
                if ~isempty(obj.select)
                    [tmp{obj.select,1}]=deal(true);
                end
                
                set(obj.Table,'Data',tmp);
            end
        end
        function val=get.select(obj)
            val=obj.select_;
        end
        function set.select(obj,val)
            obj.select_=val;
            if obj.valid
                dat=get(obj.Table,'Data');
                [dat{:,1}]=deal(false);
                if ~isempty(val)
                    [dat{val,1}]=deal(true);
                end
                set(obj.Table,'Data',dat);
            end
        end
        function set.Data(obj,val)
            set(obj.Table,'Data',val);
        end
        
        function val=get.Data(obj)
            val=get(obj.Table,'Data');
        end
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
            end
        end
        
        
        
        function val=get.clim_slider_min(obj)
            val=obj.clim_slider_min_;
        end
        function set.clim_slider_min(obj,val)
            obj.clim_slider_min_=val;
            if obj.min_clim<val
                obj.min_clim=val;
            end
            if obj.valid
                set(obj.max_clim_slider,'min',val);
                set(obj.min_clim_slider,'min',val);
                %                 set(obj.erd_slider,'min',val);
                %                 set(obj.ers_slider,'min',val);
            end
        end
        
        function val=get.clim_slider_max(obj)
            val=obj.clim_slider_max_;
        end
        function set.clim_slider_max(obj,val)
            obj.clim_slider_max_=val;
            if obj.max_clim>val
                obj.max_clim=val;
            end
            if obj.valid
                set(obj.max_clim_slider,'max',val);
                set(obj.min_clim_slider,'max',val);
                %                 set(obj.erd_slider,'max',val);
                %                 set(obj.ers_slider,'max',val);
            end
        end
        
        function val=get.max_clim(obj)
            val=obj.max_clim_;
        end
        
        function set.max_clim(obj,val)
            if val>obj.clim_slider_max
                val=obj.clim_slider_max;
            elseif val<obj.clim_slider_min
                val=obj.clim_slider_min;
            end
            
            if obj.symmetric_scale
                val=abs(val);
                obj.min_clim_=obj.clim_slider_max+obj.clim_slider_min-val;
            else
                if obj.min_clim>=val
                    obj.min_clim_=val-1;
                end
            end
            if obj.valid
                set(obj.max_clim_edit,'string',num2str(val));
                set(obj.max_clim_slider,'value',val);
                
                set(obj.min_clim_edit,'string',num2str(obj.min_clim_));
                set(obj.min_clim_slider,'value',obj.min_clim_);
            end
            obj.max_clim_=val;
        end
        
        
        function val=get.min_clim(obj)
            val=obj.min_clim_;
        end
        function set.min_clim(obj,val)
            if val>obj.clim_slider_max
                val=obj.clim_slider_max;
            elseif val<obj.clim_slider_min
                val=obj.clim_slider_min;
            end
            
            if obj.symmetric_scale
                val=-abs(val);
                obj.max_clim_=obj.clim_slider_max+obj.clim_slider_min-val;
            else
                if obj.max_clim<=val
                    obj.max_clim_=val+1;
                end
            end
            
            if obj.valid
                set(obj.min_clim_edit,'string',num2str(val));
                set(obj.min_clim_slider,'value',val);
                
                set(obj.max_clim_edit,'string',num2str(obj.max_clim_));
                set(obj.max_clim_slider,'value',obj.max_clim_);
            end
            obj.min_clim_=val;
        end
        
        function val=get.peak(obj)
            val=obj.peak_;
        end
        
        function set.peak(obj,val)
            obj.peak_=val;
            
            if obj.valid
                set(obj.peak_radio,'value',val);
            end
        end
        
        function val=get.contact(obj)
            val=obj.contact_;
        end
        
        function set.contact(obj,val)
            obj.contact_=val;
            
            if obj.valid
                set(obj.contact_radio,'value',val);
            end
        end
        
        function val=get.center_mass(obj)
            val=obj.center_mass_;
        end
        
        function set.center_mass(obj,val)
            obj.center_mass_=val;
            
            if obj.valid
                set(obj.center_mass_radio,'value',val);
            end
        end
        
        
        function val=get.symmetric_scale(obj)
            val=obj.symmetric_scale_;
        end
        function set.symmetric_scale(obj,val)
            obj.symmetric_scale_=val;
            if obj.valid
                set(obj.symmetric_scale_radio,'value',val);
            end
        end
        
        function val=get.interp_missing(obj)
            val=obj.interp_missing_;
        end
        
        function set.interp_missing(obj,val)
            obj.interp_missing_=val;
            if obj.valid
                set(obj.interp_missing_radio,'value',val);
            end
        end
        
        function val=get.fig_x(obj)
            val=100;
        end
        
        function val=get.fig_y(obj)
            val=100;
        end
        function val=get.fig_w(obj)
            if obj.color_bar
                val=obj.width+80/400*obj.width;
            else
                val=obj.width+20/400*obj.width;
            end
        end
        
        function val=get.fig_h(obj)
            val=obj.height+30/300*obj.height;
        end
        
        function val=get.color_bar(obj)
            val=obj.color_bar_;
        end
        function set.color_bar(obj,val)
            obj.color_bar_=val;
            if obj.valid
                set(obj.color_bar_radio,'value',val);
            end
        end
        
        function val=get.average(obj)
            val=obj.average_;
        end
        function set.average(obj,val)
            obj.average_=val;
            if obj.valid
                set(obj.average_radio,'value',val);
            end
        end
        
        function val=get.resize(obj)
            val=obj.resize_;
        end
        function set.resize(obj,val)
        end
        
        
        function val=get.scale_by_max(obj)
            val=obj.scale_by_max_;
        end
        function set.scale_by_max(obj,val)
            obj.scale_by_max_=val;
            if obj.valid
                set(obj.scale_by_max_radio,'value',val);
            end
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
            
            %             if obj.smw.auto_refresh
            %                 obj.smw.UpdateFigure(src);
            %             end
        end
        
        function AverageCallback(obj,src)
            obj.average_=get(src,'value');
        end
        function LoadChannelPosition(obj)
            %load channel position files
            
            [FileName,FilePath,FilterIndex]=uigetfile({...
                '*.csv;*.txt;*.pos;*.mat',...
                'Supported formats (*.csv;*.txt;*.pos;*.mat)';...
                '*.csv;*.txt;*.pos','Text File';...
                '*.mat','Montage Matlab Binary Format'},...
                'Select Channel Position Files',...
                '.',...
                'MultiSelect','off');
            
            if ~iscell(FileName)
                if ~FileName
                    return
                end
            end
            
            [channelname,pos_x,pos_y,r] = ReadPosition( fullfile(FilePath,FileName) );
            
            p=zeros(length(channelname),3);
            
            for i=1:length(p)
                p(i,1:2)=[pos_x(i), pos_y(i)];
                if ~isempty(r)
                    p(i,3)=r(i);
                end
            end
            
            obj.channames=channelname;
            obj.position=p;
            obj.position_file=fullfile(FilePath,FileName);
            set(obj.position_txt,'string',obj.position_file);
        end
        
        function ScaleByMaxCallback(obj,src)
            obj.scale_by_max_=get(src,'value');
            
            if obj.scale_by_max
                obj.clim_slider_max=1;
                obj.clim_slider_min=-1;
            else
                obj.clim_slider_max=obj.cmax;
                obj.clim_slider_min=-obj.cmax;
            end
            
            UpdateFigure(obj,src);
        end
        
        
        function InterpMissingCallback(obj,src)
            obj.interp_missing_=get(src,'value');
            UpdateFigure(obj,src);
        end
        function SymmetricScaleCallback(obj,src)
            obj.symmetric_scale_=get(src,'value');
        end
        
        function PeakCallback(obj,src)
            obj.peak_=get(src,'value');
            if ~NoSpatialMapFig(obj)
                mapv=obj.map_val;
                for i=1:length(obj.SpatialMapFig)
                    h=findobj(obj.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                    if ~isempty(h)
                        col=obj.pos_x;
                        row=obj.pos_y;
                        delete(findobj(h,'tag','peak'));
                        if obj.peak
                            [~,I]=max(abs(mapv{i}'));
                            text(col(I)*obj.width,row(I)*obj.height,'p','parent',h,'fontsize',round(20*obj.resize),'color','w',...
                                'tag','peak','horizontalalignment','center','fontweight','bold');
                        end
                    end
                end
            end
        end
        
        function ContactCallback(obj,src)
            obj.contact_=get(src,'value');
            chanpos=[obj.pos_x,obj.pos_y,obj.radius];
            if ~NoSpatialMapFig(obj)
                for i=1:length(obj.SpatialMapFig)
                    h=findobj(obj.SpatialMapFig(i),'-regexp','Tag','SpatialMapAxes');
                    if ~isempty(h)
                        delete(findobj(h,'Tag','contact'));
                        figure(obj.SpatialMapFig(i))
                        if obj.contact
                            plot_contact(h,obj.all_chan_pos(:,1),obj.all_chan_pos(:,2),obj.all_chan_pos(:,3),obj.height,obj.width,[],...
                                ~ismember(obj.all_chan_pos,chanpos,'rows'),obj.erd_chan{i},obj.ers_chan{i});
                        end
                        
                    end
                end
            end
        end
        
        function ColorBarCallback(obj,src)
            obj.color_bar_=get(src,'value');
            
            %             if ~obj.auto_refresh
            %                 return
            %             end
            
            if ~NoSpatialMapFig(obj)
                for i=1:length(obj.SpatialMapFig)
                    pos=get(obj.SpatialMapFig(i),'position');
                    set(obj.SpatialMapFig(i),'position',...
                        [pos(1),pos(2),obj.fig_w,obj.fig_h]);
                    
                    a=findobj(obj.SpatialMapFig(i),'Tag','SpatialMapAxes');
                    if ~isempty(a)
                        h=figure(obj.SpatialMapFig(i));
                        fpos=get(h,'position');
                        if obj.color_bar
                            %optional color bar
                            cb=colorbar('Units','normalized','FontSize',round(15*obj.resize));
                            cbpos=get(cb,'Position');
                            set(a,'Position',[10/400*obj.width/fpos(3),15/300*obj.height/fpos(4),obj.width/fpos(3),obj.height/fpos(4)],'FontSize',round(15*obj.resize));
                            set(cb,'Position',[(obj.width+20/400*obj.width)/fpos(3),15/300*obj.height/fpos(4),0.04,cbpos(4)]);
                        else
                            colorbar('off');
                            set(a,'Position',[10/400*obj.width/fpos(3),15/300*obj.height/fpos(4),obj.width/fpos(3),obj.height/fpos(4)]);
                        end
                    end
                end
            end
        end
    end
    
end
