function [header,fid,fname] = xltekreadeegheader(fname,ext)
[fparts{1:3}] = fileparts(fname);
if nargin < 2
    ext = fparts{3};
end
if ext(1) ~= '.'
    ext = ['.' ext];
end
switch ext(2:end)
    case {'ent' 'ent.old'}
        GUID = [147 7 11 202 149 215 208 17 175 50 0 160 36 91 84 165];
    case 'eeg'
        GUID = [144 7 11 202 149 215 208 17 175 50 0 160 36 91 84 165];
    case 'snc'
        GUID = [210 169 134 96 175 96 211 17 152 96 0 16 75 117 193 81];
    case 'stc'
        GUID = [120 18 183 233 75 168 89 77 191 135 16 114 143 184 189 157];
    case 'erd'
        GUID = [145 7   11  202 149 215 208 17  175 50  0   160 36  91  84  165];
    case 'etc'
        GUID = [146 7   11  202 149 215 208 17  175 50  0   160 36  91  84  165];
    case {'vtc' 'vt2'}
        GUID = [161 172 227 91  48  162 192 74  170 148 73  101 15  44  246 160];
    otherwise 
        error(['matlab:' mfilename],'%s extension is not supported',ext);
end
if isempty(fparts{3})
    fname = fullfile(fparts{1},[fparts{2} ext]);
else
    if ~strcmpi(fname(end-length(ext)+1:end),ext)
        error('Extension mismatch with the filename!');
    end
end
[fid,msg] = fopen(fname,'rb');
if ~isempty(msg)
    % Support the file from directory
    [fparts{1:3}] = fileparts(fname);
    fname = fullfile(fparts{1:2},[fparts{2} ext]);
    [fid,msg] = fopen(fname,'rb');
    if ~isempty(msg)
        error(['matlab:' mfilename],'%s:%s',fname,msg);
    end
end

%% Try to read file
try
    %% Read Header
    header.GUID = fread(fid,[1 16],'uint8=>uint8');
    if any(GUID ~= header.GUID)
        error(['matlab:' mfilename],'Wrong GUID');
    end
    header.FileSchema = fread(fid,1,'uint16');
    header.BaseSchema = fread(fid,1,'uint16');
    if ~any(strcmpi(ext,{'.vtc','.vt2'}))
        % In vtc file, time is written with respect to GMT so we need to convert it
        % to US/Central get correct time
        % 719529 = datenum([1970 1 1])
        header.CreationTime = [datestr(fread(fid,1,'uint32=>double')/86400.0 + 719529) ' GMT']; 
        fseek(fid,8,'cof');
        header.LastName     = fread(fid,[1 80],'char');
        header.LastName     = strtrim(char(header.LastName(1:find(header.LastName==0,1)-1)));
        header.MiddleName   = fread(fid,[1 80],'char');
        header.MiddleName   = strtrim(char(header.MiddleName(1:find(header.MiddleName ==0,1)-1)));
        header.FirstName    = fread(fid,[1 80],'char');
        header.FirstName    = strtrim(char(header.FirstName(1:find(header.FirstName ==0,1)-1)));
        header.ID = fread(fid,[1 80],'char');
        header.ID = strtrim(char(header.ID(1:find(header.ID ==0,1)-1)));
    end
catch errmsg
    fclose(fid);
    rethrow(errmsg);
end
if nargout < 2
    fclose(fid);
end