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
    if obj.EditMode==1
        obj.EditMode=0;
        EventList=obj.Evts;
        for i=1:size(obj.EventDisplayIndex,2)
            EventList{obj.EventDisplayIndex(1,i),2}=get(obj.EventTexts(1,i),'String');
        end
        obj.Evts=EventList;
    end
    %**********************************************************************
    %Multi Channel Selection
    Modifier=get(obj.Fig,'CurrentModifier');
    if ndata
        if isempty(Modifier)
            %Sigle Channel Selection
            obj.ChanSelect2Edit{ndata}=nchan;
        elseif ismember('control',Modifier)||ismember('command',Modifier)
            [flag,loc]=ismember(nchan,obj.ChanSelect2Edit{ndata});
            if flag
                obj.ChanSelect2Edit{ndata}(loc)=[];
            else
                obj.ChanSelect2Edit{ndata}=[obj.ChanSelect2Edit{ndata};nchan];
            end
            
        elseif ismember('shift',Modifier)
            if isempty(obj.ChanSelect2Edit{ndata})
                obj.ChanSelect2Edit{ndata}=linspace(nchan,1,abs(1-nchan)+1)';
            else
                tmp=obj.ChanSelect2Edit{ndata};
                start=tmp(end);
                [flag,loc]=ismember(linspace(start,nchan,abs(start-nchan)+1)',tmp);
                tmp(loc(loc~=0))=[];
                tmp=[tmp;linspace(nchan,start,abs(start-nchan)+1)'];
                pChan=nchan;
                pChanLoc=[];
                while(1)
                    if start>nchan
                        pChan=pChan-1;
                    else
                        pChan=pChan+1;
                    end
                    [flag,loc]=ismember(pChan,tmp);
                    if flag
                        pChanLoc=cat(1,pChanLoc,loc);
                    else
                        break;
                    end
                end
                
                if ~isempty(pChanLoc)
                    tmp(pChanLoc)=[];
                end
                
                obj.ChanSelect2Edit{ndata}=tmp;
            end
        end
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