classdef CnelabWindow < handle
    properties
        valid
        fig
        
        open_btn
        file_listbox
    end
    methods
        
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isvalid(obj.fig);
            catch
                val=0;
            end
        end
        
        function obj=CnelabWindow()
            
        end
        
        function buildfig(obj)
            
            if obj.valid
                figure(obj.fig);
                return
            end
            
            
            obj.fig=figure('MenuBar','none','Name','Welcome','units','pixels',...
                'Position',[200 200 750 450],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','off','DockControls','off','Alphamap',0.5,'color','white');
            
            logo=uipanel(obj.fig,'units','normalized','position',[0,0.4,0.6,0.6],'BorderType','none','backgroundcolor','white');
            
            logo_a=axes('parent',logo,'units','normalized','position',[0,0,1,1],'xlim',[0,1],'ylim',[0,1],'Color','w','visible','off');
            [img,~,alpha] = imread('cnel.png');
            image('XData',[0.35,0.65],'YData',[0.4,0.8],'CData',flipud(img),'AlphaData',flipud(alpha),'AlphaDataMapping','none');
            
            text('parent',logo_a,'position',[0.5,0.3],'string','Welcome to CNELab',...
                'FontSize',35,'HorizontalAlignment','center','Color',[0.3,0.3,0.3]);
            text('parent',logo_a,'position',[0.5,0.15],'string','Version 2.0',...
                'Fontsize',20,'HorizontalAlignment','center','Color',[0.5,0.5,0.5]);
            
            file_p=uipanel(obj.fig,'units','normalized','position',[0.6,0,0.4,1],'BorderType','none');
            obj.file_listbox=uicontrol(file_p,'units','normalized','position',[0,0,1,1],'style','listbox','fontsize',20,...
                'String',{'tmp1','tmp2'},'value',2);
            
            obj.open_btn = com.mathworks.mwswing.MJButton('Open another data ...');
            obj.open_btn.setBorder([]);
            
            obj.open_btn.setBackground(java.awt.Color(0.94, 0.94, 0.94));
            obj.open_btn.setForeground(java.awt.Color(0.2, 0.2, 0.2));
            obj.open_btn.setFlyOverAppearance(true);
%             obj.open_btn.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
            set(obj.open_btn, 'MouseEnteredCallback', @(h,e)mouse_enter(obj))
            set(obj.open_btn, 'MouseExitedCallback',  @(h,e)mouse_exit(obj))
            set(obj.open_btn, 'MousePressedCallback', @(h,e)mouse_press(obj))
            [dummy,btContainer] = javacomponent(obj.open_btn,[0 0 1 1],file_p); %#ok

            set(btContainer, 'Units','Norm', 'Position',[0.1,0.01,0.5,0.05]);
            
            opt=uipanel(obj.fig,'units','normalized','position',[0.1,0,0.5,0.4],'BorderType','none','backgroundcolor','white'); 
            demo=uipanel(opt,'units','normalized','position',[-0.01,0.72,1.02,0.28],'BorderType','line','backgroundcolor','white',...
                'highlightcolor',[0.8,0.8,0.8],'borderwidth',2,'ButtonDownFcn',@(src,evt) Demo(obj)); 
             
            new_cds=uipanel(opt,'units','normalized','position',[-0.01,0.44,1.02,0.28],'BorderType','none','backgroundcolor','white',...
                'highlightcolor',[0.8,0.8,0.8],'borderwidth',2,'ButtonDownFcn',@(src,evt) NewCDS(obj));
            
            tmp=uipanel(opt,'units','normalized','position',[-0.01,0.16,1.02,0.28],'BorderType','line','backgroundcolor','white',...
                'highlightcolor',[0.8,0.8,0.8],'borderwidth',2,'ButtonDownFcn',@(src,evt) Reserved(obj));
            
        end
        
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
        end
        
        function OpenCallback(obj)
        end
        
        function mouse_enter(obj)
            obj.open_btn.setBackground(java.awt.Color(0.8,0.8,0.8));
            obj.open_btn.setForeground(java.awt.Color(1,1,1));
        end
        
        function mouse_exit(obj)
            obj.open_btn.setBackground(java.awt.Color(0.94,0.94,0.94));
            obj.open_btn.setForeground(java.awt.Color(0.2,0.2,0.2));
        end
        function mouse_press(obj)
        end
    end
    
end