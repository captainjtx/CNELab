function [time sncfst] = stamp2time(stamp,sncstruct,eegstruct,timefmt)
% [TIME SNCFST] = STAMP2TIME(STAMP,SNCSTRUCT,EEGSTRUCT,TIMEFMT)
% time formats
% 'm'. Matlab Format (datenum or datestring). To output a date string just
% enter matlab date format string such as 'yyy/mm/dd'
% MS Office format (timezone independent)
% 'o' string
% 'od' double
% Filetime
% 'f' string
% 'fd' double
% 'fi64', int64
% I calculated the difference between CreationTime and  XLCreationTime
% fields of eegstruct. This difference helps me to determine the difference
% between file timezone and UTC.

if ~exist('timefmt','var')
    timefmt = 'ms';
end
SampleRate = str2double(eegstruct.Study.Headbox.HB0.SamplingFreq);
tzdiff     = converttime(eegstruct.Study.CreationTime,'o','m') - converttime(eegstruct.Study.XLCreationTime,'f','m');
if isempty(sncstruct)
    time  = converttime(eegstruct.Study.XLCreationTime,'f','m') + stamp/SampleRate/86400; % Go to the current position
    sncfst = 0;
else
    sncstamp   = [sncstruct.stamp];
    if isscalar(stamp)
        [~,idx] = min(abs(sncstamp-stamp));
    else
        sztm  = find(size(stamp)==1,1);
        if isempty(sztm)
            sncstamp = permute(sncstamp(:),[(1:ndims(stamp))+1 1]);
            sztm = ndims(stamp)+1;
        else
            perm = 1:ndims(stamp);
            perm(sztm) = 2;
            perm(2) = sztm;
            sncstamp = permute(sncstamp,perm);
        end
        [~,idx] = min(abs(bsxfun(@minus,sncstamp,stamp)),[],sztm);
    end
    
    % [notUsed,idx] = min(abs(sncstamp - stamp)); %#ok<ASGLU>
    % SNC structs have filetime which are with respect to UTC, we need to
    % convert them to xltek local file, if you wish you can also convert them
    % to your local time, tzdiff is the timezone difference with the system
    % that records this xltek file with UTC
    sncfst = datenum([1601 1 1]) + reshape([sncstruct(idx).filetime],size(idx))/1e7/86400; % Go to the start of the stc segment
    time  = sncfst + (stamp - reshape(sncstamp(idx),size(idx)))/SampleRate/86400; % Go to the current position
    sncfst = idx;
end
switch timefmt
    case 'od'
        time   = time - datenum([1899 12 30]) + tzdiff;
    case 'o'
        time = time - datenum([1899 12 30]) + tzdiff;
        nlen = floor(log10(time)+2);
        fmt  = sprintf('%%%d.%df',21,21-nlen);
        time = sprintf(fmt,time);
    case 'fd'
        time = (time-datenum([1601 1 1]))*864e9;
    case 'f'
        % 0x000000088ab2a01d4796cb01
        time  = (time-datenum([1601 1 1]))*864e9;
        time  = [dec2hex(floor(time/16^8),8) dec2hex(rem(time,16^8),8)];
        time  = ['0x00000008' reshape(fliplr(reshape(time,2,[])),1,[])];
    otherwise
        if ~strcmpi(timefmt,'m')
            if strcmpi(timefmt,'ms')
                time = datestr(time + tzdiff);
            else
                time = datestr(time + tzdiff,timefmt);
            end
        else
            time = time + tzdiff;
        end
end
if ~isscalar(stamp)
    time = reshape(cellstr(time),size(stamp));
end
