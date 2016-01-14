function [data,info] = mccreaddata(fname)
% [data,info] = readmcc(fname)
% Read MCC txt files

[fparts{1:3}]= fileparts(fname);
if ~strcmpi(fparts{3},'.txt')
    error(['matlab:' mfilename],'only txt files supported');
end
[fid,msg] = fopen(fname);
if ~isempty(msg)
    error(['matlab:' mfilename],'Error opening %s : %s',fname,msg);
end
try
    hsize = fscanf(fid,'%*[^:]: %f',1);
    info =  textscan(fid,'%[^:]: %f',hsize-2);
    info = [info{1} num2cell(info{2})];
    labs = fscanf(fid,'%*[^\n]\n%[^\n]\n',1);
    data = textscan(fid,['%*[^,],%*[^,]' repmat(',%f',1,sum(labs == ',')-2) '%*[^\n]\n']);
    data = [data{:}];
catch err
    fprinf('Error %s\n',err.message);
end
fclose(fid);
