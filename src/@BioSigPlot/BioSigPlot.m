classdef BioSigPlot < hgsetget
    
    properties (Access = protected,Hidden) %Graphics Object
        Sliders
        
        MainPanel
        ControlPanel
        TimePanel
        InfoPanel
        FilterPanel
        ScalePanel
        DurationPanel
        BtnPrevPage
        BtnPrevSec
        EdtTime
        BtnNextSec
        BtnNextPage
        BtnPlay
        TxtTime
        TxtY
        TxtFilter
        
        ChkFilter
        ChkStrongFilter
        EdtFilterLow
        EdtFilterHigh
        EdtFilterNotch1
        EdtFilterNotch2
        
        EdtGain
        BtnAddGain
        BtnRemGain
        
        EdtDuration
        BtnAddDuration
        BtnRemDuration
        
        TxtScale
        ArrScale
        Toolbar
        TogMontage
        TogSuperimposed
        TogAlternated
        TogHorizontal
        TogVertical
        TogMeasurer
        TogSelection
        TogPan
        TogVideo
        TogAnnotate
        MenuFile
        MenuExport
        MenuExportFigure
        MenuExportFigureMirror
        MenuExportFigureAdvanced
        MenuExportEvents
        MenuImport
        MenuImportDataSet
        MenuImportEvents
        MenuImportVideo
        MenuCopy
        
        MenuSettings
        MenuCommands
        MenuConfigurationState
        MenuPlaySpeed
        MenuColors
        MenuChan
        MenuFastEvent
        MenuSampleRate
        
        MenuWindow
        MenuEventsWindow
        
        MenuDisplay
        MenuInsideTicks
        MenuXGrid
        MenuYGrid
        MenuEventsDisplay
        MenuColor
        MenuColorCanvas
        MenuColorLines
        MenuTriggerEventsDisplay
        
        MenuApp
        MenuTriggerEvents
        MenuTriggerEventsCalculate
        MenuTriggerEventsLoad
        
        MenuSave
        PanObj
        LineVideo
        LineMeasurer
        
        TxtMeasurer
        
        WinEvts
        WinFastEvts
        WinVideo
        VideoListener
        
    end
    properties (Dependent,SetObservable)      %Public properties Requiring a redraw and that can be defined at the beginning
        Config                  %Default config file [def: defaultconfig] contains all default values
        SRate                   %Sampling rate
        WinLength               %Time length of windows
        Gain                    %Gain beetween 2 channels
        ChanNames               %Cell with channel names corresponding to raw data.
        Units                   %Units of the data
        Evts                    %List of events.
        Time                    %Current time (in TimeUnit) of the current
        DispChans               %Number of channels to display for each data set.
        FirstDispChans          %First chan to display for each data set
        TimeUnit                %time unit (not active for now)
        InsideTicks             %true if channel names ticks and time ticks are inside the axis
        Filtering               %True if preprocessing filter are enbaled
        FilterLow               %The low value of filtering: Cut-off frequency of high pass filter
        FilterHigh              %The high value of filtering: Cut-off frequency of low pass filter
        FilterNotch1             %The 2 notch filter values for 50 or 60Hz rejection. (eg. [58 62]
        FilterNotch2
        StrongFilter            %false : 1st order filter; true : 4 order filter with forward-backward filter
        Colors                  %Colors of each Data set.
        NormalModeColor         %Colors for view Horizontal, Vertical, or single (DAT*)
        AlternatedModeColors    %Colors when alternated view
        SuperimposedModeColors  %Colors when superimposed view
        ChanSelectColor         %Colors when Channels are selected
        AxesBackgroundColor
        ChanColors
        
        EventSelectColor
        EventDefaultColor
        TriggerEventDefaultColor
        
        DataView                %View Mode {'Superimposed'|'Alternated'|'Vertical'|'Horizontal'|'DAT*'}
        MontageRef              %N° Montage
        XGrid                   %true : show Grid line on each sec
        YGrid                   %true : show Grid line on each channel
        YGridInterval           %Number of subdivision for the grid
        EventsDisplay           %true : show Events
        TriggerEventsDisplay
        EventsWindowDisplay     %true : show Events Window
        
        MouseMode               %the Mouse Mode :{'Pan'|'Measurer'}
        PlaySpeed               %Play speed
        MainTimerPeriod         %Period of the Main timer
        VideoTimerPeriod        %Period of the Video timer
        Montage                 %Path for a system file wich contains info on Montage
        AxesHeight              %Height ratio of Axes for Vertical Mode.
        YBorder                 %Vector of 2elements containing the space height between the last channel and the bottom and between the top and the first channel (Units: 'Gain' relative)
        Selection               %Time of Selected area
        
        BadChannels             %The bad channels
        ChanSelect2Display      %Selected Channels to Display
        ChanSelect2Edit         %Selected Channels to Edit (Filter,Gain adjust,TriggerEvent)
        
        IsDataSameSize
        DisplayedData           %Vector of displayed data
        IsChannelSelected
        
        FastEvts
        SelectedFastEvt
        TriggerEventsFcn
        
        Evts2Display
        
    end
    properties (Access=protected,Hidden)%Storage of public properties
        Config_
        SRate_
        WinLength_
        Gain_
        ChanNames_
        Units_
        Evts_
        Time_
        DispChans_
        FirstDispChans_
        TimeUnit_
        Colors_
        InsideTicks_
        Filtering_
        FilterLow_
        FilterHigh_
        FilterNotch1_
        FilterNotch2_
        StrongFilter_
        NormalModeColor_
        AlternatedModeColors_
        SuperimposedModeColors_
        ChanSelectColor_
        AxesBackgroundColor_
        ChanColors_
        EventSelectColor_
        EventDefaultColor_
        TriggerEventDefaultColor_
        
        DataView_
        MontageRef_
        YGridInterval_
        XGrid_
        YGrid_
        EventsDisplay_
        TriggerEventsDisplay_
        EventsWindowDisplay_
        
        MouseMode_
        PlaySpeed_
        MainTimerPeriod_
        VideoTimerPeriod_
        Montage_
        AxesHeight_
        YBorder_
        Selection_
        
        
        BadChannels_
        ChanSelect2Display_
        ChanSelect2Edit_
        
        TaskFiles_
        VideoStartTime_
        VideoTimeFrame_
        
        SelectedEvent_
        
        FastEvts_
        SelectedFastEvt_
        TriggerEventsFcn_
        
    end
    properties (SetAccess=protected) %Readonly properties
        Data                        %(Read-Only)All the Signals
        PreprocData                 %(Read-Only)The currently preprocessed and drawed Data
        Commands                    %(Read-Only)List of all commands to be on this state
    end
    properties (Access = protected,Hidden) %State Properties. No utilities for users
        ChanOrderMat
        IsSelecting
        SelectionStart
        ChanSelect2DisplayStart
        SelRect
        IsInitialize
        
    end
    
    properties (Dependent) %'Public properties which does not requires redrawing
        Position                    %Position of the figure (in pixels)
        Title                       %Title of the figure
    end
    properties (Dependent) %'Public computed read-only properties
        DataNumber                  %(Read-Only) Number of Dataset
        ChanNumber                  %(Read-Only) Channel number for the Raw data
        MontageChanNumber           %(Read-Only) Channel number for the current Montages
        MontageChanNames            %(Read-Only) Channel names for the current Montages
        MouseTime                   %(Read-Only) The Time on which the mouse is in
        MouseChan                   %(Read-Only) The channel on which the mouse is in
        MouseDataset                %(Read-Only) The dataset on which the mouse is in
    end
    properties
        Fig
        Axes
    end
    
    properties
        EventDisplayIndex       %Indx of displayed events
        WinEvtEdit              %Annotation Edit window
        EventLines              %Event lines displayed
        EventTexts              %Event texts displayed
        EvtContextMenu          %Event Contex Menu
        
        SelectedEvent
        SelectedLines
        
        DragMode
        EditMode
        
        TaskFiles
        
        VideoObj
        AudioObj
        
        VideoStartTime         %Start time of the first frame of the video
        VideoFile              %File path of video
        VideoHandle
        TotalVideoFrame
        VideoFrame
        VideoFrameInd
        VideoTimeFrame
        VideoTotalTime
        
        VideoLineTime
        
        MainTimer
        VideoTimer
        
        IsEvtsSaved
        
        MAudioPlayer
        UponText
        
        EventPanel
    end
    
    methods
        
        %*****************************************************************
        function obj=BioSigPlot(data,varargin)
            % Create an instance of BioSigPlot
            %
            % SYNTAX
            %   >> BioSigPlot(Data, 'key1', value1 ...);
            %   OR
            %   >> obj=BioSigPlot(Data, 'key1', value1 ...);
            %
            % INPUT
            %   Data
            %       object containing all signals. 3 formats are accepted :
            %           - matrix (n x m)  : there will be n signals with m time samples
            %           - matrix (n x m x k): there will be k dataset
            %           - cell (with Data{k} is matrix(n_k x m)) there will be multiple dataset.
            %             The first dataset will have n_1 channels, the second will have n_2,...
            %
            %   'key1', value1, ...
            %       Setting properties:
            %       You can set properties in the constructor in the same
            %       way you can by using set method or the (dot) syntax. So
            %       this is equivalent to:
            %           >> set(obj,'key1',value1,'key2',value2,...) (Faster if there is more than 1 keys)
            %           OR
            %           >> obj.key1=value1
            %
            % EXAMPLE
            %   load filterdemo;
            %   a=BioSigPlot(data,'Srate',250);
            obj.IsInitialize=true;
            
            obj.Data=obj.uniform(data);
            
            obj.buildfig;
            
            g=varargin;
            varInitial(obj,g);
            
            resetView(obj);
            remakeMontage(obj);
            remakeAxes(obj);
            
            recalculate(obj);
            ChangeGain(obj,[]);
            redraw(obj);
            obj.IsInitialize=false;
            
        end
        
        %*****************************************************************
        function varInitial(obj,g)
            
            obj.VideoLineTime=0;
            obj.IsSelecting=0;
            obj.SelectionStart=[];
            obj.Selection_=zeros(2,0);
            obj.ChanSelect2DisplayStart=[];
            obj.ChanSelect2Display_=cell(1,obj.DataNumber);
            obj.ChanSelect2Edit_=cell(1,obj.DataNumber);
            
            obj.Gain_=cell(1,obj.DataNumber);
            
            
            obj.Filtering_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            
            obj.StrongFilter_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            obj.FilterLow_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            obj.FilterHigh_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            obj.FilterNotch1_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            obj.FilterNotch2_=obj.applyPanelVal(cell(1,obj.DataNumber),0);
            
            resetFilterPanel(obj);
            
            obj.EventLines=[];
            obj.EventTexts=[];
            obj.SelectedLines=[];
            obj.EvtContextMenu=EventContextMenu(obj);
            obj.DragMode=0;
            obj.EditMode=0;
            obj.SelectedEvent_=[];
            obj.Evts_={};
            obj.IsEvtsSaved=true;
            obj.EventsWindowDisplay=true;
            
            obj.VideoHandle=[];
            
            obj.ChanNames_=cell(1,obj.DataNumber);
            obj.MontageRef_=1;
            
            n=find(strcmpi('Config',g(1:2:end)))*2;
            if isempty(n), g=[{'Config' obj.DefaultConfigFile} g]; end
            set(obj,g{:});
            
            obj.ChanColors_=obj.applyPanelVal(cell(1,obj.DataNumber),obj.NormalModeColor);
            
            
            if ~isempty(obj.DispChans)
                obj.DispChans=obj.DispChans/obj.DataNumber;
            end
            
            
        end
        function saveConfig(obj)
            cfg=load('-mat',obj.Config);
            cfg.FastEvts=obj.FastEvts;
            cfg.SelectedFastEvt=obj.SelectedFastEvt;
            cfg.TriggerEventsFcn=obj.TriggerEventsFcn;
            save(fullfile(pwd,'/db/cfg/','defaultconfig.cfg'),'-struct','cfg');
        end
        function delete(obj)
            % Delete the figure
            %             if isa(obj.WinVideo,'VideoWindow') && isvalid(obj.WinVideo)
            %                 delete(obj.WinVideo)
            %             end
            saveConfig(obj);
            if ~isempty(obj.Evts)&&~obj.IsEvtsSaved
                default='yes';
                choice=questdlg('There are changes in events, do you want to save them before exit?',...
                    'warning','yes','no',default);
                switch choice
                    case 'yes'
                        ExportEvents(obj);
                    case 'no'
                end
                
            end
            
            if isa(obj.WinEvtEdit,'EventEditWindow') && isvalid(obj.WinEvtEdit)
                delete(obj.WinEvtEdit);
            end
            
            if isa(obj.WinFastEvts,'FastEventWindow') && isvalid(obj.WinFastEvts)
                delete(obj.WinFastEvts);
            end
            
            h = obj.Fig;
            if ishandle(h)
                delete(h);
            else
                return
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
            l=cell2mat(cellfun(@size,DATA,'UniformOutput',false)');
            if ~all(l(1,1)==l(:,1))
                error('All data must have the same number of time samples');
            end
            
            for i=1:length(DATA)
                if size(DATA{i},1)<size(DATA{i},2)
                    choice=questdlg(['The DATA ',num2str(i), ' appears to be row-wise, do you want to transpose it?','BioSigplot','Yes','No','Yes']);
                    if strcmpi(choice,'Yes')
                        DATA{i}=DATA{i}';
                    end
                end
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
            
            g=varargin;
            %Rearrangement: make sure there is no conflict on the order of
            %properties. Constraint config must be before all and Colors
            %must be before *ModeColors
            keylist={'Config','SRate','WinLength','Gain','DataView','Montage','MontageRef','Evts','Time','FirstDispChans',...
                'DispChans','TimeUnit','Colors','InsideTicks','Filtering','FilterLow','FilterHigh','FilterNotch1','FilterNotch2','StrongFilter',...
                'NormalModeColor','AlternatedModeColors','SuperimposedModeColors','ChanNames','Units','XGrid','YGrid',...
                'Position','Title','MouseMode','PlaySpeed','MainTimerPeriod','VideoTimerPeriod','AxesHeight','YBorder','YGridInterval','Selection',...
                'TaskFiles','VideoStartTime','VideoFile','VideoTimeFrame','VideoLineTime','MainTimer','VideoTimer','BadChannels','ChanSelect2Display',...
                'ChanSelect2Edit','EventsDisplay','TriggerEventsDisplay','EventsWindowDisplay','ChanSelectColor','AxesBackgroundColor','ChanColors','EventSelectColor','EventDefaultColor',...
                'TriggerEventDefaultColor','SelectedEvent','FastEvts','SelectedFastEvt','TriggerEventsFcn'};
            
            if isempty(obj.Commands)
                command='a=BioSigPlot(data';
                NeedCommand=true;
            else
                command='set(a';
            end
            
            n=find(strcmpi('Colors',g(1:2:end)))*2;
            if ~isempty(n), g=g([n-1 n 1:n-2 n+1:end]); end
            n=find(strcmpi('Config',g(1:2:end)))*2;
            if ~isempty(n), g=g([n-1 n 1:n-2 n+1:end]); end
            
            for i=1:2:length(g)
                if any(strcmpi(g{i},{'Config','SRate','WinLength','Gain','Montage','DataView','MontageRef','Time','FirstDispChans',...
                        'DispChans','TimeUnit','Colors','InsideTicks','Filtering','FilterLow','FilterHigh','FilterNotch1','FilterNotch2','StrongFilter',...
                        'NormalModeColor','AlternatedModeColors','SuperimposedModeColors','ChanNames','Units','XGrid','YGrid','MouseMode','AxesHeight',...
                        'YBorder','YGridInterval','Selection','TaskFiles','VideoStartTime','MainTimerPeriod','VideoTimerPeriod','VideoTimeFrame',...
                        'BadChannels','ChanSelect2Display','ChanSelect2Edit','ChanSelectColor','AxesBackgroundColor','ChanColors','TriggerEventsFcn'}))
                    g{i}=keylist{strcmpi(g{i},keylist)};
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                    if any(strcmpi(g{i},{'Config','SRate','WinLength','Montage','DataView',...
                            'MontageRef','DispChans','InsideTicks','MouseMode','AxesHeight'...
                            'AxesBackgroundColor'}))
                        NeedRemakeAxes=true;
                    end
                    if any(strcmpi(g{i},{'Config','Montage','ChanNames','DataView','MontageRef'}))
                        if any(strcmpi(g{i},{'Config','Montage','ChanNames'}))
                            NeedRemakeMontage=true;
                        end
                        NeedResetView=true;
                    end
                    if any(strcmpi(g{i},{'SRate','WinLength','Montage','MontageRef',...
                            'Time','Filtering','FilterLow','FilterHigh',...
                            'FilterNotch1','FilterNotch2','StrongFilter'}))
                        NeedRecalculate=true;
                    end
                    NeedRedraw=true;
                    NeedRedrawEvts=true;
                    
                elseif any(strcmpi(g{i},{'PlaySpeed','FastEvts','SelectedFastEvt','EventDefaultColor','EventsWindowDisplay',...
                        'TriggerEventsFcn','TriggerEventDefaultColor'}))
                    g{i}=keylist{strcmpi(g{i},keylist)};
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                elseif any(strcmpi(g{i},{'EventsDisplay','Evts',...
                        'EventSelectColor','SelectedEvent','TriggerEventsDisplay'}))
                    g{i}=keylist{strcmpi(g{i},keylist)};
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                    NeedRedrawEvts=true;
                else
                    set@hgsetget(obj,varargin{i},varargin{i+1})
                end
                
                
                if any(strcmpi(g{i},keylist))
                    command=[command ',''' g{i} ''',' obj2str(g{i+1})]; %#ok<AGROW>
                    NeedCommand=true;
                end
            end
            if NeedRecalculate,recalculate(obj); end
            if NeedRemakeMontage, remakeMontage(obj); end
            if NeedResetView, resetView(obj); end
            if NeedRemakeAxes, remakeAxes(obj); end
            if NeedRedraw&&~obj.IsInitialize, redraw(obj); end
            if NeedRedrawEvts&&~obj.IsInitialize, redrawEvts(obj); end
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
        function obj = set.Config(obj,val), set(obj,'Config',val); end %#ok<MCHV2>
        function val = get.Config(obj), val=obj.Config_; end
        function obj = set.SRate(obj,val), set(obj,'SRate',val); end
        function val = get.SRate(obj), val=obj.SRate_; end
        function obj = set.WinLength(obj,val), set(obj,'WinLength',val); end
        function val = get.WinLength(obj), val=obj.WinLength_; end
        function obj = set.Gain(obj,val), set(obj,'Gain',val); end
        function val = get.Gain(obj), val=obj.Gain_; end
        function obj = set.ChanNames(obj,val), set(obj,'ChanNames',val); end
        function val = get.ChanNames(obj), val=obj.ChanNames_; end
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
        function obj = set.Colors(obj,val), set(obj,'Colors',val); end
        function val = get.Colors(obj), val=obj.Colors_; end
        function obj = set.InsideTicks(obj,val), set(obj,'InsideTicks',val); end
        function val = get.InsideTicks(obj), val=obj.InsideTicks_; end
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
        
        function obj = set.StrongFilter(obj,val), set(obj,'StrongFilter',val); end
        function val = get.StrongFilter(obj), val=obj.StrongFilter_; end
        function obj = set.NormalModeColor(obj,val), set(obj,'NormalModeColor',val); end
        function val = get.NormalModeColor(obj), val=obj.NormalModeColor_; end
        function obj = set.AlternatedModeColors(obj,val), set(obj,'AlternatedModeColors',val); end
        function val = get.AlternatedModeColors(obj), val=obj.AlternatedModeColors_; end
        function obj = set.SuperimposedModeColors(obj,val), set(obj,'SuperimposedModeColors',val); end
        function val = get.SuperimposedModeColors(obj), val=obj.SuperimposedModeColors_; end
        
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
        function obj = set.MainTimerPeriod(obj,val), set(obj,'MainTimerPeriod',val); end
        function val = get.MainTimerPeriod(obj), val=obj.MainTimerPeriod_; end
        
        function obj = set.VideoTimerPeriod(obj,val), set(obj,'VideoTimerPeriod',val); end
        function val = get.VideoTimerPeriod(obj), val=obj.VideoTimerPeriod_; end
        
        function obj = set.Montage(obj,val), set(obj,'Montage',val); end
        function val = get.Montage(obj), val=obj.Montage_; end
        function obj = set.AxesHeight(obj,val), set(obj,'AxesHeight',val); end
        function val = get.AxesHeight(obj), val=obj.AxesHeight_; end
        function obj = set.YBorder(obj,val), set(obj,'YBorder',val); end
        function val = get.YBorder(obj), val=obj.YBorder_; end
        function obj = set.YGridInterval(obj,val), set(obj,'YGridInterval',val); end
        function val = get.YGridInterval(obj), val=obj.YGridInterval_; end
        function obj = set.Selection(obj,val), set(obj,'Selection',val); end
        function val = get.Selection(obj), val=obj.Selection_; end
        
        function obj = set.Position(obj,val), set(obj.Fig,'Position',val); end
        function val = get.Position(obj),     val=get(obj.Fig,'Position'); end
        function obj = set.Title(obj,val), set(obj.Fig,'Name',val); end
        function val = get.Title(obj),     val=get(obj.Fig,'Name'); end
        
        function obj = set.EventDisplayIndex(obj,val), obj.EventDisplayIndex=val; end
        function val = get.EventDisplayIndex(obj), val=obj.EventDisplayIndex; end
        
        function obj = set.TaskFiles(obj,val), set(obj,'TaskFiles',val); end
        function val = get.TaskFiles(obj), val=obj.TaskFiles_; end
        
        function obj = set.VideoStartTime(obj,val), set(obj,'VideoStartTime',val);end
        function val = get.VideoStartTime(obj), val=obj.VideoStartTime_; end
        
        function obj = set.BadChannels(obj,val), set(obj,'BadChannels',val); end
        function val = get.BadChannels(obj), val=obj.BadChannels_; end
        
        
        function obj = set.ChanSelect2Display(obj,val), set(obj,'ChanSelect2Display',val); end
        function val = get.ChanSelect2Display(obj), val=obj.ChanSelect2Display_; end
        
        function obj = set.ChanSelect2Edit(obj,val), set(obj,'ChanSelect2Edit',val); end
        function val = get.ChanSelect2Edit(obj), val=obj.ChanSelect2Edit_; end
        
        function obj = set.EventsDisplay(obj,val), set(obj,'EventsDisplay',val); end
        function val = get.EventsDisplay(obj), val=obj.EventsDisplay_; end
        
        
        function obj = set.TriggerEventsDisplay(obj,val), set(obj,'TriggerEventsDisplay',val); end
        function val = get.TriggerEventsDisplay(obj), val=obj.TriggerEventsDisplay_; end
        
        function obj = set.EventsWindowDisplay(obj,val), set(obj,'EventsWindowDisplay',val); end
        function val = get.EventsWindowDisplay(obj), val=obj.EventsWindowDisplay_; end
        
        
        function obj = set.ChanColors(obj,val), set(obj,'ChanColors',val); end
        function val = get.ChanColors(obj), val=obj.ChanColors_; end
        
        function obj = set.SelectedEvent(obj,val), set(obj,'SelectedEvent',val); end
        function val = get.SelectedEvent(obj), val=obj.SelectedEvent_; end
        
        function obj = set.EventSelectColor(obj,val), set(obj,'EventSelectColor',val); end
        function val = get.EventSelectColor(obj), val=obj.EventSelectColor_; end
        
        function obj = set.EventDefaultColor(obj,val), set(obj,'EventDefaultColor',val); end
        function val = get.EventDefaultColor(obj), val=obj.EventDefaultColor_; end
        
        function obj = set.TriggerEventDefaultColor(obj,val), set(obj,'TriggerEventDefaultColor',val); end
        function val = get.TriggerEventDefaultColor(obj), val=obj.TriggerEventDefaultColor_; end
        
        function obj = set.FastEvts(obj,val), set(obj,'FastEvts',val); end
        function val = get.FastEvts(obj), val=obj.FastEvts_; end
        
        function obj = set.SelectedFastEvt(obj,val), set(obj,'SelectedFastEvt',val); end
        function val = get.SelectedFastEvt(obj), val=obj.SelectedFastEvt_; end
        
        function obj = set.TriggerEventsFcn(obj,val), set(obj,'TriggerEventsFcn',val); end
        function val = get.TriggerEventsFcn(obj), val=obj.TriggerEventsFcn_; end
        
        %*****************************************************************
        % ***************** User available methods  **********************
        %*****************************************************************
        
        %******************************************************************
        function StartPlay(obj)
            % Begin Autoscrolling
            %
            % USAGEEvent
            % 	obj.StartPlay();
            
            set(obj.BtnPlay,'String','Stop','Callback',@(src,evt) StopPlay(obj));
            obj.Commands{end+1}='a.StartPlay';
            start(obj.MainTimer);
            start(obj.VideoTimer);
            
            %             audioStart=(obj.VideoFrameInd-1)*obj.VideoTimerPeriod;
            %             audioStart=round(audioStart*get(obj.MAudioPlayer,'SampleRate'));
            %             play(obj.MAudioPlayer,audioStart);
        end
        
        %******************************************************************
        function StopPlay(obj)
            % Stop Autoscrolling
            %
            % USAGE
            % 	obj.StopPlay();
            
            set(obj.BtnPlay,'String','Play','Callback',@(src,evt) StartPlay(obj));
            obj.Commands{end+1}='a.StopPlay';
            stop(obj.MainTimer);
            stop(obj.VideoTimer);
            %             pause(obj.MAudioPlayer);
        end
        
        %*****************************************************************
        % ***************** Public computed read-only properties*********
        %*****************************************************************
        
        %******************************************************************
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
            names=names(~strcmpi('Colors',names) &...
                ~strcmpi('Position',names) & ...
                ~strcmpi('Title',names)); % Remove this field because it's not the same properties working
            set(obj,'Colors_',def.Colors);
            for i=1:length(names)
                set(obj,[names{i} '_'],def.(names{i}));
            end
            obj.Position=def.Position; %#ok<*MCSUP>
            obj.Title=def.Title;
        end
        
        %******************************************************************
        function obj = set.Colors_(obj,val)
            obj.Colors_=val;
            obj.NormalModeColor_=val;
            obj.AlternatedModeColors_=val;
            obj.SuperimposedModeColors_=val;
        end
        %******************************************************************
        function val = get.Evts(obj)
            if isempty(obj.Evts_)
                val={};
            else
                val=sortrows(obj.Evts_(:,1:2),1);
            end
        end
        function obj = set.Evts_(obj,val)
            
            if size(val,2)==2
                c=cell(size(val,1),1);
                [c{:}]=deal(obj.EventDefaultColor);
                d=cell(size(val,1),1);
                [d{:}]=deal(0);
                obj.Evts_=cat(2,val,c,d);
            else
                obj.Evts_=val;
            end
            if ~isempty(obj.Evts_)
                obj.IsEvtsSaved=false;
                
                set(obj.MenuEventsWindow,'Enable','on');
                set(obj.MenuEventsDisplay,'Enable','on');
                obj.EventsWindowDisplay=true;
                obj.EventsDisplay=true;
            else
                obj.IsEvtsSaved=true;
                set(obj.MenuEventsWindow,'Enable','off');
                set(obj.MenuEventsDisplay,'Enable','off');
                obj.EventsWindowDisplay=false;
                obj.EventsDisplay=false;
            end
            
            obj.synchEvts();
            
        end
        
        function evts=get.Evts2Display(obj)
            if isempty(obj.Evts_)
                evts=[];
                return
            end
                
            if obj.EventsDisplay
                if obj.TriggerEventsDisplay
                    evts=obj.Evts_;
                else
                    evts=obj.Evts_([obj.Evts_{:,4}]~=2,:);
                end
            else
                
                if obj.TriggerEventsDisplay
                    evts=obj.Evts_([obj.Evts_{:,4}]==2,:);
                else
                    evts=[];
                end
            end
        end
        %==================================================================
        %*****************************************************************
        
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
            if ~isempty(obj.EventDisplayIndex)&&~isempty(obj.EventTexts)
                EventList=obj.Evts_;
                for i=1:size(obj.EventDisplayIndex,2)
                    if ishandle(obj.EventTexts(1,i))
                        EventList{obj.EventDisplayIndex(1,i),2}=get(obj.EventTexts(1,i),'String');
                    end
                end
                obj.Evts_=EventList;
            end
            if ~isempty(obj.SRate)
                m=floor((size(obj.Data{1},1)-1)/obj.SRate);
                if val>m && strcmpi(get(obj.BtnPlay,'String'),'Stop'), StopPlay(obj);end
            else
                m=val;
            end
            obj.Time_=min(max(val,0),m);
            set(obj.EdtTime,'String',obj.Time_);
            if ~isempty(obj.VideoTimeFrame)
                ind=dsearchn(obj.VideoTimeFrame(:,1),obj.Time_+obj.VideoLineTime-obj.VideoStartTime);
                if ~isempty(obj.VideoHandle)
                    obj.VideoFrameInd=ind(1);
                    obj.VideoFrame=obj.VideoTimeFrame(ind(1),2);
                end
            end
        end
        
        %******************************************************************
        function obj = set.InsideTicks_(obj,val)
            obj.InsideTicks_=val;
            if val
                set(obj.MenuInsideTicks,'Checked','on');
            else
                set(obj.MenuInsideTicks,'Checked','off');
            end
        end
        
        %******************************************************************
        function obj = set.DataView_(obj,val)
            obj.DataView_=val;
            if ~obj.IsInitialize
                dd=obj.DisplayedData;
                if all(cellfun(@isempty,obj.ChanSelect2Edit(dd)))
                    %If there is no channel selected on the current page
                    
                    if all(cellfun(@mode,obj.Gain(dd))==mode(obj.Gain{dd(1)}))
                        set(obj.EdtGain,'String',mode(obj.Gain{dd(1)}));
                    else
                        set(obj.EdtGain,'String','-');
                    end
                    
                    resetFilterPanel(obj);
                end
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
            else
                set(obj.MenuXGrid,'Checked','off');
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
            else
                set(obj.MenuYGrid,'Checked','off');
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
            
            obj.synchEvts();
        end
        
        function obj = set.TriggerEventsDisplay_(obj,val)
            if ischar(val)
                obj.TriggerEventsDisplay_=strcmpi(val,'on');
            else
                obj.TriggerEventsDisplay_=val;
            end
            
            if obj.TriggerEventsDisplay_
                set(obj.MenuTriggerEventsDisplay,'Checked','on');
            else
                set(obj.MenuTriggerEventsDisplay,'Checked','off');
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
                set(obj.MainPanel,'position',[180 ctrlsize(2) pos(3)-180 pos(4)-ctrlsize(2)]);
                
            else
                set(obj.EventPanel,'Visible','off');
                set(obj.MainPanel,'position',[0 ctrlsize(2) pos(3) pos(4)-ctrlsize(2)]);
                
            end
        end
        %==================================================================
        %******************************************************************
        function obj = set.Selection_(obj,val)
            obj.Selection_=val;
        end
        
        %******************************************************************
        function obj = set.MouseMode_(obj,val)
            obj.MouseMode_=val;
            offon={'off','on'};
            if isempty(val)
                offon={'off','off'};
            end
            set(obj.TogMeasurer,'State',offon{1+strcmpi(val,'Measurer')});
            set(obj.TogPan,'State',offon{1+strcmpi(val,'Pan')});
            set(obj.TogSelection,'State',offon{1+strcmpi(val,'Select')});
            set(obj.TogAnnotate,'State',offon{1+strcmpi(val,'Annotate')});
        end
        
        %******************************************************************
        function obj = set.PlaySpeed_(obj,val)
            obj.PlaySpeed_=val;
            
        end
        %==================================================================
        function obj =set.MainTimerPeriod_(obj,val)
            obj.MainTimerPeriod_=val;
            set(obj.MainTimer,'period',val);
        end
        %==================================================================
        function obj =set.VideoTimerPeriod_(obj,val)
            obj.VideoTimerPeriod_=val;
            set(obj.VideoTimer,'period',val);
        end
        
        %==================================================================
        %******************************************************************
        function obj=set.BadChannels_(obj,val)
            obj.BadChannels_=val;
        end
        %==================================================================
        %******************************************************************
        function obj=set.FirstDispChans_(obj,val)
            tmp=ones(1,obj.DataNumber);
            
            if length(val)==1
                tmp=min(val*ones(obj.DataNumber,1),obj.MontageChanNumber);
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
                tmp(i)=max(1,min(tmp(i),obj.MontageChanNumber(i)));
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
            if iscell(val)
                if length(val)==1
                    if ~isempty(val{1})
                        if ~val{1}||isnan(val{1})
                            for i=1:obj.DataNumber
                                tmp{i}=1:obj.MontageChanNumber(i);
                            end
                        else
                            [tmp{:}]=deal(val{1});
                        end
                    else
                        for i=1:obj.DataNumber
                            tmp{i}=1:obj.MontageChanNumber(i);
                        end
                    end
                else
                    for i=1:obj.DataNumber
                        if isempty(val{i})
                            tmp{i}=1:obj.MontageChanNumber(i);
                        else
                            if ~val{i}||isnan(val{i})
                                tmp{i}=1:obj.MontageChanNumber(i);
                            else
                                tmp{i}=val{i};
                            end
                        end
                    end
                end
            else
                if isempty(val)
                    for i=1:obj.DataNumber
                        tmp{i}=1:obj.MontageChanNumber(i);
                    end
                else
                    if ~val||isnan(val)
                        for i=1:obj.DataNumber
                            tmp{i}=1:obj.MontageChanNumber(i);
                        end
                    else
                        [tmp{:}]=deal(val);
                    end
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
        function obj = set.WinLength_(obj,val)
            obj.WinLength_=val;
            set(obj.EdtDuration,'String',num2str(val));
        end
        
        %==================================================================
        %******************************************************************
        function obj = set.VideoLineTime(obj,val)
            if ~isempty(obj.WinLength)
                val=max(0,min(val,obj.WinLength));
            end
            obj.VideoLineTime=val;
            %try
            
            t=val*obj.SRate_;
            for i=1:length(obj.LineVideo)
                set(obj.LineVideo,'XData',[t t]);
            end
        end
        %==================================================================
        %******************************************************************
        function obj=set.VideoFrame(obj,val)
            
            obj.VideoFrame=min(max(1,val),obj.TotalVideoFrame);
            
            if ishandle(obj.VideoHandle)
                set(obj.VideoHandle,'CData',obj.VideoObj.frames(val).cdata);
                drawnow
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
                    {'Superimposed','Alternated','Vertical','Horizontal'})
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
        
        %*****************************************************************
        function s=ControlBarSize(obj) %#ok<MANU>
            s=[1180,40];
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
        function makeControls(obj)
            obj.timeControlPanel(obj.ControlPanel,[0 0 .17 1]);
            obj.infoControlPanel(obj.ControlPanel,[0.17 0 .23 1]);
            obj.filterControlPanel(obj.ControlPanel,[.4 0 .35 1]);
            obj.durationControlPanel(obj.ControlPanel,[0.75 0 .1 1]);
            obj.scaleControlPanel(obj.ControlPanel,[0.85,0,0.1,1]);
            
        end
        
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
        %******************************************************************
        %Gain Panel Initailization
        scaleControlPanel(obj,parent,position)
        %==================================================================
        %******************************************************************
        %Window length Panel Initialization
        durationControlPanel(obj,parent,position)
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
                'TooltipString','Raw montage','ClickedCallback',@(src,evt) set(obj,'MontageRef',ones(obj.DataNumber,1)));
            
        end
        
        %******************************************************************
        %Data Set View Navigation Toolbar Initialization
        viewToolbar(obj)
        %==================================================================
        %******************************************************************
        %General Toolbar Initialization
        toolToolbar(obj)
        %******************************************************************
        function remakeMontage(obj)
            %Assure Montage properties Coherence
            
            if iscell(obj.Montage_)
                if length(obj.Montage_)~=obj.DataNumber, error('If system is cell, it must be of same length than data');end
            else
                tmp=cell(1,obj.DataNumber);
                [tmp{:}]=deal(obj.Montage_);
                obj.Montage_=tmp;
            end
            
            for i=1:length(obj.Montage_)
                if ischar(obj.Montage_{i})
                    try
                        s=load(obj.Montage_{i});
                        obj.Montage_{i}=s.Montage;
                    catch  %#ok<CTCH>
                        obj.Montage_{i}=[];
                    end
                end
            end
            
            if isempty(obj.ChanNames_)
                obj.ChanNames_=cell(1,obj.DataNumber);
                [obj.ChanNames_{:}]=deal([]);
            end
            
            for i=1:obj.DataNumber
                if isempty(obj.ChanNames_{i})
                    obj.ChanNames_{i}=num2cell(1:size(obj.Data{i},2));
                    obj.ChanNames_{i}=cellfun(@num2str,obj.ChanNames_{i},'UniformOutput',false);
                    obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
                elseif ~isempty(obj.Montage{i})
                    
                    if all(ismember(obj.ChanNames_{i},obj.Montage_{i}(1).channames))
                        
                        obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
                        p=zeros(1,size(obj.ChanOrderMat{i},1));
                        for j=1:size(obj.ChanOrderMat{i},1)
                            for k=1:length(obj.ChanNames_{i})
                                if strcmpi(obj.Montage_{i}(1).channames{j},obj.ChanNames_{i}{k})
                                    p(j)=k;
                                end
                            end
                        end
                        obj.ChanOrderMat{i}(1:size(obj.ChanOrderMat{i},1),:)=obj.ChanOrderMat{i}(p(1:size(obj.ChanOrderMat{i},1)),:);
                        for j=1:length(obj.Montage_{i})
                            obj.Montage_{i}(j).mat=obj.Montage_{i}(j).mat*obj.ChanOrderMat{i};
                        end
                    elseif length(obj.ChanNames_{i})==length(obj.Montage_{i}(1).channames)
                        obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
                        obj.Montage_{i}=struct('name','Raw','mat',obj.ChanOrderMat{i},'channames',obj.ChanNames_(i));
                    end
                end
                if isempty(obj.Montage{i})
                    obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
                    obj.Montage_{i}=struct('name','Raw','mat',obj.ChanOrderMat{i},'channames',obj.ChanNames_(i));
                end
            end
            
        end
        
        %******************************************************************
        function resetView(obj)
            % Reset the Tools when properties are changing
            
            if  obj.DataNumber==1
                set(obj.TogAlternated,'Enable','off')
                set(obj.TogSuperimposed,'Enable','off')
                
                set(obj.TogHorizontal,'Enable','off')
                set(obj.TogVertical,'Enable','off')
                
            elseif (obj.IsDataSameSize)
                set(obj.TogAlternated,'Enable','on')
                set(obj.TogSuperimposed,'Enable','on')
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
            set(obj.TogSuperimposed,'State',offon{strcmpi(obj.DataView_,'Superimposed')+1});
            set(obj.TogAlternated,'State',offon{strcmpi(obj.DataView_,'Alternated')+1});
            set(obj.TogHorizontal,'State',offon{strcmpi(obj.DataView_,'Horizontal')+1});
            set(obj.TogVertical,'State',offon{strcmpi(obj.DataView_,'Vertical')+1})
            
        end
        
        %******************************************************************
        %********************Interface Action Methods *********************
        %******************************************************************
        
        %******************************************************************
        function ChangeTime(obj,src)
            timemax=floor((size(obj.Data{1},1)-1)/obj.SRate);
            if strcmpi(get(obj.BtnPlay,'String'),'Stop'), StopPlay(obj);end
            if src==obj.BtnNextPage
                t=obj.Time+obj.WinLength;
            elseif src==obj.BtnPrevPage
                t=obj.Time-obj.WinLength;
            elseif src==obj.BtnNextSec
                t=obj.Time+1;
            elseif src==obj.BtnPrevSec
                t=obj.Time-1;
            else
                t=str2double(get(obj.EdtTime,'String'));
            end
            t=max(0,min(timemax,t));
            
            obj.VideoLineTime=0;
            obj.Time=t;
        end
        %******************************************************************
        function UpdateVideo(obj)
            
            videoFrameInd=max(1,min(obj.VideoFrameInd+1,size(obj.VideoTimeFrame,1)));
            videoTimeFrame=obj.VideoTimeFrame;
            
            videoFrame=videoTimeFrame(videoFrameInd,2);
            
            if videoFrame~=obj.VideoFrame
                obj.VideoFrame=videoFrame;
                %                 set(obj,'VideoFrame',videoFrame);
            end
            
            obj.VideoFrameInd=videoFrameInd;
            
        end
        %==================================================================
        %******************************************************************
        function PlayTime(obj)
            t=obj.VideoTimeFrame(obj.VideoFrameInd,1)+obj.VideoStartTime;
            
            obj.VideoLineTime=t-obj.Time;
            
            if (t-obj.Time)>obj.WinLength
                obj.VideoLineTime=0;
                set(obj,'Time',obj.Time+obj.WinLength);
            end
            
            
            
        end
        %==================================================================
        %******************************************************************
        function ChangeMouseMode(obj,src)
            s='';
            obj.SelectionStart=[];
            if strcmpi(get(src,'State'),'on')
                if src==obj.TogMeasurer
                    s='Measurer';
                elseif src==obj.TogPan
                    s='Pan';
                elseif src==obj.TogSelection
                    s='Select';
                elseif src==obj.TogAnnotate
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
        %Callback for Event File Import
        ImportEvents(obj)
        %==================================================================
        %******************************************************************
        %Callback for Event File Export
        ExportEvents(obj)
        %==================================================================
        %******************************************************************
        %Callback for number of channels per page limitaion
        MnuChan2Display(obj)
        %==================================================================
        %******************************************************************
        %Callback for Video Import
        ImportVideo(obj)
        %==================================================================
        %******************************************************************
        function MnuPlay(obj)
            %**************************************************************
            % Dialog box to change the speed for play
            %**************************************************************
            t=inputdlg('Speed of play : X ');
            t=str2double(t);
            if ~isempty(t) && ~isnan(t)
                obj.PlaySpeed=t;
            end
        end
        %==================================================================
        %******************************************************************
        function MnuSampleRate(obj)
            %**************************************************************
            % Dialog box to change the sampling frequency
            %**************************************************************
            t=inputdlg('Sampling Frequency (Hz) : ');
            t=str2double(t);
            if ~isnan(t)
                obj.SRate=t;
            end
        end
        %==================================================================
        %******************************************************************
        function ExportToFigure(obj)
            f=figure('Name','Mirror figure','Position',get(obj.Fig,'Position'));
            copyobj(obj.Axes(:),f);
        end
        function ExportToWindow(obj)
            ExportWindow(obj);
        end
        %==================================================================
        %******************************************************************
        function ImportDataSet(obj)
            
            %             cds=CommonDataStructure();
            %             if ~cds.import();
            %                 return
            %             end
            %             newData=cds.Data.Data';
            %             obj.Data=[obj.Data;{newData}];
            %
            %             l=cell2mat(cellfun(@size,obj.Data,'UniformOutput',false)');
            %             if ~all(l(1,1)==l(:,1))
            %                 error('All data must have the same number of time samples');
            %             end
            %
            %             redraw(obj);
            %
            
        end
        %==================================================================
        %******************************************************************
        
        function WinFastEvents(obj)
            obj.WinFastEvts=FastEventWindow(obj,obj.FastEvts,obj.SelectedFastEvt);
            addlistener(obj.WinFastEvts,'FastEvtsChange',@(src,evt) set(obj,'FastEvts',obj.WinFastEvts.FastEvts));
            addlistener(obj.WinFastEvts,'SelectedFastEvtChange',@(src,evt) set(obj,'SelectedFastEvt',obj.WinFastEvts.SelectedFastEvt));
        end
        
        %******************************************************************
        function WinVideoFcn(obj,src)
        end
        %******************************************************************
        function resize(obj)
            set(obj.Fig,'Units','pixels')
            pos=get(obj.Fig,'position');
            cbs=obj.ControlBarSize;
            if pos(3)<=cbs(1)
                pos(3)=cbs(1);
                set(obj.Fig,'position',pos);
            end
            ctrlsize=obj.ControlBarSize;
            
            set(obj.Fig,'position',pos);
            
            set(obj.EventPanel,'position',[0 ctrlsize(2) 180 pos(4)-ctrlsize(2)]);
            
            if  ~isempty(obj.Evts_)&&obj.EventsWindowDisplay
                set(obj.EventPanel,'Visible','on');
                set(obj.MainPanel,'position',[180 ctrlsize(2) pos(3)-180 pos(4)-ctrlsize(2)]);
            else
                set(obj.EventPanel,'Visible','off');
                set(obj.MainPanel,'position',[0 ctrlsize(2) pos(3) pos(4)-ctrlsize(2)]);
            end
            set(obj.ControlPanel,'position',[0 0 pos(3) ctrlsize(2)]);
        end
        
        function recalculate(obj)
            
            obj.PreprocData=cell(1,obj.DataNumber);
            for i=1:obj.DataNumber
                obj.PreprocData{i}=preprocessedData(obj,i);
            end
        end
        function ChangeGain(obj,src)
            val=str2double(get(obj.EdtGain,'String'));
            
            if isempty(get(obj.EdtGain,'String'))||...
                    (ismember(src,[obj.BtnAddGain,obj.BtnRemGain])&&val==0)
                %Automatic scaling
                data=obj.PreprocData;
                if isempty(data)
                    data=cell(1,obj.DataNumber);
                    [data{:}]=deal(1);
                end
                
                for i=1:obj.DataNumber
                    tmp=mean(std(data{i},1,2));
                    if tmp==0
                        val=1;
                    else
                        val=0.2/tmp;
                    end
                end
            end
            
            if src==obj.BtnAddGain
                val=val*2^.25;
            elseif src==obj.BtnRemGain
                val=val*2^-.25;
            end
            set(obj.EdtGain,'String',num2str(val));
            if obj.IsInitialize
                obj.Gain_=obj.applyPanelVal(obj.Gain_,val);
            else
                obj.Gain=obj.applyPanelVal(obj.Gain_,val);
            end
        end
        
        function ChangeDuration(obj,src)
            val=str2double(get(obj.EdtDuration,'String'));
            
            if isnan(val)
                val=10;
            end
            
            if src==obj.BtnAddDuration
                val=val+1;
            elseif src==obj.BtnRemDuration
                val=val-1;
            end
            
            obj.WinLength=val;
        end
        
        function ChangeFilter(obj,src)
            switch src
                case obj.ChkStrongFilter
                    set(obj,'StrongFilter',obj.applyPanelVal(obj.StrongFilter_,get(src,'Value')));
                case obj.EdtFilterLow
                    set(obj,'FilterLow',obj.applyPanelVal(obj.FilterLow_,str2double(get(src,'String'))));
                    if str2double(get(src,'String'))==0||isnan(str2double(get(src,'String')))
                        set(src,'String','-');
                    end
                    
                case obj.EdtFilterHigh
                    set(obj,'FilterHigh',obj.applyPanelVal(obj.FilterHigh_,str2double(get(src,'String'))));
                    if str2double(get(src,'String'))==0||isnan(str2double(get(src,'String')))
                        set(src,'String','-');
                    end
                case obj.EdtFilterNotch1
                    set(obj,'FilterNotch1',obj.applyPanelVal(obj.FilterNotch1_,str2double(get(src,'String'))));
                    if str2double(get(src,'String'))==0||isnan(str2double(get(src,'String')))
                        set(src,'String','-');
                    end
                case obj.EdtFilterNotch2
                    set(obj,'FilterNotch2',obj.applyPanelVal(obj.FilterNotch2_,str2double(get(src,'String'))));
                    if str2double(get(src,'String'))==0||isnan(str2double(get(src,'String')))
                        set(src,'String','-');
                    end
            end
        end
        
        
        function synchEvts(obj)
            
            if isempty(obj.Evts_)
                return
            end
            
            evts=obj.Evts2Display;
            
            if ~isempty(evts)
                evts=sortrows(evts,1);
            end
            
            obj.WinEvts.Evts=evts;
            
        end
    end
    
    events
        SelectedFastEvtChange
    end
end