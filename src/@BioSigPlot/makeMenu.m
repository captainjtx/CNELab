function makeMenu(obj)
%**************************************************************************
%First Order Menu------------------------------------------------------File
obj.MenuFile=uimenu(obj.Fig,'Label','File');

obj.MenuImport=uimenu(obj.MenuFile,'Label','Import');
obj.MenuImportDataSet=uimenu(obj.MenuImport,'Label','Data','Callback',@(src,evt) obj.ImportDataSet);
obj.MenuImportEvents=uimenu(obj.MenuImport,'Label','Events','Callback',@(src,evt) obj.ImportEvents);
obj.MenuImportMontage=uimenu(obj.MenuImport,'Label','Montage','Callback',@(src,evt) obj.ImportMontage);
obj.MenuImportFilter=uimenu(obj.MenuImport,'Label','Filter','Callback',@(src,evt) obj.ImportFilter);
obj.MenuImportVideo=uimenu(obj.MenuImport,'Label','Video','Callback',@(src,evt) obj.ImportVideo);

obj.MenuExport=uimenu(obj.MenuFile,'Label','Export');
obj.MenuExportData=uimenu(obj.MenuExport,'Label','Selected Data','Callback',@(src,evt) obj.ExportData);
obj.MenuExportEvents=uimenu(obj.MenuExport,'Label','Events','Callback',@(src,evt) obj.ExportEvents);
obj.MenuExportMontage=uimenu(obj.MenuExport,'Label','Montage','Callback',@(src,evt) obj.ExportMontage);
obj.MenuExportFigure=uimenu(obj.MenuExport,'Label','Figure');
obj.MenuExportFigureMirror=uimenu(obj.MenuExportFigure,'Label','Mirror','Callback',@(src,evt) obj.ExportToFigure,'Accelerator','p');
obj.MenuExportFigureAdvanced=uimenu(obj.MenuExportFigure,'Label','Advanced','Callback',@(src,evt) obj.ExportToWindow);


obj.MenuCopy=uimenu(obj.MenuFile,'Label','Copy','Enable','off');

obj.MenuSave=uimenu(obj.MenuFile,'Label','Save');
obj.MenuSaveAs=uimenu(obj.MenuFile,'Label','Save As');
%**************************************************************************
%First Order Menu--------------------------------------------------Settings
obj.MenuSettings=uimenu(obj.Fig,'Label','Settings');
obj.MenuCommands=uimenu(obj.MenuSettings,'Label','Command List',...
    'Callback',@(src,evts) listdlg('ListString',obj.Commands,'ListSize',[700 500],'PromptString','List of commands'));
obj.MenuConfigurationState=uimenu(obj.MenuSettings,'Label','Configuration file','Callback',@(src,evt) ConfigWindow(obj));
obj.MenuPlaySpeed=uimenu(obj.MenuSettings,'Label','Play speed','Callback',@(src,evt) MnuPlay(obj));
obj.MenuColor=uimenu(obj.MenuSettings,'Label','Color');
obj.MenuSampleRate=uimenu(obj.MenuSettings,'Label','Sample Rate','Callback',@(src,evt) MnuSampleRate(obj),'Accelerator','r');
obj.MenuVideoStartEnd=uimenu(obj.MenuSettings,'Label','Video Start End','Callback',@(src,evt) MnuVideoStartEnd(obj));
%Second Order Menu of Color
obj.MenuColorCanvas=uimenu(obj.MenuColor,'Label','Canvas','Accelerator','b',...
    'Callback',@(src,evt) set(obj,'AxesBackgroundColor',uisetcolor(obj.AxesBackgroundColor,'AxesBackground Color')));
obj.MenuColorLines=uimenu(obj.MenuColor,'Label','Lines','Accelerator','l',...
    'Callback',@(src,evt) set(obj,'ChanColors',obj.applyPanelVal(obj.ChanColors_,uisetcolor(obj.NormalModeColor,'Line Color'))));
%**************************************************************************
%First Order Menu------------------------------------------------------Data
obj.MenuChannel=uimenu(obj.Fig,'Label','Data');
obj.MenuChannelNumber=uimenu(obj.MenuChannel,'Label','Channels/Page','Callback',@(src,evt) MnuChan2Display(obj));
obj.MenuChannelWidth=uimenu(obj.MenuChannel,'Label','Time/Page','Callback',@(src,evt) MnuWidth2Display(obj));
obj.MenuMask=uimenu(obj.MenuChannel,'Label','Mask','Callback',@(src,evt) maskChannel(obj,src));
obj.MenuClearMask=uimenu(obj.MenuChannel,'Label','UnMask','Callback',@(src,evt) maskChannel(obj,src));
obj.MenuGain=uimenu(obj.MenuChannel,'Label','Gain','Callback',@(src,evt) MnuChanGain(obj,src));
obj.MenuAutoScale=uimenu(obj.MenuChannel,'Label','Auto Scale','Callback',@(src,evt) ChangeGain(obj,src));
obj.MenuDetrend=uimenu(obj.MenuChannel,'Label','Detrend','Callback',@(src,evt) DetrendData(obj,src));

%First Order Menu---------------------------------------------------Montage
obj.MenuMontage=uimenu(obj.Fig,'Label','Montage');
%**************************************************************************
%First Order Menu-----------------------------------------------------Event
obj.MenuEvent=uimenu(obj.Fig,'Label','Event');
obj.MenuFastEvent=uimenu(obj.MenuEvent,'Label','Fast Event','Callback',@(src,evt) WinFastEvents(obj));
obj.MenuEventDelete=uimenu(obj.MenuEvent,'Label','Delete','Callback',@(src,evt) deleteSelected(obj));
obj.MenuEventDelete=uimenu(obj.MenuEvent,'Label','Group Delete','Callback',@(src,evt) groupDeleteSelected(obj));

obj.MenuTriggerEvents=uimenu(obj.MenuEvent,'Label','Advance','Separator','on');
obj.MenuTriggerEventsCalculate=uimenu(obj.MenuTriggerEvents,'Label','Detect',...
    'Callback',@(src,evt) TriggerEvents(obj,src));
obj.MenuTriggerEventsFunction=uimenu(obj.MenuTriggerEvents,'Label','Function',...
    'Callback',@(src,evt) TriggerEvents(obj,src));
obj.MenuTriggerEventsQRS=uimenu(obj.MenuTriggerEventsFunction,'Label','EKG(QRS)',...
    'CallBack',@(src,evt) TriggerEvents(obj,src),'checked','off');
obj.MenuTriggerEventsLoad=uimenu(obj.MenuTriggerEventsFunction,'Label','Load',...
    'Separator','on','Callback',@(src,evt) TriggerEvents(obj,src));
obj.MenuTriggerEventsDisplay=uimenu(obj.MenuTriggerEvents,'Label','Display',...
    'CallBack',@(src,evt) set(obj,'TriggerEventsDisplay',~obj.TriggerEventsDisplay));

%First Order Menu---------------------------------------------------Display
obj.MenuDisplay=uimenu(obj.Fig,'Label','Display');
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
obj.MenuEventsWindow=uimenu(obj.Menupanels,'Label','Events','Accelerator','o',...
    'Callback',@(src,evt) set(obj,'EventsWindowDisplay',~obj.EventsWindowDisplay));
obj.MenuControlPanel=uimenu(obj.Menupanels,'Label','Control',...
    'Callback',@(src,evt) set(obj,'ControlPanelDisplay',~obj.ControlPanelDisplay));
obj.MenuLockLayout=uimenu(obj.Menupanels,'Label','Lock Layout',...
    'Callback',@(src,evt) set(obj,'LockLayout',~obj.LockLayout));


%First Order Menu-------------------------------------------------------App
obj.MenuApp=uimenu(obj.Fig,'Label','Apps');

obj.MenuPSD=uimenu(obj.MenuApp,'Label','Power Spectrum Density');
obj.MenuPSD_Unit=uimenu(obj.MenuPSD,'Label','Unit');
obj.MenuPSD_Normal=uimenu(obj.MenuPSD_Unit,'label','Magnitude','checked','off',...
    'Callback',@(src,evt) Power_Spectrum_Density(obj,src));
obj.MenuPSD_DB=uimenu(obj.MenuPSD_Unit,'label','dB','checked','on',...
    'Callback',@(src,evt) Power_Spectrum_Density(obj,src));

obj.MenuLayout=uimenu(obj.MenuPSD,'Label','Layout');
obj.MenuPSDAverage=uimenu(obj.MenuLayout,'Label','Average',...
    'Callback', @(src,evt) Power_Spectrum_Density(obj,src),'checked','off');
obj.MenuPSDChannel=uimenu(obj.MenuLayout,'Label','Overlap',...
    'Callback', @(src,evt) Power_Spectrum_Density(obj,src),'checked','on');
obj.MenuPSDGrid=uimenu(obj.MenuLayout,'Label','Grid',...
    'Callback', @(src,evt) Power_Spectrum_Density(obj,src),'checked','off');
obj.MenuPSDSettings=uimenu(obj.MenuPSD,'Label','Settings','Separator','on',...
    'Callback', @(src,evt) Power_Spectrum_Density(obj,src));

obj.MenuTFMap=uimenu(obj.MenuApp,'Label','Time-Frequency Map');

obj.MenuTFMap_Unit=uimenu(obj.MenuTFMap,'Label','Unit');
obj.MenuTFMap_Normal=uimenu(obj.MenuTFMap_Unit,'Label','Magnitude',...
    'Callback', @(src,evt) Time_Freq_Map(obj,src),'checked','off');
obj.MenuTFMap_DB=uimenu(obj.MenuTFMap_Unit,'Label','dB',...
    'Callback', @(src,evt) Time_Freq_Map(obj,src),'checked','on');

obj.MenuTFMapLayout=uimenu(obj.MenuTFMap,'Label','Layout');
obj.MenuTFMapAverage=uimenu(obj.MenuTFMapLayout,'Label','Average',...
    'Callback', @(src,evt) Time_Freq_Map(obj,src),'checked','on');
obj.MenuTFMapChannel=uimenu(obj.MenuTFMapLayout,'Label','Channel',...
    'Callback', @(src,evt) Time_Freq_Map(obj,src),'checked','off');
obj.MenuTFMapGrid=uimenu(obj.MenuTFMapLayout,'Label','Grid',...
    'Callback', @(src,evt) Time_Freq_Map(obj,src),'checked','off');

obj.MenuTFMapSettings=uimenu(obj.MenuTFMap,'Label','Settings','Separator','on',...
    'Callback', @(src,evt) Time_Freq_Map(obj,src));

obj.MenuAdvFilter=uimenu(obj.MenuApp,'Label','Advanced Filter');
obj.MenuMeanRef=uimenu(obj.MenuAdvFilter,'Label','Mean-Reference',...
    'Callback', @(src,evt) Mean_Reference_Filter(obj));
obj.MenuRemovePulse=uimenu(obj.MenuAdvFilter,'Label','Pulse-Artifact',...
    'Callback', @(src,evt) Auto_Remove_Pulse_Artifact(obj));
obj.MenuTemporalPCA=uimenu(obj.MenuAdvFilter,'Label','Temporal-PCA',...
    'Callback', @(src,evt) Temporal_PCA(obj));

end




