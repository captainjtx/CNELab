function setup()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% set up environment variable for the system
olddir=which('cnelab','-all');
for f=1:length(olddir)
    path=fileparts(olddir{f});
    if isempty(path)
        continue
    end
    
    p=[path,':'];
    [starti,endi]=regexpi(p,[path,'.*?:']);
    
    if isempty(starti)
        continue
    end
    
    for i=1:length(starti)
        rmpath(p(starti(i):endi(i)-1));
    end
end

addpath(pwd,'-frozen');
addpath(genpath([pwd '/src']),'-frozen');
addpath(genpath([pwd '/db']),'-frozen');
addpath(genpath([pwd '/lib']),'-frozen');
addpath(genpath([pwd '/script']),'-frozen');
addpath(genpath([pwd '/test']),'-frozen');
addpath(genpath([pwd '/demo']),'-frozen');

%recompile the java class to local platform, usually do not need
% !javac src/java/LabelListBoxRenderer.java src/java/globalVar.java
%save java class path into static file
pref_dir=prefdir;
fid = fopen(fullfile(pref_dir,'javaclasspath.txt'),'a');
fprintf(fid,'%s\n',[pwd '/src/java']);
fprintf(fid,'%s\n',[pwd '/test']);
fclose(fid);

try
    savepath;
catch
    warndlg('Can not save Matlab Path !');
end

disp('CNELab setup completed !');
% a=opengl('data');
% 
% if a.Software
%     opengl software;
%     opengl('save','software');
% else
%     opengl hardware;
%     opengl('save','hardware');
% end

end

