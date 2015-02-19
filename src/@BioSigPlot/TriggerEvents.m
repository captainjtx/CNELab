function TriggerEvents(obj,src)
%Format of the dynamic getTriggerEvents
%evts=getTriggerEvents(trigger,fs);
switch src
    case obj.MenuTriggerEventsCalculate
        if isempty(obj.TriggerEventsFcn)
            if strcmpi(get(obj.MenuTriggerEventsQRS,'checked'),'on')
                obj.TriggerEventsFcn='get_ekg_qrs';
            else
                msgbox('No function loaded!','TriggerEvents','error');
                return
            end
        else
            [pathstr,name,ext] = fileparts(obj.TriggerEventsFcn);
            if ~isempty(pathstr)
                addpath(pathstr,'-frozen');
            end
            getTriggerEvents=str2func(name);
            
        end
        
        if ~obj.IsChannelSelected
            msgbox('No channel is selected!','TriggerEvents','error');
            return
        elseif sum(cellfun(@length,obj.ChanSelect2Edit))>1
            msgbox('More than one channel is selected!','TriggerEvents','error');
            return
        else
            
            [data,chanNames,dataset,channel,sample]=get_selected_data(obj);
            triggerEvents=getTriggerEvents(data,obj.SRate,sample/obj.SRate);
            
            triggerEventsColor=cell(size(triggerEvents,1),1);
            triggerEventsCode=cell(size(triggerEvents,1),1);
            
            if strcmpi(get(obj.MenuTriggerEventsQRS,'checked'),'on')
                %Code and Color definition for QRS Event
                obj.Evts_([obj.Evts_{:,4}]==100,:)=[];
                %Red
                col=[1,0,0];
                code=100;
            else
                %Code and Color definition for customized event
                obj.Evts_([obj.Evts_{:,4}]==2,:)=[];
                col=obj.TriggerEventDefaultColor;
                code=2;
            end
            [triggerEventsColor{:}]=deal(col);
            [triggerEventsCode{:}]=deal(code);
            triggerEvents=cat(2,triggerEvents,triggerEventsColor,triggerEventsCode);
            
            obj.Evts=cat(1,obj.Evts_,triggerEvents);
            return
            
        end
        
    case obj.MenuTriggerEventsLoad
        [FileName,FilePath]=uigetfile({'*.m','matlab function(*.m)'},'Select the trigger events extraction function.','extractTriggerEvents.m');
        if ~FileName
            return
        end
        %Set off predefined functions
        set(obj.MenuTriggerEventsQRS,'checked','off');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        obj.TriggerEventsFcn=fullfile(FilePath,FileName);
        
    case obj.MenuTriggerEventsQRS
        %Select QRS detection as advanced events
        if strcmpi(get(obj.MenuTriggerEventsQRS,'checked'),'on')
            set(obj.MenuTriggerEventsQRS,'checked','off');
            %Set off other menus
            
            %===================
            obj.TriggerEventsFcn='';
        else
            set(obj.MenuTriggerEventsQRS,'checked','on');
            obj.TriggerEventsFcn='get_ekg_qrs';
        end
        
        
end

end



