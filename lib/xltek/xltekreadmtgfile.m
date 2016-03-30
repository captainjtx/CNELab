function montage = xltekreadmtgfile(fname,bDQ,bList)
% [annotations,header] = XLTEKREADMTGFILE(fname)
% Read annotation (eeg) file 

[fparts{1:3}] = fileparts(fname);
if isempty(fparts{3})
    fname = [fparts{1} filesep fparts{2},'.mtg'];
end
[fid,msg] = fopen(fname,'rb');
if ~isempty(msg)
    error(['matlab:' mfilename],msg);
end
try
    % First row in 010 editor:
    % 0000h: FF FF 01 00 08 00 43 4B 65 79 54 72 65 65  ÿÿ....CKeyTree
    if ~exist('bDQ','var') || isempty(bDQ)
        bDQ = false;
    end
    montage = [255 255 1 0 8 0 67 75 101 121 84 114 101 101];
    strLen  = fread(fid,[1 length(montage)],'uint8');
    if ~all(strLen == montage)
        error(['matlab:' mfilename],'Wrong file format');
    end
    strLen = fread(fid,1,'uint8');
    if( strLen == hex2dec('FF'))
        strLen = fread(fid,1,'uint16');
        if (strLen == hex2dec('FFFE'))
            error(['matlab:' mfilename],'Does Not support unicode strings');
        elseif (strLen == hex2dec('FFFF'))
            strLen = fread(fid,1,'uint32');
            if (strLen == hex2dec('FFFFFFFF'))
                error(['matlab:' mfilename],'Does Not support big strings');
            end
        end
    end
    montage   = readkeylist(fread(fid,[1 strLen],'*char'),bDQ);
    montage   = key2struct(montage,bList);
catch err
    fclose(fid);
    rethrow(err)
end
fclose(fid);