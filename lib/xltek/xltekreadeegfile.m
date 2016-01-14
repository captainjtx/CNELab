function [eeginfo,header,fname] = xltekreadeegfile(fname,bDQ,bList)
% [annotations,header] = XLTEKREADEEGFILE(fname,bDQ)
% Read annotation (eeg) file with filename fname
% bDQ: Includes double quotes '"' around string variables (optional)
% See also XLTEKREADENTFILE XLTEKREADERDFILE XLTEKREADMTGFILE XLTEKREADSNCFILE XLTEKREADSTCFILE

[header,fid,fname] = xltekreadeegheader(fname,'eeg');
try
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
	if nargin < 3
		if nargin < 2
			bDQ = false;
		end
		bList = false;
	end
	eeginfo   = readkeylist(fread(fid,[1 strLen],'*char'),bDQ);
	eeginfo   = key2struct(eeginfo,bList);
catch err
    fclose(fid);
    rethrow(err)
end
fclose(fid);