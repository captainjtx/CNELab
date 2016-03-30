function tm = converttime(tm,infmt,outfmt)
% tm = converttime(tm,infmt,outfmt)
% formats
% 'm'. Matlab Format (datenum or datestring). To output a date string just
% enter matlab date format string such as 'yyy/mm/dd'
% MS Office format (timezone independent)
% 'o' string
% 'od' double
% Filetime
% 'f' string
% 'fd' double
% 'fi64', int64
% We will check if the input is char, so the string identifier in informats
% can be ignored, however for outformat you need to specify correct option.
% No timezone convertion, you need to convert to your timezone.
% MS office times are with respect to their local system time
% Filetime values are with respect to UTC for XLTEK files.

if nargin < 3
    if nargin < 2
        infmt = 'm';
    end
    outfmt = 'm';
end
switch lower(infmt)
    case {'o','od'}
        if ischar(tm)
            tm = str2double(tm);
        end
        tm = tm + datenum([1899 12 30]);
    case {'f','fd'}
        if ischar(tm)
            tm = hex2dec(reshape(fliplr(reshape(tm(11:end),2,[])),1,[]));
        end
        tm  = tm/864e9 + datenum([1601 1 1]);
    otherwise
        tm = datenum(tm);
end

switch lower(outfmt)
    case 'od'
        tm   = tm - datenum([1899 12 30]);
    case 'o'
        tm   = tm - datenum([1899 12 30]);
        nlen = floor(log10(tm)+2);
        fmt  = sprintf('%%%d.%df',21,21-nlen);
        tm   = sprintf(fmt,tm);
    case 'fd'
        tm  = (tm-datenum([1601 1 1]))*864e9;
    case 'f'
        % 0x000000088ab2a01d4796cb01
        tm  = (tm-datenum([1601 1 1]))*864e9;
        tm  = [dec2hex(floor(tm/16^8),8) dec2hex(rem(tm,16^8),8)];
        tm  = ['0x00000008' reshape(fliplr(reshape(tm,2,[])),1,[])];
    otherwise
        if strcmpi(outfmt,'ms')
            tm = datestr(tm);
        elseif ~strcmpi(outfmt,'m')
            tm = datestr(tm,outfmt);
        end
end
