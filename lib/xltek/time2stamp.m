function [stamp sncfst] = time2stamp(time,SampleRate,sncstruct,eegstruct,timefmt)
% [time sncfst] = time2stamp(stamp,SampleRate,sncstruct,timefmt)
% time formats
% 'm'. Matlab Format (datenum or datestring). 
% MS Office format (timezone independent).
% 'o' string
% Filetime
% 'f' string "UTC Time"
% I calculated the difference between CreationTime and  XLCreationTime 
% fields of eegstruct. This difference helps me to determine the difference 
% between file timezone and UTC.

if ~exist('timefmt','var')
    timefmt = 'm';
end
% Convert time to matlab format
switch timefmt
    case 'o'
        if ischar(time)
            time  = str2double(time);
        end
        time  = time + datenum([1899 12 30]);
    case 'f'
        if ischar(time)
            % 0x000000088ab2a01d4796cb01
            time = hex2dec(reshape(fliplr(reshape(time(11:end),2,[])),1,[]));
        end
        [notUsed,sncfst]  = min(abs([sncstruct.filetime] - time)); %#ok<ASGLU>
        stamp  = floor(sncstruct(sncfst).stamp + SampleRate*(time - sncstruct(sncfst).filetime)/1e7);
        return;
    otherwise 
        time   = datenum(time);
end
tzdiff = converttime(eegstruct.Study.CreationTime,'o','m') - converttime(eegstruct.Study.XLCreationTime,'f','m');
sncstamp = [sncstruct.stamp];
sncfst   = tzdiff + datenum('1-1-1601') + [sncstruct.filetime]/1e7/86400;

if isscalar(time)
    [notUsed,idx] = min(abs(sncfst-time)); %#ok<ASGLU>
else
    sztm  = find(size(time)==1,1);
    if isempty(sztm)
        sncfst = permute(sncfst(:),[(1:ndims(time))+1 1]);
        sztm = ndims(time)+1;
    else
        perm = 1:ndims(time);
        perm(sztm) = 2;
        perm(2) = sztm;
        sncfst = permute(sncfst,perm);
    end
    [notUsed,idx] = min(abs(bsxfun(@minus,sncfst,time)),[],sztm); %#ok<ASGLU>
end

stamp = floor(reshape(sncstamp(idx),size(idx)) + (time - reshape(sncfst(idx),size(idx)))*86400*SampleRate);
sncfst = idx;
