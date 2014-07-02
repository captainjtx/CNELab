
function KeyPress(obj,src,evt)

dd=obj.DisplayedData;
%**************************************************************************
%Exit the special mouse mode except for "Pan" (which needs another click on the icon)
%Exit the special channel selection mode
if strcmpi(evt.Key,'escape')
    obj.MouseMode=[];
    obj.ChanSelect2Edit=[];
    return
end
%**************************************************************************
if ~isempty(evt.Modifier)
    
    if ismember('command',evt.Modifier)||ismember('control',evt.Modifier)
        %Ctrl/Cmd+A: Select the current dataset
        if strcmpi(evt.Key,'A')
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
        end
        
        %Ctl/Cmd+Num Switch to dataset(Num)
        for i=1:obj.DataNumber
            if strcmpi(evt.Key,num2str(i))
                obj.DataView=['DAT' num2str(i)];
                return;
            end
        end
        
        %Ctrl/Cmd+ i,k j,l: Change channel number and duration per page
        %Ctrl/Cmd+ -,=: Change channel gain
        if strcmpi(evt.Key,'hyphen')
            ChangeGain(obj,obj.BtnAddGain);
        elseif strcmpi(evt.Key,'equal')
            ChangeGain(obj,obj.BtnRemGain);
        elseif strcmpi(evt.Key,'i')||strcmpi(evt.Key,'uparrow')
            obj.DispChans=obj.DispChans+1;
            return
        elseif strcmpi(evt.Key,'k')||strcmpi(evt.Key,'downarrow')
            obj.DispChans=obj.DispChans-1;
            return
        elseif strcmpi(evt.Key,'l')||strcmpi(evt.Key,'rightarrow')
            ChangeDuration(obj,obj.BtnAddDuration);
            return
        elseif strcmpi(evt.Key,'j')||strcmpi(evt.Key,'leftarrow')
            ChangeDuration(obj,obj.BtnRemDuration);
            return
        end
    end
    if ismember('shift',evt.Modifier)
        if strcmpi(evt.Key,'j')||strcmpi(evt.Key,'downarrow')
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
        elseif strcmpi(evt.Key,'k')||strcmpi(evt.Key,'uparrow')
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
        elseif strcmpi(evt.Key,'leftarrow')
            ChangeTime(obj,obj.BtnPrevPage);
        elseif strcmpi(evt.Key,'rightarrow')
            ChangeTime(obj,obj.BtnNextPage);
        end
   
    end
else
    %'i': Insert the annotation and open the text at the mouse position
    %'j': Movedown a channel when there is one channel selected
    %'k': Moveup a channel
    
    if strcmpi(evt.Key,'i')
        obj.MouseMode='annotate';
        MouseDown(obj);
        MouseUp(obj);
        obj.MouseMode=[];
        MouseDown(obj);
        MouseUp(obj);
        
        for i=1:length(obj.Axes)
            if gca==obj.Axes(i)
                obj.EditMode=1;
                set(obj.EventTexts(obj.SelectedLines(i)),'Editing','on');
            end
        end
        return
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
    elseif strcmpi(evt.Key,'leftarrow')
        ChangeTime(obj,obj.BtnPrevSec)
    elseif strcmpi(evt.Key,'rightarrow')
        ChangeTime(obj,obj.BtnNextSec)
    elseif strcmpi(evt.Key,'uparrow')
    elseif strcmpi(evt.Key,'downarrow')
    end
end
end