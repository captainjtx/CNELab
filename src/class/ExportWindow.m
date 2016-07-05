classdef ExportWindow < AppWindow
    
    properties
        
        dest_dir_edit
        dest_dir_btn
        dest_dir
        filename
        
    end
    methods
        
        function DirCallback(obj,src)
            switch src
                case obj.dest_dir_edit
                    folder_name=get(src,'string');
                    if isdir(folder_name)
                        obj.dest_dir_=folder_name;
                    end
                case obj.dest_dir_btn
                    start_path=obj.dest_dir;
                    folder_name = uigetdir(start_path,'Select a directory');
                    if folder_name
                        obj.dest_dir=folder_name;
                    end
            end
        end
    end
end


