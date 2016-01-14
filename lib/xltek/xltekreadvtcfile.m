function [vtc,header] = xltekreadvtcfile(fname,ext)
% [vtc,filehead,stchead] = xltekreadstcfile(fname)
% Read VTC file

%
% General XLTEK File Header
% STC File Header
% STC Structs
if ~exist('ext','var')
    [fparts{1:3}] = fileparts(fname);
    if isempty(fparts{3})
        ext = 'vtc';
    else
        ext = fparts{3}(2:end);
    end
end
[header,fid] = xltekreadeegheader(fname,ext);
try
    %% Read entries
    if ~feof(fid)
        fpos = ftell(fid)+257;
        % Read string data
        vtc  = cellstr(reshape(fread(fid,inf,'257*char=>char',36),257,[])')';
        if isempty(vtc{1})
            vtc = struct('FileName',{},'View',{},'GUID',{},'StartTime',{},'EndTime',{});
        else
            fseek(fid,fpos,'bof');
            fpos = fpos+4;
            % Read Integer data
            vtc  = [vtc; num2cell(reshape(fread(fid,inf,'int32',289),1,[]))];
            % Read GUID
            fseek(fid,fpos,'bof');
            fpos = fpos+16;
            vtc  = [vtc; num2cell(reshape(fread(fid,inf,'16*uint8=>uint8',277),16,[])',2)'];
            % Read FileTime
            fseek(fid,fpos,'bof');
            vtc  = [vtc;num2cell(reshape(fread(fid,inf,'2*int64',277),2,[]))];
            % make it struct
            vtc = cell2struct(vtc,{'FileName','View','GUID','StartTime','EndTime'});
        end
    end
    fclose(fid);
catch msg
    fclose(fid);
    rethrow(msg);
end