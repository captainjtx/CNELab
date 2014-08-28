function MouseMovement(obj)
[nchan,ndata,yvalue]=getMouseInfo(obj);
time=obj.MouseTime;
mouseIndex=floor((obj.MouseTime-obj.Time)*obj.SRate);
pos=get(obj.Fig,'CurrentPoint');

if obj.ResizeMode
    set(obj.Fig,'pointer','right');
    pos1=get(obj.EventPanel,'Position');
    pos2=get(obj.AdjustPanel,'Position');
    pos3=get(obj.MainPanel,'Position');
    fpos=get(obj.Fig,'position');
    
    pos1(3)=max(1,min(pos(1)-obj.AdjustWidth/2,fpos(3)-obj.AdjustWidth-10));
    set(obj.EventPanel,'Position',pos1);
    
    pos2(1)=pos1(1)+pos1(3);
    set(obj.AdjustPanel,'Position',pos2);
    
    set(obj.MainPanel,'Position',[pos2(1)+pos2(3) pos3(2) fpos(3)-pos1(3)-pos2(3) pos3(4)]);
    return
end

obj.UponAdjustPanel=false;

if ndata==0
    set(obj.Fig,'pointer','arrow')
    
    if strcmpi(get(obj.AdjustPanel,'Visible'),'on')
        
        region=get(obj.AdjustPanel,'Position');
        if pos(1)>region(1)&&pos(1)<region(1)+region(3)&&pos(2)>region(2)&&pos(2)<region(2)+region(4)
            set(obj.Fig,'pointer','right');
            obj.UponAdjustPanel=true;
        end
    end
else
    if isempty(obj.MouseMode)
        set(obj.Fig,'pointer','crosshair');
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
        updateUponText(obj,mouseIndex,yvalue);
        if obj.DragMode&&~isempty(obj.SelectedEvent)
            obj.DragMode=2;
            for i=1:length(obj.Axes)
                set(obj.LineMeasurer(i),'XData',[mouseIndex mouseIndex],'Color',[0 0.7 0],'LineStyle','-.');
            end
        elseif obj.ClickDrag
            setfigptr('closedhand',obj.Fig);
        end
    elseif strcmpi(obj.MouseMode,'Measurer')
        set(obj.Fig,'pointer','crosshair');
        obj.MouseMovementMeasurer();
    elseif strcmpi(obj.MouseMode,'Select')
        set(obj.Fig,'pointer','ibeam');
        if ~isempty(obj.SelectionStart)
            t=sort([obj.SelectionStart time]-obj.Time)*obj.SRate;
            epsilon=1.e-10;
            for i=1:length(obj.Axes)
                p=get(obj.Axes(i),'YLim');
                if ishandle(obj.SelRect(i))
                    set(obj.SelRect(i),'position',[t(1),p(1),t(2)-t(1)+epsilon,p(2)]);
                end
            end
            
        end
    elseif strcmpi(obj.MouseMode,'Annotate')
        set(obj.Fig,'pointer','cross')
        updateUponText(obj,mouseIndex,yvalue);
        updateSelectedFastEvent(obj,mouseIndex);
    end
    
    updateInfoPanel(obj,time,ndata,nchan);
    
end
end

function updateUponText(obj,mouseIndex,yvalue)

obj.UponText=0;
if ~isempty(obj.EventTexts)&&~obj.DragMode
    for j=1:size(obj.EventTexts,1)*size(obj.EventTexts,2)
        if ishandle(obj.EventTexts(j))
            i=find(get(obj.EventTexts(j),'Parent')==obj.Axes);
            extent=get(obj.EventTexts(j),'Extent');
            if mouseIndex>extent(1)&&mouseIndex<extent(1)+extent(3)&&yvalue(i)>extent(2)&&yvalue(i)<extent(2)+extent(4)
                obj.UponText=1;
                set(obj.Fig,'pointer','hand');
                break
            end
        end
    end
end
end
function updateInfoPanel(obj,time,ndata,nchan)

if strcmp(obj.TimeUnit,'min')
    timestamp=time*60;
else
    timestamp=time;
end

s=rem(timestamp,60);
m=rem(floor(timestamp/60),60);
h=floor(timestamp/3600);
c=obj.MontageChanNames{ndata}{nchan};

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
total=size(obj.Data{ndata},1)/obj.SRate;
percent=time/total*100;

if obj.Filtering{ndata}(nchan)
    fl=num2str(obj.FilterLow{ndata}(nchan));
    fh=num2str(obj.FilterHigh{ndata}(nchan));
    fn1=num2str(obj.FilterNotch1{ndata}(nchan));
    fn2=num2str(obj.FilterNotch2{ndata}(nchan));
    fci=obj.FilterCustomIndex{ndata}(nchan)-1;
    if fci
        fcum=num2str(fci);
    else
        fcum='-';
    end
else
    fl='-';
    fh='-';
    fn1='-';
    fn2='-';
    fcum='-';
end

s1=['Data: ',num2str(ndata),' ; ',...
    'SR: ',num2str(obj.SRate,'%0.5g'),' ; ',...
    'Chan: ',c];

s2=['Gain: ',num2str(obj.Gain{ndata}(nchan),'%0.5g'),' ; ',...
    'Value: ',num2str(v,'%0.5g')];

if ~isempty(obj.Units)&&~isempty(obj.Units{ndata})
    s2=[s2,' ',obj.Units{ndata}{nchan}];
end

s3=['Time: ',num2str(h,'%02d'),':',num2str(m,'%02d'),':',num2str(s,'%0.3f'),...
    ' -- ',num2str(percent,'%0.2f'),'%'];

s4=['FL: ',fl,' , ',...
    'FH: ',fh,'  ;  ',...
    'FN1: ',fn1,' , ',...
    'FN2: ',fn2,'  ;  ',...
    'FCUM:',fcum];

set(obj.TxtInfo1,'String',s1);
set(obj.TxtInfo2,'String',s2);
set(obj.TxtInfo3,'String',s3);
set(obj.TxtInfo4,'String',s4);

end