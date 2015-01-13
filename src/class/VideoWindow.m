classdef VideoWindow  < handle
    properties
        File
        Fig %The handle of the matlab figure
        Actx %Activex component handle
        VideoLength %Total Video Time in Seconds
        Status %Playing or Paused or Stopped
        
        ActxOpt %WMP or VLC
        ActxName 
        
        CurrentFrameNumber
        FrameRate
        TotalFrame
        
    end
    properties(Dependent)
        PlaySpeed
        CurrentPosition %Current position in second
        CurrentPositionRatio %Current position of ratio, from 0 to 1
    end
    methods
        function obj=VideoWindow(file,varargin)
            
            if nargin==1
                obj.ActxOpt='WMP';
            else
                obj.ActxOpt=varargin{1};
            end
            
            if strcmpi(obj.ActxOpt,'WMP')
                obj.ActxName='WMPlayer.OCX.7';
                obj.File=file;
                figPos=[400,300];
            elseif strcmpi(obj.ActxOpt,'VLC')
                obj.ActxName='VideoLAN.VLCPlugin.2';
                obj.File=['file://localhost/' file];
                figPos=[400,400];
            end
            
            
            
            %Create Matlab Figure Container
            obj.Fig=figure('MenuBar','none','position',[200 100 figPos],...
                'NumberTitle','off','Name',obj.ActxOpt,...
                'CloseRequestFcn',@(src,evts) delete(obj),...
                'ResizeFcn',@(src,evts) resize(obj),...
                'ButtonDownFcn',@(src,evts) keyDown_Callback(obj));
            try
                %Create ActiveX Controller
                obj.Actx=actxcontrol(obj.ActxName,'parent',obj.Fig,...
                    'position',[0 0 figPos]);
            catch %#ok<CTCH>
                error('Error during ActiveX openning.')
            end
            
            %Add Matlab Callback Functions To Events
            if strcmpi(obj.ActxOpt,'WMP')
                registerevent(obj.Actx,{'PlayStateChange',@ obj.playStateChange_Callback;...
                    'KeyDown',@ obj.keyDown_Callback;...
                    'Click',@ obj.click_Callback;...
                    'PositionChange',@ obj.positionChange_Callback});
                obj.Actx.playlistCollection.newPlaylist('SynchVideo');
                
                newvideo=obj.Actx.newMedia(obj.File);
                obj.Actx.currentPlaylist.appendItem(newvideo);
            elseif strcmpi(obj.ActxOpt,'VLC')
                obj.Actx.registerevent({'MediaPlayerPlaying', @obj.playStateChange_Callback;...
                    'MediaPlayerPaused', @obj.playStateChange_Callback;...
                    'MediaPlayerStopped',@obj.playStateChange_Callback;...
                    'MediaPlayerForward', @obj.playStateChange_Callback;...
                    'MediaPlayerBackward', @obj.playStateChange_Callback;...
                    'MediaPlayerPositionChanged', @obj.positionChange_Callback;...
                    'MediaPlayerTimeChanged', @obj.positionChange_Callback});
                obj.Actx.playlist.add(obj.File);
            end
        end
        
        function delete(obj)
            % Delete the figure
            
            h = obj.Fig;
            obj.stop;
            delete(obj.Actx);
            pause(0.1);
            
            notify(obj,'VideoClosed');
            
            if ishandle(h)
                delete(h);
            else
                return
            end
        end
        
        function resize(obj)
            p=get(obj.Fig,'position');
            try
                move(obj.Actx,[0 0 p(3) p(4)]);
            catch %#ok<CTCH>
            end
        end
        
        %Events Callback Functions=========================================
        function playStateChange_Callback(obj,varargin)
            %             disp('play state change');
            notify(obj,'VideoChangeState');
        end
        
        function keyDown_Callback(obj,varargin)
            %             disp('key down');
        end
        
        function click_Callback(obj,varargin)
            %             disp('click');
            if strcmpi(obj.Status,'Paused')
                obj.play;
            elseif strcmpi(obj.Status,'Playing')
                obj.pause;
            end
        end
        
        function positionChange_Callback(obj,varargin)
            %             disp('position change')
            notify(obj,'VideoChangeTime')
        end
        %------------------------------------------------------------------
        function val=get.TotalFrame(obj)
            if strcmpi(obj.ActxOpt,'WMP')
                val=[];
            elseif strcmpi(obj.ActxOpt,'VLC')
                val=floor(obj.VideoLength*obj.FrameRate);
            end
        end
        function val=get.CurrentFrameNumber(obj)
            if strcmpi(obj.ActxOpt,'WMP')
                try
                    timecodestr=obj.ActxOpt.controls.currentPositionTimeCode;
                    frame_str=regexp(timecodestr,'\..+$','match');
                    val=str2double(frame_str(2:end));
                catch
                    val=[];
                end
            elseif strcmpi(obj.ActxOpt,'VLC')
%                 val=max(1,floor(obj.CurrentPosition*obj.FrameRate));
                  val=[];
            end
        end
        function val=get.FrameRate(obj)
            if strcmpi(obj.ActxOpt,'WMP')
                val=[];
            elseif strcmpi(obj.ActxOpt,'VLC')
                val=obj.Actx.input.fps;
            end
        end
        function val=get.VideoLength(obj)
            if strcmpi(obj.ActxOpt,'WMP')
                val=obj.Actx.currentMedia.duration;
            elseif strcmpi(obj.ActxOpt,'VLC')
                val=double(obj.Actx.input.length)/1000;
            end
        end
        function val=get.CurrentPosition(obj)
            if strcmpi(obj.ActxOpt,'WMP')
                val=obj.Actx.controls.currentPosition;
            elseif strcmpi(obj.ActxOpt,'VLC')
                val=double(obj.Actx.input.time)/1000;
%                val=obj.Actx.input.position*obj.VideoLength;
            end
        end
        function set.CurrentPosition(obj,val)
            if strcmpi(obj.ActxOpt,'WMP')
                obj.Actx.controls.currentPosition=val;
            elseif strcmpi(obj.ActxOpt,'VLC')
            end
        end
        
       function val=get.CurrentPositionRatio(obj)
            if strcmpi(obj.ActxOpt,'WMP')
                val=obj.CurrentPosition/obj.VideoLength;
            elseif strcmpi(obj.ActxOpt,'VLC')
                val=obj.Actx.input.position;
            end
        end
        
        function set.CurrentPositionRatio(obj,val)
            val=max(0,min(1,val));
            if strcmpi(obj.ActxOpt,'WMP')
                obj.Actx.controls.currentPosition=val*obj.VideoLength;
            elseif strcmpi(obj.ActxOpt,'VLC')
                obj.Actx.input.position=val;
            end
        end
        function val=get.PlaySpeed(obj)
            if strcmpi(obj.ActxOpt,'WMP')
                val=obj.Actx.settings.rate;
            elseif strcmpi(obj.ActxOpt,'VLC')
                val=obj.Actx.input.rate;
            end
        end
        function set.PlaySpeed(obj,val)
            if strcmpi(obj.ActxOpt,'WMP')
                obj.Actx.settings.rate=val;
            elseif strcmpi(obj.ActxOpt,'VLC')
                obj.Actx.input.rate=val;
            end
        end
       
        function val=get.Status(obj)
            if strcmpi(obj.ActxOpt,'WMP')
                if ~isempty(regexp(obj.Actx.status,'Playing','ONCE'))
                    val='Playing';
                elseif ~isempty(regexp(obj.Actx.status,'Paused','ONCE'))
                    val='Paused';
                elseif ~isempty(regexp(obj.Actx.status,'Stopped','ONCE'))
                    val='Stopped';
                else
                    val=obj.Actx.status;
                end
            elseif strcmpi(obj.ActxOpt,'VLC')
                switch (obj.Actx.input.state)
                    case 0
                        val='Idle';
                    case 1
                        val='Openning';
                    case 2
                        val='Buffering';
                    case 3
                        val='Playing';
                    case 4
                        val='Paused';
                    case 5
                        val='Stopped';
                    case 6
                        val='Ended';
                    case 7
                        val='Error';
                end
                        
            end
        end
        
        function play(obj)
            if strcmpi(obj.ActxOpt,'WMP')
                obj.Actx.controls.play
            elseif strcmpi(obj.ActxOpt,'VLC')
                obj.Actx.playlist.play
            end
        end
        
        function pause(obj)
            if strcmpi(obj.ActxOpt,'WMP')
                obj.Actx.controls.pause
            elseif strcmpi(obj.ActxOpt,'VLC')
                obj.Actx.playlist.pause
            end
        end
        function stop(obj)
            if strcmpi(obj.ActxOpt,'WMP')
                obj.Actx.controls.stop
            elseif strcmpi(obj.ActxOpt,'VLC')
                obj.Actx.playlist.stop
            end
        end
    end
    events
        VideoChangeTime
        VideoClosed
        VideoChangeState
    end
    
end