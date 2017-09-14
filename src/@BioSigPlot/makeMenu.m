function makeMenu(obj)
%**************************************************************************
%First Order Menu------------------------------------------------------File
obj.MenuFile=uimenu(obj.Fig,'Label','File');

obj.MenuNew=uimenu(obj.MenuFile,'Label','New');
obj.MenuNewMontage=uimenu(obj.MenuNew,'Label','Montage','Callback',@(src,evt) obj.NewMontage);

obj.MenuLoad=uimenu(obj.MenuFile,'Label','Load');
obj.MenuLoadDataSet=uimenu(obj.MenuLoad,'Label','Data','Callback',@(src,evt) obj.LoadDataSet);
obj.MenuLoadEvents=uimenu(obj.MenuLoad,'Label','Events','Callback',@(src,evt) obj.LoadEvents);
obj.MenuLoadMontage=uimenu(obj.MenuLoad,'Label','Montage','Callback',@(src,evt) obj.LoadMontage);
obj.MenuLoadFilter=uimenu(obj.MenuLoad,'Label','Filter','Callback',@(src,evt) obj.LoadFilter);
obj.MenuLoadVideo=uimenu(obj.MenuLoad,'Label','Video','Callback',@(src,evt) obj.LoadVideo);
obj.MenuLoadChannelPosition=uimenu(obj.MenuLoad,'Label','Position','Callback',@(src,evt) obj.LoadChannelPosition);
obj.MenuLoadSpatialMaps=uimenu(obj.MenuLoad,'Label','Spatial Maps','Callback',@(src,evt) obj.AverageMapWin.buildfig());

obj.MenuSave=uimenu(obj.MenuFile,'Label','Save');
obj.MenuSaveEvents=uimenu(obj.MenuSave,'Label','Events','Callback',@(src,evt) SaveData(obj,src),'Accelerator','e');
obj.MenuSavePosition=uimenu(obj.MenuSave,'Label','Position','Callback',@(src,evt) SaveData(obj,src));
obj.MenuSaveSettings=uimenu(obj.MenuSave,'Label','Settings','Callback',@(src,evt) SaveData(obj,src));
obj.MenuSaveData=uimenu(obj.MenuSave,'Label','Data','Callback',@(src,evt) SaveData(obj,src));


obj.MenuSaveAs=uimenu(obj.MenuFile,'Label','Save As...');
obj.MenuSaveAsData=uimenu(obj.MenuSaveAs,'Label','Data(sel)','Callback',@(src,evt) SaveData(obj,src),'Accelerator','s');
obj.MenuSaveAsEvents=uimenu(obj.MenuSaveAs,'Label','Events','Callback',@(src,evt) obj.SaveEvents);
obj.MenuSaveAsMontage=uimenu(obj.MenuSaveAs,'Label','Montage','Callback',@(src,evt) obj.SaveMontage);
obj.MenuSaveAsPosition=uimenu(obj.MenuSaveAs,'Label','Position','Callback',@(src,evt) obj.SavePosition);
obj.MenuSaveAsFigure=uimenu(obj.MenuSaveAs,'Label','Figure','Callback',@(src,evt) SaveToFigure(obj,'data'),'Accelerator','p');

obj.MenuExport=uimenu(obj.MenuFile,'Label','Export');
obj.MenuExportObj=uimenu(obj.MenuExport,'Label','Object','Callback',@(src,evt) ExportObjToWorkspace(obj));
obj.MenuExportData=uimenu(obj.MenuExport,'Label','Data(sel)','Callback',@(src,evt) obj.ExportDataToWorkspace);
obj.MenuExportTrials=uimenu(obj.MenuExport,'Label','Trials','Callback',@(src,evt) obj.ExportTrialWin.buildfig());
%**************************************************************************
%First Order Menu--------------------------------------------------Settings
obj.MenuSettings=uimenu(obj.Fig,'Label','Settings');
obj.MenuCommands=uimenu(obj.MenuSettings,'Label','Command List',...
    'Callback',@(src,evts) listdlg('ListString',obj.Commands,'ListSize',[700 500],'PromptString','List of commands'));
obj.MenuConfigurationState=uimenu(obj.MenuSettings,'Label','Configuration file','Callback',@(src,evt) ConfigWindow(obj));
obj.MenuColor=uimenu(obj.MenuSettings,'Label','Color');
obj.MenuSampleRate=uimenu(obj.MenuSettings,'Label','Sample Rate','Callback',@(src,evt) MnuSampleRate(obj),'Accelerator','r');
%Second Order Menu of Color
obj.MenuColorCanvas=uimenu(obj.MenuColor,'Label','Canvas','Accelerator','b',...
    'Callback',@(src,evt) set(obj,'AxesBackgroundColor',uisetcolor(obj.AxesBackgroundColor,'AxesBackground Color')));
obj.MenuColorLines=uimenu(obj.MenuColor,'Label','Lines','Accelerator','l',...
    'Callback',@(src,evt) MnuLineColor(obj));
obj.MenuFigurePosition=uimenu(obj.MenuSettings,'Label','Figure Position',...
    'Callback',@(src,evts) MnuFigurePosition(obj));
obj.MenuOverwritePreprocess=uimenu(obj.MenuSettings,'Label','Overwrite Preprocess',...
    'Callback',@(src,evt) MnuOverwritePreprocess(obj),'Accelerator','o');

obj.MenuVideo=uimenu(obj.MenuSettings,'Label','Video');

obj.MenuPlaySpeed=uimenu(obj.MenuVideo,'Label','Speed','Callback',@(src,evt) MnuPlay(obj));
obj.MenuVideoStartEnd=uimenu(obj.MenuVideo,'Label','Start&End','Callback',@(src,evt) MnuVideoStartEnd(obj));
obj.MenuVideoOnTop=uimenu(obj.MenuVideo,'Label','Stay On Top','Callback',@(src,evt) MnuVideoOnTop(obj),'checked','on');
obj.MenuNotchFilter=uimenu(obj.MenuSettings,'Label','Notch Filter');
obj.MenuNotchFilterSingle=uimenu(obj.MenuNotchFilter,'Label','Single','checked','on','Callback',@(src,evt) ChangeFilter(obj,src));
obj.MenuNotchFilterHarmonics=uimenu(obj.MenuNotchFilter,'Label','Harmonics','checked','off','Callback',@(src,evt) ChangeFilter(obj,src));

%**************************************************************************
%First Order Menu------------------------------------------------------Data
obj.MenuChannel=uimenu(obj.Fig,'Label','Data');
obj.MenuDataBuffer=uimenu(obj.MenuChannel,'Label','Buffer','Callback',@(src,evt)MnuDataBuffer(obj,src));
obj.MenuChannelNumber=uimenu(obj.MenuChannel,'Label','Channels/Page','Callback',@(src,evt) MnuChan2Display(obj));
obj.MenuDetrend=uimenu(obj.MenuChannel,'Label','Detrend');
obj.MenuDetrendConstant=uimenu(obj.MenuDetrend,'Label','Constant','Callback',@(src,evt)DetrendData(obj,src));
obj.MenuDetrendLinear=uimenu(obj.MenuDetrend,'Label','Linear','Callback',@(src,evt)DetrendData(obj,src));
obj.MenuDownSample=uimenu(obj.MenuChannel,'Label','Downsample');
obj.MenuSaveDownSample=uimenu(obj.MenuDownSample,'Label','For Save','callback',@(src,evts) MnuDownSample(obj,src));
obj.MenuVisualDownSample=uimenu(obj.MenuDownSample,'Label','For Visualization','callback',@(src,evts) MnuDownSample(obj,src));
obj.MenuRecordingTime=uimenu(obj.MenuSettings,'Label','Recording Time','callback',@(src,evts)MnuRecordingTime(obj,src));
%First Order Menu---------------------------------------------------Montage
obj.MenuMontage=uimenu(obj.Fig,'Label','Montage');
%**************************************************************************
%First Order Menu-----------------------------------------------------Event
obj.MenuEvent=uimenu(obj.Fig,'Label','Event');
obj.MenuNewEvent=uimenu(obj.MenuEvent,'Label','New','Callback',@(src,evt)NewEvent(obj),'Accelerator','n');
obj.MenuFastEvent=uimenu(obj.MenuEvent,'Label','Fast Event','Callback',@(src,evt)obj.WinFastEvts.buildfig());
obj.MenuAdvanceEvents=uimenu(obj.MenuEvent,'Label','Trigger');
obj.MenuAdvanceEventsCalculate=uimenu(obj.MenuAdvanceEvents,'Label','Detect',...
    'Callback',@(src,evt) AdvanceEvents(obj,src),'Accelerator','t');
obj.MenuAdvanceEventsDisplay=uimenu(obj.MenuAdvanceEvents,'Label','Display',...
    'CallBack',@(src,evt) set(obj,'AdvanceEventsDisplay',~obj.AdvanceEventsDisplay));
obj.MenuAdvanceEventsRefresh=uimenu(obj.MenuAdvanceEvents,'Label','Refresh',...
    'Separator','on','Callback',@(src,evt) scanTriggerFunction(obj));
obj.MenuAdvanceEventsFunction=uimenu(obj.MenuAdvanceEvents,'Label','$/db/trigger');

%First Order Menu---------------------------------------------------Display
obj.MenuDisplay=uimenu(obj.Fig,'Label','Display');
obj.MenuDisplayBuffer=uimenu(obj.MenuDisplay,'Label','Buffer','Callback',@(src,evt)MnuDisplayBuffer(obj,src));
obj.MenuToolbarDisplay=uimenu(obj.MenuDisplay,'Label','Toolbar',...
    'Callback',@(src,evt) set(obj,'ToolbarDisplay',~obj.ToolbarDisplay));
obj.MenuEventsDisplay=uimenu(obj.MenuDisplay,'Label','Events',...
    'Callback',@(src,evt) set(obj,'EventsDisplay',~obj.EventsDisplay));
obj.MenuXGrid=uimenu(obj.MenuDisplay,'Label','XGrid',...
    'Callback',@(src,evt) set(obj,'XGrid',~obj.XGrid));
obj.MenuYGrid=uimenu(obj.MenuDisplay,'Label','YGrid',...
    'Callback',@(src,evt) set(obj,'YGrid',~obj.YGrid));
obj.MenuGauge=uimenu(obj.MenuDisplay,'Label','Gauge',...
    'Callback', @(src,evt) set(obj,'DisplayGauge',~obj.DisplayGauge));
obj.MenuTimeLabel=uimenu(obj.MenuDisplay,'Label','Time Label',...
    'Callback', @(src,evt) showTimeLabel(obj,src),'checked','on');
obj.MenuChannelLabel=uimenu(obj.MenuDisplay,'Label','Channel Label',...
    'Callback', @(src,evt) showChannelLabel(obj,src),'checked','on');

obj.Menupanels=uimenu(obj.MenuDisplay,'Label','Panels');
obj.MenuEventsWindow=uimenu(obj.Menupanels,'Label','Events',...
    'Callback',@(src,evt) set(obj,'EventsWindowDisplay',~obj.EventsWindowDisplay));
obj.MenuControlPanel=uimenu(obj.Menupanels,'Label','Control',...
    'Callback',@(src,evt) set(obj,'ControlPanelDisplay',~obj.ControlPanelDisplay));

%First Order Menu-------------------------------------------------------App
obj.MenuApp=uimenu(obj.Fig,'Label','Apps');


%**************TFMap*******************************************************
obj.MenuPSD=uimenu(obj.MenuApp,'Label','Power Spectrum Density','callback',@(src,evt)obj.PSDWin.buildfig());
obj.MenuTFMap=uimenu(obj.MenuApp,'Label','Time Frequency Map','callback',@(src,evt)obj.TFMapWin.buildfig());
obj.MenuSpatialMap=uimenu(obj.MenuApp,'Label','Spatial Spectral Map','callback',@(src,evt) obj.SpatialMapWin.buildfig());
obj.MenuRawMap=uimenu(obj.MenuApp,'Label','Raw Data Map','callback',@(src,evt) obj.RawMapWin.buildfig());
obj.MenuSignalMap=uimenu(obj.MenuApp,'Label','Signal Map','callback',@(src,evt)obj.SignalMapWin.buildfig());

obj.MenuCrossCorr=uimenu(obj.MenuApp,'Label','Cross Correlation');

obj.MenuCrossCorrRaw=uimenu(obj.MenuCrossCorr,'Label','Raw Data',...
    'Callback', @(src,evt) CrossCorrelation(obj,src));
obj.MenuCrossCorrEnv=uimenu(obj.MenuCrossCorr,'Label','Envelope',...
    'Callback',@(src,evt) CrossCorrelation(obj,src));

obj.MenuCohere=uimenu(obj.MenuApp,'Label','Coherence');

obj.MenuCohereRaw=uimenu(obj.MenuCohere,'Label','Raw Data',...
    'Callback', @(src,evt) Coherence(obj,src));
obj.MenuCohereEnv=uimenu(obj.MenuCohere,'Label','Envelope',...
    'Callback',@(src,evt) Coherence(obj,src));

obj.MenuCSP=uimenu(obj.MenuApp,'Label','Common Spatial Pattern',...
    'Callback', @(src,evt) obj.CSPMapWin.buildfig());

obj.MenuAppDenoise=uimenu(obj.MenuApp,'Label','Denoise','Separator','on');
obj.MenuMeanRef=uimenu(obj.MenuAppDenoise,'Label','Mean Reference',...
    'Callback', @(src,evt) Mean_Reference_Filter(obj));
obj.MenuInterpolate=uimenu(obj.MenuAppDenoise,'Label','Interpolate',...
    'Callback',@(src,evt)obj.InterpolateWin.buildfig());
obj.MenuRemovePulse=uimenu(obj.MenuAppDenoise,'Label','Pulse Artifact Remove',...
    'Callback', @(src,evt) Auto_Remove_Pulse_Artifact(obj));
obj.MenuSpatialPCA=uimenu(obj.MenuAppDenoise,'Label','Spatial PCA',...
    'Callback', @(src,evt)Spatial_PCA(obj));
obj.MenuTemporalPCA=uimenu(obj.MenuAppDenoise,'Label','Temporal PCA',...
    'Callback', @(src,evt) Temporal_PCA(obj));
end