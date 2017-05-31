function scanTriggerFunction(obj)
%This function scans the following folder:
%"db/filters"
%for customized filters

delete(get(obj.MenuAdvanceEventsFunction,'Children'));
listing=dir([obj.CNELabDir,'/db/trigger/*.m']);

for i=1:length(listing)
    [~, name, ~] = fileparts(listing(i).name);
    h=uimenu(obj.MenuAdvanceEventsFunction,'Label',name,...
            'Callback',@(src,evt)AdvanceEvents(obj,src));
end

end

