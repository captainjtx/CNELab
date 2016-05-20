function MouseMovementMeasurer(obj)

lt=floor((obj.MouseTime-obj.Time)*obj.SRate);
nt=min(max(floor((obj.MouseTime-obj.BufferTime)*obj.SRate),1),size(obj.PreprocData{1},1));

for i=1:length(obj.Axes)
    set(obj.LineMeasurer(i),'XData',[lt lt])
    for j=1:length(obj.TxtMeasurer{i})
        p=get(obj.TxtMeasurer{i}(j),'position');
        p(1)=lt+0.01*obj.WinLength*obj.SRate;
        if strcmpi(obj.DataView,'Superimposed')
            nchan=obj.MontageChanNumber(1)-j+1;
            s=[obj.MontageChanNames{1}{nchan} ':'];
            for k=1:obj.DataNumber
                s=[s ' ' num2str(k) '-' num2str(obj.PreprocData{k}(nt,nchan))]; %#ok<AGROW>
                if ~isempty(obj.Units)&&~isempty(obj.Units{k})
                    s=[s ' ' obj.Units{k}{nchan}];
                end
            end
        elseif strcmpi(obj.DataView,'Alternated')
            nchan=sum(obj.MontageChanNumber)-j;
            ndata=rem(nchan,obj.DataNumber)+1;
            nchan=floor(nchan/obj.DataNumber)+1;
            s=['(' num2str(ndata) ')' obj.MontageChanNames{1}{nchan} ':' num2str(obj.PreprocData{ndata}(nt,nchan))];
            if ~isempty(obj.Units)&&~isempty(obj.Units{ndata})
                s=[s ' ' obj.Units{ndata}{nchan}];
            end
        elseif any(strcmpi(obj.DataView,{'Horizontal','Vertical'}))
            nchan=obj.MontageChanNumber(i)-j+1;
            s=[obj.MontageChanNames{i}{nchan} ':' num2str(obj.PreprocData{i}(nt,nchan))];
            
            if ~isempty(obj.Units)&&~isempty(obj.Units{i})
                s=[s ' ' obj.Units{i}{nchan}];
            end
        else
            ndata=str2double(obj.DataView(4));
            nchan=obj.MontageChanNumber(ndata)-j+1;
            s=[obj.MontageChanNames{ndata}{nchan} ':' num2str(obj.PreprocData{ndata}(nt,nchan))];
            
            if ~isempty(obj.Units)&&~isempty(obj.Units{ndata})
                s=[s ' ' obj.Units{ndata}{nchan}];
            end
        end
        set(obj.TxtMeasurer{i}(j),'Position',p,'String',s);
    end
end
end