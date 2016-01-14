function fid = xltekwriteeegheader(fname,ext,varargin)
ext = ext(max(1,end-6):end);
if ext(1) == '.'
    ext(1) = [];
end
switch ext
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
    case 'vtc'
        GUID = [161 172 227 91  48  162 192 74  170 148 73  101 15  44  246 160];
    otherwise
        error(['matlab:' mfilename],'%s extension is not supported',ext);
end
[fparts{1:3}] = fileparts(fname);
if isempty(fparts{1})
    fparts{1} = cd;
else
    [~,fattr] = fileattrib(fparts{1});
    fparts{1} = fattr.Name;
end
if isempty(fparts{3})
    fname = fullfile(fparts{1},[fparts{2},'.' ext]);
else
    fname = fullfile(fparts{1},[fparts{2} fparts{3}]);
end
if nargin == 3
    header = varargin{1};
elseif isstruct(varargin{1}) && nargin  == 4
    if varargin{2} && exist(fname,'file')
        % Save a backup
        backupname = [fparts{2} datestr(now,'_yyyy_mm_dd_HH_MM_SS.') ext];
        [bSuccess,msg] = copyfile(fname,fullfile(fparts{1},backupname),'f');
        if ~bSuccess
            error(['matlab:' mfilename],'%s',msg);
        end
    end
    header = varargin{1};
else
    header = { ...
        'GUID',GUID
        'FileSchema',1
        'BaseSchema',1
        'CreationTime',(timezoneconvert(now,'GMT','local')-719529)*86400
        'LastName',''
        'MiddleName',''
        'FirstName',''
        'ID',''}';
    header = xltekprocessinput(header,varargin);
end
[fid,msg] = fopen(fname,'r+b');
if ~isempty(msg)
    [fid,msg] = fopen(fname,'w+b');
    if ~isempty(msg)
        error(['matlab:' mfilename],'%s',msg);
    end
end
% Try to write file
try
    fwrite(fid,header.GUID,'uint8');
    fwrite(fid,header.FileSchema,'uint16');
    fwrite(fid,header.BaseSchema,'uint16');
    if ~any(strcmpi(ext,{'vtc','vt2'}))
        fwrite(fid,uint32([(datenum(header.CreationTime)-719529)*86400.0 0 0]),'uint32'); % Skip 8 bytes
        fwrite(fid,header.LastName,'char');
        fwrite(fid,char(zeros(1,80-length(header.LastName))),'char');
        fwrite(fid,header.MiddleName,'char');
        fwrite(fid,char(zeros(1,80-length(header.MiddleName))),'char');
        fwrite(fid,header.FirstName,'char');
        fwrite(fid,char(zeros(1,80-length(header.FirstName))),'char');
        fwrite(fid,header.ID,'char');
        fwrite(fid,char(zeros(1,80-length(header.ID))),'char');
    end
catch errmsg
    fclose(fid);
    rethrow(errmsg);
end
if nargout == 0
    fclose(fid);
end

