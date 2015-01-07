classdef VideoWindow  < handle
    properties
        File
        Fig
        Actx
        VideoLength
    end
    properties(Dependent)
        PlaySpeed
        CurrentPosition
    end
    methods
        function obj=VideoWindow(file)
            obj.File=file;
            
            %Create Matlab Figure Container
            obj.Fig=figure('MenuBar','none','position',[200 100 400 300],...
                           'NumberTitle','off','Name','Video (Windows Media Player)',...
                           'CloseRequestFcn',@(src,evts) delete(obj),...
                           'ResizeFcn',@(src,evts) resize(obj),...
                           'ButtonDownFcn',@(src,evts) keyDown_Callback(obj));
            try
                %Create Media Player ActiveX Controller
                obj.Actx = actxcontrol('WMPlayer.OCX','parent',obj.Fig,...
                                       'position',[0 0 400 300]);
            catch %#ok<CTCH>
                error('Error during ActiveX openning. The video feature windows media player plugin')
            end
            
            %Add Matlab Callback Functions To Events
            registerevent(obj.Actx,{'PlayStateChange',@ obj.playStateChange_Callback;...
                                    'KeyDown',@ obj.keyDown_Callback;...
                                    'Click',@ obj.click_Callback;...
                                    'PositionChange',@ obj.positionChange_Callback});
       
            obj.Actx.playlistCollection.newPlaylist('SynchVideo');
            
            newvideo=obj.Actx.newMedia(obj.File);
            obj.Actx.currentPlaylist.appendItem(newvideo);
            
            obj.VideoLength=obj.Actx.currentMedia.duration;

%             obj.Actx.controls.play;
        end
        
        function delete(obj)
            % Delete the figure

            h = obj.Fig;
            obj.Actx.controls.stop();
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
            if ~isempty(regexp(obj.Actx.status,'Paused','ONCE'))
                obj.Actx.controls.play;
            elseif ~isempty(regexp(obj.Actx.status,'Playing','ONCE'))
                obj.Actx.controls.pause;
            end
        end
        
        function positionChange_Callback(obj,varargin)
%             disp('position change')
            notify(obj,'VideoChangeTime')
        end
        %------------------------------------------------------------------
        
        function val=get.CurrentPosition(obj)
            val=obj.Actx.controls.currentPosition;
        end
        function set.CurrentPosition(obj,val)
            obj.Actx.controls.currentPosition=val;
        end
        
        function val=get.PlaySpeed(obj)
            val=obj.Actx.settings.rate;
        end
        function set.PlaySpeed(obj,val)
            obj.Actx.settings.rate=val;
        end
    end
    events
        VideoChangeTime
        VideoClosed
        VideoChangeState
    end
    
end