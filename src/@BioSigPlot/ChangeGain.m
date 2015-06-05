
function ChangeGain(obj,src)

if isempty(src)||src==obj.BtnAutoScale
    %Automatic scaling
    data=obj.PreprocData;
    if isempty(data)
        data=cell(1,obj.DataNumber);
        [data{:}]=deal(1);
    end
    
    dd=obj.DisplayedData;
    
    for i=1:length(dd)
        tmp=mean(std(data{dd(i)},1,2));
        if tmp==0
            val=1;
        else
            val=0.2/tmp;
        end
        obj.Gain_{dd(i)}=ones(obj.MontageChanNumber(dd(i)),1)*val;
    end
    
    if ~obj.IsInitialize
        gainChangeSelectedChannels(obj);
    end
else
    dd=obj.DisplayedData;
    if ~obj.IsChannelSelected
        %If there is no channel celected
        %applied to all channels of current data
        for i=1:length(dd)
            if src==obj.BtnGainIncrease
                obj.Gain_{dd(i)}=obj.Gain{dd(i)}*2^0.25;
            elseif src==obj.BtnGainDecrease
                obj.Gain_{dd(i)}=obj.Gain{dd(i)}*2^-0.25;
            end
        end
        
        gainChangeSelectedChannels(obj);
    else
        %if there are channels selected
        %var will be applied to the selected channels
        for i=1:length(dd)
            if src==obj.BtnGainIncrease
                obj.Gain_{dd(i)}(obj.ChanSelect2Edit{dd(i)},:)=obj.Gain{dd(i)}(obj.ChanSelect2Edit{dd(i)},:)*2^0.25;
            elseif src==obj.BtnGainDecrease
                obj.Gain_{dd(i)}(obj.ChanSelect2Edit{dd(i)},:)=obj.Gain{dd(i)}(obj.ChanSelect2Edit{dd(i)},:)*2^-0.25;
            end
        end
        
        gainChangeSelectedChannels(obj);
    end
    
end
end