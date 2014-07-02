
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
        elseif strcmpi(evt.Key,'i')
           obj.DispChans=obj.DispChans+1;
           return
        elseif strcmpi(evt.Key,'k')
           obj.DispChans=obj.DispChans-1;
           return
        elseif strcmpi(evt.Key,'l')
            ChangeDuration(obj,obj.BtnAddDuration);
            return
        elseif strcmpi(evt.Key,'j')
            ChangeDuration(obj,obj.BtnRemDuration);
            return
        end
    end

end
end