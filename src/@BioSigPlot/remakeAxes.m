% Re create Axes and sliders

function remakeAxes(obj)
%Lemon Chiffon
backgroundColor=obj.AxesBackgroundColor;



for i=1:length(obj.Sliders)
    delete(obj.Sliders(i));
end
for i=1:length(obj.Axes)
    delete(obj.Axes(i));
end
for i=1:length(obj.AxesAdjustPanels)
    delete(obj.AxesAdjustPanels(i));
end

obj.Sliders=[];obj.Axes=[];obj.AxesAdjustPanels=[];obj.AxesResizeMode=[];


Nchan=obj.MontageChanNumber;
n=obj.DataNumber;

MainPos=get(obj.MainPanel,'Position');

ElevWide=obj.ElevWidth/MainPos(3);

if strcmp(obj.DataView,'Horizontal')
    for i=1:n
        
        position=[(i-1)/n 0 1/n 1];
        if ~isempty(obj.DispChans(i)) %Need elevator
            
            position(3)=position(3)-ElevWide; % Multiple Elevator
            m=max(0.00001,Nchan(i)-obj.DispChans(i));
            obj.Sliders(i)=uicontrol(obj.MainPanel,'style','slider','units','normalized','position',[i/n-ElevWide 0 ElevWide 1],...
                'min',0,'max',m,'SliderStep',[1 obj.DispChans(i)]/max(1,m),'Callback',@(src,evt) ChangeSliders(obj,src));
            
        end
        obj.Axes(i)=axes('parent',obj.MainPanel,'XLim',[1 floor(obj.WinLength*obj.SRate)],'XTick',1:obj.SRate:floor(obj.WinLength*obj.SRate),...
            'TickLength',[.005 0],'position',position,'color',backgroundColor,'YAxisLocation','right','Layer','bottom');
    end
elseif strcmp(obj.DataView,'Vertical')
    for i=1:n
        if i==1
            start=0;
        else
            start=(MainPos(4)-(n-1)*obj.AxesAdjustWidth)/sum(obj.DispChans)*sum(obj.DispChans(1:i-1));
        end
        start=start+(i-1)*obj.AxesAdjustWidth;
        Height=(MainPos(4)-(n-1)*obj.AxesAdjustWidth)/sum(obj.DispChans)*obj.DispChans(i);
        position=[0    start    MainPos(3)    Height];
        
        position(3)=position(3)-obj.ElevWidth; % Multiple Elevator
        
        m=max(0.00001,Nchan(i)-obj.DispChans(i));
        obj.Sliders(i)=uicontrol(obj.MainPanel,'style','slider','units','pixels','position',[MainPos(3)-obj.ElevWidth start obj.ElevWidth Height],...
            'min',0,'max',m,'SliderStep',[1 obj.DispChans(i)]/max(1,m),'Callback',@(src,evt) ChangeSliders(obj,src));
        
        obj.Axes(i)=axes('parent',obj.MainPanel,'XLim',[1 floor(obj.WinLength*obj.SRate)],'XTick',0:obj.SRate:floor(obj.WinLength*obj.SRate),...
            'TickLength',[.005 0],'units','pixels','position',position,...
            'color',backgroundColor,'YAxisLocation','right','Layer','bottom');
        
        if i~=n
            obj.AxesAdjustPanels(i)=uipanel(obj.MainPanel,'units','pixels','BorderType','etchedout',...
                'ButtonDownFcn',@(src,evt) AxesAdjustPanelClick(obj,src),...
                'Position',[0,position(2)+Height,MainPos(3),obj.AxesAdjustWidth]);
            obj.AxesResizeMode(i)=false;
        end
    end
else
    
    position=[0 0 1 1];
    
    n=str2double(obj.DataView(4));
    
    if ~isempty(obj.DispChans)
        position(3)=position(3)-ElevWide;
        m=max(0.00001,Nchan(n)-obj.DispChans(n));
        obj.Sliders=uicontrol(obj.MainPanel,'style','slider','units','normalized','position',[1-ElevWide 0 ElevWide 1],...
            'min',0,'max',m,'SliderStep',[1 obj.DispChans(n)]/max(1,m),'Callback',@(src,evt) ChangeSliders(obj,src));
    end
    obj.Axes=axes('parent',obj.MainPanel,'XLim',[1 floor(obj.WinLength*obj.SRate)],'XTick',1:obj.SRate:floor(obj.WinLength*obj.SRate),...
        'TickLength',[.005 0],'position',position,'color',backgroundColor,'YAxisLocation','right','Layer','bottom');
end

if ~isempty(obj.DispChans) && strcmp(obj.MouseMode,'Pan')
    set(obj.PanObj,'Enable','on')
else
    set(obj.PanObj,'Enable','off')
end

end

function AxesAdjustPanelClick(obj,src)
% for i=1:length(obj.AxesAdjustPanels)
%     if src==obj.AxesAdjustPanels(i)
%         obj.AxesResizeMode(i)=true;
%     end
% end
end

