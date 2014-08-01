function makeMenu(obj)
%**************************************************************************
%First Order Menu------------------------------------------------------File
obj.MenuFile=uimenu(obj.Fig,'Label','File');

obj.MenuImport=uimenu(obj.MenuFile,'Label','Import');
obj.MenuImportDataSet=uimenu(obj.MenuImport,'Label','DataSet','Callback',@(src,evt) obj.ImportDataSet);
obj.MenuImportEvents=uimenu(obj.MenuImport,'Label','Events','Callback',@(src,evt) obj.ImportEvents);
obj.MenuImportVideo=uimenu(obj.MenuImport,'Label','Video','Callback',@(src,evt) obj.ImportVideo);

obj.MenuExport=uimenu(obj.MenuFile,'Label','Export');
obj.MenuExportFigure=uimenu(obj.MenuExport,'Label','Figure');
obj.MenuExportFigureMirror=uimenu(obj.MenuExportFigure,'Label','Mirror','Callback',@(src,evt) obj.ExportToFigure,'Accelerator','p');
obj.MenuExportFigureAdvanced=uimenu(obj.MenuExportFigure,'Label','Advanced','Callback',@(src,evt) obj.ExportToWindow);
obj.MenuExportEvents=uimenu(obj.MenuExport,'Label','Events','Callback',@(src,evt) obj.ExportEvents);
obj.MenuExportData=uimenu(obj.MenuExport,'Label','Data','Callback',@(src,evt) obj.ExportData);

obj.MenuCopy=uimenu(obj.MenuFile,'Label','Copy','Enable','off');
%**************************************************************************
%First Order Menu--------------------------------------------------Settings
obj.MenuSettings=uimenu(obj.Fig,'Label','Settings');
obj.MenuCommands=uimenu(obj.MenuSettings,'Label','Command List',...
    'Callback',@(src,evts) listdlg('ListString',obj.Commands,'ListSize',[700 500],'PromptString','List of commands'));
obj.MenuConfigurationState=uimenu(obj.MenuSettings,'Label','Configuration file','Callback',@(src,evt) ConfigWindow(obj));
obj.MenuPlaySpeed=uimenu(obj.MenuSettings,'Label','Play speed','Callback',@(src,evt) MnuPlay(obj));
obj.MenuColor=uimenu(obj.MenuSettings,'Label','Color');
obj.MenuSampleRate=uimenu(obj.MenuSettings,'Label','Sample Rate','Callback',@(src,evt) MnuSampleRate(obj),'Accelerator','r');
%Second Order Menu of Color
obj.MenuColorCanvas=uimenu(obj.MenuColor,'Label','Canvas','Accelerator','b',...
    'Callback',@(src,evt) set(obj,'AxesBackgroundColor',uisetcolor(obj.AxesBackgroundColor,'AxesBackground Color')));
obj.MenuColorLines=uimenu(obj.MenuColor,'Label','Lines','Accelerator','l',...
    'Callback',@(src,evt) set(obj,'ChanColors',obj.applyPanelVal(obj.ChanColors_,uisetcolor(obj.NormalModeColor,'Line Color'))));
%**************************************************************************
%First Order Menu---------------------------------------------------Channel
obj.MenuChannel=uimenu(obj.Fig,'Label','Channel');
obj.MenuChannelNumber=uimenu(obj.MenuChannel,'Label','Channels/Page','Callback',@(src,evt) MnuChan2Display(obj));
obj.MenuChannelWidth=uimenu(obj.MenuChannel,'Label','Time/Page','Callback',@(src,evt) MnuWidth2Display(obj));
obj.MenuMask=uimenu(obj.MenuChannel,'Label','Mask','Callback',@(src,evt) maskChannel(obj,src));
obj.MenuClearMask=uimenu(obj.MenuChannel,'Label','UnMask','Callback',@(src,evt) maskChannel(obj,src));
obj.MenuGain=uimenu(obj.MenuChannel,'Label','Gain','Callback',@(src,evt) MnuChanGain(obj,src));
obj.MenuAutoScale=uimenu(obj.MenuChannel,'Label','Auto Scale','Callback',@(src,evt) ChangeGain(obj,src));

%**************************************************************************
%First Order Menu-----------------------------------------------------Event
obj.MenuEvent=uimenu(obj.Fig,'Label','Event');
obj.MenuFastEvent=uimenu(obj.MenuEvent,'Label','Fast Event','Callback',@(src,evt) WinFastEvents(obj));
obj.MenuEventsWindow=uimenu(obj.MenuEvent,'Label','Window','Accelerator','o',...
    'Callback',@(src,evt) set(obj,'EventsWindowDisplay',~obj.EventsWindowDisplay));
obj.MenuEventsDisplay=uimenu(obj.MenuEvent,'Label','Display',...
    'Callback',@(src,evt) set(obj,'EventsDisplay',~obj.EventsDisplay));
obj.MenuEventDelete=uimenu(obj.MenuEvent,'Label','Delete','Callback',@(src,evt) deleteSelected(obj));

%First Order Menu---------------------------------------------------Display
obj.MenuDisplay=uimenu(obj.Fig,'Label','Display');
obj.MenuXGrid=uimenu(obj.MenuDisplay,'Label','XGrid',...
    'Callback',@(src,evt) set(obj,'XGrid',~obj.XGrid));
obj.MenuYGrid=uimenu(obj.MenuDisplay,'Label','YGrid',...
    'Callback',@(src,evt) set(obj,'YGrid',~obj.YGrid));
obj.MenuGauge=uimenu(obj.MenuDisplay,'Label','Gauge',...
    'Callback', @(src,evt) showGauge(obj,src),'checked','on');


%First Order Menu-------------------------------------------------------App
obj.MenuApp=uimenu(obj.Fig,'Label','Apps');
obj.MenuTriggerEvents=uimenu(obj.MenuApp,'Label','Trigger events');
obj.MenuTriggerEventsCalculate=uimenu(obj.MenuTriggerEvents,'Label','Detect',...
    'Callback',@(src,evt) TriggerEvents(obj,src));
obj.MenuTriggerEventsLoad=uimenu(obj.MenuTriggerEvents,'Label','Load Function',...
    'Callback',@(src,evt) TriggerEvents(obj,src));

obj.MenuTriggerEventsDisplay=uimenu(obj.MenuTriggerEvents,'Label','Display',...
    'CallBack',@(src,evt) set(obj,'TriggerEventsDisplay',~obj.TriggerEventsDisplay));

obj.MenuTFMap=uimenu(obj.MenuApp,'Label','Time-Frequency map');
obj.MenuTFMapAverage=uimenu(obj.MenuTFMap,'Label','Average',...
    'Callback', @(src,evt) Time_Freq_Map(obj,src),'checked','on');
obj.MenuTFMapChannel=uimenu(obj.MenuTFMap,'Label','Channel',...
    'Callback', @(src,evt) Time_Freq_Map(obj,src),'checked','off');
obj.MenuTFMapGrid=uimenu(obj.MenuTFMap,'Label','Grid',...
    'Callback', @(src,evt) Time_Freq_Map(obj,src),'checked','off');

obj.MenuTFMapSettings=uimenu(obj.MenuTFMap,'Label','Settings','Separator','on',...
    'Callback', @(src,evt) MnuTFMapSettings(obj));

end




