
function ChangeGain(obj,src)

if isempty(src)||ismember(src,[obj.BtnAddGain,obj.BtnRemGain,obj.EdtGain])
    val=str2double(get(obj.EdtGain,'String'));
    
    if isempty(get(obj.EdtGain,'String'))||...
            (ismember(src,[obj.BtnAddGain,obj.BtnRemGain])&&val==0)
        %Automatic scaling
        data=obj.PreprocData;
        if isempty(data)
            data=cell(1,obj.DataNumber);
            [data{:}]=deal(1);
        end
        
        for i=1:obj.DataNumber
            tmp=mean(std(data{i},1,2));
            if tmp==0
                val=1;
            else
                val=0.2/tmp;
            end
        end
    end
    
    if src==obj.BtnAddGain
        val=val*2^.25;
    elseif src==obj.BtnRemGain
        val=val*2^-.25;
    end
    if isnan(val)
        val=1;
    end
        
    set(obj.EdtGain,'String',num2str(val));
    if obj.IsInitialize
        obj.Gain_=obj.applyPanelVal(obj.Gain_,val);
    else
        obj.Gain=obj.applyPanelVal(obj.Gain_,val);
    end
else
    dd=obj.DisplayedData;
    if ~obj.IsChannelSelected
        %If there is no channel celected
        %applied to all channels of current data
        for i=1:length(dd)
            if src==obj.BtnGainIncrease
                obj.Gain{dd(i)}=obj.Gain{dd(i)}*2^0.25;
            elseif src==obj.BtnGainDecrease
                obj.Gain{dd(i)}=obj.Gain{dd(i)}*2^-0.25;
            end
        end
    else
        %if there are channels selected
        %var will be applied to the selected channels
        for i=1:obj.DataNumber
            if src==obj.BtnGainIncrease
                obj.Gain{i}(obj.ChanSelect2Edit{i},:)=obj.Gain{i}(obj.ChanSelect2Edit{i},:)*2^0.25;
            elseif src==obj.BtnGainDecrease
                obj.Gain{i}(obj.ChanSelect2Edit{i},:)=obj.Gain{i}(obj.ChanSelect2Edit{i},:)*2^-0.25;
            end
        end
    end
    
end
end