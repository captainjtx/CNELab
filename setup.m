function setup()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% set up environment variable for the system
while 1
    olddir=which('cnelab');
    
    olddir=fileparts(olddir);
    if isempty(olddir)
        break
    end
    p=path;
    p=[p,pathsep];
    [starti,endi]=regexpi(p,[olddir,'.*?',pathsep]);
    
    if isempty(starti)
        break
    end
    
    for i=1:length(starti)
        rmpath(p(starti(i):endi(i)-1));
    end
end

addpath(pwd,'-frozen');
addpath(genpath([pwd filesep 'src']),'-frozen');
addpath(genpath([pwd filesep 'db']),'-frozen');
addpath(genpath([pwd filesep 'lib']),'-frozen');
addpath(genpath([pwd filesep 'script']),'-frozen');
addpath(genpath([pwd filesep 'test']),'-frozen');
addpath(genpath([pwd filesep 'demo']),'-frozen');

%recompile the java class to local platform, usually do not need
% !javac src/java/LabelListBoxRenderer.java src/java/globalVar.java
%save java class path into static file
spath = javaclasspath('-static');
if ~any(strcmp(spath,[pwd filesep 'src' filesep 'java']))
    javaaddpath([pwd filesep 'src' filesep 'java']);
end

pref_dir=prefdir;
fid = fopen(fullfile(pref_dir,'javaclasspath.txt'),'w');
fprintf(fid,'%s\n',[pwd filesep 'src' filesep 'java']);
fprintf(fid,'%s\n',[pwd filesep 'test']);
fclose(fid);

try
    savepath;
catch
    warndlg('Can not save to Matlab Path !');
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

