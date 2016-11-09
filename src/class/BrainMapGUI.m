classdef BrainMapGUI<handle
    properties
        Fig
        AnnotationPanel
        
        EditAnnotation
        ListAnnotation
        
        MenuFile
        MenuFileOpen
        
        ModelDir
        ModelName
        
        AnnotationFileID
        
        Annotations_
    end
    properties(Dependent)
        AnnotationDir
        ModelNameWithoutExtension
        
        Annotations
    end
    
    methods
        function obj=BrainMapGUI()
            obj.buildfig();
        end
        function buildfig(obj)
            screensize=get(0,'ScreenSize');
            obj.Fig=figure('MenuBar','none','ToolBar','none','DockControls','off','NumberTitle','off','RendererMode','manual',...
                'CloseRequestFcn',@(src,evts) OnClose(obj),'WindowScrollWheelFcn',@(src,evts) ScrollWheel(obj,src,evts),...
                'WindowButtonMotionFcn',@(src,evt) MouseMovement(obj),'WindowButtonDownFcn',@(src,evt) MouseDown(obj),...
                'WindowButtonUpFcn',@(src,evt) MouseUp(obj),'ResizeFcn',@(src,evt) Resize(obj),...
                'WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),'WindowKeyReleaseFcn',@(src,evt) KeyRelease(obj,src,evt),'Units','Pixels','Visible','on',...
                'position',[screensize(3)/2-200,screensize(4)/2-150,400,300],'Name','BrainMap Simulink Control');
            
            obj.AnnotationPanel=uipanel(obj.Fig,'units','normalized','BorderType','none','position',[0.5,0,0.5,1]);
            
            uicontrol(obj.AnnotationPanel,'String','Annotation','Style','text','units','normalized','position',[0.05,0.9,0.9,0.08])
            obj.EditAnnotation=uicontrol(obj.AnnotationPanel,'String','','Style','edit',...
                'units','normalized','position',[0.05 0.8 0.9 0.1],...
                'HorizontalAlignment','center','FontUnits','normalized','FontSize',0.4,'callback',@(src,evt)insertAnnotation(obj));
            
            obj.ListAnnotation=uicontrol(obj.AnnotationPanel,'String','','Style','listbox',...
                'units','normalized','position',[0.05,0.01,0.9,0.75],...
                'callback',@(src,evt)listAnnotationCallback(obj));
            
            obj.ModelDir=pwd;
            obj.MakeMenu();
        end
        
        function insertAnnotation(obj)
            modelTime = get_param(obj.ModelNameWithoutExtension,'SimulationTime');
            if isempty(modelTime)
                return
            end
            
            anno=get(obj.EditAnnotation,'string');
            obj.Annotations=cat(1,obj.Annotations,{modelTime,anno});
            
            %directly write into text file
            try
                fprintf(obj.AnnotationFileID,'%f,%s\n',modelTime,anno);
            catch
                disp('Creating new annotation file');
                obj.AnnotationFileID=fopen(fullfile(obj.AnnotationDir,[obj.ModelNameWithoutExtension,'.txt']),'at');
                fprintf(obj.AnnotationFileID,'%f,%s\n',modelTime,anno);
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
                obj.AnnotationFileID=fopen(fullfile(obj.AnnotationDir,[obj.ModelNameWithoutExtension,'.txt']),'wt');
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
                delete(obj.Fig)
            catch
            end
            
            try
                fclose(obj.AnnotationFileID);
            catch
            end
            
            try
                save_system(fullfile(obj.ModelDir,obj.ModelName));
                close_system(fullfile(obj.ModelDir,obj.ModelName));
            catch
                display('GUI FORCE CLOSED!!!')
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