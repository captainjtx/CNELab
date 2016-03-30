function  errmsg = xltekclearentfile(fname)
% BSUCCESS = XLTEKCLEARENTFILE(FNAME)
% FNAME     : Ent file name or path
% TIMESTAMP : Time stamp for the note
% NOTE      : User Note
% COMMENT   : User comment
% USER      : User Name
% ORIGIN    : Review or Acquisition
% timestamp can be numeric vector, in vector case, the preceeding variables
% should be either cell array of the same size or char string
% See also XLTEKREADDATA XLTEKREADENTFILE
%%
try
    [fparts{1:3}] = fileparts(fname);
    if isempty(fparts{3})
        fname = fullfile(fparts{1},[fparts{2},'.ent']);
    end
    if ~exist(fname,'file')
        errmsg = sprintf('File %s does not exist',fname);
        return;
    end
    %%
    % Always save backup annotation
    backupname = [datestr(now,'yyyy_mm_dd_HH_MM_SS_BackupAnnotation') '.ent'];
    copyfile(fname,fullfile(fparts{1},backupname),'f');
    if ~exist(fullfile(fparts{1},backupname),'file')
        error(['Matlab::' mfilename],'Could not back up file');
    end
    [fr,errmsg] = fopen(fullfile(fparts{1},backupname),'rb');
    if ~isempty(errmsg), return;end
    [fw,errmsg] = fopen(fname,'wb');
    if ~isempty(errmsg), fclose(fr); return;end
    %% Read header
    header = fread(fr,[1 352],'uint8');
    if length(header)<352 || any([147 7 11 202 149 215 208 17 175 50 0 160 36 91 84 165] ~= header(1:16))
        fclose(fr);
        fclose(fw);
        copyfile(fullfile(fparts{1},backupname),fname,'f');
        errmsg = 'Wrong GUID';
        return;
    end
    fwrite(fw,uint8(header),'uint8');
    fseek(fr,352,'bof');
    fseek(fw,352,'bof');
    % Ok Find first insertion point
    preSize = 0;
    while ~feof(fr)
        chead = fread(fr,[1 4],'int32');
        if isempty(chead)
            fclose(fr);
            fclose(fw);
            copyfile(fullfile(fparts{1},backupname),fname,'f');
            return;
        end
        if chead(2) == 16 % We reach end of file 
            chead(3) = preSize;
            fwrite(fw,int32(chead),'int32');
            break;
        else
            pnote = fread(fr,[1 chead(2)-18],'*char');
            fseek(fr,2,'cof'); % Skip last 2 bytes, they are zero
        end
        pstamp = regexp(pnote,'\(\."Deleted", ([^\)]*)\)','tokens');
        if isempty(pstamp) 
            chead(3) = preSize;
            preSize = chead(2);
            fwrite(fw,int32(chead),'int32');
            fwrite(fw,[pnote 0 0],'char');
        end
    end
    fclose(fr);
    fclose(fw);
    if nargout == 0 
        clear errmsg;
    end
catch errmsg
    if exist('fr','var') && ~isempty(fopen(fr))
        fclose(fr);
    end
    if exist('fw','var') && ~isempty(fopen(fw))
        fclose(fw);
        copyfile(fullfile(fparts{1},txtname),fname,'f');
    end
    rethrow(errmsg);
end