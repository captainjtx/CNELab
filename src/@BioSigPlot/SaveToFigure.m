%==================================================================
%******************************************************************
function SaveToFigure(obj,opt)

if strcmpi(opt,'data')

%     [FileName,FilePath,FilterIndex]=uiputfile({...
%         '*.png','PNG Image(*.png)';
%         '*.jpg','JPEG Image(*.jpg)';
%         '*.eps','EPS Image(*.eps)'}...
%         ,'save your data image',fullfile(obj.FileDir,'untitled'));
%     if FileName~=0
%         switch FilterIndex
%             case 1
%                 format='png';
%             case 2
%                 format='jpg';
%             case 3
%                 format='eps';
%         end
                
        f=figure('Name','Copy','Position',get(obj.MainPanel,'Position'),'visible','on');
%         p=uipanel('parent',f,'units','normalized','position',[0,0,1,1]);
        copyobj(obj.Axes,f);
        
%         wait_bar_h = waitbar(1,'Saving Picture...');
%         export_fig(f,'-nocrop','-r300','-opengl',['-',format],fullfile(FilePath,FileName));
%         
%         delete(wait_bar_h)
%         delete(f);
%     end
    
elseif strcmpi(opt,'mirror')
end
end