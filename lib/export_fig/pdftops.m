function varargout = pdftops(cmd)
%PDFTOPS  Calls a local pdftops executable with the input command
%
% Example:
%   [status result] = pdftops(cmd)
%
% Attempts to locate a pdftops executable, finally asking the user to
% specify the directory pdftops was installed into. The resulting path is
% stored for future reference.
% 
% Once found, the executable is called with the input command string.
%
% This function requires that you have pdftops (from the Xpdf package)
% installed on your system. You can download this from:
% http://www.foolabs.com/xpdf
%
% IN:
%   cmd - Command string to be passed into pdftops.
%
% OUT:
%   status - 0 iff command ran without problem.
%   result - Output from pdftops.

% Copyright: Oliver Woodford, 2009-2010

% Thanks to Jonas Dorn for the fix for the title of the uigetdir window on
% Mac OS.
% Thanks to Christoph Hertel for pointing out a bug in check_xpdf_path
% under linux.

% Call pdftops
[path,cmd] = xpdf_path(cmd);
[varargout{1:nargout}] = system(sprintf('"%s" %s', path, cmd));
return

function [path,cmdo] = xpdf_path(cmd)
% Return a valid path
% Start with the currently set path
comp = computer;
if strcmpi(comp,'PCWIN64')
    path = user_string('pdftopsw64');
else
    path = user_string('pdftopsw32');
end
% Check the path works
[good,cmdo] = check_xpdf_path(path,cmd);
if good
    return
end
% Check whether the binary is on the path
if ispc
    bin = 'pdftops.exe';
else
    bin = 'pdftops';
end
[good,cmdo] = check_store_xpdf_path(bin,cmd);
if good
    path = bin;
    return
end

comp = computer;
% Search the obvious places
if ispc
    if strcmpi(comp,'PCWIN64')
        bin = 'C:\xpdf\bin64\pdftops.exe';
    else
        bin = 'C:\xpdf\bin32\pdftops.exe';
    end
else
    path = '/usr/local/bin/pdftops';
end
[good,cmdo] = check_store_xpdf_path(bin,cmd);
if good
    path = bin;
    return
end

if ispc
    bin = 'pdf2ps.exe';
end
[good,cmdo] = check_store_xpdf_path(bin,cmd);
if good
    path = bin;
    return
end

% Ask the user to enter the path
while 1
    if strncmp(computer,'MAC',3) % Is a Mac
        % Give separate warning as the uigetdir dialogue box doesn't have a
        % title
        uiwait(warndlg('Pdftops not found. Please locate the program, or install xpdf-tools from http://users.phg-online.de/tk/MOSXS/.'))
    end
    base = uigetdir('/', 'Pdftops not found. Please locate the program.');
    if isequal(base, 0)
        % User hit cancel or closed window
        break;
    end
    basedir = [base filesep];
    if strcmpi(comp,'PCWIN64')
        bin_dir = {'', ['bin' filesep], ['lib' filesep], ['bin64' filesep]};
    else
        bin_dir = {'', ['bin' filesep], ['lib' filesep], ['bin32' filesep]};
    end
    for a = 1:numel(bin_dir)
        path = [basedir bin_dir{a} bin];
        if exist(path, 'file') == 2
            break;
        end
    end
    [good,cmdo] = check_store_xpdf_path(bin,cmd);
    if good
        return
    end
end
error('pdftops executable not found.');

function [good,cmd] = check_store_xpdf_path(path,cmd)
% Check the path is valid
[good,cmd] = check_xpdf_path(path,cmd);
if ~good
    return
end
% Update the current default path to the path found
if strcmpi(computer,'PCWIN64')
    fname = 'pdftopsw64';
else
    fname = 'pdftopsw32';
end
if ~user_string(fname, path)
    warning('matlab:exportfig:pdftops','Path to pdftops executable could not be saved. Enter it manually in pdftops.txt.');
    return
end
return

function [good,cmd] = check_xpdf_path(path,cmd)
% Check the path is valid
[~,message] = system(sprintf('"%s" -h', path));
% System returns good = 1 even when the command runs
% Look for something distinct in the help text
good = ~isempty(strfind(message, 'PostScript')) || ~isempty(strfind(message, 'pdf2ps'));
cmd  = cmd{ismember(cmd(:,1),{'pdftops','pdf2ps'}),2};
return