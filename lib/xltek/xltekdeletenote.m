function  errmsg = xltekdeletenote(fname,nPath,sRelOperator,sCondition,sValue)
% BSUCCESS = XLTEKDELETENOTE(FNAME,NPATH,SRELOPERATOR,SCONDITION,SVALUE)
% FNAME     : Ent file name or path
% NPATH     : Path of the keym i.e. 'Data.Deleted'
% CONDITION : '>','<','<=','<=','==','~=',('' means do not care),'i' means
%              value has the indecies that we want to remove, 'r': regular
%              expressions
% See also XLTEKREADDATA XLTEKREADENTFILE
%%
[fparts{1:3}] = fileparts(fname);
if isempty(fparts{3})
    fname = fullfile(fparts{1},[fparts{2},'.ent']);
end
if ~exist(fname,'file')
    errmsg = sprintf('File %s does not exist',fname);
    return;
end
    % Always save backup annotation
    backupname = fullfile(fparts{1},[datestr(now,'yyyy_mm_dd_HH_MM_SS_BackupAnnotation') '.ent']);
    if(~movefile(fname,backupname,'f'))
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
    
    phead = int32([1 0 0 -1]);
    iAnno = 1;
    if ~iscell(nPath)
        nPath = {nPath};
    end
    if ~iscell(sCondition)
        sCondition = repmat({sCondition},size(nPath));
    end
    if ~iscell(sValue)
        sValue = repmat({sValue},size(nPath));
    end
    if ~iscell(sRelOperator)
        sRelOperator = ['or';repmat({sRelOperator},numel(nPath)-1,1)];
    else
        sRelOperator = ['or'; sRelOperator(:)];
    end
    while ~feof(fidsrc)
        %% Read first note
        chead = fread(fidsrc,[1 4],'int32');
        if ~isempty(chead)
            if chead(2) == 16
                % Ok we complete deleting the notes
                chead(3) = phead(2);
                fwrite(fid,chead,'int32');
                fclose(fidsrc);
                fclose(fid);
                return;
            else
                pnote = fread(fidsrc,[1 chead(2)-18],'*char');
                pkeys = readkeylist(pnote,1);
                bFound = false;
                for iPath = 1:numel(nPath)
                    [bChangeTemp,pkeys] = replaceannokey(pkeys,nPath{iPath},sCondition{iPath},sValue{iPath});
                    if ismember(lower(sRelOperator{iPath}),{'or','|','||'})
                        bFound = bFound || bChangeTemp;
                    elseif ismember(lower(sRelOperator{iPath}),{'and','&','&&'})
                        bFound = bFound && bChangeTemp;
                    end
                end
                if ~bFound
                    pnote = keylist2keystr(pkeys);
                    chead(3) = phead(2);
                    fwrite(fid,chead,'int32');
                    fwrite(fid,[pnote 0 0],'*char');
                else
                    chead = phead;
                end
                fseek(fidsrc,2,'cof');
            end
            phead = chead;
            iAnno = iAnno + 1;
        else
            fclose(fid);
            fclose(fidsrc);
            movefile(backupname,fname,'f')
            errmsg = 'Empty annotation header';
            return;
        end
    end
catch err
    fclose(fid);
    fclose(fidsrc);
    movefile(backupname,fname,'f')
    errmsg = err.message;
    err = struct2cell(err.stack);
    err = [err(2:end,:) ;err(1,:)];
    fprintf('%s %d %s\n',err{:});
end
