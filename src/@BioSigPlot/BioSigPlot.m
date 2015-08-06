classdef BioSigPlot < hgsetget
    
    properties (Access = protected,Hidden) %Graphics Object
        Sliders
        
        MainPanel
        AxesAdjustPanels
        
        ControlPanel
        TimePanel
        InfoPanel
        
        FilterPanel
        
        EventInfo
        BtnSwitchData
        BtnPrevEvent
        BtnPrevEvent1
        BtnStart
        BtnPrevPage
        BtnPrevSec
        EdtTime
        BtnNextSec
        BtnNextPage
        BtnNextEvent
        BtnNextEvent1
        BtnEnd
        
        TxtInfo1
        TxtInfo2
        TxtInfo3
        TxtInfo4
        
        ChkFilter
        EdtFilterLow
        EdtFilterHigh
        EdtFilterNotch1
        EdtFilterNotch2
        
        PopFilter
        
        BtnPSD
        BtnTFMap
        BtnPCA
        BtnICA
        
        BtnPlaySlower
        BtnPlayFaster
        TogPlay
        
        BtnGainIncrease
        BtnGainDecrease
        
        BtnWidthIncrease
        BtnWidthDecrease
        
        BtnAutoScale
        BtnMaskChannel
        BtnUnMaskChannel
        
        BtnHeightIncrease
        BtnHeightDecrease
        
        TxtScale
        ArrScale
        Toolbar
        TogMontage
        TogComAve
        TogHorizontal
        TogVertical
        TogMeasurer
        TogSelection
        TogVideo
        TogAnnotate
        
        MenuFile
        MenuNew
        MenuNewMontage
        MenuSave
        MenuSaveFigure
        MenuSaveFigureMirror
        MenuSaveFigureAdvanced
        MenuSaveEvents
        MenuSaveData
        MenuMergeData
        MenuSaveMontage
        MenuSavePosition
        
        MenuLoad
        MenuLoadDataSet
        MenuLoadEvents
        MenuLoadMontage
        MenuLoadVideo
        MenuLoadFilter
        MenuLoadChannelPosition
        
        MenuExport
        MenuExportData
        
        MenuSettings
        MenuCommands
        MenuConfigurationState
        MenuPlaySpeed
        MenuColors
        MenuSampleRate
        MenuVideoStartEnd
        MenuFigurePosition
        MenuVideo
        MenuVideoOnTop
        
        MenuChannel
        MenuChannelNumber
        MenuChannelWidth
        MenuGain
        MenuDetrend
        MenuNextPrevFile
        
        MenuMontage
        MontageOptMenu
        
        MenuEvent
        MenuEventsWindow
        MenuFastEvent
        MenuRepeatSelect
        MenuEventsDisplay
        
        MenuDisplay
        MenuToolbarDisplay
        MenuXGrid
        MenuYGrid
        MenuGauge
        MenuTimeLabel
        MenuChannelLabel
        Menupanels
        MenuControlPanel
        MenuLockLayout
        
        MenuColor
        MenuColorCanvas
        MenuColorLines
        MenuAdvanceEventsDisplay
        
        MenuApp
        MenuAdvanceEvents
        MenuAdvanceEventsCalculate
        MenuAdvanceEventsLoad
        MenuAdvanceEventsFunction
        MenuAdvanceEventsQRS
        
        MenuTFMap
        MenuTFMapNormal
        MenuTFMapNormalNone
        MenuTFMapNormalWithin
        MenuTFMapNormalBaseline
        MenuTFMapDataSel
        MenuTFMapInteractive
        MenuTFMapEvent
        MenuTFMapEventAverage
        MenuTFMap_Unit
        MenuTFMap_Normal
        MenuTFMap_DB
        MenuTFMapLayout
        MenuTFMapAverage
        MenuTFMapChannel
        MenuTFMapGrid
        MenuTFMapDisplay
        MenuTFMapDisplayOnset
        MenuTFMapSettings
        MenuTFMapSpatial
        
        MenuPSD
        MenuPSD_Unit
        MenuPSD_Normal
        MenuPSD_DB
        MenuLayout
        MenuPSDAverage
        MenuPSDChannel
        MenuPSDGrid
        MenuPSDSettings
        MenuPSDHold
        

        MenuMeanRef
        MenuTemporalPCA
        MenuRemovePulse
        MenuSpatialPCA
        
        PanObj
        LineVideo
        LineMeasurer
        
        TxtMeasurer
        TxtFastEvent
        
        WinEvts
        WinFastEvts
        
        
        VideoListener
        
        ChannelLines
        
    end
    properties (Dependent,SetObservable)
        Version
        Title
        Config                  %Default config file [def: defaultconfig] contains all default values
        SRate                   %Sampling rate
        WinLength               %Time length of windows
        Gain                    %Gain beetween 2 channels
        Mask
        ChanNames               %Cell with channel names corresponding to raw data.
        GroupNames
        ChanPosition
        Units                   %Units of the data
        Evts                    %List of events.
        Time                    %Current time (in TimeUnit) of the current
        DispChans               %Number of channels to display for each data set.
        FirstDispChans          %First chan to display for each data set
        TimeUnit                %time unit (not active for now)
        Filtering               %True if preprocessing filter are enbaled
        FilterLow               %The low value of filtering: Cut-off frequency of high pass filter
        FilterHigh              %The high value of filtering: Cut-off frequency of low pass filter
        FilterNotch1             %The 2 notch filter values for 50 or 60Hz rejection. (eg. [58 62]
        FilterNotch2
        FilterCustomIndex
        
        DefaultLineColor         %Colors for view Horizontal, Vertical, or single (DAT*)
        ChanSelectColor         %Colors when Channels are selected
        AxesBackgroundColor
        ChanColors
        
        EventSelectColor
        EventDefaultColors
        AdvanceEventDefaultColor
        
        LineDefaultColors
        
        DataView                %View Mode {'Vertical'|'Horizontal'|'DAT*'}
        MontageRef              %N° Montage
        XGrid                   %true : show Grid line on each sec
        YGrid                   %true : show Grid line on each channel
        EventsDisplay           %true : show Events
        AdvanceEventsDisplay
        EventsWindowDisplay     %true : show Events Window
        ControlPanelDisplay
        LockLayout
        ToolbarDisplay
        DisplayGauge
        
        MouseMode               %the Mouse Mode :{'Pan'|'Measurer'}
        PlaySpeed               %Play speed
        
        VideoTimerPeriod        %Period of the Video
        Montage                 %Path for a system file wich contains info on Montage
        YBorder                 %Vector of 2elements containing the space height between the last channel and the bottom and between the top and the first channel (Units: 'Gain' relative)
        Selection               %Time of Selected area
        
        BadChannels             %The bad channels
        ChanSelect2Display      %Selected Channels to Display
        ChanSelect2Edit         %Selected Channels to Edit (Filter,Gain adjust,AdvanceEvent)
        
        IsDataSameSize
        DisplayedData           %Vector of displayed data
        IsChannelSelected
        
        FastEvts
        SelectedFastEvt
        AdvanceEventsFcn
        
        Evts2Display
        
        STFTWindowLength
        STFTOverlap
        
        PSDWindowLength
        PSDOverlap
        
        FileDir
    end
    properties (Access=protected,Hidden)%Storage of public properties
        Version_
        Title_
        Config_
        SRate_
        WinLength_
        Gain_
        Mask_
        ChanNames_
        GroupNames_
        ChanPosition_
        Units_
        
        Evts_
        Time_
        DispChans_
        FirstDispChans_
        TimeUnit_

        Filtering_
        FilterLow_
        FilterHigh_
        FilterNotch1_
        FilterNotch2_
        FilterCustomIndex_
        
        DefaultLineColor_
        ChanSelectColor_
        AxesBackgroundColor_
        ChanColors_
        EventSelectColor_
        EventDefaultColors_
        AdvanceEventDefaultColor_
        
        LineDefaultColors_
        
        DataView_
        MontageRef_
        XGrid_
        YGrid_
        EventsDisplay_
        AdvanceEventsDisplay_
        EventsWindowDisplay_
        ControlPanelDisplay_
        LockLayout_
        ToolbarDisplay_
        DisplayGauge_
        
        MouseMode_
        PlaySpeed_
        VideoTimerPeriod_

        YBorder_
        Selection_
        
        BadChannels_
        ChanSelect2Display_
        ChanSelect2Edit_
        
        FileNames_
        
        SelectedEvent_
        
        FastEvts_
        SelectedFastEvt_
        AdvanceEventsFcn_
        
        STFTWindowLength_
        STFTOverlap_
        
        PSDWindowLength_
        PSDOverlap_
    end
    properties (SetAccess=protected) %Readonly properties
        Data                        %(Read-Only)All the Signals
        PreprocData                 %(Read-Only)The currently preprocessed and drawed Data
        Commands                    %(Read-Only)List of all commands to be on this state
    end
    properties (Access = protected,Hidden) %State Properties. No utilities for users
        IsSelecting
        SelectionStart
        SelRect
        IsInitialize
        RedrawEvtsSkip
    end
    
    properties (Dependent) %'Public properties which does not requires redrawing
        Position                    %Position of the figure (in pixels)
        
    end
    properties (Dependent) %'Public computed read-only properties
        
        DataTime
        DataNumber                  %(Read-Only) Number of Dataset
        ChanNumber                  %(Read-Only) Channel number for the Raw data
        MontageChanNumber           %(Read-Only) Channel number for the current Montages
        MontageChanNames            %(Read-Only) Channel names for the current Montages
        MouseTime                   %(Read-Only) The Time on which the mouse is in
        MouseChan                   %(Read-Only) The channel on which the mouse is in
        MouseDataset                %(Read-Only) The dataset on which the mouse is in
    end
    
    properties (Dependent)
        %User friendly named properties
        
        sdata                       %(Read-Only)  Selected data
    end
 
    properties
        Fig
        Axes
        TFMapFig
        PSDFig
        IconPlay
        IconPause
        WinVideo
    end
    
    methods
        
        %*****************************************************************
        function obj=BioSigPlot(data,varargin)  
            obj.IsInitialize=true;
            
            obj.Data=obj.uniform(data);
            
            obj.buildfig;
            g=varargin;
            varInitial(obj,g);
            scanFilterBank(obj);
            %Show up
            resetView(obj);
            remakeMontage(obj);
            remakeAxes(obj);
            recalculate(obj);
            if all(cellfun(@isempty,obj.Gain))
                ChangeGain(obj,[]);
            end
            redraw(obj);
            redrawEvts(obj);
            
            obj.IsInitialize=false;
            
%             set(obj.Fig,'Visible','on')
        end
        
        %*****************************************************************
        function varInitial(obj,g)
            obj.Title=cell(1,obj.DataNumber);
            obj.ResizeMode=false;
            obj.AxesResizeMode=[];
            obj.UponAdjustPanel=false;

            obj.VideoLineTime=0;
            obj.IsSelecting=0;
            obj.SelectionStart=[];
            obj.Selection_=ones(2,0);
            obj.ChanSelect2Display_=cell(1,obj.DataNumber);
            obj.ChanSelect2Edit_=cell(1,obj.DataNumber);
            
            obj.Gain_=cell(1,obj.DataNumber);
            
            obj.Mask_=cell(1,obj.DataNumber);
            obj.Mask_=obj.applyPanelVal(obj.Mask_,1);
            
            obj.Filtering_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            
            obj.FilterLow_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            obj.FilterHigh_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            obj.FilterNotch1_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            obj.FilterNotch2_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            obj.FilterCustomIndex_=obj.applyPanelVal(cell(1,obj.DataNumber),1);
            
            resetFilterPanel(obj);
            
            obj.RedrawEvtsSkip=false;
            obj.EventLines=[];
            obj.EventTexts=[];
            
            obj.DragMode=0;
            obj.EditMode=0;
            obj.SelectedEvent_=[];
            obj.Evts_={};
            obj.IsEvtsSaved=true;
            obj.EventsWindowDisplay=true;
            obj.ControlPanelDisplay=true;
            obj.ToolbarDisplay=true;
            obj.LockLayout=true;
            
            obj.DisplayGauge=true;
            
            obj.ChanNames_=cell(1,obj.DataNumber);
            obj.GroupNames_=cell(1,obj.DataNumber);
            obj.MontageRef_=ones(obj.DataNumber,1);
            obj.ChanPosition_=cell(1,obj.DataNumber);
            
            n=find(strcmpi('Config',g(1:2:end)))*2;
            if isempty(n), g=[{'Config' obj.DefaultConfigFile} g]; end
            set(obj,g{:});
            
            obj.ChanColors_=obj.applyPanelVal(cell(1,obj.DataNumber),obj.DefaultLineColor);
            
            p=mfilename('fullpath');
            obj.CNELabDir=fullfile([p(1:end-10),'../..']);
        end
        function saveConfig(obj)
            cfg=load('-mat',obj.Config);
            cfg.FastEvts=obj.FastEvts;
            cfg.SelectedFastEvt=obj.SelectedFastEvt;
            cfg.AdvanceEventsFcn=obj.AdvanceEventsFcn;
            save(fullfile(obj.CNELabDir,'/db/cfg/','defaultconfig.cfg'),'-struct','cfg');
        end
        function delete(obj)
            %             Delete the figure
            saveConfig(obj);
            if isa(obj.WinVideo,'VideoWindow') && isvalid(obj.WinVideo)
                delete(obj.WinVideo)
            end
            
            if ~isempty(obj.Evts)&&~obj.IsEvtsSaved
                default='yes';
                choice=questdlg('There are changes in events, do you want to save them before exit?',...
                    'warning','yes','no',default);
                switch choice
                    case 'yes'
                        SaveEvents(obj);
                    case 'no'
                end
                
            end
            
            if isa(obj.WinFastEvts,'FastEventWindow') && isvalid(obj.WinFastEvts)
                delete(obj.WinFastEvts);
            end
            
            h = obj.Fig;
            if ishandle(h)
                delete(h);
            end
            h = obj.PSDFig;
            if ishandle(h)
                delete(h);
            end
            
            h = obj.TFMapFig;
            if ishandle(h)
                delete(h);
            else
                return
            end
            
            if ~isempty(obj.SPFObj)&&isvalid(obj.SPFObj)&&isa(obj.SPFObj,'SPFPlot')
                delete(obj.SPFObj);
            end
        end % delete
        
        %*****************************************************************
        function DATA=uniform(obj,data)
            if iscell(data)
                DATA=data;
            elseif size(data,3)==1
                DATA={data};
            else
                DATA=cell(1,size(data,3));
                for i=1:size(data,3)
                    DATA{i}=data(:,:,i);
                end
            end
            
            for i=1:length(DATA)
                if size(DATA{i},1)<size(DATA{i},2)
                    choice=questdlg(['The DATA ',num2str(i), ' appears to be row-wise, do you want to transpose it?'],'BioSigplot','Yes','No','Yes');
                    if strcmpi(choice,'Yes')
                        DATA{i}=DATA{i}';
                    end
                end
            end
            
            l=cell2mat(cellfun(@size,DATA,'UniformOutput',false)');
            if ~all(l(1,1)==l(:,1))
                error('All data must have the same number of time samples');
            end
            
            for i=1:length(DATA)
                DATA{i}=double(DATA{i});
            end
            
        end
        
        function set(obj,varargin)
            NeedRemakeMontage=false;
            NeedResetView=false;
            NeedRemakeAxes=false;
            NeedRedraw=false;
            NeedCommand=false;
            NeedRecalculate=false;
            NeedRedrawEvts=false;
            NeedHighlightChannels=false;
            NeedHighlightEvents=false;
            NeedChangeGain=false;
            NeedDrawSelect=false;
            NeedRedrawTimeChange=false;
            NeedRedrawChannelChange=false;
            
            g=varargin;
            
            if isempty(obj.Commands)
                command='a=BioSigPlot(data';
                NeedCommand=true;
            else
                command='set(a';
            end
            
            n=find(strcmpi('Config',g(1:2:end)))*2;
            if ~isempty(n), g=g([n-1 n 1:n-2 n+1:end]); end
            
            for i=1:2:length(g)
                if any(strcmpi(g{i},{'Config','SRate','WinLength','Montage',...
                        'DataView','MontageRef','DispChans',...
                        'Filtering','FilterLow',...
                        'FilterHigh','FilterNotch1','FilterNotch2','FilterCustomIndex'...
                        'ChanNames','GroupNames','ChanPosition','YBorder',...
                        'ChanSelect2Display'}))
                   
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                    if any(strcmpi(g{i},{'Config','SRate','WinLength','Montage','DataView',...
                            'MontageRef','DispChans'}))
                        NeedRemakeAxes=true;
                    end
                    if any(strcmpi(g{i},{'Config','Montage','ChanNames','GroupNames','ChanPosition','DataView','MontageRef'}))
                        if any(strcmpi(g{i},{'Config','Montage','ChanNames','GroupNames','ChanPosition'}))
                            NeedRemakeMontage=true;
                        end
                        NeedResetView=true;
                    end
                    if any(strcmpi(g{i},{'SRate','Montage','MontageRef',...
                            'Filtering','FilterLow','FilterHigh',...
                            'FilterNotch1','FilterNotch2','FilterCustomIndex'}))
                        NeedRecalculate=true;
                    end
                    
                    NeedRedraw=true;
                    NeedRedrawEvts=true;
                    NeedDrawSelect=true;
                    
                elseif any(strcmpi(g{i},{'EventsDisplay','Evts',...
                        'EventSelectColor','AdvanceEventsDisplay'}))
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                    NeedRedrawEvts=true;
                elseif any(strcmpi(g{i},{'ChanSelect2Edit','ChanColors',...
                        'ChanSelectColor','LineDefaultColors'}))
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                    NeedHighlightChannels=true;
                    
                elseif any(strcmpi(g{i},{'SelectedEvent'}))
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                    NeedHighlightEvents=true;
                elseif any(strcmpi(g{i},{'Gain','Mask'}))
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                    NeedChangeGain=true;
                elseif any(strcmpi(g{i},{'Time'}))
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                    NeedRedrawEvts=true;
                    NeedDrawSelect=true;
                    NeedRedrawTimeChange=true;
                elseif any(strcmpi(g{i},{'FirstDispChans'}))
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
%                     NeedRedrawEvts=true;
                    NeedDrawSelect=true;
                    NeedRedrawChannelChange=true;
                elseif any(strcmpi(g{i},{'Selection'}))
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                    NeedDrawSelect=true;
                elseif any(strcmpi(g{i},{'PlaySpeed','FastEvts','SelectedFastEvt',...
                        'EventDefaultColors','EventsWindowDisplay','AdvanceEventsFcn',...
                        'AdvanceEventDefaultColor','MouseMode','STFTWindowLength',...
                        'STFTOverlap','Title','Version','PSDWindowLength',...
                        'PSDOverlap','ControlPanelDisplay',...
                        'LockLayout','ToolbarDisplay','DisplayGauge','XGrid','YGrid',...
                        'VideoTimerPeriod','BadChannels','AxesBackgroundColor',...
                        'DefaultLineColor','Units','TimeUnit','FileNames','AdvanceEventsFcn'}))
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                else
                    set@hgsetget(obj,varargin{i},varargin{i+1})
                end
                
                if isprop(obj,g{i})
                    command=[command ',''' g{i} ''',' obj2str(g{i+1})]; %#ok<AGROW>
                    NeedCommand=true;
                end
            end
            if NeedRemakeMontage, remakeMontage(obj); end
            if NeedRecalculate,recalculate(obj); end
            if NeedResetView, resetView(obj); end
            if NeedRemakeAxes, remakeAxes(obj); end
            if NeedRedraw&&~obj.IsInitialize, redraw(obj); end
            if NeedRedrawEvts&&~obj.IsInitialize, redrawEvts(obj); end
            if NeedHighlightChannels, highlightSelectedChannel(obj); end
            if NeedHighlightEvents, highlightSelectedEvents(obj); end
            if NeedChangeGain&&~obj.IsInitialize, gainChangeSelectedChannels(obj); end
            if NeedDrawSelect, redrawSelection(obj); end
            if NeedRedrawTimeChange, redrawChangeBlock(obj,'time'); end
            if NeedRedrawChannelChange, redrawChangeBlock(obj,'channel'); end
            if NeedCommand
                if strcmpi(command(1:12),'a=BioSigPlot')
                    n=1;
                else
                    n=length(obj.Commands)+1;
                end
                obj.Commands{n}=[command ');'];
            end
        end
        
        %******************************************************************
        function val=get(obj,prop)
            val=subsref(obj,substruct('.',prop));
        end
        
        %******************************************************************
        %SetGet method for properties requiring redraw (Would be auto-generates in future version)
        %******************************************************************
        function obj = set.Version(obj,val), set(obj,'Version',val); end
        function val = get.Version(obj),     val=obj.Version_; end
        
        function obj = set.Title(obj,val), set(obj,'Title',val); end
        function val = get.Title(obj), val=obj.Title_; end
        function obj = set.Config(obj,val), set(obj,'Config',val); end
        function val = get.Config(obj), val=obj.Config_; end
        function obj = set.SRate(obj,val), set(obj,'SRate',val); end
        function val = get.SRate(obj), val=obj.SRate_; end
        function obj = set.WinLength(obj,val), set(obj,'WinLength',val); end
        function val = get.WinLength(obj), val=obj.WinLength_; end
        function obj = set.Gain(obj,val), set(obj,'Gain',val); end
        function val = get.Gain(obj), val=obj.Gain_; end
        function obj = set.Mask(obj,val), set(obj,'Mask',val); end
        function val = get.Mask(obj), val=obj.Mask_; end
        function obj = set.ChanNames(obj,val), set(obj,'ChanNames',val); end
        function val = get.ChanNames(obj), val=obj.ChanNames_; end
        function obj = set.GroupNames(obj,val), set(obj,'GroupNames',val); end
        function val = get.GroupNames(obj), val=obj.GroupNames_; end
        function obj = set.ChanPosition(obj,val), set(obj,'ChanPosition',val); end
        function val = get.ChanPosition(obj), val=obj.ChanPosition_; end
        function obj = set.Units(obj,val), set(obj,'Units',val); end
        function val = get.Units(obj), val=obj.Units_; end
        function obj = set.Evts(obj,val), set(obj,'Evts',val); end
        function obj = set.Time(obj,val), set(obj,'Time',val);end
        function val = get.Time(obj), val=obj.Time_;end
        function obj = set.DispChans(obj,val), set(obj,'DispChans',val); end
        function val = get.DispChans(obj), val=obj.DispChans_; end
        function obj = set.FirstDispChans(obj,val), set(obj,'FirstDispChans',val); end
        function val = get.FirstDispChans(obj), val=obj.FirstDispChans_; end
        function obj = set.TimeUnit(obj,val), set(obj,'TimeUnit',val); end
        function val = get.TimeUnit(obj), val=obj.TimeUnit_; end
        function obj = set.Filtering(obj,val), set(obj,'Filtering',val); end
        function val = get.Filtering(obj), val=obj.Filtering_; end
        function obj = set.FilterLow(obj,val), set(obj,'FilterLow',val); end
        function val = get.FilterLow(obj), val=obj.FilterLow_; end
        function obj = set.FilterHigh(obj,val), set(obj,'FilterHigh',val); end
        function val = get.FilterHigh(obj), val=obj.FilterHigh_; end
        function obj = set.FilterNotch1(obj,val), set(obj,'FilterNotch1',val); end
        function val = get.FilterNotch1(obj), val=obj.FilterNotch1_; end
        
        function obj = set.FilterNotch2(obj,val), set(obj,'FilterNotch2',val); end
        function val = get.FilterNotch2(obj), val=obj.FilterNotch2_; end
        
        function obj = set.FilterCustomIndex(obj,val), set(obj,'FilterCustomIndex',val); end
        function val = get.FilterCustomIndex(obj), val=obj.FilterCustomIndex_; end
        
        function obj = set.DefaultLineColor(obj,val), set(obj,'DefaultLineColor',val); end
        function val = get.DefaultLineColor(obj), val=obj.DefaultLineColor_; end
        
        function obj = set.ChanSelectColor(obj,val), set(obj,'ChanSelectColor', val); end
        function val = get.ChanSelectColor(obj), val=obj.ChanSelectColor_; end
        
        function obj = set.AxesBackgroundColor(obj,val), set(obj,'AxesBackgroundColor', val); end
        function val = get.AxesBackgroundColor(obj), val=obj.AxesBackgroundColor_; end
        
        function obj = set.DataView(obj,val), set(obj,'DataView',val); end
        function val = get.DataView(obj), val=obj.DataView_; end
        function obj = set.MontageRef(obj,val), set(obj,'MontageRef',val); end
        function val = get.MontageRef(obj), val=obj.MontageRef_; end
        function obj = set.XGrid(obj,val), set(obj,'XGrid',val); end
        function val = get.XGrid(obj), val=obj.XGrid_; end
        function obj = set.YGrid(obj,val), set(obj,'YGrid',val); end
        function val = get.YGrid(obj), val=obj.YGrid_; end
        function obj = set.MouseMode(obj,val), set(obj,'MouseMode',val); end
        function val = get.MouseMode(obj), val=obj.MouseMode_; end
        function obj = set.PlaySpeed(obj,val), set(obj,'PlaySpeed',val); end
        function val = get.PlaySpeed(obj), val=obj.PlaySpeed_; end
        
        function obj = set.VideoTimerPeriod(obj,val), set(obj,'VideoTimerPeriod',val); end
        function val = get.VideoTimerPeriod(obj), val=obj.VideoTimerPeriod_; end
        
        function obj = set.Montage(obj,val), set(obj,'Montage',val); end
        function val = get.Montage(obj), val=obj.Montage_; end
        function obj = set.YBorder(obj,val), set(obj,'YBorder',val); end
        function val = get.YBorder(obj), val=obj.YBorder_; end
        function obj = set.Selection(obj,val), set(obj,'Selection',val); end
        function val = get.Selection(obj), val=obj.Selection_; end
        
        function obj = set.Position(obj,val), set(obj.Fig,'Position',val); end
        function val = get.Position(obj),     val=get(obj.Fig,'Position'); end
        
        function obj = set.EventDisplayIndex(obj,val), obj.EventDisplayIndex=val; end
        function val = get.EventDisplayIndex(obj), val=obj.EventDisplayIndex; end
        
        function obj = set.FileNames(obj,val), set(obj,'FileNames',val); end
        function val = get.FileNames(obj), val=obj.FileNames_; end
        
        function obj = set.BadChannels(obj,val), set(obj,'BadChannels',val); end
        function val = get.BadChannels(obj), val=obj.BadChannels_; end
        
        
        function obj = set.ChanSelect2Display(obj,val), set(obj,'ChanSelect2Display',val); end
        function val = get.ChanSelect2Display(obj), val=obj.ChanSelect2Display_; end
        
        function obj = set.ChanSelect2Edit(obj,val), set(obj,'ChanSelect2Edit',val); end
        function val = get.ChanSelect2Edit(obj), val=obj.ChanSelect2Edit_; end
        
        function obj = set.EventsDisplay(obj,val), set(obj,'EventsDisplay',val); end
        function val = get.EventsDisplay(obj), val=obj.EventsDisplay_; end
        
        
        function obj = set.AdvanceEventsDisplay(obj,val), set(obj,'AdvanceEventsDisplay',val); end
        function val = get.AdvanceEventsDisplay(obj), val=obj.AdvanceEventsDisplay_; end
        
        function obj = set.EventsWindowDisplay(obj,val), set(obj,'EventsWindowDisplay',val); end
        function val = get.EventsWindowDisplay(obj), val=obj.EventsWindowDisplay_; end
        
        function obj = set.ToolbarDisplay(obj,val), set(obj,'ToolbarDisplay',val); end
        function val = get.ToolbarDisplay(obj), val=obj.ToolbarDisplay_; end
        
        function obj = set.DisplayGauge(obj,val), set(obj,'DisplayGauge',val); end
        function val = get.DisplayGauge(obj), val=obj.DisplayGauge_; end
        
        function obj = set.ControlPanelDisplay(obj,val), set(obj,'ControlPanelDisplay',val); end
        function val = get.ControlPanelDisplay(obj), val=obj.ControlPanelDisplay_; end
        
        function obj = set.LockLayout(obj,val), set(obj,'LockLayout',val); end
        function val = get.LockLayout(obj), val=obj.LockLayout_; end
        
        function obj = set.ChanColors(obj,val), set(obj,'ChanColors',val); end
        function val = get.ChanColors(obj), val=obj.ChanColors_; end
        
        function obj = set.SelectedEvent(obj,val), set(obj,'SelectedEvent',val); end
        function val = get.SelectedEvent(obj), val=obj.SelectedEvent_; end
        
        function obj = set.EventSelectColor(obj,val), set(obj,'EventSelectColor',val); end
        function val = get.EventSelectColor(obj), val=obj.EventSelectColor_; end
        
        function obj = set.EventDefaultColors(obj,val), set(obj,'EventDefaultColors',val); end
        function val = get.EventDefaultColors(obj), val=obj.EventDefaultColors_; end
        
        
        function obj = set.LineDefaultColors(obj,val), set(obj,'LineDefaultColors',val); end
        function val = get.LineDefaultColors(obj), val=obj.LineDefaultColors_; end
        
        function obj = set.AdvanceEventDefaultColor(obj,val), set(obj,'AdvanceEventDefaultColor',val); end
        function val = get.AdvanceEventDefaultColor(obj), val=obj.AdvanceEventDefaultColor_; end
        
        function obj = set.FastEvts(obj,val), set(obj,'FastEvts',val); end
        function val = get.FastEvts(obj), val=obj.FastEvts_; end
        
        function obj = set.SelectedFastEvt(obj,val), set(obj,'SelectedFastEvt',val); end
        function val = get.SelectedFastEvt(obj), val=obj.SelectedFastEvt_; end
        
        function obj = set.AdvanceEventsFcn(obj,val), set(obj,'AdvanceEventsFcn',val); end
        function val = get.AdvanceEventsFcn(obj), val=obj.AdvanceEventsFcn_; end
        
        function obj = set.STFTWindowLength(obj,val), set(obj,'STFTWindowLength',val); end
        function val = get.STFTWindowLength(obj), val=obj.STFTWindowLength_; end
        
        function obj = set.STFTOverlap(obj,val), set(obj,'STFTOverlap',val); end
        function val = get.STFTOverlap(obj), val=obj.STFTOverlap_; end
        
        function obj = set.PSDWindowLength(obj,val), set(obj,'PSDWindowLength',val); end
        function val = get.PSDWindowLength(obj), val=obj.PSDWindowLength_; end
        
        function obj = set.PSDOverlap(obj,val), set(obj,'PSDOverlap',val); end
        function val = get.PSDOverlap(obj), val=obj.PSDOverlap_; end
        
        function val=get.FileDir(obj), val=fileparts(obj.FileNames{obj.DisplayedData(1)}); end
        %*****************************************************************
        % ***************** User available methods  **********************
        %*****************************************************************
        
        %******************************************************************
        
        %******************************************************************
        
        %*****************************************************************
        % ***************** Public computed read-only properties*********
        %*****************************************************************

        %******************************************************************
        function val = get.DataTime(obj)
            val=size(obj.Data{1},1)/obj.SRate;
        end
        function val = get.DataNumber(obj)
            val=length(obj.Data);
        end
        
        %******************************************************************
        function val = get.ChanNumber(obj)
            l=cell2mat(cellfun(@size,obj.Data,'UniformOutput',false)');
            val=l(:,2);
        end
        
        %******************************************************************
        function val = get.MontageChanNumber(obj)
            val=zeros(obj.DataNumber,1);
            if ~isempty(obj.MontageRef)&&~isempty(obj.Montage)
                for i=1:obj.DataNumber
                    if ~isempty(obj.Montage{i})
                        val(i)=size(obj.Montage{i}(obj.MontageRef(i)).mat,1);
                    else
                        val(i)=obj.ChanNumber(i);
                    end
                end
            else
                val=obj.ChanNumber;
            end
            
        end
        
        %******************************************************************
        function val = get.MontageChanNames(obj)
            for i=1:obj.DataNumber
                val{i}=obj.Montage{i}(obj.MontageRef(i)).channames; %#ok<AGROW>
            end
        end
        
        %******************************************************************
        function [mouseTime]=get.MouseTime(obj)
            xlim=obj.WinLength*obj.SRate;
            mouseTime=0;
            for i=1:length(obj.Axes)
                pos=get(obj.Axes(i),'CurrentPoint');
                ylim=get(obj.Axes(i),'Ylim');
                if pos(1,1)>=0 && pos(1,1)<=xlim && pos(1,2)>=ylim(1) && pos(1,2)<=ylim(2)
                    mouseTime=pos(1,1)/xlim*obj.WinLength+obj.Time;
                end
            end
        end
        
        %******************************************************************
        function [nchan]=get.MouseChan(obj)
            nchan=getMouseInfo(obj);
        end
        
        %******************************************************************
        function [ndata]=get.MouseDataset(obj)
            [unused,ndata]=getMouseInfo(obj); %#ok<ASGLU>
        end
        %******************************************************************
        function d=get.sdata(obj)
            d=get_selected_data(obj);
        end
        %*****************************************************************
        %**********************Private Properties*************************
        %*****************************************************************
        
        %******************************************************************
        function obj = set.Config_(obj,val)
            if ~strcmpi(val(end-3:end),'.cfg')
                val=[val '.cfg'];
            end
            obj.Config_=val;
            def=load('-mat',val);
            names=fieldnames(def);
            names=names(~strcmpi('Position',names)&~strcmpi('VideoStartTime',names)...
                &~strcmpi('VideoActxOpt',names));
            for i=1:length(names)
                set(obj,[names{i} '_'],def.(names{i}));
            end
            obj.Position=def.Position; %#ok<*MCSUP>
            obj.VideoStartTime=def.VideoStartTime;
            obj.VideoActxOpt=def.VideoActxOpt;
        end
        function obj = set.Title_(obj,val)
            if ~iscell(val)
                val={val};
            end
            
            obj.Title_=val;
        end
        %*****************************************************************
        
        function obj = set.SRate_(obj,val)
            obj.SRate_=val;
            obj.STFTFreqLow=0;
            obj.STFTFreqHigh=val/2;
            
            obj.PSDFreqLow=0;
            obj.PSDFreqHigh=val/2;
        end
        %******************************************************************
        function val = get.Evts(obj)
            if isempty(obj.Evts_)
                val={};
            else
                val=obj.Evts_(:,1:2);
            end
        end
        function obj = set.Evts_(obj,val)
            
            oldval=obj.Evts_;
            
            if size(val,2)==2
                val=obj.assignEventColor(val);
                d=cell(size(val,1),1);
                [d{:}]=deal(0);
                obj.Evts_=cat(2,val,d);
            else
                obj.Evts_=val;
            end
            if ~isempty(obj.Evts_)&&isempty(oldval)
                obj.IsEvtsSaved=false;
                
                set(obj.MenuEventsWindow,'Enable','on');
                set(obj.MenuEventsDisplay,'Enable','on');
                obj.EventsWindowDisplay=true;
                obj.EventsDisplay=true;
            elseif isempty(obj.Evts_)
                obj.IsEvtsSaved=true;
                set(obj.MenuEventsWindow,'Enable','off');
                set(obj.MenuEventsDisplay,'Enable','off');
                obj.EventsWindowDisplay=false;
                obj.EventsDisplay=false;
            end
            
            obj.synchEvts();
            
            
            evts=obj.WinEvts.Evts_;
            if ~isempty(evts)
                [obj.EventSummaryIndex,obj.EventSummaryNumber]=...
                    EventWindow.findIndexOfEvent(evts(:,2),[evts{:,1}]);
            end
            
        end
        
        function obj = set.SelectedFastEvt_(obj,val)
            obj.SelectedFastEvt_=val;
            if ~obj.IsInitialize
                if all(ishandle(obj.LineMeasurer))
                    x=get(obj.LineMeasurer(1),'XData');
                    updateSelectedFastEvent(obj,x(1));
                end
            end
        end
        
        function evtsInd=get.Evts2Display(obj)
            if isempty(obj.Evts_)
                evtsInd=[];
                return
            end
            
            if obj.EventsDisplay
                if obj.AdvanceEventsDisplay
                    evtsInd=1:size(obj.Evts_,1);
                else
                    evtsInd=find([obj.Evts_{:,4}]==0);
                end
            else
                if obj.AdvanceEventsDisplay
                    evtsInd=find([obj.Evts_{:,4}]~=0);
                else
                    evtsInd=[];
                end
            end
        end
        %==================================================================
        %******************************************************************
        function newevts=assignEventColor(obj,evts)
            [C,ia,ic] = unique(evts(:,2));
            
            newevts=evts;
            c=cell(size(evts,1),1);
            for i=1:size(evts,1)
                ind=rem(ic(i),size(obj.EventDefaultColors,1));
                if ~ind
                    ind=size(obj.EventDefaultColors,1);
                end
                c{i}=obj.EventDefaultColors(ind,:);
            end
            if size(evts,2)>2
                newevts(:,3)=c;
            else
                newevts=cat(2,newevts,c);
            end
            
        end
        %==================================================================
        %******************************************************************
        
        function assignChannelGroupColor(obj)
            for i=1:length(obj.Montage_)
                j=obj.MontageRef(i);
                obj.ChanColors_{i}=ones(size(obj.Montage_{i}(j).mat,1),1)*obj.LineDefaultColors(1,:);
                if isfield(obj.Montage_{i}(j),'groupnames')
                    if ~isempty(obj.Montage_{i}(j).groupnames)
%                         [C,ia,ic] = unique(obj.Montage_{i}(j).groupnames);
                        gname=obj.Montage_{i}(j).groupnames;
                        tab=tabulate(gname);
                        [tmp,order]=sort([tab{:,2}],'descend');
                        unique_name=tab(:,1);
                        unique_name=unique_name(order);
                        
                        c=zeros(length(gname),3);
                        for k=1:size(c,1)
                            ind=rem(find(strcmp(gname{k},unique_name)),size(obj.LineDefaultColors,1));
                            if ~ind
                                ind=size(obj.LineDefaultColors,1);
                            end
                            c(k,:)=obj.LineDefaultColors(ind,:);
                        end
                        obj.ChanColors_{i}=c;
                    end
                end
            end
        end
        %==================================================================
        %******************************************************************
        function newcell=applyPanelVal(obj,oldcell,val)
            %var : a single non-empty value
            %oldcell : old configuration
            %newcell : new configuration
            if isempty(val)
                val=nan;
            end
            dd=obj.DisplayedData;
            val=reshape(val,1,length(val));
            %Create a vector of NaN for each cell
            newcell=cell(1,obj.DataNumber);
            
            for i=1:obj.DataNumber
                newcell{i}=NaN*ones(obj.MontageChanNumber(i),length(val));
            end
            
            if ~obj.IsChannelSelected
                %If there is no channel celected
                %var will be applied to all channels of current data
                for i=1:length(dd)
                    newcell{dd(i)}=ones(obj.MontageChanNumber(dd(i)),1)*val;
                end
            else
                %if there are channels selected
                %var will be applied to the selected channels
                for i=1:obj.DataNumber
                    newcell{i}(obj.ChanSelect2Edit{i},:)=ones(length(obj.ChanSelect2Edit{i}),1)*val;
                end
            end
            
            for i=1:obj.DataNumber
                if ~isempty(oldcell{i})
                    newcell{i}(isnan(newcell{i}(:,1)),:)=oldcell{i}(isnan(newcell{i}(:,1)),:);
                end
            end
            
        end
        %==================================================================
        %******************************************************************
        function obj = set.Time_(obj,val)
            %Save the current page's event
            if isempty(val)
                return
            end
            if ~isempty(obj.EventDisplayIndex)&&~isempty(obj.EventTexts)
                EventList=obj.Evts_;
                flag=false;
                for i=1:size(obj.EventDisplayIndex,2)
                    if ishandle(obj.EventTexts(1,i))
                        newText=get(obj.EventTexts(1,i),'String');
                        if ~strcmpi(newText,obj.Evts_{obj.EventDisplayIndex(1,i),2})
                            EventList{obj.EventDisplayIndex(1,i),2}=newText;
                            flag=true;
                        end
                    end
                end
                if flag
                    obj.Evts_=EventList;
                end
            end
            if ~isempty(obj.SRate)
                m=floor((size(obj.Data{1},1)-1)/obj.SRate);
            else
                m=val;
            end
            
            prevTime=obj.Time_;
            obj.Time_=min(max(val,0),m);
            set(obj.EdtTime,'String',obj.Time_);
            
            if ~isempty(prevTime)
                obj.VideoLineTime=obj.Time+obj.VideoLineTime-prevTime;
            else
                obj.VideoLineTime=obj.Time;
            end
            
        end
        
        function obj = set.Gain_(obj,val)
            if iscell(val)
                obj.Gain_=val;
            elseif isnumeric(val)
                obj.Gain_=obj.applyPanelVal(obj.Gain_,val);
            end
            
            for i=1:length(obj.Gain_)
                obj.Gain_{i}(isnan(obj.Gain_{i}))=1;
            end
        end
        %******************************************************************
        function obj = set.DataView_(obj,val)
            obj.DataView_=val;
            
            if ~isempty(regexp(val,'DAT','ONCE'))
                if ~isempty(obj.Title{obj.DisplayedData})
                    set(obj.Fig,'Name',[obj.Title{obj.DisplayedData},' -- ',obj.Version]);
                end
            else
                set(obj.Fig,'Name',obj.Version);
            end
            
            
            if ~obj.IsInitialize
                dd=obj.DisplayedData;
                if all(cellfun(@isempty,obj.ChanSelect2Edit(dd)))
                    %If there is no channel selected on the current page
                    
                    resetFilterPanel(obj);
                end
            end
        end
        %******************************************************************
        function obj = set.AxesBackgroundColor_(obj,val)
            obj.AxesBackgroundColor_=val;
            if ~isempty(obj.Axes)
                set(obj.Axes(obj.DisplayedData(ishandle(obj.Axes(obj.DisplayedData)))),'color',val);
            end
            
        end
        %******************************************************************
        function obj = set.XGrid_(obj,val)
            if ischar(val)
                obj.XGrid_=strcmpi(val,'on');
            else
                obj.XGrid_=val;
            end
            if obj.XGrid_
                set(obj.MenuXGrid,'Checked','on');
                
                if ~isempty(obj.Axes)
                    set(obj.Axes,'XGrid','on','XMinorGrid','on');
                end
                
            else
                set(obj.MenuXGrid,'Checked','off');
                if ~isempty(obj.Axes)
                    set(obj.Axes,'XGrid','off','XMinorGrid','off');
                end
            end
        end
        
        %******************************************************************
        function obj = set.YGrid_(obj,val)
            if ischar(val)
                obj.YGrid_=strcmpi(val,'on');
            else
                obj.YGrid_=val;
            end
            if obj.YGrid_
                set(obj.MenuYGrid,'Checked','on');
                if ~isempty(obj.Axes)
                    set(obj.Axes,'YGrid','on','YMinorGrid','on');
                end
            else
                set(obj.MenuYGrid,'Checked','off');
                if ~isempty(obj.Axes)
                    set(obj.Axes,'YGrid','off','YMinorGrid','off');
                end
            end
        end
        %==================================================================
        %******************************************************************
        function obj = set.EventsDisplay_(obj,val)
            if ischar(val)
                obj.EventsDisplay_=strcmpi(val,'on');
            else
                obj.EventsDisplay_=val;
            end
            
            if obj.EventsDisplay_
                set(obj.MenuEventsDisplay,'Checked','on');
            else
                set(obj.MenuEventsDisplay,'Checked','off');
            end
            
            %Update EventDisplayIndex
            
            
            obj.synchEvts();
        end
        function obj = set.SelectedEvent_(obj,val)
            obj.SelectedEvent_=unique(val);
            
            if ~isempty(val)
                [f,loc]=ismember(val,obj.WinEvts.EvtIndex);
                
                set(obj.WinEvts.uilist,'value',loc);
                set(obj.EventInfo,'String',[num2str(obj.EventSummaryIndex(loc(1))),'|',num2str(obj.EventSummaryNumber(loc(1)))]);
            end
            
        end
        function obj = set.AdvanceEventsDisplay_(obj,val)
            if ischar(val)
                obj.AdvanceEventsDisplay_=strcmpi(val,'on');
            else
                obj.AdvanceEventsDisplay_=val;
            end
            
            if obj.AdvanceEventsDisplay_
                set(obj.MenuAdvanceEventsDisplay,'Checked','on');
            else
                set(obj.MenuAdvanceEventsDisplay,'Checked','off');
            end
            
            obj.synchEvts();
        end
        
        function obj = set.EventsWindowDisplay_(obj,val)
            if ischar(val)
                obj.EventsWindowDisplay_=strcmpi(val,'on');
            else
                obj.EventsWindowDisplay_=val;
            end
            
            if obj.EventsWindowDisplay_
                set(obj.MenuEventsWindow,'Checked','on');
            else
                set(obj.MenuEventsWindow,'Checked','off');
            end
            pos=get(obj.Fig,'position');
            ctrlsize=obj.ControlBarSize;
            if  ~isempty(obj.Evts_)&&obj.EventsWindowDisplay
                set(obj.EventPanel,'Visible','on');
                set(obj.AdjustPanel,'Visible','on');
                posAdjust=get(obj.AdjustPanel,'Position');
                
                set(obj.MainPanel,'position',[posAdjust(1)+posAdjust(3) ctrlsize(2) pos(3)-(posAdjust(1)+posAdjust(3)) pos(4)-ctrlsize(2)]);
                obj.resizeAxes([posAdjust(1)+posAdjust(3) ctrlsize(2) pos(3)-(posAdjust(1)+posAdjust(3)) pos(4)-ctrlsize(2)]);
                
            else
                set(obj.EventPanel,'Visible','off');
                set(obj.AdjustPanel,'Visible','off');
                set(obj.MainPanel,'position',[0 ctrlsize(2) pos(3) pos(4)-ctrlsize(2)]);
                obj.resizeAxes([0 ctrlsize(2) pos(3) pos(4)-ctrlsize(2)]);
                
            end
        end
        %==================================================================
        %******************************************************************
        function obj = set.ControlPanelDisplay_(obj,val)
            if ischar(val)
                obj.ControlPanelDisplay_=strcmpi(val,'on');
            else
                obj.ControlPanelDisplay_=val;
            end
            
            evtPos=get(obj.EventPanel,'position');
            adjustPos=get(obj.AdjustPanel,'position');
            mainPos=get(obj.MainPanel,'position');
            ctrlsize=obj.ControlBarSize;
            
            if obj.ControlPanelDisplay_
                set(obj.MenuControlPanel,'Checked','on');
                set(obj.ControlPanel,'Visible','on');
                
                set(obj.EventPanel,'position',[0,ctrlsize(2),evtPos(3),evtPos(4)-ctrlsize(2)]);
                set(obj.AdjustPanel,'position',[adjustPos(1),ctrlsize(2),adjustPos(3),adjustPos(4)-ctrlsize(2)]);
                set(obj.MainPanel,'position',[mainPos(1),ctrlsize(2),mainPos(3),mainPos(4)-ctrlsize(2)]);
                obj.resizeAxes([mainPos(1),ctrlsize(2),mainPos(3),mainPos(4)-ctrlsize(2)]);
            else
                set(obj.MenuControlPanel,'Checked','off');
                set(obj.ControlPanel,'Visible','off');
                
                set(obj.EventPanel,'position',[0,0,evtPos(3),evtPos(4)+ctrlsize(2)]);
                set(obj.AdjustPanel,'position',[adjustPos(1),0,adjustPos(3),adjustPos(4)+ctrlsize(2)]);
                set(obj.MainPanel,'position',[mainPos(1),0,mainPos(3),mainPos(4)+ctrlsize(2)]);
                obj.resizeAxes([mainPos(1),0,mainPos(3),mainPos(4)+ctrlsize(2)]);
            end
        end
        %==================================================================
        %******************************************************************
        function obj = set.LockLayout_(obj,val)
            if ischar(val)
                obj.LockLayout_=strcmpi(val,'on');
            else
                obj.LockLayout_=val;
            end
            
            if obj.LockLayout_
                set(obj.MenuLockLayout,'Checked','on');
            else
                set(obj.MenuLockLayout,'Checked','off');
            end
            
        end
        %==================================================================
        %******************************************************************
        function obj = set.DisplayGauge_(obj,val)
            if ischar(val)
                obj.DisplayGauge_=strcmpi(val,'on');
            else
                obj.DisplayGauge_=val;
            end
            
            showGauge(obj);
            
        end
        %==================================================================
        %******************************************************************
        
        function obj = set.ToolbarDisplay_(obj,val)
            if ischar(val)
                obj.ToolbarDisplay_=strcmpi(val,'on');
            else
                obj.ToolbarDisplay_=val;
            end
            
            if obj.ToolbarDisplay_
                set(obj.MenuToolbarDisplay,'Checked','on');
                set(obj.Toolbar,'Visible','on');
            else
                set(obj.MenuToolbarDisplay,'Checked','off');
                set(obj.Toolbar,'Visible','off');
            end
            
        end
        %==================================================================
        %******************************************************************
        function obj = set.MouseMode_(obj,val)
            obj.MouseMode_=val;
            offon={'off','on'};
            if isempty(val)
                offon={'off','off'};
                maskMeasurer(obj);
                maskAnnotate(obj);
            end
            set(obj.TogMeasurer,'State',offon{1+strcmpi(val,'Measurer')});
            set(obj.TogSelection,'State',offon{1+strcmpi(val,'Select')});
            set(obj.TogAnnotate,'State',offon{1+strcmpi(val,'Annotate')});
            
        end
        %==================================================================
        function obj =set.VideoTimerPeriod_(obj,val)
            obj.VideoTimerPeriod_=val;
            set(obj.VideoTimer,'period',val);
        end
        
        %==================================================================
        %******************************************************************
        function obj=set.Selection_(obj,val)
            obj.Selection_=val;
            
            if ~isempty(val)&&~isempty(obj.Evts_)
                tmp=reshape(obj.SelectedEvent,length(obj.SelectedEvent),1);
                for i=1:size(obj.Evts_,1)
                    for j=1:size(val,2)
                        if obj.Evts_{i,1}>=val(1,j)&&obj.Evts_{i,1}<=val(2,j)
                            tmp=cat(1,tmp,i);
                        end
                    end
                end
                
                obj.SelectedEvent=tmp;
            end
        end
        %==================================================================
        %******************************************************************
        function obj=set.FirstDispChans_(obj,val)
            tmp=ones(1,obj.DataNumber);
            
            if length(val)==1
                tmp=min(val*ones(obj.DataNumber,1),obj.MontageChanNumber-obj.DispChans+1);
            elseif isempty(val)
                tmp=ones(1,obj.DataNumber);
            else
                for i=1:length(val)
                    if ~val(i)||isnan(val(i))
                        tmp(i)=1;
                    else
                        tmp(i)=val(i);
                    end
                end
            end
            
            tmp=round(tmp);
            for i=1:length(tmp)
                tmp(i)=max(1,min(tmp(i),obj.MontageChanNumber(i)-obj.DispChans(i)+1));
            end
            obj.FirstDispChans_=reshape(tmp,length(tmp),1);
        end
        %==================================================================
        %******************************************************************
        function obj=set.DispChans_(obj,val)
            tmp=obj.ChanNumber;
            
            if length(val)==1
                tmp=min(val*ones(obj.DataNumber,1),obj.MontageChanNumber);
            elseif isempty(val)
                tmp=obj.MontageChanNumber;
            else
                for i=1:length(val)
                    if ~val(i)||isnan(val(i))
                        tmp(i)=obj.MontageChanNumber(i);
                    else
                        tmp(i)=val(i);
                    end
                end
            end
            
            tmp=round(tmp);
            for i=1:length(tmp)
                tmp(i)=max(1,min(tmp(i),obj.MontageChanNumber(i)));
            end
            obj.DispChans_=reshape(tmp,length(tmp),1);
            
        end
        
        %==================================================================
        %******************************************************************
        function obj=set.ChanSelect2Display_(obj,val)
            tmp=cell(1,obj.DataNumber);
            
            for i=1:length(val)
                if isempty(val{i})
                    tmp{i}=1:obj.MontageChanNumber(i);
                else
                    tmp{i}=val{i};
                end
            end
            
            
            for i=1:length(tmp)
                tmp{i}=reshape(max(1,min(round(tmp{i}),obj.MontageChanNumber(i))),length(tmp{i}),1);
            end
            
            obj.ChanSelect2Display_=tmp;
        end
        %==================================================================
        %******************************************************************
        function obj = set.ChanSelect2Edit_(obj,val)
            tmp=cell(1,obj.DataNumber);
            [tmp{:}]=deal([]);
            if iscell(val)
                if length(val)==1
                    [tmp{:}]=deal(val{1});
                elseif length(val)==obj.DataNumber
                    tmp=val;
                end
            else
                [tmp{:}]=deal(val);
            end
            
            for i=1:length(tmp)
                if ~isempty(tmp{i})
                    tmp{i}=unique(reshape(max(1,min(round(tmp{i}),obj.MontageChanNumber(i))),length(tmp{i}),1),'stable');
                end
            end
            
            obj.ChanSelect2Edit_=tmp;
            
        end
        %==================================================================
        %******************************************************************
        function obj=set.VideoTimeFrame(obj,val)
            if ~isempty(val)
                frame=(1:max(val(:,2)))';
                time=interp1(val(:,2),val(:,1),1:max(val(:,2)),'linear','extrap');
                time=reshape(time,length(time),1);
                
                obj.VideoTimeFrame=cat(2,time,frame);
                
                obj.VideoStampFrame=round(interp1(val(:,1),val(:,2),(0:size(obj.Data{1},1)-1)/obj.SRate,'linear','extrap'));
            end
        end
        
        %==================================================================
        %******************************************************************
        function obj = set.VideoLineTime(obj,val)
            
            obj.VideoLineTime=val;
            %try
            t=(val-obj.Time)*obj.SRate_;
            
            for i=1:length(obj.LineVideo)
                if ishandle(obj.LineVideo(i))
                    set(obj.LineVideo(i),'XData',[t t]);
                end
            end
        end
        %==================================================================
        %******************************************************************
        function obj=set.PlaySpeed_(obj,val)
            obj.PlaySpeed_=val;
            if isa(obj.WinVideo,'VideoWindow') && isvalid(obj.WinVideo)
                obj.WinVideo.PlaySpeed=val;
            end
        end
        %==================================================================
        
        
        function val=get.IsDataSameSize(obj)
            tmp=cellfun(@size,obj.Data,'UniformOutput',false);
            for i=1:length(tmp)
                if ~all(tmp{i}==tmp{1})
                    val=false;
                    return
                end
            end
            val=true;
            
        end
        
        function val=get.DisplayedData(obj)
            if isempty(obj.DataView)
                val=1:obj.DataNumber;
            elseif ismember(obj.DataView,...
                    {'Vertical','Horizontal'})
                val=1:obj.DataNumber;
            else
                if strcmpi(obj.DataView(1:3),'DAT')
                    val=round(str2double(obj.DataView(4)));
                else
                    val=1:obj.DataNumber;
                end
            end
        end
        
        function val=get.IsChannelSelected(obj)
            val=~all(cellfun(@isempty,obj.ChanSelect2Edit));
        end
    end
    
    methods (Access=protected)
        function a=DefaultConfigFile(obj) %#ok<MANU>
            a='defaultconfig';
        end
        
        %******************************************************************
        %Dynamic return the channel number,dataset number,amplitude in
        %sequence
        [nchan,ndata,yvalue]=getMouseInfo(obj)
        %==================================================================
        %******************************************************************
        %**********General functions called when setting properties********
        %******************************************************************
        %******************************************************************
        %Main interface Initialization
        buildfig(obj)
        %==================================================================
        %******************************************************************
        %Main interface Menu Initialization
        makeMenu(obj)
        %==================================================================
        %******************************************************************
        
        %******************************************************************
        %Time Navigation Panel Initialization
        timeControlPanel(obj,parent,position)
        %==================================================================
        %******************************************************************
        %Realtime Info Panel Initialization
        infoControlPanel(obj,parent,position)
        %==================================================================
        %******************************************************************
        %Filter Panel Initialization
        filterControlPanel(obj,parent,position)
        %==================================================================
        function makeToolbar(obj)
            obj.montageToolbar();
            obj.viewToolbar();
            obj.toolToolbar();
        end
        %=================================================================
        %******************************************************************
        function montageToolbar(obj)
            obj.TogMontage=uitoggletool(obj.Toolbar,'CData',imread('Raw.bmp'),...
                'TooltipString','Raw','ClickedCallback',@(src,evt) resetMontage(obj));
            
            obj.TogComAve=uitoggletool(obj.Toolbar,'CData',imread('common.bmp'),...
                'TooltipString','Mean Ref','ClickedCallback',@(src,evt) resetMontage(obj,2));
            
        end
        
        function resetMontage(obj,varargin)
            
            if isempty(varargin)
                ind=1;
            else
                ind=varargin{1};
            end
            
            for i=1:obj.DataNumber
                src=obj.MontageOptMenu{i}(ind);
                ChangeMontage(obj,src,i,ind);
            end
        end
        
        %******************************************************************
        %Data Set View Navigation Toolbar Initialization
        viewToolbar(obj)
        %==================================================================
        %******************************************************************
        %General Toolbar Initialization
        toolToolbar(obj)
        %==================================================================
        %******************************************************************
        remakeMontage(obj)
        %******************************************************************
        function resetView(obj)
            % Reset the Tools when properties are changing
            
            if  obj.DataNumber==1
                
                set(obj.TogHorizontal,'Enable','off')
                set(obj.TogVertical,'Enable','off')
                
            end
            
            if isempty(obj.DataView_)
                if(obj.DataNumber>=2)
                    obj.DataView_='Vertical';
                else
                    obj.DataView_='DAT1';
                end
            elseif isnumeric(obj.DataView_)
                obj.DataView_=['DAT' num2str(obj.DataView_)];
            end
            
            if ischar(obj.MontageRef_) || isscalar(obj.MontageRef_)
                tmp(1:obj.DataNumber)={obj.MontageRef_};
            elseif iscell(obj.MontageRef_)
                tmp=obj.MontageRef_;
            elseif isvector(obj.MontageRef_)
                tmp=num2cell(obj.MontageRef_);
            end
            obj.MontageRef_=[];
            for i=1:obj.DataNumber
                if isscalar(tmp{i})
                    obj.MontageRef_(i)=tmp{i};
                else
                    for j=1:length(obj.Montage{i})
                        if strcmpi(tmp{i},obj.Montage{i}(j).name)
                            obj.MontageRef_(i)=j;
                        end
                    end
                end
            end
            
            
            offon={'off','on'};
            set(obj.TogHorizontal,'State',offon{strcmpi(obj.DataView_,'Horizontal')+1});
            set(obj.TogVertical,'State',offon{strcmpi(obj.DataView_,'Vertical')+1})
            
        end
        
        %******************************************************************
        %********************Interface Action Methods *********************
        %******************************************************************

        function WinVideoFcn(obj)
            if isa(obj.WinVideo,'VideoWindow') && isvalid(obj.WinVideo)
                %Bring Video Figure To The Front If Exists
                figure(obj.WinVideo.Fig)
            else
                if ~isempty(obj.VideoFile)&& exist(obj.VideoFile,'file')==2
                    obj.WinVideo=VideoWindow(obj.VideoFile,obj.VideoActxOpt); %VLC or WMPlayer
                    addlistener(obj.WinVideo,'VideoChangeTime',@(src,evt) SynchDataWithVideo(obj));
                    addlistener(obj.WinVideo,'VideoChangeState',@(src,ect) SynchVideoState(obj));
                    addlistener(obj.WinVideo,'VideoClosed',@(src,evt) StopPlay(obj));
                end
            end
        end
        %==================================================================
        %******************************************************************
        function ChangeMouseMode(obj,src)
            s='';
            obj.SelectionStart=[];
            if strcmpi(get(src,'State'),'on')
                if src==obj.TogMeasurer
                    remakeMeasurer(obj);
                    s='Measurer';
                elseif src==obj.TogSelection
                    s='Select';
                elseif src==obj.TogAnnotate
                    remakeAnnotate(obj);
                    s='Annotate';
                end
            end
            obj.MouseMode=s;
        end
        %==================================================================
        %******************************************************************
        %Callback for slider operation
        ChangeSliders(obj,src,evt)
        %==================================================================
        %******************************************************************
        %Callback for click operation
        MouseDown(obj)
        MouseUp(obj)
        %==================================================================
        %******************************************************************
        %Callback for Keyboard operation
        KeyPress(obj,src,evt)
        KeyRelease(obj,src,evt)
        %==================================================================
        %******************************************************************
        %Callback for Dynamic Measuer
        MouseMovementMeasurer(obj)
        %==================================================================
        %******************************************************************
        %Callback for Dynamic Mouse Movement
        MouseMovement(obj)
        %==================================================================
        %******************************************************************
        %Callback for Event File Load
        LoadEvents(obj)
        %==================================================================
        %******************************************************************
        %Callback for Event File Save
        SaveEvents(obj)
        %==================================================================
        %******************************************************************
        %Callback for number of channels per page limitaion
        MnuChan2Display(obj)
        
        %==================================================================
        %******************************************************************
        %Callback for number of channels per page limitaion
        MnuWidth2Display(obj)
        %==================================================================
        %******************************************************************
        %Callback for Video Load
        LoadVideo(obj)
        %==================================================================
        %******************************************************************
        %Callback for gain change
        ChangeGain(obj,src)
        %==================================================================
        %******************************************************************
        %Callback for channel page change
        ChangeChan(obj,src)
        %==================================================================
        moveSelectedEvents(obj,step)
        %==================================================================
        function MnuVideoOnTop(obj)
            if strcmpi(get(obj.MenuVideoOnTop,'checked'),'on')
                set(obj.MenuVideoOnTop,'checked','off');
                ontop=false;
            else
                set(obj.MenuVideoOnTop,'checked','on');
                ontop=true;
            end
            
            if isa(obj.WinVideo,'VideoWindow') && isvalid(obj.WinVideo)
                obj.WinVideo.IsOnTop=ontop;
            end
            
        end
        function MnuPlay(obj)
            %**************************************************************
            % Dialog box to change the speed for play
            %**************************************************************
            t=inputdlg('Speed of play : X ','Play Speed',1,{num2str(obj.PlaySpeed)});
            if ~isempty(t)
                t=str2double(t{1});
                if ~isnan(t)
                    obj.PlaySpeed=t;
                end
            end
        end
        %==================================================================
        %******************************************************************
        function MnuSampleRate(obj)
            %**************************************************************
            % Dialog box to change the sampling frequency
            %**************************************************************
            t=inputdlg('Sampling Frequency (Hz) : ','Sample rate',1,{num2str(obj.SRate)});
            if ~isempty(t)
                t=str2double(t{1});
                if ~isnan(t)
                    obj.SRate=t;
                end
            end
        end
        %==================================================================
        %******************************************************************
        function SaveToFigure(obj)
            f=figure('Name','Mirror figure','Position',get(obj.Fig,'Position'));
            %             for i=1:length(obj.Axes)
            %                 set(obj.Axes(i),'YTick',[]);
            %                 set(obj.Axes(i),'XTick',[]);
            %             end
            copyobj(obj.Axes(:),f);
        end
        function SaveToWindow(obj)
            SaveWindow(obj);
        end
        %==================================================================
        %******************************************************************
        LoadDataSet(obj)
        %==================================================================
        %******************************************************************
        
        function WinFastEvents(obj)
            obj.WinFastEvts=FastEventWindow(obj,obj.FastEvts,obj.SelectedFastEvt);
            addlistener(obj.WinFastEvts,'FastEvtsChange',@(src,evt) set(obj,'FastEvts',obj.WinFastEvts.FastEvts));
            addlistener(obj.WinFastEvts,'SelectedFastEvtChange',@(src,evt) set(obj,'SelectedFastEvt',obj.WinFastEvts.SelectedFastEvt));
        end
        %******************************************************************
        function s=ControlBarSize(obj) %#ok<MANU>
            s=[1100,35];
        end
        
        function w=EventPanelWidth(obj)
            w=150;
        end
        
        function w=AdjustWidth(obj)
            w=10;
        end
        
        function w=ElevWidth(obj)
            w=20;
        end
        
        function w=AxesAdjustWidth(obj)
            w=10;
        end
        
        function resizeAxes(obj,MainPos)
            n=length(obj.Axes);
            for i=1:length(obj.Axes)
                if strcmp(obj.DataView,'Vertical')
                    if i==1
                        start=0;
                    else
                        start=(MainPos(4)-(n-1)*obj.AxesAdjustWidth)/sum(obj.DispChans)*sum(obj.DispChans(1:i-1));
                    end
                    start=start+(i-1)*obj.AxesAdjustWidth;
                    Height=(MainPos(4)-(n-1)*obj.AxesAdjustWidth)/sum(obj.DispChans)*obj.DispChans(i);
                    position=[0    start    MainPos(3)-obj.ElevWidth    Height];
                    
                    set(obj.Axes(i),'Position',position);
                    
                    set(obj.Sliders(i),'Position',[MainPos(3)-obj.ElevWidth start obj.ElevWidth Height]);
                    
                    if i~=n
                        set(obj.AxesAdjustPanels(i),'Position',[0,(position(2)+Height),MainPos(3),obj.AxesAdjustWidth]);
                    end
                    
                end
                
            end
        end
        function resize(obj)
            pos=get(obj.Fig,'position');
            cbs=obj.ControlBarSize;
            
            if isempty(pos)
                return
            end
            if pos(3)<=cbs(1)
                if obj.LockLayout
                    pos(3)=cbs(1);
                end
            end
            
            set(obj.Fig,'position',pos);
            
            ctrlsize=obj.ControlBarSize;
            
            posEvent=get(obj.EventPanel,'Position');
            
            adjustwidth=obj.AdjustWidth;
            
            
            if obj.ControlPanelDisplay
                set(obj.EventPanel,'position',[0 ctrlsize(2) posEvent(3) pos(4)-ctrlsize(2)]);
                set(obj.AdjustPanel,'position',[posEvent(3) ctrlsize(2) adjustwidth pos(4)-ctrlsize(2)]);
            else
                set(obj.EventPanel,'position',[0 0 posEvent(3) pos(4)]);
                set(obj.AdjustPanel,'position',[posEvent(3) 0 adjustwidth pos(4)]);
            end
            
            
            if  ~isempty(obj.Evts_)&&obj.EventsWindowDisplay
                set(obj.EventPanel,'Visible','on');
                set(obj.AdjustPanel,'Visible','on');
                if obj.ControlPanelDisplay
                    MainPos=[posEvent(3)+adjustwidth ctrlsize(2) pos(3)-posEvent(3)-adjustwidth pos(4)-ctrlsize(2)];
                    set(obj.MainPanel,'position',MainPos);
                else
                    MainPos=[posEvent(3)+adjustwidth 0 pos(3)-posEvent(3)-adjustwidth pos(4)];
                    set(obj.MainPanel,'position',MainPos);
                end
            else
                set(obj.EventPanel,'Visible','off');
                set(obj.AdjustPanel,'Visible','off');
                if obj.ControlPanelDisplay
                    MainPos=[0 ctrlsize(2) pos(3) pos(4)-ctrlsize(2)];
                    set(obj.MainPanel,'position',MainPos);
                else
                    MainPos=[0 0 pos(3) pos(4)];
                    set(obj.MainPanel,'position',MainPos);
                end
            end
            
            set(obj.ControlPanel,'position',[0 0 pos(3) ctrlsize(2)]);
            obj.resizeAxes(MainPos);
        end
        
        function recalculate(obj)
            obj.PreprocData=cell(1,obj.DataNumber);
            for i=1:obj.DataNumber
                obj.PreprocData{i}=preprocessedData(obj,i);
            end
        end
        
        
        
        function ChangeDuration(obj,src)
            val=obj.WinLength;
            
            if isnan(val)
                val=10;
            end
            
            if src==obj.BtnWidthIncrease
                val=val*(16/15);
            elseif src==obj.BtnWidthDecrease
                val=val*(14/15);
            end
            
            if val<=0
                val=1;
            elseif val>obj.DataTime
                val=obj.DataTime;
            end
            obj.WinLength=val;
        end
        
        function ChangeFilter(obj,src)
            switch src
                case obj.EdtFilterLow
                    if str2double(get(src,'String'))==0||isnan(str2double(get(src,'String')))
                        set(src,'String','-');
                    end
                    
                case obj.EdtFilterHigh
                    if str2double(get(src,'String'))==0||isnan(str2double(get(src,'String')))
                        set(src,'String','-');
                    end
                case obj.EdtFilterNotch1
                    if str2double(get(src,'String'))==0||isnan(str2double(get(src,'String')))
                        set(src,'String','-');
                    end
                case obj.EdtFilterNotch2
                    if str2double(get(src,'String'))==0||isnan(str2double(get(src,'String')))
                        set(src,'String','-');
                    end
                case obj.PopFilter
                    if get(obj.PopFilter,'value')==1
                        scanFilterBank(obj);
                    end
                    
            end
            
            filterCheck(obj);
        end
        
        
        function synchEvts(obj)
            
            if isempty(obj.Evts_)
                return
            end
            
            obj.WinEvts.Evts=obj.Evts_;
            
        end
        
        function remakeMeasurer(obj)
            Nchan=obj.MontageChanNumber;
            deleteMeasurer(obj);
            for i=1:length(obj.Axes)
                obj.LineMeasurer(i)=line([inf inf],[0 1000],'parent',obj.Axes(i),'Color',[1 0 0]);
                uistack(obj.LineMeasurer(i),'top');
                
                for j=1:Nchan(i)
                    obj.TxtMeasurer{i}(j)=text('Parent',obj.Axes(i),'position',[inf,j],'EdgeColor',[0 0 0],'BackgroundColor',[0.7 0.7 0],...
                        'VerticalAlignment','Top','Margin',1,'FontSize',10,'FontName','FixedWidth');
                    uistack(obj.TxtMeasurer{i}(j),'top');
                end
            end
        end
        function maskMeasurer(obj)
            Nchan=obj.MontageChanNumber;
            if ~isempty(obj.LineMeasurer)&&~isempty(obj.TxtMeasurer)
                for i=1:length(obj.Axes)
                    set(obj.LineMeasurer(i),'XData',[inf inf]);
                    if all(ishandle(obj.TxtMeasurer{i}))
                        for j=1:Nchan(i)
                            
                            set(obj.TxtMeasurer{i}(j),'position',[inf j]);
                            
                        end
                    end
                end
            end
        end
        
        function deleteMeasurer(obj)
            if ~isempty(obj.LineMeasurer)
                delete(obj.LineMeasurer(ishandle(obj.LineMeasurer)));
            end
            if ~isempty(obj.TxtMeasurer)
                for i=1:length(obj.Axes)
                    delete(obj.TxtMeasurer{i}(ishandle(obj.TxtMeasurer{i})))
                end
            end
        end
        
        function remakeAnnotate(obj)
            deleteAnnotate(obj);
            for i=1:length(obj.Axes)
                yl=get(obj.Axes(i),'Ylim');
                
                obj.LineMeasurer(i)=line([inf inf],[0 1000],'parent',obj.Axes(i),'Color',[1 0 0]);
                
                obj.TxtFastEvent(i)=text('Parent',obj.Axes(i),'position',[inf yl(2)],'VerticalAlignment','Top','Margin',1,'FontSize',12,...
                    'Editing','off');
                
                uistack(obj.LineMeasurer(i),'top')
                uistack(obj.TxtFastEvent(i),'top')
            end
        end
        function maskAnnotate(obj)
            if ~isempty(obj.TxtFastEvent)&&~isempty(obj.LineMeasurer)
                for i=1:length(obj.Axes)
                    
                    yl=get(obj.Axes(i),'ylim');
                    if ishandle(obj.LineMeasurer(i))
                        set(obj.LineMeasurer(i),'XData',[inf inf]);
                    end
                    if ishandle(obj.TxtFastEvent(i))
                        set(obj.TxtFastEvent(i),'position',[inf yl(2)]);
                    end
                end
            end
        end
        function deleteAnnotate(obj)
            if ~isempty(obj.LineMeasurer)
                delete(obj.LineMeasurer(ishandle(obj.LineMeasurer)));
            end
            
            if ~isempty(obj.TxtFastEvent)
                delete(obj.TxtFastEvent(ishandle(obj.TxtFastEvent)));
            end
        end
        function MnuLineColor(obj)
            
            col=uisetcolor('Line Color');
            if length(col)~=1||col~=0
               set(obj,'ChanColors',obj.applyPanelVal(obj.ChanColors_,col));
            end
        end
    end
    
    methods
        modifySelecetdEvent(obj,opt)
        groupModifySelectedEvent(obj,opt)
        openText(obj,src,axenum,count)
        addNewEvent(obj,newEvent)
        updateSelectedFastEvent(obj,x)
        Time_Freq_Map(obj,src)
        filterCheck(obj)
        SaveData(obj,src)
        ExportDataToWorkspace(obj)
        d=preprocessedAllData(obj,n,chan,selection)
        ChangeTime(obj,src)
        redrawChangeBlock(obj,opt)
        showGauge(obj)
        maskChannel(obj,src)
        MnuChanGain(obj,src)
        LoadMontage(obj)
        remakeMontageMenu(obj)
        ChangeMontage(obj,src,data,mtgref)
        scanFilterBank(obj)
        Power_Spectrum_Density(obj,src)
        SPF_Analysis(obj,src)
        SynchDataWithVideo(obj)
        Mean_Reference_Filter(obj)
        SaveMontage(obj)
        Temporal_PCA(obj)
        Spatial_PCA(obj)
        Auto_Remove_ECG_Artifact(obj)
        ReadMontage(obj)
        LoadFilter(obj)
        NewMontage(obj)
        MnuFigurePosition(obj)
        EventRepeatSelection(obj)
        updateVideo(obj)
        LoadChannelPosition(obj)
        MnuNextPrevFile(obj)
        SavePosition(obj)
    end
    
    methods
        function StartPlay(obj)
            set(obj.TogPlay,'CData',obj.IconPause,'ClickedCallback',@(src,evt) PausePlay(obj),'State','on');
            if strcmpi(obj.VideoTimer.Running,'off')
                start(obj.VideoTimer);
            end
            if isa(obj.WinVideo,'VideoWindow') && isvalid(obj.WinVideo)
                obj.WinVideo.play;
            end
        end
        
        function PausePlay(obj)
            set(obj.TogPlay,'CData',obj.IconPlay,'ClickedCallback',@(src,evt) StartPlay(obj),'State','off');
            if strcmpi(obj.VideoTimer.Running,'on')
                stop(obj.VideoTimer);
            end
            if isa(obj.WinVideo,'VideoWindow') && isvalid(obj.WinVideo)
                obj.WinVideo.pause;
            end
        end
        function StopPlay(obj)
            set(obj.TogPlay,'CData',obj.IconPlay,'ClickedCallback',@(src,evt) StartPlay(obj),'State','off');
            if strcmpi(obj.VideoTimer.Running,'on')
                stop(obj.VideoTimer);
            end
            %             obj.VideoLineTime=0;
        end
        function PlayFaster(obj)
            obj.PlaySpeed=obj.PlaySpeed+1;
            if obj.PlaySpeed==0
                obj.PlaySpeed=1;
            end
        end
        
        function PlaySlower(obj)
            obj.PlaySpeed=obj.PlaySpeed/2;
        end
        
        function SynchVideoState(obj)
            if strcmpi(obj.WinVideo.Status,'Playing')
                set(obj.TogPlay,'CData',obj.IconPause,'ClickedCallback',@(src,evt) PausePlay(obj),'State','on');
                if strcmpi(obj.VideoTimer.Running,'off')
                    start(obj.VideoTimer);
                end
            else
                set(obj.TogPlay,'CData',obj.IconPlay,'ClickedCallback',@(src,evt) StartPlay(obj),'State','off');
                if strcmpi(obj.VideoTimer.Running,'on')
                    stop(obj.VideoTimer);
                end
            end
            
            obj.PlaySpeed=obj.WinVideo.PlaySpeed;
        end
    end
    properties
        EventDisplayIndex       %Indx of displayed events
        EventLines              %Event lines displayed
        EventTexts              %Event texts displayed
        
        SelectedEvent
        
        DragMode
        ClickDrag
        EditMode
        ResizeMode
        AxesResizeMode
        
        FileNames
        StartTime
        
        VideoActxOpt           %WMP or VLC
        VideoStartTime         %Start time of the first frame of the video
        VideoEndTime           %End time of the video
        
        VideoFile              %File path of video
        
        VideoTimeFrame
        VideoStampFrame
        VideoLineTime
        NumberOfFrame
        
        VideoTimer
        
        IsEvtsSaved
        
        MAudioPlayer
        UponText
        
        EventPanel
        AdjustPanel
        
        PrevMouseTime
        UponAdjustPanel
        UponAxesAdjustPanel
        
        EventSummaryIndex
        EventSummaryNumber
        
        CustomFilters
        
        CNELabDir
        
        SPFObj
        
        TPCA_Event_Label
        TPCA_Seg_Before
        TPCA_Seg_After
        TPCA_S
        
        SPCA_Event_Label
        SPCA_Seg_Before
        SPCA_Seg_After
        
        STFTFreqLow
        STFTFreqHigh
        STFTScaleLow
        STFTScaleHigh
        STFTNormalizePoint
        
        PSDFreqLow
        PSDFreqHigh
        
        Montage_
        
        NextFiles
        PrevFiles
        
        TFMapBeforeOnset%ms
        TFMapAfterOnset%ms
        TFMapEvent
        TFMapRestStart
        TFMapRestEnd
    end
    events
        SelectedFastEvtChange
    end
end