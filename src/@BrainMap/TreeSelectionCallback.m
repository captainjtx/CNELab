function TreeSelectionCallback(obj,src,evt)
if ~strcmpi(obj.SelectEvt.category,evt.category)
    if strcmpi(evt.category,'Volume')
        obj.JLoadBtn.setIcon(obj.IconLoadVolume);
        obj.JLoadBtn.setToolTipText('Load volume');
        
        obj.JDeleteBtn.setIcon(obj.IconDeleteVolume);
        obj.JDeleteBtn.setToolTipText('Delete volume');
        
        obj.JNewBtn.setIcon(obj.IconNewVolume);
        obj.JNewBtn.setToolTipText('New volume');
        
        obj.JSaveBtn.setIcon(obj.IconSaveVolume);
        obj.JSaveBtn.setToolTipText('Save volume');
        
        set(obj.HExtraBtn1,'visible','off');
        
        set(handle(obj.JLoadBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) LoadVolume(obj));
        set(handle(obj.JDeleteBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) DeleteVolume(obj));
        set(handle(obj.JNewBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) NewVolume(obj));
        set(handle(obj.JSaveBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) SaveVolume(obj));
        
        set(obj.volumetoolpane,'visible','on');
        set(obj.surfacetoolpane,'visible','off');
        set(obj.electrodetoolpane,'visible','off');
    elseif strcmpi(evt.category,'Surface')
        obj.JLoadBtn.setIcon(obj.IconLoadSurface);
        obj.JLoadBtn.setToolTipText('Load surface');
        
        obj.JDeleteBtn.setIcon(obj.IconDeleteSurface);
        obj.JDeleteBtn.setToolTipText('Delete surface');
        
        obj.JNewBtn.setIcon(obj.IconNewSurface);
        obj.JNewBtn.setToolTipText('New surface');
        
        obj.JSaveBtn.setIcon(obj.IconSaveSurface);
        obj.JSaveBtn.setToolTipText('Save surface');
        
        set(obj.HExtraBtn1,'visible','off');
        
        set(handle(obj.JLoadBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) LoadSurface(obj));
        set(handle(obj.JDeleteBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) DeleteSurface(obj));
        set(handle(obj.JNewBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) NewSurface(obj));
        set(handle(obj.JSaveBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) SaveSurface(obj));
        
        set(obj.volumetoolpane,'visible','off');
        set(obj.surfacetoolpane,'visible','on');
        set(obj.electrodetoolpane,'visible','off');
        
        if evt.level==2
            electrode=obj.mapObj(char(evt.getKey()));
            alpha=get(electrode.handles,'facealpha');
            obj.JSurfaceAlphaSpinner.setValue(round(alpha*100));
            obj.JSurfaceAlphaSlider.setValue(round(alpha*100));
        end
    elseif strcmpi(evt.category,'Electrode')
        obj.JLoadBtn.setIcon(obj.IconLoadElectrode);
        obj.JLoadBtn.setToolTipText('Load electrode');
        
        obj.JDeleteBtn.setIcon(obj.IconDeleteElectrode);
        obj.JDeleteBtn.setToolTipText('Delete electrode');
        
        obj.JNewBtn.setIcon(obj.IconNewElectrode);
        obj.JNewBtn.setToolTipText('New electrode');
        
        obj.JSaveBtn.setIcon(obj.IconSaveElectrode);
        obj.JSaveBtn.setToolTipText('Save electrode');
        
        set(obj.HExtraBtn1,'visible','on');
        
        set(handle(obj.JLoadBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) LoadElectrode(obj));
        set(handle(obj.JDeleteBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) DeleteElectrode(obj));
        set(handle(obj.JNewBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) NewElectrode(obj));
        set(handle(obj.JSaveBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) SaveElectrode(obj));
        
        set(obj.volumetoolpane,'visible','off');
        set(obj.surfacetoolpane,'visible','off');
        set(obj.electrodetoolpane,'visible','on');
    elseif strcmpi(evt.category,'Others')
        
    end
end

if strcmpi(evt.category,'Electrode')&&evt.level==2
    electrode=obj.mapObj(char(evt.getKey()));
    electrode.selected=ones(size(electrode.coor,1),1)*true;
    set(electrode.handles,'edgecolor','y');
    obj.mapObj(char(evt.getKey()))=electrode;
    obj.SelectedElectrode=electrode.ind;
else
    if strcmpi(obj.SelectEvt.category,'Electrode')&&obj.SelectEvt.level==2
        electrode=obj.mapObj(char(obj.SelectEvt.getKey()));
        electrode.selected=ones(size(electrode.coor,1),1)*false;
        electrode=obj.mapObj(char(obj.SelectEvt.getKey()));
        set(electrode.handles,'edgecolor','none');
        obj.mapObj(char(obj.SelectEvt.getKey()))=electrode;
        obj.SelectedElectrode=[];
    end
end


obj.SelectEvt=evt;

end