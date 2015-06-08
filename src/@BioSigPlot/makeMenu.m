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

obj.MenuSave=uimenu(obj.MenuFile,'Label','Save');
obj.MenuSaveData=uimenu(obj.MenuSave,'Label','Data(sel)','Callback',@(src,evt) obj.SaveData,'Accelerator','s');
obj.MenuSaveEvents=uimenu(obj.MenuSave,'Label','Events','Callback',@(src,evt) obj.SaveEvents);
obj.MenuSaveMontage=uimenu(obj.MenuSave,'Label','Montage','Callback',@(src,evt) obj.SaveMontage);
obj.MenuSaveFigure=uimenu(obj.MenuSave,'Label','Figure');
obj.MenuSaveFigureMirror=uimenu(obj.MenuSaveFigure,'Label','Mirror','Callback',@(src,evt) obj.SaveToFigure,'Accelerator','p');
obj.MenuSaveFigureAdvanced=uimenu(obj.MenuSaveFigure,'Label','Advanced','Callback',@(src,evt) obj.SaveToWindow);

obj.MenuExport=uimenu(obj.MenuFile,'Label','Export to Matlab');
obj.MenuExportData=uimenu(obj.MenuExport,'Label','Data(sel)','Callback',@(src,evt) obj.ExportDataToWorkspace);

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
obj.MenuFigurePosition=uimenu(obj.MenuSettings,'Label','Figue Position',...
    'Callback',@(src,evts) MnuFigurePosition(obj));

obj.MenuVideo=uimenu(obj.MenuSettings,'Label','Video');
obj.MenuPlaySpeed=uimenu(obj.MenuVideo,'Label','Speed','Callback',@(src,evt) MnuPlay(obj));
obj.MenuVideoStartEnd=uimenu(obj.MenuVideo,'Label','Start&End','Callback',@(src,evt) MnuVideoStartEnd(obj));
obj.MenuVideoOnTop=uimenu(obj.MenuVideo,'Label','Stay On Top','Callback',@(src,evt) MnuVideoOnTop(obj),'checked','on');
%**************************************************************************
%First Order Menu------------------------------------------------------Data
obj.MenuChannel=uimenu(obj.Fig,'Label','Data');
obj.MenuChannelNumber=uimenu(obj.MenuChannel,'Label','Channels/Page','Callback',@(src,evt) MnuChan2Display(obj));
obj.MenuChannelWidth=uimenu(obj.MenuChannel,'Label','Time/Page','Callback',@(src,evt) MnuWidth2Display(obj));
obj.MenuGain=uimenu(obj.MenuChannel,'Label','Gain','Callback',@(src,evt) MnuChanGain(obj,src));
obj.MenuDetrend=uimenu(obj.MenuChannel,'Label','Detrend','Callback',@(src,evt) DetrendData(obj,src));

%First Order Menu---------------------------------------------------Montage
obj.MenuMontage=uimenu(obj.Fig,'Label','Montage');
%**************************************************************************
%First Order Menu-----------------------------------------------------Event
obj.MenuEvent=uimenu(obj.Fig,'Label','Event');
obj.MenuFastEvent=uimenu(obj.MenuEvent,'Label','Fast Event','Callback',@(src,evt) WinFastEvents(obj));
obj.MenuRepeatSelect=uimenu(obj.MenuEvent,'Label','Repeat Selection','Callback',@(src,evt) EventRepeatSelection(obj));
obj.MenuAdvanceEvents=uimenu(obj.MenuEvent,'Label','Advance','Separator','on');
obj.MenuAdvanceEventsCalculate=uimenu(obj.MenuAdvanceEvents,'Label','Detect',...
    'Callback',@(src,evt) AdvanceEvents(obj,src));
obj.MenuAdvanceEventsFunction=uimenu(obj.MenuAdvanceEvents,'Label','Function',...
    'Callback',@(src,evt) AdvanceEvents(obj,src));
obj.MenuAdvanceEventsQRS=uimenu(obj.MenuAdvanceEventsFunction,'Label','EKG(QRS)',...
    'CallBack',@(src,evt) AdvanceEvents(obj,src),'checked','off');
obj.MenuAdvanceEventsLoad=uimenu(obj.MenuAdvanceEventsFunction,'Label','Load',...
    'Separator','on','Callback',@(src,evt) AdvanceEvents(obj,src));
obj.MenuAdvanceEventsDisplay=uimenu(obj.MenuAdvanceEvents,'Label','Display',...
    'CallBack',@(src,evt) set(obj,'AdvanceEventsDisplay',~obj.AdvanceEventsDisplay));

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




