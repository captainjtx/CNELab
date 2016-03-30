function  errmsg = xltekremoveduplicates(fname,fndtext)
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
    %% Read first note
    phead = fread(fidsrc,[1 4],'int32');
    if isempty(phead) || phead(2) == 16
        restorefiles(fid,fidsrc,bModifyFile);
        errmsg = 'Empty annotation header';
        return;
    end
    pnote = fread(fidsrc,[1 phead(2)-18],'*char');
    pkeys = readkeylist(pnote,1);
    bSame = false;
    
    while ~feof(fidsrc)
        if ~bSame
            % Copy first note
            fwrite(fid,phead,'int32');
            fwrite(fid,[pnote 0 0],'*char');
        end
        % Read current note
        chead = fread(fidsrc,[1 4],'int32');
        if isempty(chead) 
            restorefiles(fid,fidsrc,bModifyFile);
            errmsg = 'Empty annotation header';
            return;
        end
        if chead(2) == 16
            % Ok we complete modifying the notes
            fwrite(fid,chead,'int32');
            fclose(fidsrc);
            fclose(fid);
            return;
        end
        cnote = fread(fidsrc,[1 chead(2)-18],'*char');
        ckeys = readkeylist(cnote,1);
        
        ptext = strcmp({pkeys.Key},'Text');
        ctext = strcmp({ckeys.Key},'Text');

        % Nothing to compare
        if ~any(ptext) || ~any(ctext)
            bSame = false;
            chead(3) = phead(2);
            % Advance note
            phead = chead;
            pkeys = ckeys;
            pnote = cnote;
            continue;
        end
        ptext = pkeys(ptext).Value;
        ctext = ckeys(ctext).Value;
        
        % Not repeating or we do not require it to be deleted
        if ~strcmpi(ptext,ctext) || ~any(strcmpi(fndtext,ptext))
            bSame = false;
            chead(3) = phead(2);
            % Advance note
            phead = chead;
            pkeys = ckeys;
            pnote = cnote;
            continue;
        end
        % Repeating task
        bSame = true;
    end
catch err
    restorefiles(fid,fidsrc,bModifyFile);
    %% Report Error
    errmsg = err.message;
    err = struct2cell(err.stack);
    err = [err(2:end,:) ;err(1,:)];
    fprintf('%s %d %s\n',err{:});
end

function restorefiles(fid,fidsrc,bModifyFile)
fclose(fid);
fclose(fidsrc);
if bModifyFile
    movefile(backupname,fname,'f')
else
    delete(backupname);
end
