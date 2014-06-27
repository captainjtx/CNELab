

function MouseMovementMeasurer(obj)
t=floor((obj.MouseTime-obj.Time)*obj.SRate);

for i=1:length(obj.Axes)
    set(obj.LineMeasurer(i),'XData',[t t])
    for j=1:length(obj.TxtMeasurer{i})
        p=get(obj.TxtMeasurer{i}(j),'position');
        p(1)=t+0.01*obj.WinLength*obj.SRate;
        if strcmpi(obj.DataView,'Superimposed')
            nchan=obj.MontageChanNumber(1)-j+1;
            s=[obj.MontageChanNames{1}{nchan} ':'];
            for k=1:obj.DataNumber
                s=[s ' ' num2str(k) '-' num2str(obj.PreprocData{k}(nchan,t))]; %#ok<AGROW>
                if ~isempty(obj.Units{k})
                    s=[s ' ' obj.Units{k}{nchan}];
                end
            end
        elseif strcmpi(obj.DataView,'Alternated')
            nchan=sum(obj.MontageChanNumber)-j;
            ndata=rem(nchan,obj.DataNumber)+1;
            nchan=floor(nchan/obj.DataNumber)+1;
            s=['(' num2str(ndata) ')' obj.MontageChanNames{1}{nchan} ':' num2str(obj.PreprocData{ndata}(nchan,t))];
            if ~isempty(obj.Units)
                s=[s ' ' obj.Units{ndata}{nchan}];
            end
        elseif any(strcmpi(obj.DataView,{'Horizontal','Vertical'}))
            nchan=obj.MontageChanNumber(i)-j+1;
            s=[obj.MontageChanNames{i}{nchan} ':' num2str(obj.PreprocData{i}(nchan,t))];
            
            if ~isempty(obj.Units)
                s=[s ' ' obj.Units{i}{nchan}];
            end
        else
            ndata=str2double(obj.DataView(4));
            nchan=obj.MontageChanNumber(ndata)-j+1;
            s=[obj.MontageChanNames{ndata}{nchan} ':' num2str(obj.PreprocData{ndata}(nchan,t))];
            
            if ~isempty(obj.Units)
                s=[s ' ' obj.Units{ndata}{nchan}];
            end
        end
        set(obj.TxtMeasurer{i}(j),'Position',p,'String',s);
    end
end
end