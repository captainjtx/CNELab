classdef ElectrodeSettings<handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bm
        fig
        
        Table
        BtnDelete
        BtnNew
        BtnUnSelect
        select_ele
        
    end
    properties(Dependent)
        valid
        Data
        ele_key
    end
    
    methods
        
        function val=get.ele_key(obj)
            val=['Electrode',num2str(obj.select_ele)];
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
        function obj=ElectrodeSettings(bm)
            obj.bm=bm;
            addlistener(bm,'ElectrodeSettingsChange',@(src,evt) updateData(obj));
        end
        
        function buildfig(obj)
            if obj.valid
                figure(obj.fig)
                return
            end
            
            if isempty(obj.bm.SelectedElectrode)
                return
            end
            
            electrode=obj.bm.mapObj(['Electrode',num2str(obj.bm.SelectedElectrode)]);
            
            obj.select_ele=obj.bm.SelectedElectrode;
            
            bmpos=get(obj.bm.fig,'position');
            sidepos = getpixelposition(obj.bm.sidepane);
            screensize=get(0,'ScreenSize');
            
            columnWidth=[40,40,180,180,60,60,40];
            
            obj.fig=figure('Menubar','none','Name','Electrode Settings','units','pixels','position',...
                [bmpos(1)+sidepos(1),screensize(4)/2-325,sum(columnWidth)+50,500],...
                'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),'resize','off','Dockcontrols','off');
            
            columnName={'Select','Name','Position','Norm','Radius','Thickness','Color'};
            columnFormat={'logical','char','char','char','numeric','numeric','char'};
            columnEditable=[true,true,true,true,true,true,false];
            
            data=cell(size(electrode.coor,1),7);
            for i=1:size(electrode.coor,1)
                data{i,1}=logical(electrode.selected(i));
                data{i,2}=electrode.channame{i};
                data{i,3}=num2str(electrode.coor(i,:));
                data{i,4}=num2str(electrode.norm(i,:));
                data{i,5}=electrode.radius(i);
                data{i,6}=electrode.thickness(i);
                data{i,7}=ElectrodeSettings.colorgen(electrode.color(i,:),'');
            end
            
            columnWidth=num2cell(columnWidth);
            obj.Table=uitable(obj.fig,'units','normalized',...
                'position',[0 0.1 1 0.9],...
                'ColumnName',columnName,...
                'ColumnFormat',columnFormat,...
                'ColumnEditable',columnEditable,...
                'ColumnWidth',columnWidth,...
                'Data',data,...
                'CellSelectionCallback',@(src,evt) cellClick(obj,src,evt),...
                'CellEditCallback',@(src,evt) cellEdit(obj,src,evt));
%             jscrollpane = findjobj(obj.Table);
%             jtable = jscrollpane.getViewport.getView;
%             
%             % Now turn the JIDE sorting on
%             jtable.setSortable(true);		% or: set(jtable,'Sortable','on');
% %             jtable.setAutoResort(true);
%             jtable.setMultiColumnSortable(true);
%             jtable.setPreserveSelectionsAfterSorting(true);
%             
%             for i=1:length(columnWidth)
%                 jtable.getColumnModel().getColumn(i-1).setPreferredWidth(columnWidth{i});
%             end
            
            obj.BtnDelete=uicontrol(obj.fig,'Style','pushbutton','string','delete',...
                'Units','normalized','Position',[0.89,0.01,0.1,0.05],...
                'tooltipstring','delete the selected electrode','callback',@(src,evt) deleteElectrode(obj));
            
            obj.BtnUnSelect=uicontrol(obj.fig,'Style','pushbutton','string','unselect',...
                'Units','normalized','Position',[0.475,0.01,0.1,0.05],...
                'tooltipstring','unselect all','callback',@(src,evt) unselectElectrode(obj));
            
            obj.BtnDelete=uicontrol(obj.fig,'Style','pushbutton','string','new',...
                'Units','normalized','Position',[0.01,0.01,0.1,0.05],...
                'tooltipstring','create a new electrode','callback',@(src,evt) newElectrode(obj));
        end
        function OnClose(obj)
            try
                delete(obj.fig);
            catch
            end
        end
        
        function cellClick(obj,src,evt)
            indices=evt.Indices;
            %click on the color column
            if size(indices,1)==1&&indices(1,2)==7
                electrode=obj.bm.mapObj(obj.ele_key);
                color=uisetcolor(electrode.color(indices(1),:),electrode.channame{indices(1)});
                electrode.color(indices(1),:)=color;
                obj.Data{indices(1),7}=ElectrodeSettings.colorgen(color,'');
                
                set(electrode.handles(indices(1)),'facecolor',color);
                
                obj.bm.mapObj(obj.ele_key)=electrode;
            end
        end
        
        function cellEdit(obj,src,evt)
            indices=evt.Indices;
            if size(indices,1)==1
                electrode=obj.bm.mapObj(obj.ele_key);
                switch indices(1,2)
                    case 1
                        electrode.selected(indices(1))=evt.NewData;
                        if electrode.selected(indices(1))
                            set(electrode.handles(indices(1)),'edgecolor','y');
                        else
                            set(electrode.handles(indices(1)),'edgecolor','none');
                        end
                    case 2
                        [a,b]=ismember(evt.NewData,electrode.channame);
                        if a&&b~=indices(1)
                            errordlg([evt.NewData,' already exists !']);
                            obj.Data{indices(1),2}=evt.PreviousData;
                            return
                        end
                        electrode.channame{indices(1)}=evt.NewData;
                        
                        userdata=get(electrode.handles(indices(1)),'UserData');
                        userdata.name=electrode.channame(indices(1));
                        
                        set(electrode.handles(indices(1)),'UserData',userdata);
                    case 3
                        electrode.coor(indices(1),:)=str2num(evt.NewData);
                        redrawElectrode(obj,electrode,indices(1));
                    case 4
                        electrode.norm(indices(1),:)=str2num(evt.NewData);
                        redrawElectrode(obj,electrode,indices(1));
                    case 5
                        electrode.radius(indices(1))=evt.NewData;
                        redrawElectrode(obj,electrode,indices(1));
                    case 6
                        electrode.thickness(indices(1))=evt.NewData;
                        redrawElectrode(obj,electrode,indices(1));
                end
                obj.bm.mapObj(obj.ele_key)=electrode;
            end
        end
        
        function redrawElectrode(obj,electrode,ind)
            userdat.name=electrode.channame{ind};
            userdat.ele=obj.select_ele;
            
            [faces,vertices] = createContact3D...
                (electrode.coor(ind,:),electrode.norm(ind,:),electrode.radius(ind),electrode.thickness(ind));
            delete(electrode.handles(ind));
            
            if electrode.selected(ind)
                edgecolor='y';
            else
                edgecolor='none';
            end
            
            electrode.handles(ind)=patch('faces',faces,'vertices',vertices,...
                'facecolor',electrode.color(ind,:),'edgecolor',edgecolor,'UserData',userdat,...
                'ButtonDownFcn',@(src,evt) obj.bm.ClickOnElectrode(src),'facelighting','gouraud');
            material dull;
        end
        function newElectrode(obj)
        end
        function deleteElectrode(obj)
        end
        
        function updateData(obj)
            if obj.valid
                electrode=obj.bm.mapObj(obj.ele_key);
                data=cell(size(electrode.coor,1),7);
                for i=1:size(electrode.coor,1)
                    data{i,1}=logical(electrode.selected(i));
                    data{i,2}=electrode.channame{i};
                    data{i,3}=num2str(electrode.coor(i,:));
                    data{i,4}=num2str(electrode.norm(i,:));
                    data{i,5}=electrode.radius(i);
                    data{i,6}=electrode.thickness(i);
                    data{i,7}=ElectrodeSettings.colorgen(electrode.color(i,:),'');
                end
                obj.Data=data;
            end
        end
        
        function unselectElectrode(obj)
            electrode=obj.bm.mapObj(obj.ele_key);
            electrode.selected=ones(size(electrode.selected))*false;
            
            set(electrode.handles,'edgecolor','none');
            
            dat=obj.Data;
            [dat{:,1}]=deal(false);
            obj.Data=dat;
            
            obj.bm.mapObj(obj.ele_key)=electrode;
        end
    end
    methods (Static=true)
        function htmlstr=colorgen(color,text)
            colorstr=rgb2hex(color);
            htmlstr=['<html><div style="padding: 100px; background-color:',colorstr,'">',text,'</div></html>'];
        end
    end
    
end

