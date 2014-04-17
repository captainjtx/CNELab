% Class Enabling to Play videos with VLC ActiveX. 
% [Works only on 32bits version of Matlab]
%
% USAGE
%    a=VideoWindow('VideoFile');
% PROPERTIES
%    Set Access : a.key1=value1
%    Get Access : value1=a.key1
% 
%   Time    (Read/Write) Current time of the Video (s)
%   Speed   (Read/Write) Speed of the Video (Normal = 1) 2 means twice faster
%   VideoLength (Read Only) Length of the Video (s)
%   Fig      The fig handle of the Window
%
% EVENTS
%  VideoChangeTime: Call every 0.5 s if time has changed
%  VideoClosed    : When the window is closed


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
% V0.1.1 Beta - 13/02/2013 - Initial Version


classdef VideoWindow  < handle
    properties
        File
        Fig
        Toolbar
        Tools
        Slider
        Actx
        Timer
        Speed=1
        VideoLength
    end
    properties (Dependent)
        Time
    end
    methods
        function obj=VideoWindow(file)
            obj.Fig=figure('MenuBar','none','position',[200 100 400 315],'NumberTitle','off','Name','Video (vlc)',...
                'CloseRequestFcn',@(src,evts) delete(obj),'ResizeFcn',@(src,evts) resize(obj));
            obj.Toolbar=uitoolbar(obj.Fig);
            
            obj.Tools(1)=uipushtool(obj.Toolbar,'cdata',imread('pause.bmp'),'tooltipstring','Pause',...
                'clickedcallback',@(src,evt) action(obj,src));
            obj.Tools(2)=uipushtool(obj.Toolbar,'cdata',imread('stop.bmp'),'tooltipstring','Stop',...
                'clickedcallback',@(src,evt) action(obj,src));
            obj.Tools(3)=uipushtool(obj.Toolbar,'cdata',imread('slower.bmp'),'tooltipstring','Slower',...
                'clickedcallback',@(src,evt) action(obj,src),'separator','on');
            obj.Tools(4)=uipushtool(obj.Toolbar,'cdata',imread('faster.bmp'),'tooltipstring','Faster',...
                'clickedcallback',@(src,evt) action(obj,src));
            obj.Tools(5)=uipushtool(obj.Toolbar,'cdata',imread('on.bmp'),'tooltipstring','Sound on',...
                'clickedcallback',@(src,evt) action(obj,src),'separator','on');
            try
                obj.Actx = actxcontrol('VideoLAN.VLCPlugin.2','parent',obj.Fig,'position',[0 15 400 300]);
            catch %#ok<CTCH>
                error('Error during ActiveX openning. The video feature is only compatible with 32 bit version of Matlab and it requires VLC being installed (http://www.videolan.org/vlc/)')
            end
            obj.Slider=uicontrol(obj.Fig,'Style','Slider','position',[0 0 400 15],'value',0,'callback',@(src,evt) SliderFcn(obj));
            
            obj.File=file;
            obj.Actx.playlist.add(file);
            obj.Actx.playlist.play();
            
            obj.VideoLength=-inf;%Compute video length and wait the video openning
            while obj.VideoLength<=0
                obj.VideoLength=double(obj.Actx.input.length)/1000;
                pause(.01);
            end

            
            obj.Timer = timer('timerfcn',@(src,evt) Timerfcn(obj),'period',.2,'executionmode','fixedRate');
            start(obj.Timer)

        end
        
        function delete(obj)
            % Delete the figure
            stop(obj.Timer);
            delete(obj.Timer);
            h = obj.Fig;
            obj.Actx.playlist.stop();
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
                move(obj.Actx,[0 15 p(3) p(4)-15]);
                set(obj.Slider,'position',[0 0 p(3) 15]);
            catch %#ok<CTCH>
            end
        end
        
        function set.Speed(obj,val)
            obj.Speed=max(min(val,16),.125);
            obj.Actx.input.rate = obj.Speed;
        end
        
        function set.Time(obj,val)
            pos=val/obj.VideoLength;
            obj.Actx.input.position=pos;
            set(obj.Slider,'Value',pos);
        end
        function val=get.Time(obj)
            val=obj.Actx.input.position*obj.VideoLength;
        end
        
        function action(obj,src)
            button=get(src,'tooltipstring');
            switch button
                case 'Stop'
                    delete(obj);
                case 'Pause'
                    set(obj.Tools(1),'cdata',imread('play.bmp'),'tooltipstring','Play');
                    obj.Actx.playlist.togglePause();
                    stop(obj.Timer)
                case 'Play'
                    set(obj.Tools(1),'cdata',imread('pause.bmp'),'tooltipstring','Pause');
                    obj.Actx.playlist.togglePause();
                    start(obj.Timer)
                case 'Slower'
                    obj.Speed=obj.Speed/2;
                case 'Faster'
                    obj.Speed=obj.Speed*2;
                case 'Sound off'
                    set(obj.Tools(5),'cdata',imread('on.bmp'),'tooltipstring','Sound on');
                    obj.Actx.audio.toggleMute();
                case 'Sound on'
                    set(obj.Tools(5),'cdata',imread('off.bmp'),'tooltipstring','Sound off');
                    obj.Actx.audio.toggleMute();
            end
        end
        
        function Timerfcn(obj)
            
            try
                pos=obj.Actx.input.position;
                
                set(obj.Slider,'Value',pos);
                notify(obj,'VideoChangeTime')
                if pos>=1
                    delete(obj)
                end
            catch %#ok<CTCH>
                obj.Actx.playlist.play();
                obj.VideoLength=-inf;%Compute video length and wait the video openning
                while obj.VideoLength<=0
                    obj.VideoLength=double(obj.Actx.input.length)/1000;
                    pause(.01);
                end
                action(obj,obj.Tools(1));%Pause
            end
            
            
        end
       
        function SliderFcn(obj)
            pos=get(obj.Slider,'Value');
            obj.Actx.input.position=pos;
            notify(obj,'VideoChangeTime')
        end
    end
    events
        VideoChangeTime
        VideoClosed
    end
    
end