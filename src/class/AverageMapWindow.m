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
        map_new_menu
        map_export_menu
        map_export_fig_menu
        map_export_val_menu
        settings_menu
        
        BtnDelete
        BtnLoad
        BtnDraw
        BtnNew
        
        bsp
        
        MapFiles_
        select_
        width
        height
    end
    
    properties (Dependent=true)
        MapFiles
        select
        Data
        
        fig_w
        fig_h
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
        end
        
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.fig=figure('MenuBar','none','position',[500 100 300 500],...
                'NumberTitle','off','Name','Average Spatial Maps','DockControls','off',...
                'CloseRequestFcn',@(src,evts) OnClose(obj));
            obj.file_menu=uimenu(obj.fig,'label','File');
            obj.map_new_menu=uimenu(obj.file_menu,'label','New','callback',@(src,evts) NewCallback(obj));
            obj.map_export_menu=uimenu(obj.file_menu,'label','Export');
            obj.map_export_fig_menu=uimenu(obj.map_export_menu,'label','Figure');
            obj.map_export_val_menu=uimenu(obj.map_export_menu,'label','Value');
            
            obj.settings_menu=uimenu(obj.fig,'label','Settings');
            
            columnName={'Selected','FileName'};
            columnFormat={'logical','char'};
            columnEditable=[true,true];
            columnWidth={50,210};
            obj.Table=uitable(obj.fig,'units','normalized',...
                'position',[0 0.1 1 0.9],...
                'ColumnName',columnName,...
                'ColumnFormat',columnFormat,...
                'ColumnEditable',columnEditable,...
                'ColumnWidth',columnWidth,...
                'Data',[],...
                'CellSelectionCallback',@(src,evt) cellClick(obj,src,evt),...
                'CellEditCallback',@(src,evt) cellEdit(obj,src,evt));
            obj.MapFiles=obj.MapFiles_;
            
            obj.BtnDelete=uicontrol(obj.fig,'Style','pushbutton','string','delete',...
                'Units','normalized','Position',[0.79,0.01,0.2,0.05],...
                'tooltipstring','delete the selected event','callback',@(src,evt) deleteMap(obj));
            
            obj.BtnLoad=uicontrol(obj.fig,'Style','pushbutton','string','load',...
                'Units','normalized','Position',[0.01,0.01,0.2,0.05],...
                'tooltipstring','load a new map','callback',@(src,evt) loadMap(obj));
            
            obj.BtnDraw=uicontrol(obj.fig,'Style','pushbutton','string','draw',...
                'Units','normalized','Position',[0.4,0.01,0.2,0.05],...
                'tooltipstring','visualize the maps','callback',@(src,evt) drawMap(obj));
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
        
        function drawMap(obj)
            maps=obj.MapFiles(obj.select);
            if isempty(maps)
                return
            end
            %**************************************************************     
            [allchannames,~,~,~,~,~,allchanpos]=get_datainfo(obj.bsp);
            
            chanind=~isnan(allchanpos(:,1))&~isnan(allchanpos(:,2));
            allchanpos=allchanpos(chanind,:);
            allchannames=allchannames(chanind);
            
            [allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),~,~] = ...
                get_relative_chanpos(allchanpos(:,1),allchanpos(:,2),allchanpos(:,3),obj.bsp.SpatialMapWin.width,obj.bsp.SpatialMapWin.height);
            %**************************************************************
            mapv=zeros(length(allchannames),1);
            ind=[];
            for i=1:length(maps)
                sm=ReadSpatialMap(maps{i});
                [~,ib]=ismember(sm.name,allchannames);
                ind=union(ind,ib);
                mapv(ib)=mapv(ib)+sm.val;
            end
            mapv=mapv(ind); 
            %**************************************************************
            if obj.bsp.SpatialMapWin.interp_missing
                map_pos=allchanpos(ind,:);
                map_channames=allchannames(ind);
                val=mapv;
            else
                map_pos=allchanpos;
                map_channames=allchannames;
                %default to zeros
                val=zeros(length(map_channames),1);
                ind=ismember(allchannames,channames);
                val(ind)=mapv;
            end
            
            spatialmap_grid(obj.SpatialMapFig(e),mapv,obj.bsp.SpatialMapWin.interp_method,...
                obj.bsp.SpatialMapWin.extrap_method,map_channames,map_pos(:,1),map_pos(:,2),map_pos(:,3),obj.width,obj.height,sl,sh,obj.color_bar,obj.resize);
            h=findobj(obj.SpatialMapFig(e),'-regexp','tag','SpatialMapAxes');
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
        
        function NewSpatialMapFig(obj)
            
            fpos=get(obj.fig,'position');
            
            obj.SpatialMapFig=figure('Name','Average Spatial Maps','NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),...
                'units','pixels','position',[fpos(1)+fpos(3)+20,fpos(2),obj.fig_w,obj.fig_h],'Resize','off',...
                'doublebuffer','off','Tag','Act');
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
    end
    
end
