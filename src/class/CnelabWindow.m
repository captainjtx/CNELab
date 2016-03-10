classdef CnelabWindow < handle
    properties
        valid
        fig
        
        open_btn
        file_listbox
        
        cfg
        
        choice
        
        selectedFiles
        
        cfg_name
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
            obj.cfg_name=[char(globalVar.CNELAB_PATH),'/db/cfg/cnelab.cfg'];
            
            if exist(obj.cfg_name,'file')==2
                obj.cfg=load(obj.cfg_name,'-mat');
            else
                cfg.files={};
                cfg.skip=0;
                obj.cfg=cfg;
            end
            obj.choice=-1;
        end
        
        function buildfig(obj)
            obj.choice=0;
            
            if obj.valid
                figure(obj.fig);
                return
            end
            screensize=get(0,'ScreenSize');
            obj.fig=figure('MenuBar','none','Name','Welcome','units','pixels',...
                'Position',[screensize(3)/2-375 screensize(4)/2-225 750 450],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','off','DockControls','off','Alphamap',0.5,'color','w');
            set(obj.fig,'WindowKeyPressFcn',@(h,e)key_press(obj,h,e));
            
            logo=uipanel(obj.fig,'units','normalized','position',[0,0.4,0.6,0.6],'BorderType','none','backgroundcolor','white');
            
            logo_a=axes('parent',logo,'units','normalized','position',[0,0,1,1],'xlim',[0,1],'ylim',[0,1],'Color','w','visible','off');
            [img,~,alpha] = imread('cnel.png');
            image('XData',[0.35,0.65],'YData',[0.4,0.8],'CData',flipud(img),'AlphaData',flipud(alpha),'AlphaDataMapping','none');
            
            text('parent',logo_a,'position',[0.5,0.3],'string','Welcome to CNELab',...
                'FontSize',35,'HorizontalAlignment','center','Color',[0.3,0.3,0.3]);
            text('parent',logo_a,'position',[0.5,0.15],'string','Version 2.0',...
                'Fontsize',20,'HorizontalAlignment','center','Color',[0.5,0.5,0.5]);
            
            file_p=uipanel(obj.fig,'units','normalized','position',[0.6,0,0.4,1],'BorderType','none','backgroundcolor',[0.95,0.95,0.95]);
            %             obj.file_listbox=uicontrol(file_p,'units','normalized','position',[0,0,1,1],'style','listbox','fontsize',20,...
            %                 'String',{'tmp1','tmp2'},'value',2);
            
            if isempty(obj.cfg.files)
                obj.file_listbox=javaObjectEDT(javax.swing.JList());
            else
                list_str=cell(1,length(obj.cfg.files));
                for i=1:length(list_str)
                    list_str{i}=obj.cfg.files{i}{1};
                    [pathstr,~,~]=fileparts(obj.cfg.files{i}{1});
                    for j=2:length(obj.cfg.files{i})
                        [path_tmp,name_tmp,ext_tmp]=fileparts(obj.cfg.files{i}{j});
                        if strcmp(path_tmp,pathstr)
                            %all cds files must in the same directory
                            list_str{i}=[list_str{i},' &#43; ',name_tmp,ext_tmp];
                        else
                            %if two files not in the same directory, delete
                            %it
                            obj.cfg.files{i}(j)=[];
                        end
                    end
                end
                obj.file_listbox=javaObjectEDT(javax.swing.JList(list_str));
                obj.file_listbox.setSelectedIndex(0);
            end
            file_type=ones(1,length(obj.cfg.files));
            
            for i=1:length(obj.cfg.files)
                for j=1:length(obj.cfg.files{i})
                    [~,~,ext]=fileparts(obj.cfg.files{i}{j});
                    if ~strcmp(ext,'.cds')
                        file_type(i)=-1;
                    end
                end
            end
            
            obj.file_listbox.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_INTERVAL_SELECTION);
            obj.file_listbox.setLayoutOrientation(javax.swing.JList.VERTICAL);
            obj.file_listbox.setVisibleRowCount(10);
            obj.file_listbox.setSelectionBackground(java.awt.Color(0.2,0.6,1));
            obj.file_listbox.setSelectionForeground(java.awt.Color(1,1,1));
            obj.file_listbox.setFixedCellHeight(45);
            obj.file_listbox.setBackground(java.awt.Color(0.95,0.95,0.95));
            obj.file_listbox.setBorder([]);
            jRenderer = LabelListBoxRenderer();
            jRenderer.setFileType(file_type);
            obj.file_listbox.setCellRenderer(jRenderer);
            set(handle(obj.file_listbox,'CallbackProperties'),'MousePressedCallback',@(h,e)mouse_press_list(obj));
            [jh,gh]=javacomponent(obj.file_listbox,[0,0.11,1,0.89],file_p);
            set(gh,'Units','normalized','position',[0,0.11,1,0.89]);
            
            obj.open_btn = javaObjectEDT(com.mathworks.mwswing.MJButton('Open another data ...'));
            obj.open_btn.setBorder([]);
            
            obj.open_btn.setBackground(java.awt.Color(0.95, 0.95, 0.95));
            obj.open_btn.setForeground(java.awt.Color(0.2, 0.2, 0.2));
            obj.open_btn.setFlyOverAppearance(true);
            %             obj.open_btn.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
            set(handle(obj.open_btn,'CallbackProperties'), 'MouseEnteredCallback', @(h,e)mouse_enter(obj))
            set(handle(obj.open_btn,'CallbackProperties'), 'MouseExitedCallback',  @(h,e)mouse_exit(obj))
            set(handle(obj.open_btn,'CallbackProperties'), 'MousePressedCallback', @(h,e)mouse_press_btn(obj))
            [dummy,btContainer] = javacomponent(obj.open_btn,[0 0 1 1],file_p); %#ok
            set(btContainer, 'Units','Norm', 'Position',[0.03,0.01,0.5,0.05]);
            
            opt=uipanel(obj.fig,'units','normalized','position',[0.1,0,0.5,0.4],'BorderType','none','backgroundcolor','white');
            
            demo_icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/demo.png']));
            demo_label = javaObjectEDT(javax.swing.JLabel());
            demo_label.setIcon(demo_icon);
            demo_label.setText('<html><font size=4.5 color=black><b>Start from demo</b></font> <br> <font size=3.5 color=gray> Quickly learn the features</font></html>');
            demo_label.setIconTextGap(10);
            demo_label.setOpaque(true);
            
            demo=javaObjectEDT(javax.swing.JButton());
            demo.setBorder([]);
            demo.setBackground(java.awt.Color(1,1,1));
            demo.add(demo_label);
            set(handle(demo,'CallbackProperties'),'MousePressedCallback',@(h,e) Demo(obj));
            [jh,gh]=javacomponent(demo,[0,0.72,1,0.28],opt);
            set(gh,'Units','Norm','Position',[0,0.72,1,0.28]);
            
            new_cds_icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/new_cds.png']));
            new_cds_label = javaObjectEDT(javax.swing.JLabel());
            new_cds_label.setIcon(new_cds_icon);
            new_cds_label.setText('<html><font size=4.5 color=black><b>Create new CDS files</b></font> <br> <font size=3.5 color=gray> By converting from other data formats</font></html>');
            new_cds_label.setBorder(javax.swing.border.EmptyBorder(0,3,0,0));
            new_cds_label.setIconTextGap(14);
            new_cds_label.setOpaque(true);
            
            new_cds=javaObjectEDT(javax.swing.JButton());
            new_cds.setBorder([]);
            new_cds.setBackground(java.awt.Color(1,1,1));
            new_cds.add(new_cds_label);
            set(handle(new_cds,'CallbackProperties'),'MousePressedCallback',@(h,e) NewCDS(obj));
            [jh,gh]=javacomponent(new_cds,[0,0.44,1,0.28],opt);
            set(gh,'Units','Norm','Position',[0,0.44,1,0.28]);
            
            tmp=javaObjectEDT(javax.swing.JButton());
            tmp.setBorder([]);
            tmp.setBackground(java.awt.Color(1,1,1));
            set(handle(tmp,'CallbackProperties'),'MousePressedCallback',@(h,e) Reserved(obj));
            [jh,gh]=javacomponent(tmp,[0,0.16,1,0.28],opt);
            set(gh,'Units','Norm','Position',[0,0.16,1,0.28]);
        end
        
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
        end
        
        function mouse_enter(obj)
            obj.open_btn.setBackground(java.awt.Color(0.8,0.8,0.8));
            obj.open_btn.setForeground(java.awt.Color(1,1,1));
        end
        
        function mouse_exit(obj)
            obj.open_btn.setBackground(java.awt.Color(0.94,0.94,0.94));
            obj.open_btn.setForeground(java.awt.Color(0.2,0.2,0.2));
        end
        function mouse_press_btn(obj)
            obj.choice=1;
            OnClose(obj);
            notify(obj,'UserChoice')
        end
        function mouse_press_list(obj)
            ind = obj.file_listbox.getSelectedIndex();
            
            if ind==-1
                return
            else
                obj.selectedFiles=obj.cfg.files{ind+1};
            end
            obj.choice=2;
            OnClose(obj);
            notify(obj,'UserChoice');
        end
        
        function key_press(obj,src,evt)
            ind=obj.file_listbox.getSelectedIndex();
            if ind==-1
                return
            end
            if strcmpi(evt.Key,'uparrow')
                ind=ind-1;
                obj.file_listbox.setSelectedIndex(mod(ind,length(obj.cfg.files)));
            elseif strcmpi(evt.Key,'downarrow')
                ind=ind+1;
                obj.file_listbox.setSelectedIndex(mod(ind,length(obj.cfg.files)));
            elseif strcmpi(evt.Key,'return')
                mouse_press_list(obj);
            end
        end
                
        function NewCDS(obj)
        end
        function Demo(obj)
        end
        
        function Reserved(obj)
        end
        
        function saveConfig(obj)
            newcfg=obj.cfg;
            save(obj.cfg_name,'-struct','newcfg','-mat');
        end
    end
    
    events
        UserChoice
    end
end
