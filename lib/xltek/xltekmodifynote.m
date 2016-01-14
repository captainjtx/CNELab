function  errmsg = xltekmodifynote(fname,varargin)
% ERRMSG = XLTEKMODIFYNOTE(FNAME,SRELOPERATOR,SFINDPATH,SFINDOPERATOR,SFINDEXPRESSION,SREPLACEPATH,SREPLACEOPERATOR,SREPLACEEXPRESSION,SREPLACE)
% ERRMSG = XLTEKMODIFYNOTE(FNAME,SREPLACEPATH,SREPLACEOPERATOR,SREPLACEEXPRESSION,SREPLACE)
% FNAME     : Ent file name or path, put ? at the beginning of filename not
% to modify the original file, modified file saved in backup file instead of
% original file.
% SRELOPERATOR = cell or string or empty: 'or','|','and','&', default: 'or'
% SFINDOPERATOR,SREPLACEOPERATOR = string. Possible values:
%                '>','<','<=','<=','==','~=',('' means do not care),'i'
%                means value has the indecies that we want to remove, 'r':
%                regular expressions
% SFINDOPERATOR can also be cell array
% SFINDPATH: The searching path i.e. Data.Deleted 
% SFINDEXPRESSION: The searching expression, can be numeric or string or
%                  cell array for lists
% SREPLACEPATH: The data path that we want to replace
% SREPLACEEXPRESSION: Replacing expression, can be numeric or reg exp string
% SREPLACE: New value or text
%
% Examples: 
% 1. Changing montage labels in three steps
% % Change ChanNames
% xltekmodifynote('?Test','','Text','r','"Montage:LFP in DBS Study - Phase II, Ref.*"','Data.ChanNames','r',{'"EDC upp"','"FDC low"'},{'"EDC"','"FDC"'})
% % Change Channels
% xltekmodifynote('?Test','','Text','r','"Montage:LFP in DBS Study - Phase II, Ref.*"','Data.Channels.Channel.To_Name','r',{'"EDC upp"','"FDC low"'},{'"EDC"','"FDC"'})
% % Change HalfMontageChannels
% xltekmodifynote('?Test','','Text','r','"Montage:LFP in DBS Study - Phase II, Ref.*"','Data.HalfMontageChannels.Name','r',{'"EDC upp"','"FDC low"'},{'"EDC"','"FDC"'})
% 
% 2. Remove deleted annotations
% xltekmodifynote('?E:\Test','','Data.Deleted','r','1','','d',[],[])
% 
% 3. Undelete deleted notes
% xltekmodifynote('?E:\Test','','Data.Deleted','r','1','Data.Deleted','d',[],[])
% See also XLTEKREADDATA XLTEKREADENTFILE
%%
bModifyFile = (fname(1) ~= '?');
if ~bModifyFile
    fname = fname(2:end);
end
[fparts{1:3}] = fileparts(fname);
if isempty(fparts{3})
    fname = fullfile(fparts{1},[fparts{2},'.ent']);
end
if ~exist(fname,'file')
    errmsg = sprintf('File %s does not exist',fname);
    return;
end
%%
if nargin == 9
    [sreloperator,sfindpath,sfindoperator,sfindexpression,sreplacepath,sreplaceoperator,sreplaceexpression,sreplace] = deal(varargin{:});
elseif nargin == 5
    [sreplacepath,sreplaceoperator,sreplaceexpression,sreplace] = deal(varargin{:});
else
    error('Wrong number of inputs');
end
% bFindAndReplace = nargin < 6;

% Always save backup annotation
if bModifyFile
    %%
    backupname = fullfile(fparts{1},[datestr(now,'yyyy_mm_dd_HH_MM_SS_BackupAnnotation') '.ent']);
    if ~movefile(fname,backupname,'f')
        return;end
    [fidsrc,errmsg] = fopen(backupname,'rb');
    if ~isempty(errmsg),
        movefile(backupname,fname,'f')
        return;
    end
    [fid,errmsg] = fopen(fname,'wb');
    if ~isempty(errmsg)
        fclose(fidsrc);
        movefile(backupname,fname,'f')
        return;
    end
else
    backupname = fullfile(fparts{1},[datestr(now,'yyyy_mm_dd_HH_MM_SS_FFF_') mfilename '.ent']);
    [fidsrc,errmsg] = fopen(fname,'rb');
    if ~isempty(errmsg),
        return;
    end
    [fid,errmsg] = fopen(backupname,'wb');
    if ~isempty(errmsg)
        fclose(fidsrc);
        return;
    end
end
try
    header.GUID = fread(fidsrc,[1 16],'uint8');
    if any([147 7 11 202 149 215 208 17 175 50 0 160 36 91 84 165] ~= header.GUID)
        fclose(fid);
        fclose(fidsrc);
        movefile(backupname,fname,'f')
        return;
    end
    fseek(fidsrc,0,'bof');
    fseek(fid,0,'bof');
    pnote = fread(fidsrc,[1 352],'*char');
    fwrite(fid,pnote,'*char');
    %%
    phead = int32([1 0 0 -1]);
    if exist('sfindpath','var')
        if ~iscell(sfindexpression)
            sfindexpression = {sfindexpression};
        end
        if ~iscell(sfindpath)
            sfindpath = repmat({sfindpath},size(sfindexpression));
        end
        if ~iscell(sfindoperator)
            sfindoperator = repmat({sfindoperator},size(sfindexpression));
        end
        if ~iscell(sreloperator)
            if isempty(sreloperator)
                sreloperator = repmat({'or'},numel(sfindexpression),1);
            else
                sreloperator = ['or';repmat({sreloperator},numel(sfindexpression)-1,1)];
            end
        else
            sreloperator = ['or'; sreloperator(:)];
        end
    end
    while ~feof(fidsrc)
        %% Read first note
        chead = fread(fidsrc,[1 4],'int32');
        if ~isempty(chead)
            if chead(2) == 16
                % Ok we complete modifying the notes
                chead(3) = phead(2);
                fwrite(fid,chead,'int32');
                fclose(fidsrc);
                fclose(fid);
                return;
            else
                %%
                pnote = fread(fidsrc,[1 chead(2)-18],'*char');
                pkeys = readkeylist(pnote,1);
                %%
                if ~exist('sfindpath','var')
                    [breplaced,pkeys] = replaceannokey(pkeys,sreplacepath,sreplaceoperator,sreplaceexpression,sreplace);
                    if breplaced
                        pnote  = keylist2keystr(pkeys);
                    end
                else
                    bfound = false;
                    for ipath = 1:numel(sfindpath)
                        bchangetemp = replaceannokey(pkeys,sfindpath{ipath},sfindoperator{ipath},sfindexpression{ipath},'');
                        if ismember(lower(sreloperator{ipath}),{'or','|','||'})
                            bfound = bfound || bchangetemp; 
                            if bfound && all(ismember(lower(sreloperator(ipath:end)),{'or','|','||'}))
                                break;
                            end
                        elseif ismember(lower(sreloperator{ipath}),{'and','&','&&'})
                            bfound = bfound && bchangetemp; 
                            if ~bfound && all(ismember(lower(sreloperator),{'or','|','||'}))
                                break;
                            end
                        end
                    end
                    if bfound
                        [breplaced,pkeys] = replaceannokey(pkeys,sreplacepath,sreplaceoperator,sreplaceexpression,sreplace);
                        if breplaced
                            pnote  = keylist2keystr(pkeys);
                        end
                    end
                end
                if ~isempty(pnote)
                    chead([2 3]) = [length(pnote)+18 phead(2)];
                    fwrite(fid,chead,'int32');
                    fwrite(fid,[pnote 0 0],'*char');
                    phead = chead;
                end
                fseek(fidsrc,2,'cof');
            end
        else
            fclose(fid);
            fclose(fidsrc);
            movefile(backupname,fname,'f')
            errmsg = 'Empty annotation header';
            return;
        end
    end
catch err
    %% Restore original file
    fclose(fid);
    fclose(fidsrc);
    if bModifyFile
        movefile(backupname,fname,'f')
    else
        delete(backupname);
    end
    %% Report Error
    errmsg = err.message;
    err = struct2cell(err.stack);
    err = [err(2:end,:) ;err(1,:)];
    fprintf('%s %d %s\n',err{:});
end

