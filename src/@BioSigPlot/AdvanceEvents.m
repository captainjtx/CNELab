function AdvanceEvents(obj,src)
%Format of the dynamic getAdvanceEvents
%evts=getAdvanceEvents(trigger,fs);
switch src
    case obj.MenuAdvanceEventsCalculate
        name=getSelectedFunction(obj);
        if isempty(name)
            error('No function selected !')
        end
        
        getAdvanceEvents=str2func(name);
        
        if ~obj.IsChannelSelected
            msgbox('No channel is selected!','AdvanceEvents','error');
            return
        else
            [data,~,~,~,sample]=get_selected_data(obj);
            if size(data,2)==2
                data=data(:,1)-data(:,2);
            end
            AdvanceEvents=getAdvanceEvents(data,obj.SRate,sample/obj.SRate);
            
            AdvanceEventsColor=cell(size(AdvanceEvents,1),1);
            AdvanceEventsCode=cell(size(AdvanceEvents,1),1);
            

            %Code and Color definition for customized event
            %obj.Evts_([obj.Evts_{:,4}]==2,:)=[];
            col=obj.AdvanceEventDefaultColor;
            code=2;
            
            [AdvanceEventsColor{:}]=deal(col);
            [AdvanceEventsCode{:}]=deal(code);
            AdvanceEvents=cat(2,AdvanceEvents,AdvanceEventsColor,AdvanceEventsCode);
            
            obj.Evts=cat(1,obj.Evts_,AdvanceEvents);
            return  
        end
    otherwise
        set(get(obj.MenuAdvanceEventsFunction,'Children'),'checked','off');
        set(src,'checked','on');
end
end

function functor=getSelectedFunction(obj)
    functors=get(obj.MenuAdvanceEventsFunction,'Children');
    functor='';
    for i=1:size(functors)
        if(strcmpi(get(functors(i),'checked'),'on'))
            functor=get(functors(i),'Label');
        end
    end
end



