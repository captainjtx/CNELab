classdef BioSigPlot < hgsetget
    %General class to visualize any multichannel biomedical signals and scroll
    %through the time.
    %
    % USAGE
    %   >> BioSigPlot(DATA, 'key1', value1 ...);
    %   OR
    %   >> a=BioSigPlot(DATA, 'key1', value1 ...);
    %     Then, to modify properties :
    %           >> a.key1=value1
    %        OR >> set(a,'key1',value1,'key2',value2,...) (Faster if there is more than 1 keys)
    %
    %     To get propertie values :
    %           >> val=a.key1
    %        OR >> val=get('key1',value1)
    %     The Modification of key is allowed (eg a.key1(i)=val)
    %     You can receive a notification when each key is modified
    %
    % INPUT
    %   DATA     object containing all signals. 3 format are accepted :
    %              -mat(n,m)  : there will be n signals with m time samples
    %              -mat(n,m,k): there will be k dataset
    %              -cell (data{k} is mat(nk,m)) there will be multiple dataset.
    %              The first with n1 channels, the second with n2,...
    %
    %              DATA can be access after as a read only property (a.Data)
    %
    %
    % READ/WRITE PROPERTIES
    % The followibg properties are accessible by constructor, get/set methods or .(dot) syntax
    %
    %   ChanLink
    %    <true|false> if true all datasets have the same channels
    %      eg. data vs filtered data, various ERP realisation,
    %      signal vs indice computed on signals)
    %    <Empty = auto> : true if all the datasets have the same number of
    %      channels, else false
    %
    %   ChanNames
    %     Cell with channel Names of raw data.
    %     (See Montage properties for the difference between Raw and Montage channel names)
    %     Default Format : ChanNames{i}{j} corresponds to Dataset i,channel j
    %     Other accepted format (for set) :
    %      - Channels{j} if ChanLink all the dataset will have the same channel names.
    %      - empty : Put number to channel names
    %
    %    Colors, NormalModeColor, AlternatedModeColor, SuperimposedModeColor
    %      Tables containing the colors of all dataset. The 3 columns corresponds
    %      to RGB with values between 0 and 1. Each line corresponds to
    %      a dataset.
    %      -NormalModeColors are the colors used when DataView is set to 'DAT*',
    %      'Horizontal' or 'Vertical'
    %      -AlternatedModeColors are the colors used when DataView is set to
    %      'Alternated'
    %      -SuperimposedModeColors are the colors used when DataView is set to
    %      'Superimposed'
    %      -Colors is never used but if you set it, NormalModeColor,
    %      AlternatedModeColor and SuperimposedModeColor will take its value.
    %
    %   Config
    %      Path to a CFG file corresponding to default values of properties.
    %      The CFG file contains the value for all keys in this section.
    %      You can use ConfigWindow to help you to modify the CFG file
    %      The default value is given by DefaultConfigFile (See INHERENCE
    %      Section)
    %
    %   DataView
    %     Current Data View Mode
    %     <'Superimposed'|'Alternated'|'Vertical'|'Horizontal'|'DAT1'|'DAT2'|...>
    %     The modes 'Superimposed' and 'Alternated' are not allowed if ChanLink
    %     is false.
    %     If there is only one dataset, the only possible value is 'DAT1'
    %
    %   DispChans
    %     Number of channels to display for each data set.
    %     Empty:means all
    %
    %   Evts
    %     List of Events. Each events have a latency and a String value
    %     Default format : {time1 'evt1';time2 'evt2';...}.
    %     Other accepted format (for set) :
    %     - struct array with any fields
    %     - Ok if transposed or if columns are inversed
    %
    %   Filtering
    %     <true|false> true if the data must be filter
    %
    %   StrongFilter
    %     <true|False> False: 1st order Butterworth filter (2nd for band stop)
    %     [It's often this type of filter which are implemented on manufacturer Software]
    %     True : 4th order Butterworth Filter with Forward-Backward process
    %     [Better filters]
    %     (Since the Forward-Backward process function has been re-programed,
    %     depending of the system, the Strong Filter can be as fast as 1st
    %     order Butterworth filter.)
    %
    %
    %   FilterLow, FilterHigh, FilterNotch
    %     FilterLow : The low value of filtering: Cut-off frequency of high pass filter
    %     FilterHigh :The high value of filtering: Cut-off frequency of low pass filter
    %     FilterNotch : The 2 notch filter values for 50 or 60Hz rejection. (eg. [58 62])
    %
    %   FirstDispChans
    %     First channel to display for each dataset. It corresponds to the
    %     scroll bar levels.
    %     Used only if DispChans is not empty.
    %
    %   InsideTicks
    %     <true|False>
    %      True: The ticks are put inside the Graph, and the graph size is maximised
    %      False:The ticks are put outside the Graph
    %
    %   Montage
    %     Information on various montages
    %     Default Format :
    %      -Cell of struct array: 1 cell for each dataset and one struct for each Montage
    %       Montage{i}(j).name     : Name of the Montage j for dataset i
    %       Montage{i}(j).mat      : Matrix to transform Raw Data to 'Montaged' Data
    %       Montage{i}(j).channames: Cell containing list of montage channanmes
    %       for j=1, the montage have to correspond to RAW data
    %     Other accepted format (for set) :
    %      -File path string of system info (eg '1020system19')
    %      -if no cells and ChanLink the Montage is set to all the DataSet
    %      -if empty automatically generate Raw Montage
    %     if ChanNames and Montage are set, the ChanNames must be in Raw data order
    %     and Montage{i}(j).channames must be in View order
    %
    %   MontageRef
    %     Montage number for each datasets
    %     Default Format : array
    %     Other accepted format (for set) : Montage name
    %
    %   MouseMode
    %     <'pan'|'Measurer'>
    %     Set the action on mouse movement or mouse click
    %
    %   Position
    %     [x y w h]
    %     poistion of the figure (in pixels)
    %         x,y : low left corner coordinates
    %         w width
    %         h height
    %
    %   MainTimerPeriod
    %     The period of the main timer of BioSigPlot
    %
    %   VideoTimerPeriod
    %     The period of the video timer
    %
    %   Selection
    %     Time of Selected Periods:
    %     Format: array [start1 start2 start3 ... ; end1 end2 end2 ...]
    %     start_n and end_n corresponding to the beggining and the end of the
    %     selection periods
    %
    %   SRate
    %     Sampling Rate
    %
    %   Spacing
    %     Space between 2 channels on Y units for each dataset
    %     Default Format : array (S1, S2,...) Si=Spacing for dataset i
    %     Other accepted format (for set) :
    %       number (if ChannLink) put all the dataset the same spacing
    %
    %   Time
    %     The time of the beginning of the current page (from the recording begginning
    %     (in TimeUnit))
    %
    %   TimeUnit
    %     The Time unit (for now only 's'(second) are allowed)
    %
    %   Title
    %     Title of the Graph
    %
    %   XGrid
    %     <true|False>
    %      true : show Grid line on each TimeUnit
    %
    %   YGrid
    %     <true|False>
    %      true : show Grid line on each channel
    %
    %   Video
    %     File path for the video (Supported format : See http://www.videolan.org/vlc/features.html)
    %
    %   VideoLineTime
    %     Time for video cursor (from the display begginning (in TimeUnit))
    %
    %   WinLength
    %     Time of a Page during Viewing
    %
    % READ-ONLY PROPERTIES
    %   Data
    %     All the Signals
    %
    %   ChanSelect
    %     Selected Channels
    %
    %   PreprocData
    %    The currently preprocessed and drawed Data
    %
    %   Commands
    %     List of all commands to arrive on this state
    %
    %   DataNumber
    %     Number of Dataset
    %
    %   ChanNumber
    %     Channel number for the Raw data
    %
    %   MontageChanNumber
    %     Channel number for the current Montages
    %
    %   MontageChanNames
    %     Channel names for the current Montages
    %
    %   MouseTime
    %     The Time on which the mouse is on.
    %
    %   MouseChan
    %     The channel on which the mouse is on
    %
    %   MouseDataset
    %     The dataset on which the mouse is on
    %
    %
    % METHODS
    %   StartPlay
    %     Start Fast Reading
    %
    %   StopPlay
    %     Stop Fast Reading
    %
    %   ExportPagesTo
    %     Export some pages to separate files
    %
    %   ExportPagesToMultiPages
    %     Export some pages to a single document
    %
    %
    % EXAMPLES
    %  Example 1 : Compared viewing of EEG and filtered EEG (with AFOP method)
    % You can lauch <a href="matlab: biosigdemo">biosigdemo</a> to carry
    % out this sample step by step.
    %    %Plot Signals
    %    load filterdemo
    %    a=BioSigPlot({data fdata},'srate',250,'Montage','1020system19','video','videodemo.avi');
    %    %Define Events
    %    a.Evts={10 'Electrode';64 'Muscle';86 'Muscle';110,'End HVT';144 'Smile'};
    %    %Change the Montage to Mean Reference Montage (Note that the filtered
    %    %EEG is already Mean referenced)
    %    a.MontageRef=2;
    %    %Move through Time
    %    a.Time=40;
    %    %Change to Horizontal View
    %    a.DataView='Horizontal';
    %    %Change Scales of the 2 Datasets
    %    a.Spacing=100;
    %    %Change Spacing on the second dataset only
    %    a.Spacing(2)=200;
    %    %Change the scale of the third electrod on dataset 1 (2nd Montage ie Mean Reference)
    %    a.Montage{1}(2).mat(3,:)=a.Montage{1}(2).mat(3,:)/10;
    %    %Start The Playing
    %    a.StartPlay
    %    %Stop it
    %    a.StopPlay
    %
    
    %123456789012345678901234567890123456789012345678901234567890123456789012
    %
    %     BioSigPlot Copyright (C) 2013 Samuel Boudet, Faculté Libre de Médecine,
    %     samuel.boudet@gmail.com
    %
    %     This file is part of BioSigPlot
    %
    %     BioSigPlot is free software: you can redistribute it and/or modify
    %     it under the terms of the GNU General Public License as published by
    %     the Free Software Foundation, either version 3 of the License, or
    %     (at your option) any later version.
    %
    %     BioSigPlot is distributed in the hope that it will be useful,
    %     but WITHOUT ANY WARRANTY; without even the implied warranty of
    %     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    %     GNU General Public License for more details.
    %
    %     You should have received a copy of the GNU General Public License
    %     along with this program.  If not, see <http://www.gnu.org/licenses/>.
    %
    % V0.1.2 Beta - 13/02/2013
    
    
    properties (Access = protected,Hidden) %Graphics Object
        Sliders
        MainPanel
        ControlPanel
        TimePanel
        InfoPanel
        FilterPanel
        ScalePanel
        BtnPrevPage
        BtnPrevSec
        EdtTime
        BtnNextSec
        BtnNextPage
        BtnPlay
        TxtTime
        TxtY
        ChkFilter
        ChkStrongFilter
        EdtFilterLow
        EdtFilterHigh
        EdtFilterNotch1
        EdtFilterNotch2
        PopSpacingTarget
        EdtSpacing
        BtnAddSpacing
        BtnRemSpacing
        TxtScale
        ArrScale
        Toolbar
        TogMontage
        TogSuperimposed
        TogAlternated
        TogHorizontal
        TogVertical
        TogData
        TogMeasurer
        TogSelection
        TogPan
        TogEvts
        TogVideo
        TogAnnotate
        MenuFile
        MenuExport
        MenuExportFigure
        MenuExportEvents
        MenuImport
        MenuImportEvents
        MenuImportVideo
        
        MenuCopy
        MenuSettings
        MenuCommands
        MenuConfigurationState
        MenuPlaySpeed
        MenuColors
        MenuChan
        MenuTime2disp
        MenuChanLink
        MenuDisplay
        MenuInsideTicks
        MenuXGrid
        MenuYGrid
        MenuSave
        PanObj
        LineVideo
        LineMeasurer
        
        TxtMeasurer
        
        WinEvts
        WinVideo
        VideoListener
        
    end
    properties (Dependent,SetObservable)      %Public properties Requiring a redraw and that can be defined at the beginning
        Config                  %Default config file [def: defaultconfig] contains all default values
        SRate                   %Sampling rate
        WinLength               %Time length of windows
        Spacing                 %Spacing beetween 2 channels
        ChanNames               %Cell with channel names corresponding to raw data.
        Evts                    %List of events.
        Time                    %Current time (in TimeUnit) of the current
        DispChans               %Number of channels to display for each data set.
        FirstDispChans          %First chan to display for each data set
        ChanLink                %true if all dataset have corresponding channels (Empty=auto).
        TimeUnit                %time unit (not active for now)
        InsideTicks             %true if channel names ticks and time ticks are inside the axis
        Filtering               %True if preprocessing filter are enbaled
        FilterLow               %The low value of filtering: Cut-off frequency of high pass filter
        FilterHigh              %The high value of filtering: Cut-off frequency of low pass filter
        FilterNotch             %The 2 notch filter values for 50 or 60Hz rejection. (eg. [58 62]
        StrongFilter            %false : 1st order filter; true : 4 order filter with forward-backward filter
        Colors                  %Colors of each Data set.
        NormalModeColors        %Colors for view Horizontal, Vertical, or single (DAT*)
        AlternatedModeColors    %Colors when alternated view
        SuperimposedModeColors  %Colors when superimposed view
        DataView                %View Mode {'Superimposed'|'Alternated'|'Vertical'|'Horizontal'|'DAT*'}
        MontageRef              %N° Montage
        XGrid                   %true : show Grid line on each sec
        YGrid                   %true : show Grid line on each channel
        YGridInterval           %Number of subdivision for the grid
        MouseMode               %the Mouse Mode :{'Pan'|'Measurer'}
        PlaySpeed               %Play speed
        MainTimerPeriod         %Period of the Main timer
        VideoTimerPeriod        %Period of the Video timer
        Montage                 %Path for a system file wich contains info on Montage
        AxesHeight              %Height ratio of Axes for Vertical Mode.
        YBorder                 %Vector of 2elements containing the space height between the last channel and the bottom and between the top and the first channel (Units: 'Spacing' relative)
        Selection               %Time of Selected area
        
    end
    properties (Access=protected,Hidden)%Storage of public properties
        Config_
        SRate_
        WinLength_
        Spacing_
        ChanNames_
        Evts_
        Time_
        DispChans_
        FirstDispChans_
        ChanLink_
        TimeUnit_
        Colors_
        InsideTicks_
        Filtering_
        FilterLow_
        FilterHigh_
        FilterNotch_
        StrongFilter_
        NormalModeColors_
        AlternatedModeColors_
        SuperimposedModeColors_
        DataView_
        MontageRef_
        YGridInterval_
        XGrid_
        YGrid_
        MouseMode_
        PlaySpeed_
        MainTimerPeriod_
        VideoTimerPeriod_
        Montage_
        AxesHeight_
        YBorder_
        Selection_
        
        TaskFiles_
        VideoStartTime_
        VideoFile_
        VideoTimeFrame_
        
    end
    properties (SetAccess=protected) %Readonly properties
        Data                        %(Read-Only)All the Signals
        ChanSelect={}               %(Read-Only)Selected Channels
        PreprocData                 %(Read-Only)The currently preprocessed and drawed Data
        Commands                    %(Read-Only)List of all commands to be on this state
    end
    properties (Access = protected,Hidden) %State Properties. No utilities for users
        ChanOrderMat
        IsSelecting
        SelectionStart
        ChanSelectStart
        SelRect
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
            
            if iscell(data)
                obj.Data=data;
            elseif size(data,3)==1
                obj.Data={data};
            else
                for i=1:size(data,3)
                    obj.Data{i}=data(:,:,i);
                end
            end
            l=cell2mat(cellfun(@size,obj.Data,'UniformOutput',false)');
            if ~all(l(1,2)==l(:,2))
                error('All data must have the same number of time samples');
            end
            
            obj.VideoLineTime=0;
            %             obj.VideoStartTime=0;
            
            obj.buildfig;
            
            g=varargin;
            
            n=find(strcmpi('Config',g(1:2:end)))*2;
            if isempty(n), g=[{'Config' obj.DefaultConfigFile} g]; end
            
            % Private Properties
            
            obj.IsSelecting=0;
            obj.SelectionStart=[];
            obj.Selection_=zeros(2,0);
            obj.ChanSelect(1:obj.DataNumber)={[]};
            obj.ChanSelectStart=[];
            
            % Beginning of setting and starting Redraw
            
            obj.EventLines=[];
            obj.EventTexts=[];
            obj.EvtContextMenu=EventContextMenu(obj);
            obj.SelectedEvent=[];
            obj.SelectedLines=[];
            
            obj.DragMode=0;
            obj.EditMode=0;
            
            obj.VideoHandle=[];
            set(obj,g{:});
            
            obj.IsEvtsSaved=true;
        end
        
        %*****************************************************************
        function delete(obj)
            % Delete the figure
            %             if isa(obj.WinVideo,'VideoWindow') && isvalid(obj.WinVideo)
            %                 delete(obj.WinVideo)
            %             end
            
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
            if isa(obj.WinEvts,'EventWindow') && isvalid(obj.WinEvts)
                delete(obj.WinEvts);
            end
            
            if isa(obj.WinEvtEdit,'EventEditWindow') && isvalid(obj.WinEvtEdit)
                delete(obj.WinEvtEdit);
            end
            
            h = obj.Fig;
            if ishandle(h)
                delete(h);
            else
                return
            end
        end % delete
        
        %*****************************************************************
        function set(obj,varargin)
            NeedRemakeMontage=false;
            NeedResetView=false;
            NeedRemakeAxes=false;
            NeedRedraw=false;
            NeedCommand=false;
            g=varargin;
            %Rearrangement: make sure there is no conflict on the order of
            %properties. Constraint config must be before all and Colors
            %must be before *ModeColors
            keylist={'Config','SRate','WinLength','Spacing','DataView','Montage','MontageRef','Evts','Time','FirstDispChans',...
                'DispChans','ChanLink','TimeUnit','Colors','InsideTicks','Filtering','FilterLow','FilterHigh','FilterNotch','StrongFilter',...
                'NormalModeColors','AlternatedModeColors','SuperimposedModeColors','ChanNames','XGrid','YGrid',...
                'Position','Title','MouseMode','PlaySpeed','MainTimerPeriod','VideoTimerPeriod','AxesHeight','YBorder','YGridInterval','Selection',...
                'TaskFiles','VideoStartTime','VideoFile','VideoTimeFrame','VideoLineTime','MainTimer','VideoTimer'};
            
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
                if any(strcmpi(g{i},{'Config','SRate','WinLength','Spacing','Montage','DataView','MontageRef','Evts','Time','FirstDispChans',...
                        'DispChans','ChanLink','TimeUnit','Colors','InsideTicks','Filtering','FilterLow','FilterHigh','FilterNotch','StrongFilter',...
                        'NormalModeColors','AlternatedModeColors','SuperimposedModeColors','ChanNames','XGrid','YGrid','MouseMode','AxesHeight','YBorder','YGridInterval','Selection',...
                        'TaskFiles','VideoStartTime','VideoFile','MainTimerPeriod','VideoTimerPeriod','VideoTimeFrame'}))
                    g{i}=keylist{strcmpi(g{i},keylist)};
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                    if any(strcmpi(g{i},{'Config','SRate','WinLength','Montage','DataView','MontageRef','DispChans','ChanLink','InsideTicks','MouseMode','AxesHeight'}))
                        NeedRemakeAxes=true;
                    end
                    if any(strcmpi(g{i},{'Config','Spacing','Montage','ChanLink','ChanNames','DataView','MontageRef'}))
                        if any(strcmpi(g{i},{'Config','Montage','ChanLink','ChanNames'}))
                            NeedRemakeMontage=true;
                        end
                        NeedResetView=true;
                    end
                    NeedRedraw=true;
                    
                elseif any(strcmpi(g{i},{'PlaySpeed'}))
                    g{i}=keylist{strcmpi(g{i},keylist)};
                    set@hgsetget(obj,[g{i} '_'],g{i+1})
                else
                    set@hgsetget(obj,varargin{i},varargin{i+1})
                end
                
                
                if any(strcmpi(g{i},keylist))
                    command=[command ',''' g{i} ''',' obj2str(g{i+1})]; %#ok<AGROW>
                    NeedCommand=true;
                end
            end
            if NeedRemakeMontage, remakeMontage(obj); end
            if NeedResetView, resetView(obj); end
            if NeedRemakeAxes, remakeAxes(obj); end
            if NeedRedraw, redraw(obj); end
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
        function obj = set.Spacing(obj,val), set(obj,'Spacing',val); end
        function val = get.Spacing(obj), val=obj.Spacing_; end
        function obj = set.ChanNames(obj,val), set(obj,'ChanNames',val); end
        function val = get.ChanNames(obj), val=obj.ChanNames_; end
        function obj = set.Evts(obj,val), set(obj,'Evts',val); end
        function val = get.Evts(obj), val=obj.Evts_; end
        function obj = set.Time(obj,val), set(obj,'Time',val);end
        function val = get.Time(obj), val=obj.Time_;end
        function obj = set.DispChans(obj,val), set(obj,'DispChans',val); end
        function val = get.DispChans(obj), val=obj.DispChans_; end
        function obj = set.FirstDispChans(obj,val), set(obj,'FirstDispChans',val); end
        function val = get.FirstDispChans(obj), val=obj.FirstDispChans_; end
        function obj = set.ChanLink(obj,val), set(obj,'ChanLink',val); end
        function val = get.ChanLink(obj), val=obj.ChanLink_; end
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
        function obj = set.FilterNotch(obj,val), set(obj,'FilterNotch',val); end
        function val = get.FilterNotch(obj), val=obj.FilterNotch_; end
        function obj = set.StrongFilter(obj,val), set(obj,'StrongFilter',val); end
        function val = get.StrongFilter(obj), val=obj.StrongFilter_; end
        function obj = set.NormalModeColors(obj,val), set(obj,'NormalModeColors',val); end
        function val = get.NormalModeColors(obj), val=obj.NormalModeColors_; end
        function obj = set.AlternatedModeColors(obj,val), set(obj,'AlternatedModeColors',val); end
        function val = get.AlternatedModeColors(obj), val=obj.AlternatedModeColors_; end
        function obj = set.SuperimposedModeColors(obj,val), set(obj,'SuperimposedModeColors',val); end
        function val = get.SuperimposedModeColors(obj), val=obj.SuperimposedModeColors_; end
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
        
        function obj = set.VideoFile(obj,val), set(obj,'VideoFile',val);end
        function val = get.VideoFile(obj), val=obj.VideoFile_; end
        
        
        
        %*****************************************************************
        % ***************** User available methods  **********************
        %*****************************************************************
        function ExportPagesTo(obj,file,pages,varargin)
            % Export some pages to separate files
            % (One document per page)
            %
            % USAGE
            %   obj.ExportPagesTo(file,pages,'PaperUnits',unit,'PaperSize',[width height]);
            %   OR
            %   obj.ExportPagesTo(file,pages,'PaperUnits',unit,'PaperType',paper,'PaperOrientation',orientation);
            %
            % INPUT
            %   file
            %       Filename to export. Can be any Image format, .pdf, .ps or .fig(Matlab figure)
            %
            %   pages
            %       list of time corresponding to begginings of pages
            %
            %   unit
            %       Paper size unit ('inches' | 'centimeters' | 'points')
            %
            %   width, height
            %       Dimension of the paper in unit
            %
            
            
            
            oldtime=obj.Time;
            n=find(file=='.',1,'last');
            f=figure('Visible','off',varargin{:});
            set(f,'paperpositionMode','manual','paperunits','Normalized','PaperPosition',[0.02 0.02 0.96 0.96]);
            for p=pages
                obj.Time=p;
                filename=[file(1:n-1) '-' num2str(p) file(n:end)];
                clf(f);
                
                copyobj(obj.Axes(:),f);
                try saveas(f,filename); catch, msgbox(['The following file cannot be written :' filename]); end %#ok<CTCH>
                
                obj.Commands{end+1}=['a.ExportPagesTo(''' file ''',' obj2str(pages) ',' obj2str(varargin{:}) ');'];
            end
            close(f);
            obj.Time=oldtime;
        end
        
        %******************************************************************
        function ExportPagesToMultiPages(obj,file,pages,varargin)
            % Export to a single mutli-page document (PDF or PS)
            %
            %
            % USAGE
            %   obj.ExportPagesToMultiPages(file,pages,'PaperUnits',unit,'PaperSize',[width height]);
            %   OR
            %   obj.ExportPagesToMultiPages(file,pages,'PaperUnits',unit,'PaperType',paper,'PaperOrientation',orientation);
            %
            % INPUT
            %   file
            %       Filename to export. Can be .pdf or .ps
            %
            %   pages
            %       list of time corresponding to begginings of pages
            %
            %   unit
            %       Paper size unit ('inches' | 'centimeters' | 'points')
            %
            %   width, height
            %       Dimension of the paper in unit
            %
            
            oldtime=obj.Time;
            n=find(file=='.',1,'last');
            if strcmpi(file(n+1:end),'pdf')
                tmpname='tmp.ps';
            else
                tmpname=file;
            end
            f=figure('Visible','off',varargin{:});
            set(f,'paperpositionMode','manual','paperunits','Normalized','PaperPosition',[0.02 0.02 0.96 0.96]);
            firstpage=1;
            for p=pages
                obj.Time=p;
                clf(f);
                
                copyobj(obj.Axes(:),f);
                if (firstpage)
                    print(['-f' num2str(f)],'-dpsc','tmp.ps');
                    firstpage=0;
                else
                    print(['-f' num2str(f)],'-append','-dpsc','tmp.ps');
                end
                
            end
            close(f);
            if strcmpi(file(n+1:end),'pdf')
                g=struct(varargin{:});
                
                if isfield(g,'PaperType')
                    if strcmpi(g.PaperType,'usletter')
                        gspapersize='letter';
                    else
                        gspapersize=g.PaperType;
                    end
                    ps2pdf('psfile',tmpname,'pdffile',file,'gspapersize', gspapersize);
                elseif isfield(g,'PaperUnits') && isfield(g,'PaperSize')
                    if strcmpi(g.PaperUnits,'inches')
                        dims=round(g.PaperSize*72);
                    elseif strcmpi(g.PaperUnits,'centimeters')
                        dims=round(g.PaperSize*72/2.54);
                    else
                        dims=round(g.PaperSize);
                    end
                    ps2pdf('psfile',tmpname,'pdffile',file,'gsdevicewidthpoints',dims(1),'gsdeviceheightpoints',dims(2));
                else
                    ps2pdf('psfile',tmpname,'pdffile',file);
                end
                
                delete(tmpname);
            end
            
            obj.Time=oldtime;
            obj.Commands{end+1}=['a.ExportPagesToMultiPages(''' file ''',' obj2str(pages)  ',' obj2str(varargin{:}) ');'];
            
        end
        
        %******************************************************************
        function StartPlay(obj)
            % Begin Autoscrolling
            %
            % USAGE
            % 	obj.StartPlay();
            
            set(obj.BtnPlay,'String','Stop','Callback',@(src,evt) StopPlay(obj));
            obj.Commands{end+1}='a.StartPlay';
            start(obj.MainTimer);
            start(obj.VideoTimer);
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
            val=l(:,1);
        end
        
        %******************************************************************
        function val = get.MontageChanNumber(obj)
            val=zeros(1,obj.DataNumber);
            for i=1:obj.DataNumber
                val(i)=size(obj.Montage{i}(obj.MontageRef(i)).mat,1);
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
            names=names(~strcmpi('Colors',names) & ~strcmpi('ChanLink',names) & ~strcmpi('DataView',names) &...%Remove those fields because they must be affected before others
                ~strcmpi('Position',names) & ~strcmpi('Title',names)); % Remove this field because it's not the same properties working
            set(obj,'Colors_',def.Colors);
            set(obj,'ChanLink_',def.ChanLink);
            set(obj,'DataView_',def.DataView);
            for i=1:length(names)
                set(obj,[names{i} '_'],def.(names{i}));
            end
            obj.Position=def.Position; %#ok<*MCSUP>
            obj.Title=def.Title;
        end
        
        %******************************************************************
        function obj = set.Colors_(obj,val)
            obj.Colors_=val;
            obj.NormalModeColors_=val;
            obj.AlternatedModeColors_=val;
            obj.SuperimposedModeColors_=val;
        end
        
        %******************************************************************
        function obj = set.ChanLink_(obj,val)
            l=cell2mat(cellfun(@size,obj.Data,'UniformOutput',false)');
            
            if isempty(val)
                obj.ChanLink_=all(l(1,1)==l(:,1));
            elseif val==1 && ~all(l(1,1)==l(:,1))
                error('The number of channel of each dataset is not equal')
            else
                obj.ChanLink_=val;
            end
            
            if obj.ChanLink_
                set(obj.MenuChanLink,'Checked','on');
            else
                set(obj.MenuChanLink,'Checked','off');
            end
        end
        
        %******************************************************************
        function obj = set.Evts_(obj,val)
            obj.IsEvtsSaved=false;
            obj.Evts_=val;
            if ~isempty(obj.Evts_)
                if isstruct(obj.Evts_)
                    obj.Evts_=reshape(struct2cell(obj.Evts_),2,length(obj.Evts_));
                end
                if size(obj.Evts_,1)==2 && (size(obj.Evts_,2)~=2 ||  ~strcmpi(class(obj.Evts_{1,1}),class(obj.Evts_{2,1})) )
                    obj.Evts_=obj.Evts_';
                end
                if ischar(obj.Evts_{1,1})
                    obj.Evts_=obj.Evts_(:,[2 1]);
                end
                obj.Evts_=sortrows(obj.Evts_);
                set(obj.TogEvts,'Enable','on')
            else
                set(obj.TogEvts,'Enable','off')
            end
        end
        
        %******************************************************************
        function obj = set.Filtering_(obj,val)
            obj.Filtering_=val;
            set(obj.ChkFilter,'Value',val);
            if val, offon='on'; else offon='off'; end
            set(obj.ChkStrongFilter,'Enable',offon)
            set(obj.EdtFilterLow,'Enable',offon)
            set(obj.EdtFilterHigh,'Enable',offon)
            set(obj.EdtFilterNotch1,'Enable',offon)
            set(obj.EdtFilterNotch2,'Enable',offon)
        end
        
        
        %******************************************************************
        function obj = set.StrongFilter_(obj,val)
            obj.StrongFilter_=val;
            set(obj.ChkStrongFilter,'Value',val);
        end
        
        %******************************************************************
        function obj = set.FilterLow_(obj,val)
            obj.FilterLow_=val;
            set(obj.EdtFilterLow,'String',val)
        end
        
        %******************************************************************
        function obj = set.FilterHigh_(obj,val)
            obj.FilterHigh_=val;
            set(obj.EdtFilterHigh,'String',val)
        end
        
        %******************************************************************
        function obj = set.FilterNotch_(obj,val)
            obj.FilterNotch_=val;
            set(obj.EdtFilterNotch1,'String',val(1))
            set(obj.EdtFilterNotch2,'String',val(2))
        end
        
        %******************************************************************
        function obj = set.Time_(obj,val)
            if ~isempty(obj.SRate)
                m=floor((size(obj.Data{1},2)-1)/obj.SRate);
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
            if ~isempty(val)
                if (obj.ChanLink && (isempty(obj.Spacing) || all(obj.Spacing(:)==obj.Spacing(1)))) ||...
                        any(strcmpi(obj.DataView_,{'Superimposed','Alternated','Vertical','Horizontal'}))
                    set(obj.PopSpacingTarget,'Value',1);
                else
                    n=str2double(val(4));
                    set(obj.PopSpacingTarget,'Value',n+1);
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
        
        %******************************************************************
        function obj = set.Selection_(obj,val)
            obj.Selection_=val;
        end
        
        %******************************************************************
        function obj = set.MouseMode_(obj,val)
            obj.MouseMode_=val;
            offon={'off','on'};
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
        function obj=set.VideoFrame(obj,val)
            
            obj.VideoFrame=min(max(1,val),obj.TotalVideoFrame);
            
            if ishandle(obj.VideoHandle)
                set(obj.VideoHandle,'CData',obj.VideoObj.frames(val).cdata);
                drawnow
            end
        end
        
    end
    methods (Access=protected)
        function a=DefaultConfigFile(obj) %#ok<MANU>
            a='defaultconfig';
        end
        
        %*****************************************************************
        function s=ControlBarSize(obj) %#ok<MANU>
            s=[1015 35];
        end
        
        
        %******************************************************************
        function [nchan,ndata,yvalue]=getMouseInfo(obj)
            xlim=obj.WinLength*obj.SRate;
            ndata=0;nchan=0;
            yvalue=zeros(1,length(obj.Axes));%for two axes
            
            for i=1:length(obj.Axes)
                pos=get(obj.Axes(i),'CurrentPoint');
                yvalue(i)=pos(1,2); %TODO adjust to the scale
                ylim=get(obj.Axes(i),'Ylim');
                if pos(1,1)>=0 && pos(1,1)<=xlim && pos(1,2)>=ylim(1) && pos(1,2)<=ylim(2)
                    if strcmpi(obj.DataView,'Alternated')
                        nchan=sum(obj.MontageChanNumber)-round(pos(1,2))+1;
                        if nchan<=0, nchan=1; end
                        if nchan>sum(obj.MontageChanNumber), nchan=sum(obj.MontageChanNumber); end
                        ndata=rem(nchan-1,obj.DataNumber)+1;
                        nchan=floor((nchan-1)/obj.DataNumber)+1;
                    else
                        if strcmpi(obj.DataView(1:3),'DAT')
                            ndata=str2double(obj.DataView(4));
                        else
                            ndata=i;
                        end
                        nchan=obj.MontageChanNumber(ndata)-round(pos(1,2))+1;
                        if nchan<=0, nchan=1; end
                        if nchan>obj.MontageChanNumber(ndata), nchan=obj.MontageChanNumber(ndata); end
                    end
                end
            end
        end
        
        
        
        %******************************************************************
        %**********General functions called when setting properties********
        %******************************************************************
        
        %******************************************************************
        function buildfig(obj)
            % Designing of all figure controls
            
            obj.Fig=figure('MenuBar','none','ToolBar','none','DockControls','on','NumberTitle','off',...
                'CloseRequestFcn',@(src,evts) delete(obj),'WindowScrollWheelFcn',@(src,evts) ChangeSliders(obj,src,evts),...
                'WindowButtonMotionFcn',@(src,evt) MouseMovement(obj),'WindowButtonDownFcn',@(src,evt) MouseDown(obj),...
                'WindowButtonUpFcn',@(src,evt) MouseUp(obj),'Renderer','painters','ResizeFcn',@(src,evt) resize(obj),...
                'WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),'WindowKeyReleaseFcn',@(src,evt) KeyRelease(obj,src,evt));
            obj.PanObj=pan(obj.Fig);
            set(obj.PanObj,'Motion','vertical','ActionPostCallback',@(src,evts) ChangeSliders(obj,src,evts))
            obj.MainTimer = timer('TimerFcn',@(src ,evts) PlayTime(obj),'ExecutionMode','fixedRate','BusyMode','queue');
            obj.VideoTimer = timer('TimerFcn',@ (src,evts) UpdateVideo(obj),'ExecutionMode','fixedRate','BusyMode','queue');
            
            % Panel declaration
            set(obj.Fig,'Units','pixels')
            pos=get(obj.Fig,'position');
            ctrlsize=obj.ControlBarSize;
            obj.MainPanel=uipanel(obj.Fig,'units','pixels','position',[0 ctrlsize(2) pos(3) pos(4)-ctrlsize(2)],'BorderType','none');
            obj.ControlPanel=uipanel(obj.Fig,'units','pixels','position',[0 0 ctrlsize(1) ctrlsize(2)],'BorderType','none');
            obj.Toolbar=uitoolbar(obj.Fig);
            
            obj.makeControls();
            obj.makeToolbar();
            obj.makeMenu();
            
        end
        
        %******************************************************************
        function makeControls(obj)
            obj.timeControlPanel(obj.ControlPanel,[0 0 .2 1]);
            obj.infoControlPanel(obj.ControlPanel,[0.2 0 .2 1]);
            obj.filterControlPanel(obj.ControlPanel,[.4 0 .31 1]);
            obj.scaleControlPanel(obj.ControlPanel,[0.71 0 .25 1]);
            
        end
        
        %******************************************************************
        function makeToolbar(obj)
            obj.montageToolbar();
            obj.viewToolbar();
            obj.toolToolbar();
        end
        
        %******************************************************************
        function makeMenu(obj)
            obj.MenuFile=uimenu(obj.Fig,'Label','File');
            obj.MenuExport=uimenu(obj.MenuFile,'Label','Export');
            obj.MenuExportFigure=uimenu(obj.MenuExport,'Label','Figure','Callback',@(src,evt) obj.ExportToWindow);
            obj.MenuExportEvents=uimenu(obj.MenuExport,'Label','Events','Callback',@(src,evt) obj.ExportEvents);
            
            obj.MenuImport=uimenu(obj.MenuFile,'Label','Import');
            obj.MenuImportEvents=uimenu(obj.MenuImport,'Label','Events','Callback',@(src,evt) obj.ImportEvents);
            obj.MenuImportVideo=uimenu(obj.MenuImport,'Label','Video','Callback',@(src,evt) obj.ImportVideo);
            
            obj.MenuCopy=uimenu(obj.MenuFile,'Label','Copy','Enable','off');
            obj.MenuSettings=uimenu(obj.Fig,'Label','Settings');
            obj.MenuCommands=uimenu(obj.MenuSettings,'Label','Command List',...
                'Callback',@(src,evts) listdlg('ListString',obj.Commands,'ListSize',[700 500],'PromptString','List of commands'));
            obj.MenuConfigurationState=uimenu(obj.MenuSettings,'Label','Configuration file','Callback',@(src,evt) ConfigWindow(obj));
            obj.MenuPlaySpeed=uimenu(obj.MenuSettings,'Label','Set the speed for play','Callback',@(src,evt) MnuPlay(obj));
            obj.MenuChan=uimenu(obj.MenuSettings,'Label','Number of channels to display','Callback',@(src,evt) MnuChan2Display(obj));
            obj.MenuTime2disp=uimenu(obj.MenuSettings,'Label','Time range to display','Callback',@(src,evt) MnuTime2Display(obj));
            obj.MenuChanLink=uimenu(obj.MenuSettings,'Label','All datasets have the same channels',...
                'Callback',@(src,evt) set(obj,'ChanLink',~obj.ChanLink));
            obj.MenuDisplay=uimenu(obj.Fig,'Label','Display');
            obj.MenuInsideTicks=uimenu(obj.MenuDisplay,'Label','Put ticks inside the graph',...
                'Callback',@(src,evt) set(obj,'InsideTicks',~obj.InsideTicks));
            obj.MenuXGrid=uimenu(obj.MenuDisplay,'Label','Show XGrid',...
                'Callback',@(src,evt) set(obj,'XGrid',~obj.XGrid));
            obj.MenuYGrid=uimenu(obj.MenuDisplay,'Label','Show YGrid',...
                'Callback',@(src,evt) set(obj,'YGrid',~obj.YGrid));
        end
        
        %******************************************************************
        function infoControlPanel(obj,parent,position)
            obj.InfoPanel=uipanel(parent,'units','normalized','position',position,'BorderType','none');
            obj.TxtTime=uicontrol(obj.InfoPanel,'Style','text','units','normalized','position',[0 .5 1 .4],'HorizontalAlignment','Left','String','Time : 0:00:00.00 - sample 0');
            obj.TxtY=uicontrol(obj.InfoPanel,'Style','text','units','normalized','position',[0 0 1 .4],'HorizontalAlignment','Left','String','Chan :  - value 0');
        end
        
        %******************************************************************
        function timeControlPanel(obj,parent,position)
            obj.TimePanel=uipanel(parent,'units','normalized','position',position);
            obj.BtnPrevPage=uicontrol(obj.TimePanel,'Style','pushbutton','String','<<','units','normalized','position',[.01 .1 .1 .8],'Callback',@(src,evt) ChangeTime(obj,src));
            obj.BtnPrevSec=uicontrol(obj.TimePanel,'Style','pushbutton','String','<','units','normalized','position',[.11 .1 .1 .8],'Callback',@(src,evt) ChangeTime(obj,src));
            obj.EdtTime=uicontrol(obj.TimePanel,'Style','edit','String',0,'units','normalized','position',[.22 0.1 .26 .8],'BackgroundColor',[1 1 1],'Callback',@(src,evt) ChangeTime(obj,src));
            obj.BtnNextSec=uicontrol(obj.TimePanel,'Style','pushbutton','String','>','units','normalized','position',[.49 0.1 .1 .8],'Callback',@(src,evt) ChangeTime(obj,src));
            obj.BtnNextPage=uicontrol(obj.TimePanel,'Style','pushbutton','String','>>','units','normalized','position',[.60 0.1 .1 .8],'Callback',@(src,evt) ChangeTime(obj,src));
            obj.BtnPlay=uicontrol(obj.TimePanel,'Style','pushbutton','String','Play','units','normalized','position',[.71 0.1 .28 .8],'Callback',@(src,evt) StartPlay(obj));
        end
        
        %******************************************************************
        function filterControlPanel(obj,parent,position)
            obj.FilterPanel=uibuttongroup('Parent',parent,'Position',position,'units','normalized');
            obj.ChkFilter=uicontrol(obj.FilterPanel,'Style','checkbox','units','normalized','position',[0 .55 .31 .4],'String','Filtering',...
                'Callback',@(src,evt) set(obj,'Filtering',get(src,'Value')));
            obj.ChkStrongFilter=uicontrol(obj.FilterPanel,'Style','checkbox','units','normalized','position',[0 .05 .31 .4],'String','High Order',...
                'Callback',@(src,evt) set(obj,'StrongFilter',get(src,'Value')));
            uicontrol(obj.FilterPanel,'Style','text','String','Low:','units','normalized','position',[.32 .2 .09 .6],'HorizontalAlignment','right');
            obj.EdtFilterLow=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.43 .1 .08 .8],'BackgroundColor',[1 1 1],...
                'Callback',@(src,evt) set(obj,'FilterLow',str2double(get(src,'String'))));
            uicontrol(obj.FilterPanel,'Style','text','String','High:','units','normalized','position',[.52 .2 .09 .6],'HorizontalAlignment','right');
            obj.EdtFilterHigh=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.62 .1 .08 .8],'BackgroundColor',[1 1 1],...
                'Callback',@(src,evt) set(obj,'FilterHigh',str2double(get(src,'String'))));
            uicontrol(obj.FilterPanel,'Style','text','String','Notch:','units','normalized','position',[.72 .2 .09 .6],'HorizontalAlignment','right');
            obj.EdtFilterNotch1=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.82 .1 .08 .8],'BackgroundColor',[1 1 1],...
                'Callback',@(src,evt) set(obj,'FilterNotch1',str2double(get(src,'String'))));
            obj.EdtFilterNotch2=uicontrol(obj.FilterPanel,'Style','edit','units','normalized','position',[.9 .1 .08 .8],'BackgroundColor',[1 1 1],...
                'Callback',@(src,evt) set(obj,'FilterNotch2',str2double(get(src,'String'))));
        end
        
        %******************************************************************
        function scaleControlPanel(obj,parent,position)
            obj.ScalePanel=uibuttongroup('Parent',parent,'units','normalized','position',position);
            list=[{'All'} num2cell(1:obj.DataNumber)];
            uicontrol(obj.ScalePanel,'Style','text','String','Target data','units','normalized','position',[0 .2 .28 .6],'HorizontalAlignment','Right');
            obj.PopSpacingTarget=uicontrol(obj.ScalePanel,'Style','popupmenu','String',list,'units','normalized','position',[0.3 .1 .15 .8],'BackgroundColor',[1 1 1],'Callback',@(src,evt) ChangeSpacingTarget(obj));
            obj.EdtSpacing=uicontrol(obj.ScalePanel,'Style','edit','units','normalized','position',[.47 .1 .15 .8],'BackgroundColor',[1 1 1],'Callback',@(src,evt) ChangeSpacing(obj,src));
            obj.BtnAddSpacing=uicontrol(obj.ScalePanel,'Style','pushbutton','String','+','units','normalized','position',[.63 0.55 .07 .35],'Callback',@(src,evt) ChangeSpacing(obj,src));
            obj.BtnRemSpacing=uicontrol(obj.ScalePanel,'Style','pushbutton','String','-','units','normalized','position',[.63 0.1 .07 .35],'Callback',@(src,evt) ChangeSpacing(obj,src));
        end
        
        %******************************************************************
        function montageToolbar(obj)
            obj.TogMontage(1)=uitoggletool(obj.Toolbar,'CData',imread('Raw.bmp'),'TooltipString','Raw montage','ClickedCallback',@(src,evt) set(obj,'MontageRef',1));
            for i=2:5, obj.TogMontage(i)=uitoggletool(obj.Toolbar,'ClickedCallback',@(src,evt) set(obj,'MontageRef',i));end
            
        end
        
        %******************************************************************
        function viewToolbar(obj)
            obj.TogSuperimposed=uitoggletool(obj.Toolbar,'CData',imread('superimposed.bmp'),'TooltipString','Superimposed','separator','on','ClickedCallback',@(src,evt) set(obj,'DataView','Superimposed'));
            obj.TogAlternated=uitoggletool(obj.Toolbar,'CData',imread('alternated.bmp'),'TooltipString','Alternated','ClickedCallback',@(src,evt) set(obj,'DataView','Alternated'));
            obj.TogHorizontal=uitoggletool(obj.Toolbar,'CData',imread('horizontal.bmp'),'TooltipString','Horizontal','ClickedCallback',@(src,evt) set(obj,'DataView','Horizontal'));
            obj.TogVertical=uitoggletool(obj.Toolbar,'CData',imread('vertical.bmp'),'TooltipString','Vertical','ClickedCallback',@(src,evt) set(obj,'DataView','Vertical'));
            
            for i=1:9
                obj.TogData(i)=uitoggletool(obj.Toolbar,'CData',imread(['eeg' num2str(i) '.bmp']),'TooltipString',['DAT' num2str(i)],'ClickedCallback',@(src,evt) set(obj,'DataView',['DAT' num2str(i)]));
            end
            
            for i=obj.DataNumber+1:9
                set(obj.TogData(i),'Enable','off')
            end
        end
        
        %******************************************************************
        function toolToolbar(obj)
            obj.TogMeasurer=uitoggletool(obj.Toolbar,'CData',imread('measurer.bmp'),'TooltipString','Measure of each channels','separator','on','ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));
            obj.TogPan=uitoggletool(obj.Toolbar,'CData',imread('pan.bmp'),'TooltipString','Vertical Pan','ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));
            obj.TogSelection=uitoggletool(obj.Toolbar,'CData',imread('select.bmp'),'TooltipString','Selection','ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));
            obj.TogEvts=uitoggletool(obj.Toolbar,'CData',imread('evts.bmp'),'TooltipString','Event Window','separator','on','Enable','off','ClickedCallback',@(src,evt) WinEvents(obj,src));
            obj.TogVideo=uitoggletool(obj.Toolbar,'CData',imread('video.bmp'),'TooltipString','Video Window','ClickedCallback',@(src,evt) WinVideoFcn(obj,src));
            
            obj.TogAnnotate=uitoggletool(obj.Toolbar,'CData',imread('annotate.bmp'),'TooltipString','Annotate events','separator','on','ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));
        end
        
        %******************************************************************
        function remakeMontage(obj)
            %Assure Montage properties Coherence
            
            if iscell(obj.Montage_)
                if length(obj.Montage_)~=obj.DataNumber, error('If system is cell, it must be of same length than data');end
            else
                obj.Montage_={obj.Montage_};
                if obj.ChanLink
                    obj.Montage_(2:obj.DataNumber)=obj.Montage_(1);
                else
                    obj.Montage_(2:obj.DataNumber)={[]};
                end
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
                obj.ChanNames_(1:obj.DataNumber)={{}};
            end
            if ~iscell(obj.ChanNames_{1})
                tmp=obj.ChanNames_;
                obj.ChanNames_={{}};
                obj.ChanNames_{1}=tmp;
                for i=2:obj.DataNumber
                    if obj.ChanLink_
                        obj.ChanNames_{i}=tmp;
                    else
                        obj.ChanNames_(i)={{}};
                    end
                end
            end
            for i=1:obj.DataNumber
                if isempty(obj.ChanNames_{i})
                    obj.ChanNames_{i}=num2cell(1:size(obj.Data{i},1));
                    obj.ChanNames_{i}=cellfun(@num2str,obj.ChanNames_{i},'UniformOutput',false);
                    obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
                elseif ~isempty(obj.Montage{i}) && isnan(str2double(obj.ChanNames_{i}{1}))
                    obj.ChanOrderMat{i}=eye(obj.DataSize(i));
                    p=zeros(1,size(obj.ChanOrderMat{i},1));
                    for j=1:size(obj.ChanOrderMat{i},1)
                        for k=1:length(obj.ChanNames_{i})
                            if strcmpi(obj.Montage_{i}(1).ChanNames_{j},obj.ChanNames_{i}{k})
                                p(j)=k;
                            end
                        end
                    end
                    obj.ChanOrderMat(1:size(obj.ChanOrderMat{i},1),:)=obj.ChanOrderMat{i}(p(1:size(obj.ChanOrderMat{i},1)),:);
                    for j=1:length(obj.Montage_{i})
                        obj.Montage_{i}(j).mat=obj.Montage_{i}(j).mat*obj.ChanOrderMat{i};
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
            
            if ~obj.ChanLink || obj.DataNumber==1
                set(obj.TogAlternated,'Enable','off')
                set(obj.TogSuperimposed,'Enable','off')
                if any(strcmpi(obj.DataView_,{'Superimposed','Alternated'}))
                    obj.DataView_='DAT1';
                end
            else
                set(obj.TogAlternated,'Enable','on')
                set(obj.TogSuperimposed,'Enable','on')
            end
            if obj.DataNumber==1
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
            set(obj.TogSuperimposed,'State',offon{strcmpi(obj.DataView_,'Superimposed')+1});
            set(obj.TogAlternated,'State',offon{strcmpi(obj.DataView_,'Alternated')+1});
            set(obj.TogHorizontal,'State',offon{strcmpi(obj.DataView_,'Horizontal')+1});
            set(obj.TogVertical,'State',offon{strcmpi(obj.DataView_,'Vertical')+1});
            for i=1:length(obj.TogData)
                set(obj.TogData(i),'State',offon{strcmpi(obj.DataView_,['DAT' num2str(i)])+1});
            end
            
            
            for i=2:length(obj.TogMontage), set(obj.TogMontage(i),'Enable','off','CData',imread(['montage' num2str(i-1) '.bmp']),'TooltipString',['Preset Montage' num2str(i-1)]); end
            for i=1:length(obj.TogMontage), set(obj.TogMontage(i),'State','off'); end
            
            n=NaN;
            if obj.ChanLink && any(strcmpi(obj.DataView,{'Superimposed','Alternated','Vertical','Horizontal'}))
                n=1;
            end
            if strcmpi(obj.DataView(1:3),'DAT')
                n=str2double(obj.DataView(4));
            end
            if ~isnan(n)
                for i=1:length(obj.Montage{n})
                    im=[obj.Montage{n}(i).name '.bmp'];
                    if exist(im,'file')~=2, im=['montage' num2str(i-1) '.bmp']; end
                    set(obj.TogMontage(i),'Enable','on','CData',imread(im),'TooltipString',obj.Montage{n}(i).name)
                end
                try set(obj.TogMontage(obj.MontageRef_(n)),'State','on');
                catch,set(obj.TogMontage(obj.MontageRef_(1)),'State','on'); end %#ok<CTCH>
            end
            
            if length(obj.Spacing_)==1
                clear tmp;
                tmp(1:obj.DataNumber)=obj.Spacing_;
                set(obj,'Spacing_',tmp);
            end
            ChangeSpacingTarget(obj);
        end
        
        %******************************************************************
        %********************Interface Action Methods *********************
        %******************************************************************
        
        %******************************************************************
        function ChangeTime(obj,src)
            timemax=floor((size(obj.Data{1},2)-1)/obj.SRate);
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
        function PlayTime(obj)
            t=obj.VideoTimeFrame(obj.VideoFrameInd,1)+obj.VideoStartTime;
            
            obj.VideoLineTime=t-obj.Time;
            
            if (t-obj.Time)>obj.WinLength
                obj.VideoLineTime=0;
                set(obj,'Time',obj.Time+obj.WinLength);
            end
            
            
            
        end
        
        %******************************************************************
        function ChangeSpacingTarget(obj)
            if get(obj.PopSpacingTarget,'Value')==1
                if all(obj.Spacing==obj.Spacing(1))
                    set(obj.EdtSpacing,'String',obj.Spacing(1))
                else
                    set(obj.EdtSpacing,'String','-')
                end
            else
                n=get(obj.PopSpacingTarget,'Value')-1;
                set(obj.EdtSpacing,'String',obj.Spacing(n))
            end
        end
        
        %******************************************************************
        function ChangeSpacing(obj,src)
            if get(obj.PopSpacingTarget,'Value')==1
                if src==obj.BtnAddSpacing
                    obj.Spacing=obj.Spacing*2^.25;
                elseif src==obj.BtnRemSpacing
                    obj.Spacing=obj.Spacing*2^-.25;
                else
                    obj.Spacing=str2double(get(src,'String'));
                end
            else
                n=get(obj.PopSpacingTarget,'Value')-1;
                if src==obj.BtnAddSpacing
                    obj.Spacing(n)=obj.Spacing(n)*2^.25;
                elseif src==obj.BtnRemSpacing
                    obj.Spacing(n)=obj.Spacing(n)*2^-.25;
                else
                    obj.Spacing(n)=str2double(get(src,'String'));
                end
            end
        end
        
        %******************************************************************
        function ChangeSliders(obj,src,evt)
            if src==obj.Fig && ~isempty(obj.Sliders) && ~isa(src,'figure')
                if length(obj.Sliders)==1
                    if obj.ChanLink || any(strcmpi(obj.DataView,{'Superimposed','Alternated','Vertical','Horizontal'}))
                        obj.FirstDispChans(:)=obj.FirstDispChans(:)+evt.VerticalScrollCount;
                    else
                        n=str2double(obj.DataView(4));
                        obj.FirstDispChans(n)=obj.FirstDispChans(n)+evt.VerticalScrollCount;
                    end
                end
                if length(obj.Sliders)>1
                    n=obj.MouseDataset;
                    if n~=0
                        obj.FirstDispChans(n)=obj.FirstDispChans(n)+evt.VerticalScrollCount;
                    end
                end
            else
                if isa(src,'figure')
                    if length(obj.Sliders)==1
                        src=obj.Sliders;
                    else
                        src=obj.Sliders(obj.Axes==evt.Axes);
                    end
                    v=get(evt.Axes,'Ylim');
                    if strcmpi(obj.DataView,'Alternated')
                        set(src,'value',v(1)/obj.DataNumber);
                    else
                        set(src,'value',v(1));
                    end
                end
                if length(obj.Sliders)==1
                    if obj.ChanLink || any(strcmpi(obj.DataView,{'Superimposed','Alternated','Vertical','Horizontal'}))
                        obj.FirstDispChans(:)=get(src,'max')-get(src,'value')+1;
                    else
                        n=str2double(obj.DataView(4));
                        obj.FirstDispChans(n)=get(src,'max')-get(src,'value')+1;
                    end
                end
                if length(obj.Sliders)>1
                    obj.FirstDispChans(obj.Sliders==src)=get(src,'max')-get(src,'value')+1;
                end
            end
        end
        
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
        
        %******************************************************************
        function MouseDown(obj)
            
            
            t=floor((obj.MouseTime-obj.Time)*obj.SRate);
            
            [nchan,ndata,yvalue]=getMouseInfo(obj); %#ok<ASGLU>
            time=obj.MouseTime;
            
            obj.SelectedEvent=[];
            obj.SelectedLines=[];
            if ~isempty(obj.EventLines)
                for i=1:size(obj.EventLines,1)*size(obj.EventLines,2)
                    XData=get(obj.EventLines(i),'XData');
                    eventIndex=XData(1);
                    if abs(t-eventIndex)<50
                        
                        set(obj.EventLines(i),'Color',[159/255 0 197/255]);
                        set(obj.EventTexts(i),'EdgeColor',[159/255 0 197/255],'BackgroundColor',[159/255 0 197/255]);
                        obj.SelectedLines=[obj.SelectedLines i];
                        obj.SelectedEvent=obj.EventDisplayIndex(i);
                        obj.DragMode=1;
                    else
                        set(obj.EventLines(i),'Color',[0 0.7 0]);
                        set(obj.EventTexts(i),'EdgeColor',[0 0.7 0],'BackgroundColor',[0.6 1 0.6]);
                        
                    end
                end
            end
            
            
            if strcmpi(obj.MouseMode,'Select')
                
                if(strcmp(get(obj.Fig,'SelectionType'),'open'))
                    
                    obj.SelectionStart=[];%Cancel first click
                    i=1;
                    while i<=size(obj.Selection,2)
                        if time<=obj.Selection(2,i) && time>=obj.Selection(1,i)
                            obj.Selection=obj.Selection(:,[1:i-1 i+1:end]);
                        else
                            i=i+1;
                        end
                    end
                    redraw(obj);
                    
                else
                    if isempty(obj.SelectionStart)
                        obj.SelectionStart=time;
                    else %Second click
                        tempSelection=sort([obj.SelectionStart;time]);
                        for i=1:size(obj.Selection,2)
                            if tempSelection(1,1)<=obj.Selection(2,i) && tempSelection(2,1)>=obj.Selection(1,i)
                                tempSelection(:,1)=[min([tempSelection(1,1) obj.Selection(1,i)]) max([tempSelection(2,1) obj.Selection(2,i)])];
                            else
                                tempSelection(:,end+1)=obj.Selection(:,i); %#ok<AGROW>
                            end
                        end
                        obj.Selection=round(100*sortrows(tempSelection',1)')/100;
                        
                        
                        obj.SelectionStart=[];
                        redraw(obj);
                    end
                end
            elseif strcmpi(obj.MouseMode,'Annotate')
                
                EventList=obj.Evts;
                EventList=cat(1,EventList,{time,'NewText'});
                obj.Evts=EventList;
                
            end
        end
        %==================================================================
        function MouseUp(obj)
            if obj.EditMode==1
                obj.EditMode=0;
                EventList=obj.Evts;
                for i=1:size(obj.EventDisplayIndex,2)
                    EventList{obj.EventDisplayIndex(1,i),2}=get(obj.EventTexts(1,i),'String');
                end
                obj.Evts=EventList;
            end
            
            if ~isempty(obj.SelectedEvent)
                if obj.DragMode==2
                    EventList=obj.Evts;
                    EventList{obj.SelectedEvent,1}=obj.MouseTime;
                    obj.Evts=EventList;
                    
                end
            end
            
            
            obj.DragMode=0;
            
        end
        %==================================================================
        function KeyPress(obj,src,evt)
            if strcmpi(evt.Key,'escape')
                obj.MouseMode=[];
            end
        end
        
        %==================================================================
        function KeyRelease(obj,src,evt)
            
            if ~isempty(evt.Modifier)
                if (strcmpi(evt.Modifier{1},'command')&&strcmpi(evt.Key,'backspace'))...
                        ||(strcmpi(evt.Modifier{1},'shift')&&strcmpi(evt.Key,'d'))
                    
                    %delete the drag selected event
                    if ~isempty(obj.SelectedEvent)
                        EventList=obj.Evts;
                        EventList(obj.SelectedEvent,:)=[];
                        
                        obj.SelectedEvent=[];
                        obj.SelectedLines=[];
                        
                        obj.Evts=EventList;
                    end
                end
            end
            
            if strcmpi(evt.Key,'return')
                if ~isempty(obj.SelectedEvent)
                    for i=1:length(obj.Axes)
                        if gca==obj.Axes(i)
                            obj.EditMode=1;
                            set(obj.EventTexts(obj.SelectedLines(i)),'Editing','on');
                        end
                    end
                end
            end
        end
        %******************************************************************
        
        function MouseMovementMeasurer(obj)
            t=floor((obj.MouseTime-obj.Time)*obj.SRate);
            
            for i=1:length(obj.Axes)
                set(obj.LineMeasurer(i),'XData',[t t])
                for j=1:length(obj.TxtMeasurer{i})
                    p=get(obj.TxtMeasurer{i}(j),'position');
                    p(1)=t+0.01*obj.WinLength*obj.SRate;
                    if strcmpi(obj.DataView,'Superimposed')
                        nchan=obj.MontageChanNumber(1)-j+1;
                        s=[obj.MontageChanNames{1}{nchan} ':'];
                        for k=1:obj.DataNumber
                            s=[s ' ' num2str(k) '-' num2str(obj.PreprocData{k}(nchan,t))]; %#ok<AGROW>
                        end
                    elseif strcmpi(obj.DataView,'Alternated')
                        nchan=sum(obj.MontageChanNumber)-j;
                        ndata=rem(nchan,obj.DataNumber)+1;
                        nchan=floor(nchan/obj.DataNumber)+1;
                        s=['(' num2str(ndata) ')' obj.MontageChanNames{1}{nchan} ':' num2str(obj.PreprocData{ndata}(nchan,t))];
                    elseif any(strcmpi(obj.DataView,{'Horizontal','Vertical'}))
                        nchan=obj.MontageChanNumber(i)-j+1;
                        s=[obj.MontageChanNames{i}{nchan} ':' num2str(obj.PreprocData{i}(nchan,t))];
                    else
                        ndata=str2double(obj.DataView(4));
                        nchan=obj.MontageChanNumber(ndata)-j+1;
                        s=[obj.MontageChanNames{ndata}{nchan} ':' num2str(obj.PreprocData(nchan,t))];
                    end
                    set(obj.TxtMeasurer{i}(j),'Position',p,'String',s);
                end
            end
        end
        
        %******************************************************************
        function MouseMovement(obj)
            [nchan,ndata,yvalue]=getMouseInfo(obj);
            time=obj.MouseTime;
            mouseIndex=floor((obj.MouseTime-obj.Time)*obj.SRate);
            
            
            if ndata==0
                set(obj.Fig,'pointer','arrow')
            else
                if ~strcmpi(obj.MouseMode,'Pan')
                    set(obj.Fig,'pointer','crosshair')
                end
                
                if strcmpi(obj.MouseMode,'Measurer')
                    obj.MouseMovementMeasurer();
                elseif strcmpi(obj.MouseMode,'Select')
                    if ~isempty(obj.SelectionStart)
                        t=sort([obj.SelectionStart time]-obj.Time)*obj.SRate;
                        epsilon=1.e-10;
                        if strcmpi(obj.DataView,'Horizontal') || strcmpi(obj.DataView,'Vertical')
                            for i=1:length(obj.Data);
                                p=get(obj.Axes(i),'YLim');
                                set(obj.SelRect(i),'position',[t(1),p(1),t(2)-t(1)+epsilon,p(2)]);
                            end
                        else
                            p=get(obj.Axes,'YLim');
                            set(obj.SelRect,'position',[t(1),p(1),t(2)-t(1)+epsilon,p(2)]);
                        end
                        
                    end
                elseif strcmpi(obj.MouseMode,'Annotate')
                    set(obj.Fig,'pointer','cross')
                    
                    for i=1:length(obj.Axes)
                        set(obj.LineMeasurer(i),'XData',[mouseIndex mouseIndex],'Color',[159/255 0 0],'LineStyle',':');
                    end
                end
                
                if ~isempty(obj.EventLines)
                    for i=1:size(obj.EventLines,1)*size(obj.EventLines,2)
                        XData=get(obj.EventLines(i),'XData');
                        eventIndex=XData(1);
                        if abs(mouseIndex-eventIndex)<50
                            set(obj.Fig,'pointer','hand');
                        end
                    end
                end
                
                
                if obj.DragMode
                    obj.DragMode=2;
                    for i=1:length(obj.Axes)
                        set(obj.LineMeasurer(i),'XData',[mouseIndex mouseIndex],'Color',[0 0.7 0],'LineStyle','-.');
                    end
                end
                
                
                if strcmp(obj.TimeUnit,'min')
                    timestamp=time*60;
                else
                    timestamp=time;
                end
                
                s=rem(timestamp,60);
                m=rem(floor(timestamp/60),60);
                h=floor(timestamp/3600);
                
                set(obj.TxtTime,'String',['Time : ' num2str(h,'%02d') ':' num2str(m,'%02d') ':' num2str(s,'%06.3f')  ' - Sample : ' num2str(round(timestamp*obj.SRate),'%10d')]);
                c=obj.MontageChanNames{ndata};
                
                if round(time*obj.SRate)<=size(obj.Data{ndata},2)
                    if iscell(obj.PreprocData)
                        v=obj.PreprocData{ndata}(nchan,max(round((time-obj.Time)*obj.SRate),1));
                    else
                        v=obj.PreprocData(nchan,max(round((time-obj.Time)*obj.SRate),1));
                    end
                    set(obj.TxtY,'String',['Data : ' num2str(ndata) ' - Chan : '  c{nchan} ' - Value : ' num2str(v)]);
                else
                    set(obj.TxtY,'String',['Data : ' num2str(ndata) ' - Chan : '  c{nchan} ' - Value : OUT']);
                end
                
            end
        end
        
        %******************************************************************
        function MnuTime2Display(obj)
            %**************************************************************************
            % Dialog box to change windows length
            %**************************************************************************
            t=inputdlg('Time range to display :');
            t=str2double(t);
            if ~isempty(t) && ~isnan(t)
                obj.WinLength=t;
            end
        end
        
        %******************************************************************
        function MnuChan2Display(obj)
            %**************************************************************************
            % Dialog box to change number of channel to display
            %**************************************************************************
            t=inputdlg('Number of channel to display (empty for all):');
            if iscell(t) && isempty(t)
                return;
            end
            if iscell(t)
                t=t{1};
            end
            if isempty(t) || strcmp(t,'[]')
                obj.DispChans=[];
            else
                t=str2double(t);
                if ~isnan(t)
                    obj.DispChans=t;
                end
            end
        end
        
        %******************************************************************
        function MnuPlay(obj)
            %**************************************************************************
            % Dialog box to change the speed for play
            %**************************************************************************
            t=inputdlg('Speed of play : X ');
            t=str2double(t);
            if ~isempty(t) && ~isnan(t)
                obj.PlaySpeed=t;
            end
        end
        
        %******************************************************************
        function ExportToWindow(obj)
            [file,filetype,pages,paperparams]=ExportWindow();
            if ~isempty(file)
                if strcmpi(pages,'CurrentPage')
                    pages=obj.Time;
                elseif strcmpi(pages,'Whole')
                    pages=0:obj.WinLength:((size(obj.Data{1},2)-1)/obj.SRate);
                elseif strcmpi(pages,'Selection')
                    pages=[];
                    for i=1:size(obj.Selection,2)
                        for d=floor(obj.Selection(1,i)):obj.WinLength:obj.Selection(2,i)
                            pages=[pages d]; %#ok<AGROW>
                        end
                    end
                end
                
                
                if(strcmp(filetype,'image') || strcmp(filetype,'fig'))
                    obj.ExportPagesTo(file,pages,paperparams{:});
                else
                    obj.ExportPagesToMultiPages(file,pages,paperparams{:});
                end
            end
        end
        function ExportEvents(obj)
            %==================================================================
            for i=1:size(obj.Evts,1)
                Events.stamp(i)=obj.Evts{i,1};
                Events.text{i}=obj.Evts{i,2};
            end
            if ~isempty(Events)
                [FileName,FilePath]=uiputfile({'*.mat';'*.evt'},'save your Events');
                if FileName~=0
                    save(fullfile(FilePath,FileName),'-struct','Events');
                    obj.IsEvtsSaved=true;
                end
            end
        end
        
        function ImportEvents(obj)
            
            if isempty(obj.Evts)
                choice='overwrite';
            else
                default='overwrite';
                choice=questdlg('Do you want to overwrite or overlap the existed events?','warning',...
                    'overwrite','overlap','cancel',default);
            end
            
            if strcmpi(choice,'cancel')
                return
            end
            
            [FileName,FilePath]=uigetfile({'*.mat';'*.evt'},'select your events file');
            if FileName~=0
                Events=load(fullfile(FilePath,FileName),'-mat');
                
                if isfield(Events,'stamp')&&isfield(Events,'text')
                    for i=1:length(Events.stamp)
                        NewEventList{i,1}=Events.stamp(i);
                        NewEventList{i,2}=Events.text{i};
                    end
                end
                if iscell(NewEventList)
                    if size(NewEventList,2)==2
                        switch choice
                            case 'overwrite'
                                obj.Evts=NewEventList;
                                obj.IsEvtsSaved=true;
                            case 'overlap'
                                obj.Evts=cat(1,obj.Evts,NewEventList);
                                obj.IsEvtsSaved=false;
                            case 'cancel'
                        end
                    end
                end
            end
        end
        
        %==================================================================
        function ImportVideo(obj)
            formats=VideoReader.getFileFormats();
            filterSpec=getFilterSpec(formats);
            [FileName,FilePath]=uigetfile(filterSpec,'select the video file','behv.avi');
            
            if FileName~=0
                [video,audio]=mmread(fullfile(FilePath,FileName),1);
                if ~isempty(video)
                    videoTotalTime=video.totalDuration;
                    obj.VideoFile=fullfile(FilePath,FileName);
                    
                    dataTime=floor((size(obj.Data{1},2)-1)/obj.SRate);
                    f=figure;
                    obj.VideoHandle=imagesc(video.frames(1).cdata);
                    drawnow
                    
                    disp('Video loading...');
                    obj.VideoTotalTime=videoTotalTime;
                    if isempty(obj.VideoTimeFrame)
                        
                        if obj.VideoStartTime>0
                            videoEndTime=dataTime-obj.VideoStartTime;
                            if videoEndTime>videoTotalTime
                                videoEndTime=videoTotalTime;
                            end
                            [obj.VideoObj,obj.AudioObj]=mmread(fullfile(FilePath,FileName),[],[0,videoEndTime]);
                        else
                            videoEndTime=abs(obj.VideoStartTime)+dataTime;
                            if videoEndTime>videoTotalTime
                                videoEndTime=videoTotalTime;
                            end
                            [obj.VideoObj,obj.AudioObj]=mmread(fullfile(FilePath,FileName),[],[abs(obj.VideoStartTime),videoEndTime]);
                        end
                        timeframe(:,1)=reshape(obj.VideoObj.times,length(obj.VideoObj.times),1);
                        timeframe(:,2)=(1:length(obj.VideoObj.times))';
                        
                        %make sure the first frame start at time 0
                        timeframe(:,1)=timeframe(:,1)-timeframe(1,1);
                        obj.VideoTimeFrame=timeframe;
                    else
                        %                         [frames,iframe,j]=unique(obj.VideoTimeFrame(:,2));
                        %                         obj.VideoTimeFrame=obj.VideoTimeFrame(iframe,:);
                        %                         obj.VideoTimeFrame(:,2)=0:size(obj.VideoTimeFrame,1)-1;
                        [obj.VideoObj,obj.AudioObj]=mmread(fullfile(FilePath,FileName));
                    end
                    
                    obj.VideoTimerPeriod=1/obj.VideoObj.rate;
                    obj.TotalVideoFrame=length(obj.VideoObj.frames);
                    obj.VideoFrame=1;
                    ind=find(obj.VideoTimeFrame(:,2)==1);
                    obj.VideoFrameInd=ind(1);
                    obj.VideoLineTime=0;
                    
                    disp('Video loaded.')
                    
                else
                    error('Cannot import the selected video');
                end
            end
        end
        
        %******************************************************************
        function WinEvents(obj,src)
            if strcmpi(get(src,'State'),'on')
                obj.WinEvts=EventWindow(obj.Evts);
                addlistener(obj.WinEvts,'EvtSelected',@(src,evtdat) set(obj,'Time',round(src.EventTime-obj.WinLength/2)));
                addlistener(obj.WinEvts,'EvtClosed',@(src,evtdat) set(obj.TogEvts,'State','off'));
            else
                delete(obj.WinEvts);
            end
        end
        
        %******************************************************************
        function WinVideoFcn(obj,src)
            %             if strcmpi(get(src,'State'),'on')
            %                 if ~strcmp(computer,'PCWIN')
            %                     set(src,'State','off')
            %                     msgbox('Only works on Windows with Matlab 32bits version')
            %                     return;
            %                 end
            %                 if isempty(obj.Video)
            %                     [f,p]=uigetfile('*.*','Select a Video File');
            %                     if f~=0,obj.Video=[p f];end
            %                 end
            %
            %                 if ~isempty(obj.Video)
            %                     obj.WinVideo=VideoWindow(obj.Video);
            %                     obj.WinVideo.Time=obj.VideoTime;
            %                     obj.VideoListener=addlistener(obj.WinVideo,'VideoChangeTime',@(src,evtdat) UpdateVideoTime(obj));
            %                     addlistener(obj.WinVideo,'VideoClosed',@(src,evtdat) set(obj.TogVideo,'State','off'));
            %                 else
            %                     set(src,'State','off')
            %                 end
            %             else
            %                 delete(obj.WinVideo);
            %             end
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
            set(obj.MainPanel,'position',[0 ctrlsize(2) pos(3) pos(4)-ctrlsize(2)]);
            set(obj.ControlPanel,'position',[0 0 ctrlsize(1) ctrlsize(2)]);
        end
    end
    
    
    
    
    %evts
    %end
end