function TriggerEvents(obj,src)
%Format of the dynamic getTriggerEvents
%evts=getTriggerEvents(trigger,fs);
switch src
    case obj.MenuTriggerEventsCalculate
        if isempty(obj.TriggerEventsFcn)
            msgbox('No function loaded!','TriggerEvents','error');
            return
        else
            [pathstr,name,ext] = fileparts(obj.TriggerEventsFcn);
            addpath(pathstr,'-frozen');
            getTriggerEvents=str2func(name);
        end
        
        if ~obj.IsChannelSelected
            msgbox('No channel is selected!','TriggerEvents','error');
            return
        elseif sum(cellfun(@length,obj.ChanSelect2Edit))>1
            msgbox('More than one channel is selected!','TriggerEvents','error');
            return
        else
            
            for i=1:obj.DataNumber
                if ~isempty(obj.ChanSelect2Edit{i})
                    t=zeros(size(obj.Data{i},2),1);
                    t(obj.ChanSelect2Edit{i})=1;
                    trigger=double(obj.Data{i})*(obj.Montage{i}(obj.MontageRef(i)).mat*obj.ChanOrderMat{i})'*t;
                    triggerEvents=getTriggerEvents(trigger,obj.SRate);
                    
                    triggerEventsColor=cell(size(triggerEvents,1),1);
                    [triggerEventsColor{:}]=deal(obj.TriggerEventDefaultColor);
                    
                    triggerEventsCode=cell(size(triggerEvents,1),1);
                    [triggerEventsCode{:}]=deal(2);
                    
                    triggerEvents=cat(2,triggerEvents,triggerEventsColor,triggerEventsCode);
                    
                    obj.Evts_([obj.Evts_{:,4}]==2,:)=[];
                    obj.Evts=cat(1,obj.Evts_,triggerEvents);
                    return
                end
            end
        end
    case obj.MenuTriggerEventsLoad
        [FileName,FilePath]=uigetfile({'*.m','matlab function(*.m)'},'Select the trigger events extraction function.','extractTriggerEvents.m');
        if ~FileName
            return
        end
        
        obj.TriggerEventsFcn=fullfile(FilePath,FileName);
        
end

end



