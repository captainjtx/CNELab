function KeyPress(obj,src,evt)

dd=obj.DisplayedData;
% time=obj.MouseTime;
% [nchan,ndata,yvalue]=getMouseInfo(obj);

%**************************************************************************
%Exit the special mouse mode except for "Pan" (which needs another click on the icon)
%Exit the special channel selection mode
if strcmpi(evt.Key,'escape')
    if ~isempty(obj.MouseMode)
        obj.MouseMode=[];
    else
        obj.MouseMode=[];
        if ~isempty(obj.SelectedEvent)
            obj.SelectedEvent=[];
        elseif obj.IsChannelSelected
            obj.ChanSelect2Edit=[];
        elseif ~isempty(obj.Selection)
            obj.Selection=[];
        end
    end
    return
end
%**************************************************************************

if ~isempty(evt.Modifier)
    if length(evt.Modifier)==1
        if ismember('command',evt.Modifier)||ismember('control',evt.Modifier)
            
            if strcmpi(evt.Key,'leftarrow')
                ChangeTime(obj,-1);
            elseif strcmpi(evt.Key,'rightarrow')
                ChangeTime(obj,1);
                %Ctrl+A: Select the current dataset
            elseif strcmpi(evt.Key,'A')&&~ismember('command',evt.Modifier)
                if ~obj.IsChannelSelected
                    for i=1:length(dd)
                        obj.ChanSelect2Edit{dd(i)}=1:obj.MontageChanNumber(dd(i));
                    end
                else
                    for i=1:obj.DataNumber
                        if ~isempty(obj.ChanSelect2Edit{i})
                            obj.ChanSelect2Edit{i}=1:obj.MontageChanNumber(i);
                        end
                    end
                end
                return
                %Ctrl/Cmd+ -,=: Change channel gain
            elseif strcmpi(evt.Key,'hyphen')
                ChangeGain(obj,-1);
            elseif strcmpi(evt.Key,'equal')
                ChangeGain(obj,1);
            elseif strcmpi(evt.Key,'i')
                if obj.JTogAnnotate.isSelected()
                    obj.JTogAnnotate.setSelected(false);
                else
                    obj.JTogAnnotate.setSelected(true)
                end
                ChangeMouseMode(obj,3);
            elseif strcmpi(evt.Key,'e')
            else
                m=min(9,size(obj.FastEvts,1));
                if strcmpi(evt.Character,num2str(0))
                    obj.SelectedFastEvt=[];
                    if isa(obj.WinFastEvts,'FastEventWindow')&&isvalid(obj.WinFastEvts)
                        notify(obj,'SelectedFastEvtChange');
                    end
                else
                    for i=1:m
                        if strcmpi(evt.Character,num2str(i))
                            obj.SelectedFastEvt=i;
                            if isa(obj.WinFastEvts,'FastEventWindow')&&isvalid(obj.WinFastEvts)
                                notify(obj,'SelectedFastEvtChange');
                            end
                        end
                    end
                end
            end
        elseif ismember('shift',evt.Modifier)
            if strcmpi(evt.Key,'j')
                for i=1:length(dd)
                    if ~isempty(obj.ChanSelect2Edit{dd(i)})
                        newchan=obj.ChanSelect2Edit{dd(i)}(end)+1;
                        [f,p]=ismember(newchan,obj.ChanSelect2Edit{dd(i)});
                        if f
                            obj.ChanSelect2Edit{dd(i)}(end)=[];
                        else
                            obj.ChanSelect2Edit{dd(i)}=[obj.ChanSelect2Edit{dd(i)};newchan];
                        end
                    end
                end
                return
            elseif strcmpi(evt.Key,'k')
                for i=1:length(dd)
                    if ~isempty(obj.ChanSelect2Edit{dd(i)})
                        newchan=obj.ChanSelect2Edit{dd(i)}(end)-1;
                        [f,p]=ismember(newchan,obj.ChanSelect2Edit{dd(i)});
                        if f
                            obj.ChanSelect2Edit{dd(i)}(end)=[];
                        else
                            obj.ChanSelect2Edit{dd(i)}=[obj.ChanSelect2Edit{dd(i)};newchan];
                        end
                    end
                end
                return
                %if no event line is selected, shift + left and right move the time of canvas
                %else move the time of selected event by 10 sample point
            elseif strcmpi(evt.Key,'leftarrow')
                if isempty(obj.SelectedEvent)
                    ChangeTime(obj,-2);
                else
                    step=-20/obj.SRate;
                    moveSelectedEvents(obj,step);
                end
                return
            elseif strcmpi(evt.Key,'rightarrow')
                if isempty(obj.SelectedEvent)
                    ChangeTime(obj,2);
                else
                    step=20/obj.SRate;
                    moveSelectedEvents(obj,step);
                end
                return
            else
                
                %Ctl/Cmd+Num Switch to dataset(Num)
                for i=1:obj.DataNumber
                    if strcmpi(evt.Key,num2str(i))
                        ChangeData(obj,i);
                        return;
                    end
                end
            end
        end
    elseif length(evt.Modifier)==2
        if ismember('command',evt.Modifier)||ismember('control',evt.Modifier)
            if ismember('shift',evt.Modifier)
               if strcmpi(evt.Key,'leftarrow')
                   ChangeTime(obj,-4);
               elseif  strcmpi(evt.Key,'rightarrow')
                   ChangeTime(obj,4);
               end
            end
        end
        
    end
else
    %'i': Insert the annotation and open the text at the mouse position
    %'j': Movedown a channel when there is one channel selected
    %'k': Moveup a channel
    
    if strcmpi(evt.Key,'i')
%         obj.MouseMode='annotate';
%         obj.Evts=cat(1,obj.Evts_,{time,'New Event',obj.EventDefaultColors(1,:),0});
%         MouseUp(obj);
%         obj.MouseMode=[];
%         MouseDown(obj);
%         MouseUp(obj);
%         
%         for i=1:length(obj.Axes)
%             if gca==obj.Axes(i)
%                 obj.EditMode=1;
%                 set(obj.EventTexts(obj.SelectedLines(i)),'Editing','on');
%             end
%         end
%         return
    elseif strcmpi(evt.Key,'j')
        for i=1:length(dd)
            if isempty(obj.ChanSelect2Edit{dd(i)})
                obj.ChanSelect2Edit{dd(i)}=1;
            else
                obj.ChanSelect2Edit{dd(i)}=obj.ChanSelect2Edit{dd(i)}(end)+1;
            end
        end
    elseif strcmpi(evt.Key,'k')
        for i=1:length(dd)
            if isempty(obj.ChanSelect2Edit{dd(i)})
                obj.ChanSelect2Edit{dd(i)}=1;
            else
                obj.ChanSelect2Edit{dd(i)}=obj.ChanSelect2Edit{dd(i)}(end)-1;
            end
        end
        %move the time of selected event by 1 sample point
    elseif strcmpi(evt.Key,'leftarrow')
        
        if ~isempty(obj.SelectedEvent)
            step=-5/obj.SRate;
            moveSelectedEvents(obj,step);
        end
    elseif strcmpi(evt.Key,'rightarrow')
        
        if ~isempty(obj.SelectedEvent)
            step=5/obj.SRate;
            moveSelectedEvents(obj,step);
        end
    end
end
end