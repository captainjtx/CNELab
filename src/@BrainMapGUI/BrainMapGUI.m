classdef BrainMapGUI<handle
    properties
        Fig
        
        EditFileName
        EditAnnotation
        ListAnnotation
        
        Toolbar
        JToolbar
        RadioSaveFile
        
        MenuFile
        MenuFileOpen
        
        ModelDir
        ModelName
        
        AnnotationFileID
        
        Annotations_
        
        IconPlay
        IconStop
        IconResetMap
        IconScreenshot
        
        JTogPlay
        JBtnResetMap
        JBtnScreenshot
        
        anno_count
        
        save_data_time
        
        udp_behv
        port
        host
    end
    properties(Dependent)
        AnnotationDir
        ModelNameWithoutExtension
        
        Annotations
    end
    
    methods
        function obj=BrainMapGUI()
            obj.buildfig();
            obj.anno_count = 0;
            obj.save_data_time = 0;
            obj.host = '127.0.0.1';
            obj.port = 27100;
            obj.udp_behv=pnet('udpsocket',obj.port);
        end
        function buildfig(obj)
            screensize=get(0,'ScreenSize');
            obj.Fig=figure('MenuBar','none','ToolBar','none','DockControls','off','NumberTitle','off','RendererMode','manual',...
                'CloseRequestFcn',@(src,evts) OnClose(obj),'WindowScrollWheelFcn',@(src,evts) ScrollWheel(obj,src,evts),...
                'WindowButtonMotionFcn',@(src,evt) MouseMovement(obj),'WindowButtonDownFcn',@(src,evt) MouseDown(obj),...
                'WindowButtonUpFcn',@(src,evt) MouseUp(obj),'ResizeFcn',@(src,evt) Resize(obj),...
                'WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),'WindowKeyReleaseFcn',@(src,evt) KeyRelease(obj,src,evt),'Units','Pixels','Visible','on',...
                'position',[10,screensize(4)-390,350,200],'Name','BrainMap Simulink Control');
            
            file_panel=uipanel(obj.Fig,'units','normalized','BorderType','none','position',[0,0,0.5,1]);
            
            uicontrol(file_panel,'String','Mat-file & video name','Style','text','units','normalized','position',[0.05,0.9,0.9,0.08])
            obj.EditFileName=uicontrol(file_panel,'String','','Style','edit',...
                'units','normalized','position',[0.05 0.75 0.9 0.15],...
                'HorizontalAlignment','center','FontUnits','normalized','FontSize',0.4,'callback',@(src,evt)changeFileName(obj));
           
            obj.RadioSaveFile=uicontrol(file_panel,'style','radiobutton','units','normalized','position',[0,0.6,1,0.15],'string','Save Data & Video','value',0,...
                'Callback',@(src,evt)saveFileCallback(obj,src));

            annotation_panel=uipanel(obj.Fig,'units','normalized','BorderType','none','position',[0.5,0,0.5,1]);
            
            uicontrol(annotation_panel,'String','Annotation','Style','text','units','normalized','position',[0.05,0.9,0.9,0.08])
            obj.EditAnnotation=uicontrol(annotation_panel,'String','','Style','edit',...
                'units','normalized','position',[0.05 0.75 0.9 0.15],...
                'HorizontalAlignment','center','FontUnits','normalized','FontSize',0.4,'callback',@(src,evt)insertAnnotation(obj));
            
            obj.ListAnnotation=uicontrol(annotation_panel,'String','','Style','listbox',...
                'units','normalized','position',[0.05,0.01,0.9,0.72],...
                'callback',@(src,evt)listAnnotationCallback(obj));
            
            obj.ModelDir=pwd;
            obj.MakeMenu();
            obj.MakeToolbar();
        end
        
        function MakeToolbar(obj)
            import src.java.PushButton;
            import src.java.TogButton;
            import src.java.ToolbarSpinner;
            import javax.swing.ButtonGroup;
            import javax.swing.SpinnerNumberModel;
            import javax.swing.JComponent;
            import javax.swing.JLabel;
            obj.Toolbar=uitoolbar(obj.Fig);
            drawnow
            obj.JToolbar=get(get(obj.Toolbar,'JavaContainer'),'ComponentPeer');
            d=obj.JToolbar.getPreferredSize();
            btn_d=java.awt.Dimension();
            btn_d.width=d.height;
            btn_d.height=d.height;
            
            spinner_d=java.awt.Dimension();
            spinner_d.width=d.height*2.5;
            spinner_d.height=d.height;
            col=obj.JToolbar.getBackground();
            
            [path,~,~] = fileparts(mfilename('fullpath'));
            obj.IconPlay=javaObjectEDT(javax.swing.ImageIcon([path,'/../../db/icon/play.png']));
            obj.IconStop=javaObjectEDT(javax.swing.ImageIcon([path,'/../../db/icon/stop.png']));
            obj.IconResetMap=javaObjectEDT(javax.swing.ImageIcon([path,'/../../db/icon/refresh.png']));
            obj.IconScreenshot=javaObjectEDT(javax.swing.ImageIcon([path,'/../../db/icon/screenshot.png']));
            
            obj.JTogPlay=javaObjectEDT(PushButton([path,'/../../db/icon/play.png'],btn_d,char('Play'),col));
            set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StartPlay(obj));
            obj.JToolbar.add(obj.JTogPlay);
            
            obj.JToolbar.addSeparator();
            
            obj.JBtnResetMap=javaObjectEDT(PushButton([path,'/../../db/icon/refresh.png'],btn_d,char('Reset Map'),col));
            set(handle(obj.JBtnResetMap,'CallbackProperties'),'MousePressedCallback',@(h,e) ResetMap(obj));
            obj.JToolbar.add(obj.JBtnResetMap);
            
            obj.JToolbar.addSeparator();
            
            obj.JBtnScreenshot=javaObjectEDT(PushButton([path,'/../../db/icon/screenshot.png'],btn_d,char('Take Screenshot'),col));
            set(handle(obj.JBtnScreenshot,'CallbackProperties'),'MousePressedCallback',@(h,e) TakeScreenshot(obj));
            obj.JToolbar.add(obj.JBtnScreenshot);
            
            obj.JToolbar.repaint;
            obj.JToolbar.revalidate;
        end
        
        function StartPlay(obj)
            try
                status = get_param(obj.ModelNameWithoutExtension,'SimulationStatus');
                set_param(strcat(obj.ModelNameWithoutExtension,'/FileSave'),'Value',num2str(get(obj.RadioSaveFile,'value')));
            catch
                return
            end
            if strcmp(status,'stopped')
                set_param(obj.ModelNameWithoutExtension,'SimulationCommand','Start');
                obj.JTogPlay.setIcon(obj.IconStop);
                set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StopPlay(obj));
                
                try
                    open_system(strcat(obj.ModelNameWithoutExtension,'/BipolarScope1'),'window');
                    open_system(strcat(obj.ModelNameWithoutExtension,'/BipolarScope2'),'window');
                    open_system(strcat(obj.ModelNameWithoutExtension,'/BehvScope'),'window');
                catch
                    try
                        open_system(strcat(obj.ModelNameWithoutExtension,'/BipolarScope'),'window');
                        open_system(strcat(obj.ModelNameWithoutExtension,'/BehvScope'),'window');
                    catch
                    end
                end
                figure(obj.Fig);
                
                if get(obj.RadioSaveFile, 'value') == 1
                    obj.AutoSetVideoFileName();
                    obj.StartCaptureVideo();
                end
            end
        end
        function StopPlay(obj)
            status = get_param(obj.ModelNameWithoutExtension,'SimulationStatus');
            if strcmp(status,'running')
                obj.StopCaptureVideo();
                set_param(obj.ModelNameWithoutExtension,'SimulationCommand','Stop');
            end
            set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StartPlay(obj));
            obj.JTogPlay.setIcon(obj.IconPlay);
        end
        
        function writeAnnotationToFile(obj, anno)
            try
                fprintf(obj.AnnotationFileID,'%s\n',anno);
            catch
                disp('Creating new annotation file');
                obj.anno_count = obj.anno_count+1;
                obj.AnnotationFileID=fopen(fullfile(obj.AnnotationDir,[obj.ModelNameWithoutExtension,'-',num2str(obj.anno_count),'.txt']),'at');
                fprintf(obj.AnnotationFileID,'%s\n',anno);
            end
        end
        
        function StartCaptureVideo(obj)
            pnet(obj.udp_behv, 'write', 'Video: Start Capture', 'native');
            pnet(obj.udp_behv, 'writepacket', obj.host, obj.port);
        end
        
        function StopCaptureVideo(obj)
            pnet(obj.udp_behv, 'write', 'Video: Stop Capture', 'native');
            pnet(obj.udp_behv, 'writepacket', obj.host, obj.port);
        end
        
        function SetVideoCaptureFileName(obj, filename)
            pnet(obj.udp_behv, 'write', sprintf('Video: FileName=%s', filename), 'native');
            pnet(obj.udp_behv, 'writepacket', obj.host, obj.port);
        end
        
        function AutoSetVideoFileName(obj)
            formatOut = 'dd_mm_yyyy_HH_MM_SS';
            filename=sprintf('%s\\%s_%s.avi', obj.ModelDir, get(obj.EditFileName, 'string'), datestr(now,formatOut));
            obj.SetVideoCaptureFileName(filename);
        end
        function saveFileCallback(obj,src)
            s=get(src,'value');
            try
                set_param(strcat(obj.ModelNameWithoutExtension,'/FileSave'),'Value',num2str(s));
                status = get_param(obj.ModelNameWithoutExtension,'SimulationStatus');
                if strcmp(status,'running')
                    modelTime = get_param(obj.ModelNameWithoutExtension,'SimulationTime');
                    obj.save_data_time = modelTime;
                    if s == 0
                        obj.StopCaptureVideo();
                        anno = ['%Stop saving data at ' num2str(modelTime) ' (absolute time)'];
                    elseif s == 1
                        obj.AutoSetVideoFileName();
                        obj.StartCaptureVideo();
                        anno = ['%Start saving data at ' num2str(modelTime) ' (absolute time)'];
                    end
                    %directly write into text file
                    writeAnnotationToFile(obj, anno);
                end
            catch
                
            end
        end
        
        function ResetMap(obj)
            try
                val = get_param(strcat(obj.ModelNameWithoutExtension,'/MapReset'), 'Value');
                if val == '1'
                    newval = '0';
                elseif val == '0'
                    newval = '1';
                end
                set_param(strcat(obj.ModelNameWithoutExtension,'/MapReset'),'Value',newval);
            catch
                return
            end
        end
        
        function TakeScreenshot(obj)
            pnet(obj.udp_behv, 'write', sprintf('Screenshot: FileName=%s', [obj.ModelDir, '/']), 'native');
            pnet(obj.udp_behv, 'writepacket', obj.host, obj.port);
        end
        function insertAnnotation(obj)
            modelTime = get_param(obj.ModelNameWithoutExtension,'SimulationTime');
            modelTime = modelTime-obj.save_data_time;
            anno=get(obj.EditAnnotation,'string');
            if isempty(modelTime)||isempty(anno)
                return
            end
            
            anno=get(obj.EditAnnotation,'string');
            anno = strrep(anno,',',' ');
            
            obj.Annotations=cat(1,obj.Annotations,{modelTime,anno});
            
            %directly write into text file
            anno_str = sprintf('%f,%s', modelTime, anno);
            writeAnnotationToFile(obj, anno_str)
            
        end
        
        function changeFileName(obj)
            try
                set_param(strcat(obj.ModelNameWithoutExtension,'/FileSink'), 'FileName', get(obj.EditFileName, 'str'));
            catch
            end
        end
        function listAnnotationCallback(obj)
        end
        function MakeMenu(obj)
            %**************************************************************************
            %First Order Menu------------------------------------------------------File
            obj.MenuFile=uimenu(obj.Fig,'Label','File');
            obj.MenuFileOpen=uimenu(obj.MenuFile,'Label','Open','Accelerator','o','Callback',@(src,evt)OpenFile(obj));
            
        end
        
        function OpenFile(obj)
            if isempty(obj.ModelDir)
                open_dir=pwd;
            else
                open_dir=obj.ModelDir;
            end
            
            [FileName,FilePath,~]=uigetfile({'*.mdl;*.slx','Simulink Model Files (*.mdl;*.slx)'},...
                'select simulink model file',...
                open_dir);
            if FileName~=0
                obj.ModelName=FileName;
                obj.ModelDir=FilePath;
                %open simulink model
                load_system(fullfile(FilePath,FileName));
                open_system(fullfile(FilePath,FileName));
                
                if exist(obj.AnnotationDir,'dir')~=7
                    mkdir(obj.ModelDir,'events');
                end
                obj.AnnotationFileID=fopen(fullfile(obj.AnnotationDir,[obj.ModelNameWithoutExtension,'-',num2str(obj.anno_count),'.txt']),'at');
                
                set(obj.EditFileName, 'string', get_param(strcat(obj.ModelNameWithoutExtension,'/FileSink'), 'FileName'));
            end
            figure(obj.Fig);
        end
        
        function SetVideoCaptureFileUI(obj)
            defaultVideoName=sprintf('%s\\%s.avi', obj.ModelDir, get(obj.EditFileName, 'string'));
            [FileName,FilePath,~]=uiputfile({'*.avi','CNELBehv Video Files (*.avi)';...
                '*.avi','AVI format (*.avi)'}...
                ,'save your Video',defaultVideoName);
            if FileName~=0
                filename=fullfile(FilePath,FileName);
                obj.SetVideoCaptureFileName(filename);
            end
        end
        function val=get.AnnotationDir(obj)
            val=[obj.ModelDir,'/events'];
        end
        
        function val=get.ModelNameWithoutExtension(obj)
            if ~isempty(obj.ModelName)
                if ~isempty(regexp(obj.ModelName,'.mdl','once'))||~isempty(regexp(obj.ModelName,'.slx','once'))
                    val=obj.ModelName(1:end-4);
                end
            else
                val=[];
            end
        end
        
        function val=get.Annotations(obj)
            val=obj.Annotations_;
        end
        function set.Annotations(obj,val)
            obj.Annotations_=val;
            s=cell(size(val,1));
            for i=1:size(val,1)
                s{i}=sprintf('%8.2f - %s    ',val{i,1},val{i,2});
            end
            
            set(obj.ListAnnotation,'value',size(val,1));
            set(obj.ListAnnotation,'string',s);
        end
        %%
        %for future ...
        function OnClose(obj)
            try
                obj.StopPlay();
            catch
            end
            
            try
                save_system(fullfile(obj.ModelDir,obj.ModelName));
                disp('Model Saved ... ')
            catch
                disp('Model Save Failed !')
            end
            
            try
                close_system(fullfile(obj.ModelDir,obj.ModelName), 0);
            catch
            end
            
            try
                pnet(obj.udp_behv, 'close');
            catch
            end
            
            try
                fclose(obj.AnnotationFileID);
            catch
            end
            
            try
                delete(obj.Fig)
            catch
            end
        end
        function ScrollWheel(obj,src,evts)
        end
        function MouseDown(obj)
        end
        function MouseUp(obj)
        end
        function MouseMovement(obj)
        end
        function Resize(obj)
        end
        function KeyPress(obj,src,evt)
        end
        function KeyRelease(obj,src,evt)
        end
        %%
    end
end
