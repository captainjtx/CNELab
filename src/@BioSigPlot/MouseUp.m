function MouseUp(obj)
obj.ClickDrag=false;
obj.ResizeMode=false;

[nchan,ndata,yvalue]=getMouseInfo(obj); %#ok<ASGLU>
time=obj.MouseTime;
Modifier=get(obj.Fig,'CurrentModifier');

if isempty(obj.MouseMode)
    if ndata
        if isempty(Modifier)
            if ~isempty(obj.SelectedEvent)
                if obj.DragMode==2
                    step=obj.MouseTime-obj.Evts{obj.SelectedEvent,1};
                    moveSelectedEvents(obj,step);
                    obj.DragMode=0;
                    for i=1:length(obj.Axes)
                        set(obj.LineMeasurer(i),'XData',[inf inf]);
                    end
                    return
                end
            end
            %**********************************************************************
            %Sigle Channel Selection or move canvas
            if abs(time-obj.PrevMouseTime)<10/obj.SRate
                if ~obj.DragMode&&~obj.UponText
                    obj.ChanSelect2Edit{ndata}=nchan;
                end
            else
                obj.Time=obj.Time-time+obj.PrevMouseTime;
                set(obj.Fig,'pointer','crosshair');
            end
        end
    end
end

obj.DragMode=0;

end