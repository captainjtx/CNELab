function MouseMovement(obj)
[nchan,ndata,yvalue]=getMouseInfo(obj);
time=obj.MouseTime;
mouseIndex=floor((obj.MouseTime-obj.Time)*obj.SRate);


if ndata==0
    set(obj.Fig,'pointer','arrow')
else
    if ~strcmpi(obj.MouseMode,'Pan')
        set(obj.Fig,'pointer','crosshair')
    end
    
    if isempty(obj.MouseMode)
        if ~isempty(obj.EventLines)&&~obj.DragMode
            for i=1:size(obj.EventLines,1)*size(obj.EventLines,2)
                if ishandle(obj.EventLines(i))&&obj.EventLines(i)
                    XData=get(obj.EventLines(i),'XData');
                    eventIndex=XData(1);
                    if abs(mouseIndex-eventIndex)<50
                        set(obj.Fig,'pointer','hand');
                    end
                end
            end
        end
        
        
        obj.UponText=0;
        if ~isempty(obj.EventTexts)&&~obj.DragMode
            for i=1:length(obj.Axes)
                for j=1:size(obj.EventTexts,2)
                    if ishandle(obj.EventTexts(i,j))&&obj.EventTexts(i,j)
                        extent=get(obj.EventTexts(i,j),'Extent');
                        if mouseIndex>extent(1)&&mouseIndex<extent(1)+extent(3)&&yvalue>extent(2)&&yvalue<extent(2)+extent(4)
                            obj.UponText=1;
                            set(obj.Fig,'pointer','hand');
                            break
                        end
                    end
                end
                
            end
        end
        
        if obj.DragMode
            obj.DragMode=2;
            for i=1:length(obj.Axes)
                set(obj.LineMeasurer(i),'XData',[mouseIndex mouseIndex],'Color',[0 0.7 0],'LineStyle','-.');
            end
        end
    elseif strcmpi(obj.MouseMode,'Measurer')
        obj.MouseMovementMeasurer();
    elseif strcmpi(obj.MouseMode,'Select')
        if ~isempty(obj.SelectionStart)
            t=sort([obj.SelectionStart time]-obj.Time)*obj.SRate;
            epsilon=1.e-10;
            if strcmpi(obj.DataView,'Horizontal') || strcmpi(obj.DataView,'Vertical')
                for i=1:length(obj.Data);
                    p=get(obj.Axes(i),'YLim');
                    set(obj.SelRect(i),'position',[t(1),p(1),t(2)-t(1)+epsilon,p(2)]);
                end
            else
                p=get(obj.Axes,'YLim');
                set(obj.SelRect,'position',[t(1),p(1),t(2)-t(1)+epsilon,p(2)]);
            end
            
        end
    elseif strcmpi(obj.MouseMode,'Annotate')
        set(obj.Fig,'pointer','cross')
        
        for i=1:length(obj.Axes)
            set(obj.LineMeasurer(i),'XData',[mouseIndex mouseIndex],'Color',[159/255 0 0],'LineStyle',':');
        end
    end
    
    
    
    if strcmp(obj.TimeUnit,'min')
        timestamp=time*60;
    else
        timestamp=time;
    end
    
    s=rem(timestamp,60);
    m=rem(floor(timestamp/60),60);
    h=floor(timestamp/3600);
    c=obj.MontageChanNames{ndata};
    
    if round(time*obj.SRate)<=size(obj.Data{ndata},1)
        if iscell(obj.PreprocData)
            v=obj.PreprocData{ndata}(max(round((time-obj.Time)*obj.SRate),1),nchan);
        else
            if ~isempty(obj.PreprocData)
                v=obj.PreprocData(max(round((time-obj.Time)*obj.SRate),1),nchan);
            end
        end
        
    else
        v=nan;
    end
    st=['Time: ' num2str(h,'%02d') ':' num2str(m,'%02d') ':' num2str(s,'%06.3f')...
        ' ; Value: ' num2str(v)];
    
    if ~isempty(obj.Units)&&~isempty(obj.Units{ndata})
        st=[st,' ',obj.Units{ndata}{nchan}];
    end
    
    set(obj.TxtTime,'String',st);
    
    g=obj.Gain{ndata}(nchan);
    set(obj.TxtY,'String',['Data: ' num2str(ndata) ...
        ' ; Chan: '  c{nchan} ...
        ' ; Gain: ' num2str(g)]);
    
    if obj.Filtering{ndata}(nchan)
        fl=num2str(obj.FilterLow{ndata}(nchan));
        fh=num2str(obj.FilterHigh{ndata}(nchan));
        fn1=num2str(obj.FilterNotch1{ndata}(nchan));
        fn2=num2str(obj.FilterNotch2{ndata}(nchan));
    else
        fl='-';
        fh='-';
        fn1='-';
        fn2='-';
    end
    sf=['SR: ',num2str(obj.SRate),' ; ',...
        'FL: ',fl,' , ',...
        'FH: ',fh,' ; ',...
        'FN1: ',fn1,' , ',...
        'FN2: ',fn2];
    set(obj.TxtFilter,'String',sf);
    
end
end