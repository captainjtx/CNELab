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
        JBtnSwitchData
        JBtnPrevEvent
        JBtnPrevEvent1
        JBtnStart
        JBtnPrevPage
        JBtnPrevSec
        EdtTime
        JBtnNextSec
        JBtnNextPage
        JBtnNextEvent
        JBtnNextEvent1
        JBtnEnd
        JBtnSelectWin
        
        JChannelNumberSpinner
        JSensitivitySpinner
        
        
        TxtInfo1
        TxtInfo2
        TxtInfo3
        TxtInfo4
        
        ChkFilter
        EdtFilterLow
        EdtFilterHigh
        EdtFilterNotch
        
        PopFilter
        
        JTogNavigation
        
        JBtnPSD
        JBtnTFMap
        JBtnPCA
        JBtnICA
        
        JBtnPlaySlower
        JBtnPlayFaster
        JTogPlay
        JTogVideo
        
        JBtnGainIncrease
        JBtnGainDecrease
        
        JBtnAutoScale
        JBtnMaskChannel
        JBtnUnMaskChannel
        
        TxtScale
        ArrScale
        Toolbar
        JToolbar
        JTogMontage
        JTogComAve
        JTogHorizontal
        JTogVertical
        JTogMeasurer
        JTogSelection
        
        JTogAnnotate
        
        MenuFile
        MenuNew
        MenuNewMontage
        MenuSave
        MenuSaveSettings
        MenuSaveData
        MenuSaveEvents
        MenuSavePosition
        
        MenuSaveAs
        MenuSaveAsFigure
        MenuSaveAsEvents
        MenuSaveAsData
        MenuSaveAsEDF
        MenuSaveAsMontage
        MenuSaveAsPosition
        
        MenuLoad
        MenuLoadDataSet
        MenuLoadEvents
        MenuLoadMontage
        MenuLoadVideo
        MenuLoadFilter
        MenuLoadChannelPosition
        MenuLoadSpatialMaps
        
        MenuExport
        MenuExportData
        MenuExportObj
        MenuExportTrials
        
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
        MenuNotchFilter
        MenuNotchFilterSingle
        MenuNotchFilterHarmonics
        MenuOverwritePreprocess
        
        MenuChannel
        MenuDataBuffer
        MenuChannelNumber
        MenuDetrend
        MenuDetrendConstant
        MenuDetrendLinear
        MenuDownSample
        MenuSaveDownSample
        MenuVisualDownSample
        MenuRecordingTime
        
        MenuMontage
        MontageOptMenu
        
        MenuEvent
        MenuNewEvent
        MenuEventsWindow
        MenuFastEvent
        MenuEventsDisplay
        EventOptMenu
        
        MenuDisplay
        MenuDisplayBuffer
        MenuToolbarDisplay
        MenuXGrid
        MenuYGrid
        MenuGauge
        MenuTimeLabel
        MenuChannelLabel
        Menupanels
        MenuControlPanel
        
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
        MenuSpatialMap
        MenuPSD
        MenuCrossCorr
        MenuCrossCorrRaw
        MenuCrossCorrEnv
        
        MenuCohere
        MenuCohereRaw
        MenuCohereEnv
        
        MenuAppDenoise
        MenuMeanRef
        MenuTemporalPCA
        MenuRemovePulse
        MenuSpatialPCA
        MenuRawMap
        
        MenuInterpolate
        
        MenuCSP
        
        
        
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
        Evts_
        Time                    %Current time (in TimeUnit) of the current
        DispChans               %Number of channels to display for each data set.
        FirstDispChans          %First chan to display for each data set
        TimeUnit                %time unit (not active for now)
        Filtering               %True if preprocessing filter are enbaled
        FilterLow               %The low value of filtering: Cut-off frequency of high pass filter
        FilterHigh              %The high value of filtering: Cut-off frequency of low pass filter
        FilterNotch             %The harmonic notch filter
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
        
        FileDir
        
        VisualDownSample
        TotalTime
        BufferStartSample
        BufferEndSample
        
        valid
        cnelab_path
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
        
        Time_
        DispChans_
        FirstDispChans_
        TimeUnit_

        Filtering_
        FilterLow_
        FilterHigh_
        FilterNotch_
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
        
        SelectedEvent_
        
        FastEvts_
        SelectedFastEvt_
        AdvanceEventsFcn_
    end
    properties (SetAccess=protected) %Readonly properties
        Data                        %(Read-Only)All the Signals
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
        ChanNameMargin
        GaugeMargin
        
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
        FilterOrder
    end
 
    properties
        Fig
        Axes
        TFMapFig
        IconPlay
        IconPause
        WinVideo
        TFMapWin
        PSDWin
        SpatialMapWin
        RawMapWin
        InterpolateWin
        
        ExportTrialWin
        
        CSPMapWin
        
        AverageMapWin
        
        PreprocData                 %The currently preprocessed and drawed Data
    end
    
    methods
        
        %*****************************************************************
        function obj=BioSigPlot(data,varargin)  
            obj.IsInitialize=true;
            
            obj.Data=obj.uniform(data);
            
            %These variables are need for buildfig
            %%
            g=varargin;
            
            
            n=find(strcmpi('WinLength',g(1:2:end)))*2;
            if ~isempty(n)
                obj.WinLength_=g{n};
                g(n-1:n)=[];
            else
                obj.WinLength_=15;
            end
            
            n=find(strcmpi('SRate',g(1:2:end)))*2;
            if ~isempty(n)
                obj.SRate_=g{n};
                g(n-1:n)=[];
            else
                obj.SRate_=256;
            end
            
            n=find(strcmpi('TotalSample',g(1:2:end)))*2;
            if ~isempty(n)
                obj.TotalSample=g{n};
                g(n-1:n)=[];
            else
                obj.TotalSample=size(obj.Data{1},1);
            end
            %%
            obj.buildfig;
            
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
            
            obj.TFMapWin=TFMapWindow(obj);
            obj.SpatialMapWin=SpatialMapWindow(obj);
            obj.RawMapWin=RawMapWindow(obj);
            
            obj.InterpolateWin=InterpWin(obj);
            
            obj.ExportTrialWin=ExportSingleTrialWin(obj);
            
            obj.CSPMapWin=CSPMapWindow(obj);
            obj.PSDWin=PSDWindow(obj);
            obj.AverageMapWin=AverageMapWindow(obj);
            obj.WinFastEvts=FastEventWindow(obj);
            addlistener(obj.WinFastEvts,'FastEvtsChange',@(src,evt) set(obj,'FastEvts',obj.WinFastEvts.FastEvts));
            addlistener(obj.WinFastEvts,'SelectedFastEvtChange',@(src,evt) set(obj,'SelectedFastEvt',obj.WinFastEvts.SelectedFastEvt));
            obj.IsInitialize=false;
            
%             set(obj.Fig,'Visible','on')
        end
        
        %*****************************************************************
        function varInitial(obj,g)
            obj.Title=cell(1,obj.DataNumber);
            obj.DownSample=1;
            obj.ResizeMode=false;
            obj.AxesResizeMode=[];
            obj.UponAdjustPanel=false;

            obj.VideoLineTime=0;
            obj.VideoStartTime=0;
            
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

            obj.FilterNotch_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            obj.FilterCustomIndex_=obj.applyPanelVal(cell(1,obj.DataNumber),1);
            
            resetFilterPanel(obj);
            
            obj.RedrawEvtsSkip=false;
            obj.EventLines=[];
            obj.EventTexts=[];
            
            obj.DragMode=0;
            obj.EditMode=0;
            obj.SelectedEvent_=[];
            obj.Evts__=[];
            obj.EventRef=0;
            obj.EventsWindowDisplay=false;
            
            obj.ControlPanelDisplay=true;
            obj.ToolbarDisplay=true;
            
            obj.DisplayGauge=true;
            
            obj.BufferLength=obj.TotalSample;
            obj.BufferTime=0;
            obj.VisualBuffer=inf;
            
            obj.Version_='CNELab(Clinical Neuro-Engineering Lab)';
            obj.DataView_='Vertical';
            
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
        function OnClose(obj)
            %             Delete the figure
            saveConfig(obj);
            if ~isempty(obj.WinVideo)
                if obj.WinVideo.valid
                    obj.WinVideo.OnClose();
                end
            end
            
            if obj.TFMapWin.valid
                obj.TFMapWin.OnClose();
            end
            
            if obj.SpatialMapWin.valid
                obj.SpatialMapWin.OnClose();
            end
            
            if obj.RawMapWin.valid
                obj.RawMapWin.OnClose();
            end
            
            if obj.InterpolateWin.valid
                obj.InterpolateWin.OnClose();
            end
            
            if obj.ExportTrialWin.valid
                obj.ExportTrialWin.OnClose();
            end
            
            if obj.PSDWin.valid
                obj.PSDWin.OnClose();
            end
            
            if obj.AverageMapWin.valid
                obj.AverageMapWin.OnClose();
            end
            
            if obj.WinFastEvts.valid
                obj.WinFastEvts.OnClose();
            end
            
            h = obj.Fig;
            if ishandle(h)
                delete(h);
            end
            
            
            if ~isempty(obj.SPFObj)&&ishandle(obj.SPFObj)&&isa(obj.SPFObj,'SPFPlot')
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
                        'FilterHigh','FilterCustomIndex','FilterNotch'...
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
                            'FilterCustomIndex','FilterNotch'}))
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
                        'AdvanceEventDefaultColor','MouseMode','Title','Version',...
                        'ControlPanelDisplay',...
                        'ToolbarDisplay','DisplayGauge','XGrid','YGrid',...
                        'VideoTimerPeriod','BadChannels','AxesBackgroundColor',...
                        'DefaultLineColor','Units','TimeUnit','AdvanceEventsFcn'}))
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
        
        function val = get.SRate(obj), val=obj.SRate_; end
        
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
        
        
        function obj = set.FilterNotch(obj,val), set(obj,'FilterNotch',val); end
        function val = get.FilterNotch(obj), val=obj.FilterNotch_; end
        
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
        
        function val=get.FileDir(obj) 
            if ~isempty(obj.FileNames)
                val=fileparts(obj.FileNames{obj.DisplayedData(1)});
            else
                val=[];
            end
        end
        %*****************************************************************
        % ***************** User available methods  **********************
        %*****************************************************************
        
        %******************************************************************
        
        %******************************************************************
        
        %*****************************************************************
        % ***************** Public computed read-only properties*********
        %*****************************************************************
        function val=get.FilterOrder(obj)
            val=2;
        end
        %******************************************************************
        function val = get.BufferStartSample(obj)
            val=min(max(1,round(obj.BufferTime*obj.SRate+1)),obj.TotalSample);
        end
        function val = get.BufferEndSample(obj)
            val=min(round((obj.BufferTime+obj.BufferLength)*obj.SRate+1),obj.TotalSample);
        end
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
        function val = get.ChanNameMargin(obj)
%             mname=obj.MontageChanNames;
%             len=0;
%             for i=1:length(mname)
%                 for j=1:length(mname{i})
%                     len=max(len,length(mname{i}{j}));
%                 end
%             end
            val=obj.WinLength*obj.SRate/20;
        end
        %******************************************************************
        function val = get.GaugeMargin(obj)
            val=obj.WinLength*obj.SRate/25;
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
                    mouseTime=pos(1,1)/obj.SRate+obj.Time;
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
        %*****************************************************************
        %**********************Private Properties*************************
        %*****************************************************************
        function val=get.TotalTime(obj)
            if ~isempty(obj.SRate)&&obj.SRate
                val=obj.TotalSample/obj.SRate;
            else
                val=[];
            end
        end
        %******************************************************************
        function obj = set.Config_(obj,val)
            if ~strcmpi(val(end-3:end),'.cfg')
                val=[val '.cfg'];
            end
            obj.Config_=val;
            def=load('-mat',val);
            names=fieldnames(def);
            names=names(~strcmpi('Position',names));
            for i=1:length(names)
                set(obj,[names{i} '_'],def.(names{i}));
            end
            obj.Position=def.Position; %#ok<*MCSUP>
        end
        function obj = set.Title_(obj,val)
            if ~iscell(val)
                val={val};
            end
            
            if length(obj.DisplayedData)==1
                set(obj.Fig,'Name',[val{obj.DisplayedData},' -- ',obj.Version]);
            end
            obj.Title_=val;
        end
        %******************************************************************
        function val = get.Evts(obj)
            if isempty(obj.Evts_)
                val={};
            else
                val=obj.Evts_(:,1:2);
            end
        end
        function val=get.Evts_(obj)
            if obj.EventRef
                val=obj.Evts__(obj.EventRef).event;
            else
                val={};
            end
        end
        function obj = set.Evts_(obj,val)
            ref=obj.EventRef;
            if ~ref
                ref=1;
            end
            %order the events according to its time
%             if ~isempty(val)
%                 [~,order]=sort([val{:,1}]);
%                 val=val(order,:);
%             end
            if size(val,2)==2
                val=obj.assignEventColor(val);
                d=cell(size(val,1),1);
                [d{:}]=deal(0);
                obj.Evts__(ref).event=cat(2,val,d);
            else
                obj.Evts__(ref).event=val;
            end
            if ~isempty(val)
                obj.EventRef=ref;
                set(obj.MenuEventsWindow,'Enable','on');
                set(obj.MenuEventsDisplay,'Enable','on');
                if ~obj.EventsWindowDisplay
                    obj.EventsWindowDisplay=true;
                end
                if ~obj.EventsDisplay
                    obj.EventsDisplay=true;
                end
            elseif isempty(obj.Evts_)
                obj.EventRef=0;
                set(obj.MenuEventsWindow,'Enable','off');
                set(obj.MenuEventsDisplay,'Enable','off');
                if obj.EventsWindowDisplay
                    obj.EventsWindowDisplay=false;
                end
                if obj.EventsDisplay
                    obj.EventsDisplay=false;
                end
                
            end
            obj.synchEvts();
            
            evts=obj.WinEvts.Evts_;
            if ~isempty(evts)
                [obj.EventSummaryIndex,obj.EventSummaryNumber]=...
                    EventWindow.findIndexOfEvent(evts(:,2),[evts{:,1}]);
            end
            notify(obj,'EventListChange');
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
                if ~isempty(oldcell{i})
                    newcell{i}=oldcell{i};
                else
                    newcell{i}=NaN*ones(obj.MontageChanNumber(i),length(val));
                end
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
            
            prevTime=obj.Time_;
            
            if ~isempty(obj.TotalTime)
                obj.Time_=min(max(val,0),obj.TotalTime);
            else
                obj.Time_=min(max(val,0),obj.DataTime);
            end
            if ~isempty(obj.BufferTime)&&~isempty(obj.BufferLength)&&~isempty(obj.TotalTime)
                if obj.Time_<obj.BufferTime||...
                        min(obj.TotalTime,(obj.Time_+obj.WinLength))>min(obj.TotalTime,obj.BufferTime+obj.BufferLength)
                    %need to reload data buffer
                    if obj.Time_>prevTime
                        t_start=max(0,obj.Time_-obj.BufferLength/10);
                    else
                        t_start=max(0,obj.Time_+obj.WinLength-obj.BufferLength/10*9);
                    end
                    obj.BufferTime=min(t_start,obj.TotalTime);
                    for i=1:length(obj.CDS)
                        [obj.Data{i},eof]=obj.CDS{i}.get_data_by_start_end...
                            (obj.CDS{i},obj.BufferStartSample,obj.BufferEndSample);
                    end
                    recalculate(obj);
                end
            end
            set(obj.EdtTime,'String',obj.Time_);
            
            if ~isempty(prevTime)
                obj.VideoLineTime=obj.Time+obj.VideoLineTime-prevTime;
            else
                obj.VideoLineTime=obj.Time;
            end
            SynchVideoWithData(obj);
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
            obj.JTogHorizontal.setSelected(strcmpi(obj.DataView_,'Horizontal'));
            obj.JTogVertical.setSelected(strcmpi(obj.DataView_,'Vertical'));
            
            if length(obj.DisplayedData)==1
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
            try
                set(obj.Axes,'color',val);
            catch
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
            
            notify(obj,'SelectedEventChange');
            
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
        function obj =set.VideoTimerPeriod_(obj,val)
            obj.VideoTimerPeriod_=val;
            set(obj.VideoTimer,'period',val);
        end
        
        %==================================================================
        %******************************************************************
        function obj=set.Selection_(obj,val)
            obj.Selection_=val;
%             if ~isempty(val)&&~isempty(obj.Evts_)
%                 tmp=reshape(obj.SelectedEvent,length(obj.SelectedEvent),1);
%                 for i=1:size(obj.Evts_,1)
%                     for j=1:size(val,2)
%                         if obj.Evts_{i,1}>=val(1,j)/obj.SRate&&obj.Evts_{i,1}<=val(2,j)/obj.SRate
%                             tmp=cat(1,tmp,i);
%                         end
%                     end
%                 end
%                 
%                 obj.SelectedEvent=tmp;
%             end
            notify(obj,'SelectionChange');
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
            
            obj.JChannelNumberSpinner.setValue(max(obj.DispChans_(obj.DisplayedData)));
            
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
            
            notify(obj,'SelectionChange');
            
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
            notify(obj,'VideoLineChange');
        end
        %==================================================================
        %******************************************************************
        function obj=set.PlaySpeed_(obj,val)
            obj.PlaySpeed_=val;
            if isa(obj.WinVideo,'VideoWindow') && obj.WinVideo.valid
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
        
        function val=get.VisualDownSample(obj)
            totalchan=sum(obj.DispChans);
            val=max(1,round(obj.WinLength*obj.SRate*totalchan*8/(obj.VisualBuffer*1000*1000)));
        end
        
        function obj=set.VisualDownSample(obj,val)
            totalchan=sum(obj.DispChans);
            obj.VisualBuffer=obj.WinLength*obj.SRate*totalchan*8/val/1000/1000;
        end
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.Fig)&&isgraphics(obj.Fig);
            catch
                val=0;
            end
        end
        
        function val=get.cnelab_path(obj)
            [val,~,~]=fileparts(which('cnelab.m'));
        end
        
        function obj=set.TotalSample(obj,val)
            obj.TotalSample=val;
            
            if ~isempty(obj.JWindowTimeSpinner)&&~siempty(obj.TotalTime)
                obj.JWindowTimeSpinner.getModel().setMaximum(java.lang.Double(obj.TotalTime));
            end
        end
        
        function obj = set.WinLength(obj,val)
            set(obj,'WinLength',val); 
            
            obj.JWindowTimeSpinner.setValue(java.lang.Double(val));
            obj.JWindowTimeSpinner.getModel().setStepSize(java.lang.Double(val/15));
        end
        %*****************************************************************
        function obj = set.SRate(obj,val)
            set(obj,'SRate',val);
            if ~isempty(obj.TotalTime)&&~isempty(obj.JWindowTimeSpinner)
                obj.JWindowTimeSpinner.getModel().setMaximum(java.lang.Double(obj.TotalTime));
            end
        end
    end
    
    methods (Access=protected)
        function a=DefaultConfigFile(obj) %#ok<MANU>
            a='defaultconfig';
        end
        
        %******************************************************************
        %Dynamic return the channel number,dataset number,amplitude in
        %sequence
        [nchan,ndata,yvalue,t]=getMouseInfo(obj)
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
        makeToolbar(obj)
            
        %=================================================================
        %******************************************************************       
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
        
        %==================================================================
        %******************************************************************
        remakeMontage(obj)
        %******************************************************************
        function resetView(obj)
            % Reset the Tools when properties are changing
            
            if  obj.DataNumber==1
                
                obj.JTogHorizontal.setEnabled(false);
                obj.JTogVertical.setEnabled(false);
                
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
        end
        
        %******************************************************************
        %********************Interface Action Methods *********************
        %******************************************************************

        function WinVideoFcn(obj)
            if isa(obj.WinVideo,'VideoWindow') && obj.WinVideo.valid
                %Bring Video Figure To The Front If Exists
                figure(obj.WinVideo.Fig)
            else
                if ~isempty(obj.VideoFile)&& exist(obj.VideoFile,'file')==2
                    obj.WinVideo=VideoWindow(obj.VideoFile); %VLC or WMPlayer
                    addlistener(obj.WinVideo,'VideoChangeTime',@(src,evt) SynchDataWithVideo(obj));
                    addlistener(obj.WinVideo,'VideoChangeState',@(src,ect) SynchVideoState(obj));
                    addlistener(obj.WinVideo,'VideoClosed',@(src,evt) StopPlay(obj));
                else
                    obj.LoadVideo();
                end
            end
        end
        %==================================================================
        %******************************************************************
        function ChangeMouseMode(obj,opt)
            s='';
            obj.SelectionStart=[];
            switch opt
                case 0
                    ClearMouseMode(obj);
                    s='';
                case 1
                    s='Measurer';
                    maskAnnotate(obj);
                    remakeMeasurer(obj);
                case 2
                    s='Select';
                    maskAnnotate(obj);
                    maskMeasurer(obj);
                case 3
                    s='Annotate';
                    maskMeasurer(obj);
                    remakeAnnotate(obj);
            end
            obj.MouseMode=s;
        end
        function ClearMouseMode(obj)
            obj.MouseMode='';
            maskMeasurer(obj);
            maskAnnotate(obj);
            obj.JTogNavigation.setSelected(true);
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
        %Callback for Video Load
        LoadVideo(obj)
        %==================================================================
        %******************************************************************
        %Callback for gain change
        ChangeGain(obj,opt)
        %==================================================================
        %******************************************************************
        %Callback for channel page change
        ChangeChan(obj,opt);
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
            
            if isa(obj.WinVideo,'VideoWindow') && obj.WinVideo.valid
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
        function MnuRecordingTime(obj,src)
            %**************************************************************
            % Dialog box to change the sampling frequency
            %**************************************************************
            if isempty(obj.RecordingTime)
                t=datetime('now');
            else
                t=obj.RecordingTime;
            end
            choice=inputdlg({'Year: ','Month: ','Day: ','Hour: ','Minute: ','Second: '},'Data time',1,...
                {num2str(t.Year),num2str(t.Month),num2str(t.Day),num2str(t.Hour),num2str(t.Minute),num2str(t.Second)});
            if ~isempty(choice)
                year=round(str2double(choice{1}));
                month=round(str2double(choice{2}));
                day=round(str2double(choice{3}));
                hour=round(str2double(choice{4}));
                minute=round(str2double(choice{5}));
                second=round(str2double(choice{6}));
                dt=datetime(year,month,day,hour,minute,second);
                if dt~=NaT
                    obj.RecordingTime=dt;
                end
            end
        end
        %==================================================================
        %******************************************************************
        LoadDataSet(obj)
        %==================================================================
        %******************************************************************
        function s=ControlBarSize(obj) %#ok<MANU>
            s=[1100,35];
        end
        
        function w=EventPanelWidth(obj)
            w=150;
        end
        
        function h=EventNavPanelHeight(obj)
            pos=get(obj.EventPanel,'position');
            h=min(30,pos(4)-1);
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
            if strcmp(obj.DataView,'Vertical')
                for i=1:length(obj.Axes)
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
            if isempty(obj.Fig)
                return
            end
            
            pos=get(obj.Fig,'position');
            
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
            
            newPosEvent=get(obj.EventPanel,'Position');
            
            set(obj.ControlPanel,'position',[0 0 pos(3) ctrlsize(2)]);
            
            set(obj.EventNavPanel,'position',[0 newPosEvent(4)-obj.EventNavPanelHeight newPosEvent(3) obj.EventNavPanelHeight]);
            set(obj.EventListPanel,'position',[0 0 newPosEvent(3) newPosEvent(4)-obj.EventNavPanelHeight]);
            obj.resizeAxes(MainPos);
        end
        
        function recalculate(obj)
            obj.PreprocData=cell(1,obj.DataNumber);
            for i=1:obj.DataNumber
                obj.PreprocData{i}=preprocessedData(obj,i);
            end
        end
        
        
        
        function ChangeDuration(obj,opt)
            val=obj.WinLength;
            
            if isnan(val)
                val=10;
            end
            
            if opt==1
                val=val*(16/15);
            elseif opt==-1
                val=val*(14/15);
            end
            
            if val<=0
                val=1;
            elseif val>obj.TotalTime
                val=obj.TotalTime;
            end
        end
        
        function ChangeFilter(obj,src)
            switch src
                case obj.EdtFilterLow
                    tmp=str2double(get(src,'String'));
                    if tmp<=0||isnan(tmp)||tmp>=obj.SRate/2
                        set(src,'String','-');
                    end
                case obj.EdtFilterHigh
                    tmp=str2double(get(src,'String'));
                    if tmp<=0||isnan(tmp)||tmp>=obj.SRate/2
                        set(src,'String','-');
                    end
                case obj.EdtFilterNotch
                    tmp=str2double(get(src,'String'));
                    if tmp<=0||isnan(tmp)||tmp>=obj.SRate/2
                        set(src,'String','-');
                    end
                case obj.PopFilter
                    if get(obj.PopFilter,'value')==1
                        scanFilterBank(obj);
                    end
                case obj.MenuNotchFilterSingle
                    set(src,'checked','on');
                    set(obj.MenuNotchFilterHarmonics,'checked','off');
                case obj.MenuNotchFilterHarmonics
                    set(src,'checked','on');
                    set(obj.MenuNotchFilterSingle,'checked','off');
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
        
        function ChannelNumberSpinnerCallback(obj)
            val=obj.JChannelNumberSpinner.getValue();
            
            dd=obj.DisplayedData;
            
            for i=1:length(dd)
                obj.DispChans(dd(i))=val;
            end
        end
        
        function WindowTimeSpinnerCallback(obj)
            val=obj.JWindowTimeSpinner.getValue();
            
            if val==obj.WinLength||val==0
                return
            end
            
            if (val+obj.Time)>(obj.BufferTime+obj.BufferLength)
                obj.BufferLength=val*2;
                
                %need to reload data buffer
                t_start=max(0,obj.Time_-obj.BufferLength/10);
                t_end=min(t_start+obj.BufferLength,obj.TotalTime);
                obj.BufferTime=t_start;
                for i=1:length(obj.CDS)
                    obj.Data{i}=obj.CDS{i}.get_data_segment(obj.CDS{i},round(t_start*obj.SRate)+1:round(t_end*obj.SRate),[]);
                end
                recalculate(obj);
            end
            set(obj,'WinLength',val); 
        end
        
        function SensitivitySpinnerCallback(obj)
            val=obj.JSensitivitySpinner.getValue();
            
            if val==0
                return
            end
            obj.Gain=obj.applyPanelVal(obj.Gain_,1/val);
        end
        function MaskChannel(obj,opt)
            
            obj.Mask=obj.applyPanelVal(obj.Mask_,opt);
            
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
        ChangeTime(obj,opt)
        redrawChangeBlock(obj,opt)
        showGauge(obj)
        MnuChanGain(obj,src)
        MnuVisualBuffer(obj,src)
        MnuDataBuffer(obj,src)
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
        SynchVideoWithData(obj)
        LoadChannelPosition(obj)
        SavePosition(obj)
        Interpolate(obj)
        SaveToFigure(obj,opt)
        CrossCorrelation(obj,src)
        MnuNotchFilter(obj,src)
        MnuDownSample(obj,src)
        SelectCurrentWindow(obj);
        ExportObjToWorkspace(obj);
        MnuOverwritePreprocess(obj);
        NewEvent(obj);
    end
    
    methods
        function StartPlay(obj)
            obj.JTogPlay.setIcon(obj.IconPause);
            set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) PausePlay(obj));
            if strcmpi(obj.VideoTimer.Running,'off')
                start(obj.VideoTimer);
            end
            if isa(obj.WinVideo,'VideoWindow') && obj.WinVideo.valid
                obj.WinVideo.play;
            end
        end
        
        function PausePlay(obj)
            obj.JTogPlay.setIcon(obj.IconPlay);
            set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StartPlay(obj));
            if strcmpi(obj.VideoTimer.Running,'on')
                stop(obj.VideoTimer);
            end
            if isa(obj.WinVideo,'VideoWindow') && obj.WinVideo.valid
                obj.WinVideo.pause;
            end
        end
        function StopPlay(obj)
            obj.JTogPlay.setIcon(obj.IconPlay);
            
            set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StartPlay(obj));

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
                
                obj.JTogPlay.setIcon(obj.IconPause);
                set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) PausePlay(obj));
                if strcmpi(obj.VideoTimer.Running,'off')
                    start(obj.VideoTimer);
                end
            else
                
                obj.JTogPlay.setIcon(obj.IconPlay);
                set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StartPlay(obj));
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
        
        VideoStartTime         %Start time of the first frame of the video
        VideoEndTime           %End time of the video
        
        VideoFile              %File path of video
        
        VideoTimeFrame
        VideoStampFrame
        VideoLineTime
        NumberOfFrame
        
        VideoTimer
        
        MAudioPlayer
        UponText
        
        EventPanel
        EventNavPanel
        EventListPanel
        
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
        
        Montage_
        Evts__
        
        DownSample
        
        TotalSample
        BufferTime
        BufferLength
        CDS
        VisualBuffer
        EventRef
        JWindowTimeSpinner
        
        RecordingTime
    end
    events
        SelectedFastEvtChange
        EventListChange
        SelectedEventChange
        SelectionChange
        VideoLineChange
    end
end