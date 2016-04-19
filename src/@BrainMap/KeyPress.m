function KeyPress(obj,src,evt)
if ~isempty(obj.SelectedElectrode)
    electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
    
    ind=find(electrode.selected);
    
    redraw_electrode=false;
    if isempty(evt.Modifier)
        if strcmpi(evt.Key,'leftarrow')
            electrode.coor(ind,:)=...
                perspectiveRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),campos(obj.axis_3d),0,0.05);
            redraw_electrode=true;
        elseif strcmpi(evt.Key,'rightarrow')
            electrode.coor(ind,:)=...
                perspectiveRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),campos(obj.axis_3d),0,-0.05);
            redraw_electrode=true;
        elseif strcmpi(evt.Key,'uparrow')
            electrode.coor(ind,:)=...
                perspectiveRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),campos(obj.axis_3d),0.05,0);
            redraw_electrode=true;
        elseif strcmpi(evt.Key,'downarrow')
            electrode.coor(ind,:)=...
                perspectiveRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),campos(obj.axis_3d),-0.05,0);
            redraw_electrode=true;
        end
    else
        if length(evt.Modifier)==1
            if ismember('command',evt.Modifier)||ismember('control',evt.Modifier)
                if strcmpi(evt.Key,'uparrow')
                    electrode.coor(ind,:)=axialTranslate(electrode.coor(ind,:),camtarget(obj.axis_3d),0.025);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'downarrow')
                    electrode.coor(ind,:)=axialTranslate(electrode.coor(ind,:),camtarget(obj.axis_3d),-0.025);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'leftarrow')
                    electrode.coor(ind,:) = selfRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),-0.06);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'rightarrow')
                    electrode.coor(ind,:) = selfRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),0.06);
                    redraw_electrode=true;
                end
                
            elseif ismember('shift',evt.Modifier)
                if strcmpi(evt.Key,'leftarrow')
                    electrode.coor(ind,:)=...
                        perspectiveRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),campos(obj.axis_3d),0,0.01);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'rightarrow')
                    electrode.coor(ind,:)=...
                        perspectiveRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),campos(obj.axis_3d),0,-0.01);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'uparrow')
                    electrode.coor(ind,:)=...
                        perspectiveRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),campos(obj.axis_3d),0.01,0);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'downarrow')
                    electrode.coor(ind,:)=...
                        perspectiveRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),campos(obj.axis_3d),-0.01,0);
                    redraw_electrode=true;
                end
            end
        elseif length(evt.Modifier)==2
            if ismember('command',evt.Modifier)||ismember('control',evt.Modifier)
                if ismember('shift',evt.Modifier)
                    if strcmpi(evt.Key,'uparrow')
                        electrode.coor(ind,:)=axialTranslate(electrode.coor(ind,:),camtarget(obj.axis_3d),0.005);
                        redraw_electrode=true;
                    elseif strcmpi(evt.Key,'downarrow')
                        electrode.coor(ind,:)=axialTranslate(electrode.coor(ind,:),camtarget(obj.axis_3d),-0.005);
                        redraw_electrode=true;
                    elseif strcmpi(evt.Key,'leftarrow')
                        electrode.coor(ind,:) = selfRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),-0.02);
                        redraw_electrode=true;
                    elseif strcmpi(evt.Key,'rightarrow')
                        electrode.coor(ind,:) = selfRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),0.02);
                        redraw_electrode=true;
                    end
                end
            end
            
        end
    end
    
    if redraw_electrode
        for i=1:length(ind)
            userdat.name=electrode.channame{ind(i)};
            userdat.ele=electrode.ind;
            
            electrode.norm(ind(i),:)=electrode.coor(ind(i),:)-camtarget(obj.axis_3d);
            [faces,vertices] = createContact3D(electrode.coor(ind(i),:),electrode.norm(ind(i),:),electrode.radius(ind(i)),electrode.thickness(ind(i)));
            
            delete(electrode.handles(ind(i)));
            electrode.handles(ind(i))=patch('faces',faces,'vertices',vertices,...
                'facecolor',electrode.color(ind(i),:),'edgecolor','y','UserData',userdat,...
                'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src,evt),'facelighting','gouraud');
        end
        obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)])=electrode;
        
        if electrode.ind==obj.electrode_settings.select_ele
            notify(obj,'ElectrodeSettingsChange')
        end
    end
end



end

