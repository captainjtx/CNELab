classdef BrainMap < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties (Dependent)
        valid
        cnelab_path
    end
    
    properties
        fig
        axis_3d
        
        FileMenu
        LoadMenu
        LoadVolumeMenu
        LoadSurfaceMenu
        LoadElectrodeMenu
        
        SaveAsMenu
        SaveAsFigureMenu
        SettingsMenu
        SettingsBackgroundColorMenu
        
        ViewPanel
        
        Toolbar
        JToolbar
        
        JRecenter
        
        JFileLoadTree
        JLight
        JCanvasColor
        
        IconLightOn
        IconLightOff
        
        IconLoadSurface
        IconDeleteSurface
        IconNewSurface
        IconSaveSurface
        
        IconLoadVolume
        IconDeleteVolume
        IconNewVolume
        IconSaveVolume
        
        IconLoadElectrode
        IconDeleteElectrode
        IconNewElectrode
        IconSaveElectrode
        
        
        JLoadBtn
        JDeleteBtn
        JNewBtn
        JSaveBtn
        
        sidepane
        toolbtnpane
        
        surfacetoolpane
        electrodetoolpane
        volumetoolpane
        
        JSurfaceAlphaSpinner
        JSurfaceAlphaSlider
        ColorMapPopup
        
        JVolumeMinSpinner
        JVolumeMaxSpinner
        
        JElectrodeColorBtn
        JExtraBtn1
        JExtraBtn2
        
        JElectrodeRadiusSpinner
        JElectrodeThicknessSpinner
        
        IconInterpolateElectrode
        IconLoadMap
        
        HExtraBtn1
        HExtraBtn2
        
        JSettingsBtn
    end
    properties
        light
        RotateTimer
        ZoomTimer
        loc
        
        inView
        
        mapObj
        
        SelectEvt
        
        cmin
        cmax
        
        SelectedElectrode
        
        electrode_settings
    end
    
    methods
        function obj=BrainMap()
            
            obj.varinit();
            
            obj.electrode_settings=ElectrodeSettings(obj);
            obj.BuildFig();
        end
        
        function val=get.cnelab_path(obj)
            [val,~,~]=fileparts(which('cnelab.m'));
        end
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
            end
        end
        function varinit(obj)
            
            
            obj.light=[];
            obj.inView=[];
            
            obj.mapObj=containers.Map;
            
            obj.SelectEvt.category='Volume';
            
            obj.cmin=50;
            obj.cmax=140;
        end
        
        function OnClose(obj)
            try
                delete(obj.fig);
            catch
            end
            try
                delete(obj.RotateTimer)
            catch
            end
            obj.electrode_settings.OnClose();
        end
        
        function f=panon(obj)
            f=strcmp(get(pan(obj.fig),'Enable'),'on');
        end
        
        function MouseDown_View(obj)
            obj.loc = get(obj.fig,'CurrentPoint');    % get starting point
            start(obj.RotateTimer);
            set(obj.fig,'windowbuttonupfcn',@(src,evt) MouseUp_View(obj));
        end
        function f=isIn(obj,cursor,position)
            f=cursor(1)>position(1)&&cursor(1)<position(1)+position(3)&&cursor(2)>position(2)&&cursor(2)<position(2)+position(4);
        end
        function MouseMove(obj)
            position = getpixelposition(obj.ViewPanel);
            cursor=get(obj.fig,'CurrentPoint');
            in_view=obj.isIn(cursor,position);
            
            %within the view panel
            f=obj.panon();
            if ~f
                if in_view&&~obj.inView
                    set(obj.fig,'WindowButtonDownFcn',@(src,evt)MouseDown_View(obj));
                    set(obj.fig,'WindowScrollWheelFcn',@(src,evt)Scroll_View(obj,src,evt));
                    
                elseif ~in_view&&obj.inView
                    set(obj.fig,'WindowButtonDownFcn',[]);
                    set(obj.fig,'WindowScrollWheelFcn',[]);
                end
            end
            
            obj.inView=in_view;
        end
        
        function MouseUp_View(obj)
            %             set(obj.fig,'windowbuttonmotionfcn',[]);    % unassign windowbuttonmotionfcn
            set(obj.fig,'windowbuttonupfcn',[]);        % unassign windowbuttonupfcn
            stop(obj.RotateTimer);
        end
        
        function RotateTimerCallback(obj)
            locend = get(obj.fig, 'CurrentPoint'); % get mouse location
            dx = locend(1) - obj.loc(1);           % calculate difference x
            dy = locend(2) - obj.loc(2);           % calculate difference y
            factor = 2;                         % correction mouse -> rotation
            camorbit(obj.axis_3d,-dx/factor,-dy/factor);
            
            if ~isempty(obj.light)
                obj.light = camlight(obj.light,'headlight');        % adjust light
            end
            obj.loc=locend;
        end
        
        function Scroll_View(obj,src,evt)
            vt=-evt.VerticalScrollCount;
            factor=1.05^vt;
            camzoom(factor);
        end
        
        function SaveAsFigure(obj)
            position=getpixelposition(obj.ViewPanel);
            figpos=get(obj.fig,'position');
            position(1)=position(1)+figpos(1);
            position(2)=position(2)+figpos(2);
            f=figure('Name','Axis 3D','Position',position,'visible','on','color',get(obj.ViewPanel,'BackgroundColor'));
            copyobj(obj.axis_3d,f);
            colormap(colormap(obj.axis_3d));
        end
        
        function RecenterCallback(obj)
            view(3);
            if ~isempty(obj.light)
                obj.light = camlight(obj.light,'headlight');        % adjust light
            end
            set(obj.axis_3d,'CameraViewAngle',10);
        end
        
        
        
        function CheckChangedCallback(obj,src,evt)
            mapval=obj.mapObj(char(evt.getKey()));
            if evt.ischecked
                set(mapval.handles,'visible','on');
                mapval.checked=true;
            else
                set(mapval.handles,'visible','off');
                mapval.checked=false;
            end
            obj.mapObj(char(evt.getKey()))=mapval;
            if mapval.ind==obj.electrode_settings.select_ele
                notify(obj,'ElectrodeSettingsChange')
            end
            
            %             disp(evt.filename)
            %             disp(evt.ischecked)
        end
        
        function LightOffCallback(obj)
            obj.JLight.setIcon(obj.IconLightOn);
            obj.JLight.setToolTipText('Light on');
            delete(findobj(obj.axis_3d,'type','light'));
            obj.light=[];
            set(handle(obj.JLight,'CallbackProperties'),'MousePressedCallback',@(h,e) LightOnCallback(obj));
        end
        
        function LightOnCallback(obj)
            obj.JLight.setIcon(obj.IconLightOff);
            obj.JLight.setToolTipText('Light off');
            obj.light=camlight('headlight','infinite');
            set(handle(obj.JLight,'CallbackProperties'),'MousePressedCallback',@(h,e) LightOffCallback(obj));
        end
        
        
        function DeleteSurface(obj)
            
        end
        
        function DeleteVolume(obj)
        end
        function DeleteElectrode(obj)
        end
        
        function NewElectrode(obj)
        end
        function NewSurface(obj)
        end
        function NewVolume(obj)
        end
        
        function SaveVolume(obj)
        end
        function SaveSurface(obj)
        end
        function SurfaceAlphaSpinnerCallback(obj)
            
            alpha=obj.JSurfaceAlphaSpinner.getValue();
            
            obj.JSurfaceAlphaSlider.setValue(alpha);
            drawnow
            if ~isempty(obj.SelectEvt)&&obj.SelectEvt.level==2
                mapval=obj.mapObj(char(obj.SelectEvt.getKey()));
                set(mapval.handles,'facealpha',alpha/100);
            end
        end
        
        function SurfaceAlphaSliderCallback(obj)
            alpha=obj.JSurfaceAlphaSlider.getValue();
            
            obj.JSurfaceAlphaSpinner.setValue(alpha);
            drawnow
            if ~isempty(obj.SelectEvt)&&obj.SelectEvt.level==2
                mapval=obj.mapObj(char(obj.SelectEvt.getKey()));
                set(mapval.handles,'facealpha',alpha/100);
            end
        end
        
        function ChangeCanvasColor(obj)
            set(obj.ViewPanel,'BackgroundColor',uisetcolor(get(obj.ViewPanel,'BackgroundColor'),'Background'))
        end
        
        function ColormapCallback(obj)
            %extraction of colormap name from popupmenu
            htmlList = get(obj.ColorMapPopup,'String');
            listIdx = get(obj.ColorMapPopup,'Value');
            removedHTML = regexprep(htmlList{listIdx},'<[^>]*>','');
            cmapName = strrep(strrep(strrep(removedHTML,'_',''),'>',''),'-','');
            cmapFun = str2func(['@(x) ' lower(cmapName) '(x)']);
            colormap(obj.axis_3d,cmapFun(16));
        end
        function VolumeScaleSpinnerCallback(obj)
            
            min=obj.JVolumeMinSpinner.getValue();
            max=obj.JVolumeMaxSpinner.getValue();
            
            drawnow
            
            if min<max
                obj.cmin=min;
                obj.cmax=max;
                set(obj.axis_3d,'clim',[obj.cmin/255,obj.cmax/255]);
            end
        end
        function ElectrodeColorCallback(obj)
            col=[ obj.JElectrodeColorBtn.getBackground().getRed(),...
                obj.JElectrodeColorBtn.getBackground().getGreen(),...
                obj.JElectrodeColorBtn.getBackground().getBlue()]/255;
            
            newcol=uisetcolor(col,'Electrode');
            obj.JElectrodeColorBtn.setBackground(java.awt.Color(newcol(1),newcol(2),newcol(2)));
            
            if ~isempty(obj.SelectedElectrode)
                electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
                set(electrode.handles(logical(electrode.selected)),'facecolor',newcol);
                
                electrode.color(logical(electrode.selected),:)=ones(sum(electrode.selected),1)*newcol;
                obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)])=electrode;
                if electrode.ind==obj.electrode_settings.select_ele
                    notify(obj,'ElectrodeSettingsChange')
                end
            end
        end
        
        function ElectrodeSpinnerCallback(obj)
            r=obj.JElectrodeRadiusSpinner.getValue();
            thick=obj.JElectrodeThicknessSpinner.getValue();
            if ~isempty(obj.SelectedElectrode)
                electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
                ind=find(electrode.selected);
                
                electrode.thickness(ind)=thick;
                electrode.radius(ind)=r;
                for i=1:length(ind)
                    userdat.name=electrode.channame{ind(i)};
                    userdat.ele=obj.SelectedElectrode;
                    
                    [faces,vertices] = createContact3D...
                        (electrode.coor(ind(i),:),electrode.norm(ind(i),:),electrode.radius(ind(i)),electrode.thickness(ind(i)));
                    delete(electrode.handles(ind(i)));
                    
                    if electrode.selected(ind(i))
                        edgecolor='y';
                    else
                        edgecolor='none';
                    end
                        
                    electrode.handles(ind(i))=patch('faces',faces,'vertices',vertices,...
                        'facecolor',electrode.color(ind(i),:),'edgecolor',edgecolor,'UserData',userdat,...
                        'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src),'facelighting','gouraud');
                end
                material dull;
                obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)])=electrode;
                if electrode.ind==obj.electrode_settings.select_ele
                    notify(obj,'ElectrodeSettingsChange')
                end
            end
        end
        function ClickOnElectrode(obj,src,evt)
            dat=get(src,'UserData');
            electrode=obj.mapObj(['Electrode',num2str(dat.ele)]);
            type=get(obj.fig,'selectiontype');

            datind=strcmp(dat.name,electrode.channame);
            switch type
                case 'normal'
                    electrode.selected=ones(size(electrode.selected))*false;
                    electrode.selected(datind)=true;
                case 'alt'
                    electrode.selected(datind)=~electrode.selected(datind);
            end
            
            set(electrode.handles,'edgecolor','none');
            set(electrode.handles(logical(electrode.selected)),'edgecolor','y');
            
            obj.mapObj(['Electrode',num2str(dat.ele)])=electrode;
            obj.SelectedElectrode=dat.ele;
            
            if electrode.ind==obj.electrode_settings.select_ele
                notify(obj,'ElectrodeSettingsChange')
            end
        end
        

        
        function maps=getCheckedObjects(obj,opt)
            allvalues=obj.mapObj.values;
            maps={};
            for i=1:length(allvalues)
                if strcmpi(allvalues{i}.category,opt)
                    if allvalues{i}.checked
                        maps=cat(1,maps,allvalues(i));
                    end
                end
            end
        end
        
        function VolumeSettingsCallback(obj)
        end
        function ElectrodeSettingsCallback(obj)
            obj.electrode_settings.buildfig();
        end
        function SurfaceSettingsCallback(obj)
        end
    end
    methods
        LoadSurface(obj)
        LoadElectrode(obj)
        BuildToolbar(obj)
        BuildIOBar(obj)
        BuildFig(obj)
        TreeSelectionCallback(obj,src,evt)
        SaveElectrode(obj)
        ElectrodeInterpolateCallback(obj)
        LoadMap(obj)
    end
    events
        ElectrodeSettingsChange
    end
end