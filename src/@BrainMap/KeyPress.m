function KeyPress(obj,src,evt)
electrode=obj.mapObj(char(obj.SelectEvt.getKey()));
if isempty(evt.Modifier)
    if strcmpi(evt.Key,'leftarrow')
        electrode.coor=bmrotate(obj,electrode.coor,0,0.05);
    elseif strcmpi(evt.Key,'rightarrow')
        electrode.coor=bmrotate(obj,electrode.coor,0,-0.05);
    elseif strcmpi(evt.Key,'uparrow')
        electrode.coor=bmrotate(obj,electrode.coor,0.05,0);
    elseif strcmpi(evt.Key,'downarrow')
        electrode.coor=bmrotate(obj,electrode.coor,-0.05,0);
    end
else
    
    if length(evt.Modifier)==1
        if ismember('command',evt.Modifier)||ismember('control',evt.Modifier)
            if strcmpi(evt.Key,'uparrow')
                electrode.coor = selfRotate(electrode.coor,camtarget,-0.06);
            elseif strcmpi(evt.Key,'downarrow')
                electrode.coor = selfRotate(electrode.coor,camtarget,0.06);
            elseif strcmpi(evt.Key,'leftarrow')
            elseif strcmpi(evt.Key,'rightarrow')
            end
            
        elseif ismember('shift',evt.Modifier)
            if strcmpi(evt.Key,'leftarrow')
                electrode.coor=bmrotate(obj,electrode.coor,0,0.01);
            elseif strcmpi(evt.Key,'rightarrow')
                electrode.coor=bmrotate(obj,electrode.coor,0,-0.01);
            elseif strcmpi(evt.Key,'uparrow')
                electrode.coor=bmrotate(obj,electrode.coor,0.01,0);
            elseif strcmpi(evt.Key,'downarrow')
                electrode.coor=bmrotate(obj,electrode.coor,-0.01,0);
            end
        end
    elseif length(evt.Modifier)==2
        if ismember('command',evt.Modifier)||ismember('control',evt.Modifier)
            if ismember('shift',evt.Modifier)
                if strcmpi(evt.Key,'uparrow')
                    electrode.coor = selfRotate(electrode.coor,camtarget,-0.02);
                elseif strcmpi(evt.Key,'downarrow')
                    electrode.coor = selfRotate(electrode.coor,camtarget,0.02);
                elseif strcmpi(evt.Key,'leftarrow')
                elseif strcmpi(evt.Key,'rightarrow')
                end
            end
        end
        
    end
end

delete(electrode.handles);
for i=1:size(electrode.coor,1)
    userdat.ind=i;
    userdat.select=false;
    electrode.norm(i,:)=electrode.coor(i,:)-camtarget;
    [faces,vertices] = createContact3D(electrode.coor(i,:),electrode.norm(i,:),electrode.radius(i),electrode.thickness(i));
    
    electrode.handles(i)=patch('faces',faces,'vertices',vertices,...
        'facecolor',electrode.color(i,:),'edgecolor','none','UserData',userdat,...
        'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src),'facelighting','gouraud');
end

obj.mapObj(char(obj.SelectEvt.getKey()))=electrode;

end

