function [SyncStampTime,header] = xltekreadsncfile(fname)
% [SyncStampTime,header] = xltekreadsncfile(fname)
% Read Synchronization (snc) file 
% Note: For using time values returned by this function use the equation
% date = datevec(SyncStampTime.time/1e7/86400+datenum('01/01/1601'))
% Time information is in UTC, so you should convert it to desired time
% zone and Daylight Saving Time (e.g using timezoneconvert)
% See also XLTEKREADDATA XLTEKANNOTATIONWRITE XLTEKANNOTATIONREAD TIMEZONECONVERT


% General XLTEK File Header
[header,fid] = xltekreadeegheader(fname,'snc');
try 
    % Read entries
    if ~feof(fid)
        fDataPosition = ftell(fid);
        % Read stamp data
        SyncStampTime  = num2cell(fread(fid,inf,'int32=>double',8));
        fseek(fid,fDataPosition+4,'bof');
        % Read Integer data
        SyncStampTime  = [SyncStampTime num2cell(fread(fid,inf,'int64',4))];
        % make it struct
        SyncStampTime = cell2struct(SyncStampTime',{'stamp','filetime'});
    end
    fclose(fid);
catch msg
    fclose(fid);
    rethrow(msg);
end