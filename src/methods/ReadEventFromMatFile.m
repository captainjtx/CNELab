function NewEventList=ReadEventFromMatFile(filename)
Events=load(filename,'-mat');

if isfield(Events,'stamp')&&isfield(Events,'text')
    NewEventList=cell(length(Events.stamp),4);
    
    for i=1:length(Events.stamp)
        NewEventList{i,1}=Events.stamp(i);
        NewEventList{i,2}=Events.text{i};
        if ~isfield(Events,'color')
            NewEventList{i,3}=[0 0 0];
        else
            NewEventList{i,3}=Events.color(i,:);
        end
        
        if ~isfield(Events,'code')
            NewEventList{i,4}=0;
        else
            NewEventList{i,4}=Events.code(i);
        end
    end
   
else
    NewEventList=[];
    return
end
end