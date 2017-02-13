%Class for predefined event window
%Inspired by EventWindow.m
%Tianxiao Jiang @ CNEL
%tjiang3@uh.edu
classdef FastEventWindow  < handle
    properties
        fig
        
        FastEvts % A n*2 cell; Column 1: Event name ; Column 2: Event color
        
        Table
        
        BtnDelete
        BtnNew
        
        bsp
    end
    
    properties (Dependent=true)
        SelectedFastEvt
        Data
        valid
    end
    
    methods
        function obj=FastEventWindow(bsp)
            obj.bsp=bsp;
            
            FastEvts=bsp.FastEvts;
            
            if isempty(FastEvts)
                FastEvts={'New Event',bsp.EventDefaultColors(1,:)};
            end
            
            obj.FastEvts=FastEvts; 
            
            addlistener(bsp,'SelectedFastEvtChange',@(src,evt) synchSelect(obj));
        end
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.fig=figure('MenuBar','none','position',[500 100 300 500],...
                'NumberTitle','off','Name','FastEvents',...
                'CloseRequestFcn',@(src,evts) OnClose(obj));
            SelectedEvt=obj.bsp.SelectedFastEvt;
            
            tmp=cell(size(obj.FastEvts,1),3);
            
            for i=1:size(obj.FastEvts,1)
                tmp{i,1}=false;
                tmp{i,2}=obj.FastEvts{i,1};
                tmp{i,3}=FastEventWindow.colorgen(obj.FastEvts{i,2},'');
            end
            if ~isempty(SelectedEvt)
                tmp{SelectedEvt,1}=true;
            end
            
            columnName={'Default','Name','Color'};
            columnFormat={'logical','char','char'};
            columnEditable=[true,true,false];
            columnWidth={50,170,40};
            obj.Table=uitable(obj.fig,'units','normalized',...
                'position',[0 0.1 1 0.9],...
                'ColumnName',columnName,...
                'ColumnFormat',columnFormat,...
                'ColumnEditable',columnEditable,...
                'ColumnWidth',columnWidth,...
                'Data',tmp,...
                'CellSelectionCallback',@(src,evt) cellClick(obj,src,evt),...
                'CellEditCallback',@(src,evt) cellEdit(obj,src,evt));
            
            obj.BtnDelete=uicontrol(obj.fig,'Style','pushbutton','string','delete',...
                'Units','normalized','Position',[0.79,0.01,0.2,0.05],...
                'tooltipstring','delete the selected event','callback',@(src,evt) deleteFastEvent(obj));
            
            obj.BtnDelete=uicontrol(obj.fig,'Style','pushbutton','string','new',...
                'Units','normalized','Position',[0.01,0.01,0.2,0.05],...
                'tooltipstring','create a new event','callback',@(src,evt) newFastEvent(obj));
        end
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isgraphics(obj.fig);
            catch
                val=0;
            end
        end
        function OnClose(obj)
            % Delete the figure
            h = obj.fig;
            notify(obj,'FastEvtsClosed');
            if ishandle(h)
                delete(h);
            else
                return
            end
        end
        
        function synchSelect(obj)
            if ~isempty(obj.Data)
                [obj.Data{:,1}]=deal(false);
                if ~isempty(obj.bsp.SelectedFastEvt)
                    obj.Data{obj.bsp.SelectedFastEvt,1}=true;
                end
            end
        end
        
        function cellClick(obj,src,evt)
            indices=evt.Indices;
            
            %click on the color column
            if size(indices,1)==1&&indices(1,2)==3
                color=uisetcolor(obj.FastEvts{indices(1),2},obj.FastEvts{indices(1),1});
                obj.FastEvts{indices(1),2}=color;
                obj.Data{indices(1),3}=FastEventWindow.colorgen(color,'');
            end
        end
        
        function cellEdit(obj,src,evt)
            if size(evt.Indices,1)==1
                if evt.Indices(1,2)==1
                    if evt.NewData
                        [obj.Data{:,1}]=deal(false);
                        obj.Data{evt.Indices(1),1}=true;
                    end
                    notify(obj,'SelectedFastEvtChange');
                    
                elseif evt.Indices(1,2)==2
                    obj.FastEvts(:,1)=obj.Data(:,2);
                end
            end
        end
        
        function newFastEvent(obj)
            
            if ~isempty(obj.FastEvts)
                obj.FastEvts=cat(1,obj.FastEvts,{'',[1,1,0]});
            else
                obj.FastEvts={'',[1,1,0]};
            end
            
            obj.Data=cat(1,obj.Data,{false,'',FastEventWindow.colorgen([1,1,0],'')});
        end
        
        function deleteFastEvent(obj)
            obj.FastEvts(obj.SelectedFastEvt,:)=[];
            obj.Data(obj.SelectedFastEvt,:)=[];
            notify(obj,'SelectedFastEvtChange');
        end
        
        function val=get.SelectedFastEvt(obj)
            ind=[obj.Data{:,1}];
            val=find(ind);
        end
        
        function set.Data(obj,val)
            set(obj.Table,'Data',val);
        end
        
        function val=get.Data(obj)
            val=get(obj.Table,'Data');
        end
        
        function set.FastEvts(obj,val)
            obj.FastEvts=val;
            notify(obj,'FastEvtsChange');
        end
    end
    methods (Static=true)        
        function htmlstr=colorgen(color,text)
            colorstr=rgb2hex(color);
            htmlstr=['<html><div style="padding: 100px; background-color:',colorstr,'">',text,'</div></html>'];
        end
    end
    
    events
        SelectedFastEvtChange
        FastEvtsClosed
        FastEvtsChange
    end    
end
