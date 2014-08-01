
function ChangeGain(obj,src)

if isempty(src)||ismember(src,[obj.MenuAutoScale,obj.BtnAutoScale])
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
        for i=1:length(dd)
            if src==obj.BtnGainIncrease
                obj.Gain{dd(i)}(obj.ChanSelect2Edit{dd(i)},:)=obj.Gain{dd(i)}(obj.ChanSelect2Edit{dd(i)},:)*2^0.25;
            elseif src==obj.BtnGainDecrease
                obj.Gain{dd(i)}(obj.ChanSelect2Edit{dd(i)},:)=obj.Gain{dd(i)}(obj.ChanSelect2Edit{dd(i)},:)*2^-0.25;
            end
        end
    end
    
end
end