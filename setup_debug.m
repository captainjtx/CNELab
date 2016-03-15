function setup_debug()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% set up environment variable for the system
clear java;

while 1
    olddir=which('cnelab');
    
    olddir=fileparts(olddir);
    if isempty(olddir)
        break
    end
    p=path;
    p=[p,':'];
    [starti,endi]=regexpi(p,[olddir,'.*?:']);
    
    if isempty(starti)
        break
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

%save java class path into dynamic file
f=fullfile(prefdir,'javaclasspath.txt');

if exist(f,'file')==2
    delete(f);
end

javaaddpath([pwd '/src/java']);
javaaddpath([pwd '/test']);

!javac src/java/LabelListBoxRenderer.java src/java/globalVar.java
% !javac src/java/globalVar.java

% !jar -cf cnel.jar src/java/LabelListBoxRenderer src/java/globalVar.java

savepath;

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

