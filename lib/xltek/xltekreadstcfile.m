function [stc,header,stchead] = xltekreadstcfile(fname)
% [stc,filehead,stchead] = xltekreadstcfile(fname)
% Read STC file

%
% General XLTEK File Header
% STC File Header
% STC Structs
[header,fid] = xltekreadeegheader(fname,'stc');
try 
    %% Read STC haeder
    %stchead
    stchead = cell2struct(num2cell(fread(fid,2,'int32')),{'nextsegment','final'});
    fseek(fid,48,'cof'); 
    %% Read entries
    if ~feof(fid)
        fpos = ftell(fid);
        % Read string data
        stc  = cellstr(reshape(fread(fid,inf,'256*char=>char',16),256,[])')';
        fseek(fid,fpos+256,'bof');
        % Read Integer data
        stc  = [stc; num2cell(reshape(fread(fid,inf,'4*int32',256),4,[]))];
        % make it struct
        stc = cell2struct(stc,{'segmentname','startstamp','endstamp','samplenum','samplespan'});
    end
    fclose(fid);
catch msg
    fclose(fid);
    rethrow(msg);
end