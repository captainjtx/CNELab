function  xltekwriteentfile(fname,header,annotations,bBackItUp)
% [annotations,header] = XLTEKWRITEENTFILE(fname,index)
% Read annotation (ent) file 
% Note: For using time values returned by this function add 
% datenum([1899 12 30]) to returned time
% i.e  datestr(datenum([1899 12 30])+timevalue)
% Time information is locale independent, you can get the same results if
% your system time zone changes
% See also XLTEKREADDATA XLTEKREADENTFILE

% Ibrahim ONARAN
% 3/16/2011

%% Get the filename

fid = xltekwriteeegheader(fname,'ent',header,bBackItUp);
%% Try to read file
try
    pcLen = [uint32([1 0 0 1])];
    for iAnno = 1:length(annotations)
        str      = struct2keystr(annotations{iAnno});
        pcLen(2) = length(str)+18;
        fwrite(fid,pcLen,'uint32');
        fwrite(fid,str);
        fwrite(fid,[0 0],'char');
        pcLen(3) = pcLen(2);
    end
    pcLen([1 4]) = 0;
    pcLen(2) = 16;
    fwrite(fid,pcLen,'uint32');
catch err
    fclose(fid);
    rethrow(err)
end
fclose(fid);
