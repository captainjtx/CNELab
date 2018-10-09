classdef InterpWin < handle
    properties
        ds
        selectChan
        interpChan
        
        width
        height
        
        col
        row
        r
        
        fig
        
        bsp
        
        channames
        
    end
    properties (Dependent)
        valid
    end
    
    methods
        
        function obj=InterpWin(bsp)
            obj.height=350;
            obj.width=350;
            obj.bsp=bsp;
            
            addlistener(bsp,'SelectionChange',@(src,evts)UpdateSelection(obj));
        end
        
        function buildfig(obj)
            
            if obj.valid
                figure(obj.fig);
                return
            end
            
            obj.interpChan=[];
            
            [~,dataset,channel,~,~,~,~]=get_selected_datainfo(obj.bsp);
            
            if length(channel)~=1
                errordlg('Must select one channel !');
                return
            end
            
            obj.ds=dataset;
            obj.selectChan=channel;
            
            obj.channames=obj.bsp.MontageChanNames{obj.ds};
%             allchan=obj.channames;
            
            chanpos=obj.bsp.Montage{obj.ds}(obj.bsp.MontageRef(obj.ds)).position;
            if isempty(chanpos)
                errordlg('Cannot find channel positions !');
                return
            end
            chanind=~isnan(chanpos(:,1))&~isnan(chanpos(:,2));
            obj.channames=obj.channames(chanind);
            chanpos=chanpos(chanind,:);
            
            [obj.col,obj.row,obj.r,obj.width,obj.height] = get_relative_chanpos(chanpos(:,1),chanpos(:,2),chanpos(:,3),obj.width,obj.height);
            
            obj.fig=figure('Name','Interpolation','units','pixels','position',[150,150,obj.width,obj.height],'MenuBar','None',...
                'NumberTitle','off','WindowButtonDownFcn',@(src,evts)Click(obj),'CloseRequestFcn',@(src,evts) OnClose(obj),'resize','off');
            
            a=axes('units','normalized','position',[0,0,1,1],'Visible','off','parent',obj.fig,...
                'xlimmode','manual','ylimmode','manual');
            
            %needs relative positions
            plot_contact(a,[],obj.col,obj.row,obj.r,obj.height,obj.width,obj.channames);
            %**************************************************************
            %transform to pixels
            obj.col=round(obj.col*obj.width);
            obj.row=round(obj.row*obj.height);
            obj.r=round(obj.r*obj.width);
            %**************************************************************
            if ~isempty(obj.selectChan)
                background=uint8(ones(obj.height,obj.width,3)*255);
                shapeInserter = vision.ShapeInserter('Shape','Circles',...
                    'Fill',true,'FillColor','Custom','CustomFillColor',[255,0,0]);
                circles = int32([obj.col(obj.selectChan) obj.row(obj.selectChan) obj.r(obj.selectChan)]);
                I = step(shapeInserter, background, circles);
                hold on
                imgh=image(I,'parent',a,'tag','select');
                A=rgb2gray(I);
                A(A~=255)=0;
                set(imgh,'AlphaData',255-A);
                
                set(a,'XLim',[1,obj.width]);
                set(a,'YLim',[1,obj.height]);
                set(a,'YDir','reverse');
            end
        end
        
        function Click(obj)
            a=findobj(obj.fig,'type','axes');
            
            pos=get(obj.fig,'CurrentPoint');
            
            pos(2)=obj.height-pos(2);
            
            clickedimg=findobj(obj.fig,'Tag','interp');
            
            if ~isempty(clickedimg)
                delete(clickedimg);
            end
            
            D=pdist2([pos(1),pos(2)],[obj.col,obj.row]);
            [~,I]=min(D);
            clickchan=I(1);
            
            obj.interpChan=setxor(obj.interpChan,clickchan);
            obj.interpChan(obj.interpChan==obj.selectChan)=[];
            
            if isempty(obj.interpChan)
                return
            end
            
            background=uint8(ones(obj.height,obj.width,3)*255);
            shapeInserter = vision.ShapeInserter('Shape','Circles','Fill',true,'FillColor','Custom','CustomFillColor',[0,255,0],'Antialiasing',true);
            circles=[];
            
            
            for i=1:length(obj.interpChan)
                circles = cat(1,circles,int32([obj.col(obj.interpChan(i)) obj.row(obj.interpChan(i)) obj.r(obj.interpChan(i))]));
            end
            
            I = step(shapeInserter, background, circles);
            
            hold on
            
            imgh=image(I,'parent',a,'tag','interp');
            A=rgb2gray(I);
            A(A~=255)=0;
            set(imgh,'AlphaData',255-A);
            
            interpolate(obj);
            
        end
        
        function UpdateSelection(obj)
            
            if ~obj.valid
                return
            end
            
%             figure(obj.fig);
            
            [~,dataset,channel,~,~,~,~]=get_selected_datainfo(obj.bsp);
            
            if length(channel)~=1||dataset~=obj.ds
                return
            end
            
            if channel==obj.selectChan&&dataset==obj.ds
                interpolate(obj);
            else
                obj.selectChan=[];
                obj.interpChan=[];
                selectimg=findobj(obj.fig,'Tag','select');
                if ~isempty(selectimg)
                    delete(selectimg);
                end
                
                interpimg=findobj(obj.fig,'Tag','interp');
                if ~isempty(interpimg)
                    delete(interpimg);
                end
                
                obj.selectChan=channel;
                
                background=uint8(ones(obj.height,obj.width,3)*255);
                shapeInserter = vision.ShapeInserter('Shape','Circles','Fill',true,'FillColor','Custom','CustomFillColor',[255,0,0],'Antialiasing',true);
                
                circles = int32([obj.col(obj.selectChan) obj.row(obj.selectChan) obj.r(obj.selectChan)]);
                I = step(shapeInserter, background, circles);
                hold on
                a=findobj(obj.fig,'type','axes');
                imgh=image(I,'parent',a,'tag','select');
                A=rgb2gray(I);
                A(A~=255)=0;
                set(imgh,'AlphaData',255-A);
            end
            
        end
        
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
        end
        
        function interpolate(obj)
            if isempty(obj.selectChan)
                return
            end
            [data,chanNames,dataset,channel,sample,evts,groupnames,pos]=get_selected_data(obj.bsp);
            
            totalweight=0;
            newdata=0;
            
            if isempty(obj.interpChan)
                newdata=data;
            else
                for i=1:length(obj.interpChan)
                    weight=[obj.col(obj.interpChan(i)),obj.row(obj.interpChan(i))]-[obj.col(obj.selectChan),obj.row(obj.selectChan)];
                    weight=sqrt(sum(weight.^2));
                    
                    totalweight=totalweight+weight;
                    newdata=obj.bsp.PreprocData{dataset}(sample-obj.bsp.BufferStartSample+1,obj.interpChan(i))*weight+newdata;
                end
                newdata=newdata/totalweight;
            end
            obj.bsp.PreprocData{dataset}(sample-obj.bsp.BufferStartSample+1,channel)=newdata;
            
            obj.bsp.redrawChangeBlock('time');
        end
        
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isgraphics(obj.fig);
            catch
                val=0;
            end
        end
    end
    
end

