function AdvanceEvents(obj,src)
%Format of the dynamic getAdvanceEvents
%evts=getAdvanceEvents(trigger,fs);
switch src
    case obj.MenuAdvanceEventsCalculate
        if isempty(obj.AdvanceEventsFcn)
            if strcmpi(get(obj.MenuAdvanceEventsQRS,'checked'),'on')
                obj.AdvanceEventsFcn='get_ekg_qrs';
            else
                msgbox('No function loaded!','AdvanceEvents','error');
                return
            end
        else
            [pathstr,name,ext] = fileparts(obj.AdvanceEventsFcn);
            if ~isempty(pathstr)
                addpath(pathstr,'-frozen');
            end
            getAdvanceEvents=str2func(name);
            
        end
        
        if ~obj.IsChannelSelected
            msgbox('No channel is selected!','AdvanceEvents','error');
            return
        elseif sum(cellfun(@length,obj.ChanSelect2Edit))>2
            msgbox('More than two channel is selected!','AdvanceEvents','error');
            return
        else
            
            [data,chanNames,dataset,channel,sample]=get_selected_data(obj);
            if size(data,2)==2
                data=data(:,1)-data(:,2);
            end
            AdvanceEvents=getAdvanceEvents(data,obj.SRate,sample/obj.SRate);
            
            AdvanceEventsColor=cell(size(AdvanceEvents,1),1);
            AdvanceEventsCode=cell(size(AdvanceEvents,1),1);
            
            if strcmpi(get(obj.MenuAdvanceEventsQRS,'checked'),'on')
                %Code and Color definition for QRS Event
                obj.Evts_([obj.Evts_{:,4}]==100,:)=[];
                %Red
                col=[1,0,0];
                code=100;
            else
                %Code and Color definition for customized event
                obj.Evts_([obj.Evts_{:,4}]==2,:)=[];
                col=obj.AdvanceEventDefaultColor;
                code=2;
            end
            [AdvanceEventsColor{:}]=deal(col);
            [AdvanceEventsCode{:}]=deal(code);
            AdvanceEvents=cat(2,AdvanceEvents,AdvanceEventsColor,AdvanceEventsCode);
            
            obj.Evts=cat(1,obj.Evts_,AdvanceEvents);
            return
            
        end
        
    case obj.MenuAdvanceEventsLoad
        [FileName,FilePath]=uigetfile({'*.m','matlab function(*.m)'},'Select the trigger events extraction function.','extractAdvanceEvents.m');
        if ~FileName
            return
        end
        %Set off predefined functions
        set(obj.MenuAdvanceEventsQRS,'checked','off');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        obj.AdvanceEventsFcn=fullfile(FilePath,FileName);
        
    case obj.MenuAdvanceEventsQRS
        %Select QRS detection as advanced events
        if strcmpi(get(obj.MenuAdvanceEventsQRS,'checked'),'on')
            set(obj.MenuAdvanceEventsQRS,'checked','off');
            %Set off other menus
            
            %===================
            obj.AdvanceEventsFcn='';
        else
            set(obj.MenuAdvanceEventsQRS,'checked','on');
            obj.AdvanceEventsFcn='get_ekg_qrs';
        end
        
        
end

end



