function MouseDown(obj)
t=floor((obj.MouseTime-obj.Time)*obj.SRate);

[nchan,ndata,yvalue]=getMouseInfo(obj); %#ok<ASGLU>
time=obj.MouseTime;

if isempty(obj.MouseMode)
    %**********************************************************************
    %Event Line selection
    obj.SelectedEvent=[];
    obj.SelectedLines=[];
    if ~isempty(obj.EventLines)
        for i=1:size(obj.EventLines,1)*size(obj.EventLines,2)
            if ishandle(obj.EventLines(i))&&obj.EventLines(i)
                XData=get(obj.EventLines(i),'XData');
                eventIndex=XData(1);
                if abs(t-eventIndex)<50
                    
                    set(obj.EventLines(i),'Color',[159/255 0 197/255]);
                    set(obj.EventTexts(i),'EdgeColor',[159/255 0 197/255],'BackgroundColor',[159/255 0 197/255]);
                    obj.SelectedLines=[obj.SelectedLines i];
                    obj.SelectedEvent=obj.EventDisplayIndex(i);
                    obj.DragMode=1;
                    return
                else
                    set(obj.EventLines(i),'Color',[0 0.7 0]);
                    set(obj.EventTexts(i),'EdgeColor',[0 0.7 0],'BackgroundColor',[0.6 1 0.6]);
                    
                end
            end
        end
    end
    %**********************************************************************
    %Multi Channel Selection
    Modifier=get(obj.Fig,'CurrentModifier');
    if isempty(Modifier)
        %Sigle Channel Selection
        
    else
    end

elseif strcmpi(obj.MouseMode,'Select')
    
    if(strcmp(get(obj.Fig,'SelectionType'),'open'))
        
        obj.SelectionStart=[];%Cancel first click
        i=1;
        while i<=size(obj.Selection,2)
            if time<=obj.Selection(2,i) && time>=obj.Selection(1,i)
                obj.Selection=obj.Selection(:,[1:i-1 i+1:end]);
            else
                i=i+1;
            end
        end
        redraw(obj);
        
    else
        if isempty(obj.SelectionStart)
            obj.SelectionStart=time;
        else %Second click
            tempSelection=sort([obj.SelectionStart;time]);
            for i=1:size(obj.Selection,2)
                if tempSelection(1,1)<=obj.Selection(2,i) && tempSelection(2,1)>=obj.Selection(1,i)
                    tempSelection(:,1)=[min([tempSelection(1,1) obj.Selection(1,i)]) max([tempSelection(2,1) obj.Selection(2,i)])];
                else
                    tempSelection(:,end+1)=obj.Selection(:,i); %#ok<AGROW>
                end
            end
            obj.Selection=round(100*sortrows(tempSelection',1)')/100;
            
            
            obj.SelectionStart=[];
            redraw(obj);
        end
    end
elseif strcmpi(obj.MouseMode,'Annotate')
    
    EventList=obj.Evts;
    EventList=cat(1,EventList,{time,'NewText'});
    obj.Evts=EventList;
    
end

end