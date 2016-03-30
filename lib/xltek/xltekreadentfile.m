function [annotations,header] = xltekreadentfile(fname,bDQ,bList)
% [ANNOTATIONS,HEADER] = XLTEKREADENTFILE(FNAME,BDQ,BLIST)
% Read annotation (ent) file 
% bDQ 1 => Do not remove double quotes from strings 
% Note: For using time values returned by this function add 
% datenum([1899 12 30]) to returned time
% i.e  datestr(datenum([1899 12 30])+timevalue)
% Time information is locale independent, you can get the same results if
% your system time zone changes
% See also XLTEKREADDATA XLTEKWRITEANNOTATION

% Ibrahim ONARAN
% 3/16/2011

%% Get the filename
[header,fid] = xltekreadeegheader(fname,'ent');
%% Try to read file
try
    if ~exist('bDQ','var') || isempty(bDQ)
        bDQ = false;
    end
    if ~exist('bList','var')
        bList = false;
    end
    fchunkpos = ftell(fid);
    
    % Check file and count the number of chunks
    nChunks = 0;
    while true
        chunkhead = fread(fid,[1 4],'int32');
        if isempty(chunkhead) 
            error(['matlab:' mfilename],'Unexpected file termination!')
        elseif chunkhead(2) == 16
            break;
        end
        fseek(fid,chunkhead(2)-16,'cof');
        nChunks = nChunks+1;
    end
    
    % Read the chunks
    fseek(fid,fchunkpos,'bof');
    annotations = cell(nChunks,1);
    for iChunk  = 1:nChunks
        chunkhead   = fread(fid,[1 4],'int32');
        annotations{iChunk} = readkeylist(fread(fid,[1 chunkhead(2)-16],'*char'),bDQ);
    end
    annotations = key2struct(annotations,bList);
    fclose(fid);
catch err
    fclose(fid);
    rethrow(err)
end

