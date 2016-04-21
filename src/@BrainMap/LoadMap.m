function LoadMap(obj)
import javax.swing.SpinnerNumberModel;

if ~isempty(obj.SelectedElectrode)
    electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
    open_dir=fileparts(electrode.file);
    
    if exist([open_dir,'/app/spatial map'],'dir')==7
        open_dir=[open_dir,'/app/spatial map'];
    else
        open_dir='.';
    end
    
    [FileName,FilePath,FilterIndex]=uigetfile({'*.smw;*.txt;*.csv','Spatial Map Files (*.smw;*.txt;*.csv)';...
        '*.smw;*.txt;*csv','Text File (*.smw;*.txt;*csv)'},...
        'select your spatial map file',...
        'MultiSelect','off',...
        open_dir);
    try
        if FileName==0
            return
        end
    catch
    end
    
    mapfiles={fullfile(FilePath,FileName)};
    map=ones(size(electrode.coor,1),length(mapfiles))*nan;
    
    for i=1:length(mapfiles)
        sm=ReadSpatialMap(mapfiles{i});
        [~,ib]=ismember(sm.name,electrode.channame);
        map(ib,i)=sm.val;
    end
    map=mean(map,2);
    electrode.map=map;
    %%
    obj.JMapMinSpinner.getModel().setValue(min(map));
    obj.JMapMaxSpinner.getModel().setValue(max(map));
    %set map alpha value
    obj.JMapAlphaSpinner.setValue(electrode.map_alpha*100);
    obj.JMapAlphaSlider.setValue(electrode.map_alpha*100);
    %%
    %set map colormap
    set(obj.MapColorMapPopup,'value',...
        find(strcmpi(electrode.map_colormap,get(obj.MapColorMapPopup,'UserData'))));
    %%
    electrode=obj.redrawNewMap(electrode);
    
    obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)])=electrode;
    
    if electrode.ind==obj.electrode_settings.select_ele
        notify(obj,'ElectrodeSettingsChange')
    end
end
end



