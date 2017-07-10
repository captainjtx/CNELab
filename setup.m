function setup()

clear functions

java_version=version('-java');

if ~strcmp(java_version(6:8),'1.7')
    error('Matlab Java version mismatch !');
end

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

xippmex=which('xippmex');

addpath(pwd,'-frozen');
addpath(genpath([pwd filesep 'src']),'-frozen');
addpath(genpath([pwd filesep 'db']),'-frozen');
addpath(genpath([pwd filesep 'lib']),'-frozen');
addpath(genpath([pwd filesep 'script']),'-frozen');
addpath(genpath([pwd filesep 'test']),'-frozen');
addpath(genpath([pwd filesep 'demo']),'-frozen');

if ~isempty(xippmex)
    disp('... xippmex skipped as already being installed ...');
    rmpath([pwd filesep 'lib' filesep 'xippmex']);
end

%%
if ispc
    try
        mex([pwd filesep 'src' filesep 'mex' filesep 'WinMultiThreadedFilter.cpp']);
        movefile('WinMultiThreadedFilter.*',[pwd filesep 'src' filesep 'mex']);
    catch
        disp('Cannot recompile WinMultiThreadedFilter.cpp, will try to use precompiled one ...');
    end
elseif ismac||isunix
    try
        mex([pwd filesep 'src' filesep 'mex' filesep 'UnixMultiThreadedFilter.cpp']);
        movefile('UnixMultiThreadedFilter.*',[pwd filesep 'src' filesep 'mex']);
    catch
        disp('Cannot recompile UnixMultiThreadedFilter.cpp, will try to use precompiled one ...');
    end
else
    %not sure what kind of computer fall into this category
    %no parallel filtering supported here, but still faster than matlab
    %filter function
    try
        mex([pwd filesep 'src' filesep 'mex' filesep 'FastFilter.cpp']);
        movefile('FastFilter.*',[pwd filesep 'src' filesep 'mex']);
    catch
        disp('Cannot recompile FastFilter.cpp');
    end
end
%%
    

spath = javaclasspath('-static');
pref_dir=prefdir;
if ~any(strcmp(spath,pwd))
    javaaddpath(pwd);
    fid = fopen(fullfile(pref_dir,'javaclasspath.txt'),'a');
    fprintf(fid,'%s\n',pwd);
    fclose(fid);
    warndlg('Add java class path, restart Matlab to ensure function !');
end

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

