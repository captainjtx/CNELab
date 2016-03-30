function  errmsg = xltekwritenote(fname,timestamp,note,comment,user,origin)
% BSUCCESS = XLTEKWRITENOTE(FNAME,TIMESTAMP,NOTE,COMMENT,USER,ORIGIN)
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
    % check input parameters and convert them to appropriate values
    timestamp = timestamp(:);
    [timestamp,iOrder] = sort(timestamp);
    [note,errmsg] = var2cell(note,'note',numel(timestamp),iOrder); if ~isempty(errmsg), return;end
    
    if nargin < 6
        origin = 'Review';
        if nargin < 5
            user = getenv('UserName');
            if nargin < 4
                comment = '';
            end
        end
    end
    [comment,errmsg] = var2cell(comment,'comment',numel(timestamp),iOrder); if ~isempty(errmsg), return;end
    [user,errmsg] = var2cell(user,'user',numel(timestamp),iOrder); if ~isempty(errmsg), return;end
    [origin,errmsg] = var2cell(origin,'origin',numel(timestamp),iOrder); if ~isempty(errmsg), return;end
    
    %%
    stc = xltekreadstcfile(fullfile(fparts{1},fparts{2}));
    if isempty(stc), errmsg = 'No data stc file'; return;end
    %%
    snc = xltekreadsncfile(fullfile(fparts{1},fparts{2}));
    eeg = xltekreadeegfile(fullfile(fparts{1},fparts{2}));

    % Always save backup annotation
    backupname = [datestr(now,'yyyy_mm_dd_HH_MM_SS_FFF_xltekwritenote') '.ent'];
    [fid,errmsg] = fopen(fname,'r+b');
    if ~isempty(errmsg), return;end
    copyfile(fname,fullfile(fparts{1},backupname),'f');
    
    if ~exist(fullfile(fparts{1},backupname),'file')
        error(['Matlab::' mfilename],'Could not back up file');
    end
    
    anno = struct('timestamp',num2cell(timestamp),'note',note,'comment',comment,'user',user,'origin',origin);
    [ret, hostname] = system('hostname');
    if ret~=0
        hostname = 'HOSTNAME';
    else
        hostname = strtrim(hostname);
    end
    
    %%
    % Assume frquency does not change during the study
    % Find first valid annotation insertion point
    iAnno = find(stc(1).startstamp <= [anno.timestamp],1);
    if isempty(iAnno) || stc(end).endstamp < anno(iAnno).timestamp
        errmsg = fileclose('we could not find any stamp to insert, they are all out of range',fid);
        return;
    end
    idata = 1;
    while idata <= length(stc) && iAnno <= length(anno)
        info = xltekreaderdfile(fullfile(fparts{1},stc(idata).segmentname),'info');
        if  all((anno(iAnno).timestamp < [info.TOCEntries(1,1) sum(info.TOCEntries(end,[1 3]))]) == [false true])
            % We have place this annotation into here
            if sum(info.TOCEntries(end,2:3)) - 1 == stc(idata).endstamp - stc(idata).startstamp ...
                    || any(all(anno(iAnno).timestamp < [info.TOCEntries(:,1) sum(info.TOCEntries(:,[1 3]),2)] == repmat([false true],size(info.TOCEntries,1),1),2));
                break; % No break in data file
            end
        end
        idata = idata + 1;
        if idata <= length(stc)
            while  iAnno <= length(anno) && anno(iAnno).timestamp < stc(idata).startstamp
                iAnno = iAnno + 1;
            end
        end
    end
    
    if iAnno > length(anno) || idata > length(stc)
        errmsg = fileclose('We could not any stamp to insert, they are all out of range',fid);
        return;
    end
    
    %% Read header
    
    header.GUID = fread(fid,[1 16],'uint8');
    if any([147 7 11 202 149 215 208 17 175 50 0 160 36 91 84 165] ~= header.GUID)
        errmsg = fileclose('Wrong GUID',fid);
        return;
    end
    fseek(fid,352,'bof');
    if ~feof(fid)
        %% Read first note
        phead = fread(fid,[1 4],'int32');
        if ~isempty(phead)
            if phead(2) == 16
                errmsg = fileclose('Incorrect Annotation File,No Annotations',fid);
                return;
            else
                pnote = fread(fid,[1 phead(2)-18],'*char');
                fseek(fid,2,'cof');
            end
        else
            errmsg = fileclose('Incorrect Annotation File,No Annotations',fid);
            return;
        end
    end
    pstamp = regexp(pnote,'\(\."Stamp", ([^\)]*)\)','tokens');
    if length(pstamp) ~= 1
        errmsg = fileclose('Wrong stamp information',fid);
        return;
    end
    pstamp = str2double(pstamp{1}{1});
    if any(pstamp > anno(iAnno).timestamp)
        errmsg = fileclose('Can not insert before first annotation',fid);
        return;
    end
    % Ok Find first insertion point
    while ~feof(fid)
        insloc = ftell(fid);
        chead = fread(fid,[1 4],'int32');
        if isempty(chead)
            errmsg = fileclose(fid,'Last chunk does not exist',fid);
            return;
        end
        if chead(2) == 16 % We reach end of file 
            break;
        else
            pnote = fread(fid,[1 chead(2)-18],'*char');
            fseek(fid,2,'cof'); % Skip last 2 bytes, they are zero
        end
        pstamp = regexp(pnote,'\(\."Stamp", ([^\)]*)\)','tokens');
        if length(pstamp) ~= 1
            errmsg = fileclose('Wrong stamp information',fid);
            return;
        end
        pstamp = str2double(pstamp{1}{1});
        if pstamp > anno(iAnno).timestamp(1)
            break;
        else
            phead = chead;
        end
    end
    fseek(fid,insloc,'bof');
    
    if chead(2) == 16 % Insert notes at the end of the file
        snote = makenote(anno(iAnno),hostname,info.SampleRate,snc,eeg);
        phead = [1 length(snote)+18 phead(2) -1];
        fwrite(fid,int32(phead),'int32');
        fwrite(fid,[snote 0 0],'char');
        iAnno = iAnno + 1;
        while idata <= length(stc) && iAnno <= length(anno)
            info = xltekreaderdfile(fullfile(fparts{1},stc(idata).segmentname),'info');
            if  all((anno(iAnno).timestamp < [info.TOCEntries(1,1) sum(info.TOCEntries(end,[1 3]))]) == [false true])
                % We have place this annotation into here
                if sum(info.TOCEntries(end,2:3)) - 1 == stc(idata).endstamp - stc(idata).startstamp ...
                        || any(all(anno(iAnno).timestamp < [info.TOCEntries(:,1) sum(info.TOCEntries(:,[1 3]),2)] == repmat([false true],size(info.TOCEntries,1),1),2));
                    snote = makenote(anno(iAnno),hostname,info.SampleRate,snc);
                    phead = [1 length(snote)+18 phead(2) -1];
                    fwrite(fid,int32(phead),'int32');
                    fwrite(fid,[snote 0 0],'char');
                end
                iAnno = iAnno + 1;
                continue;
            end
            idata = idata + 1;
            if idata <= length(stc)
                while  iAnno <= length(anno) && anno(iAnno).timestamp < stc(idata).startstamp
                    iAnno = iAnno + 1;
                end
            end
        end
        fwrite(fid,int32([0 16 phead(2) 0]),'int32');
    else
        nfAnno = 0;
        while ~feof(fid)
            chead = fread(fid,[1 4],'int32');
            if isempty(chead)
                errmsg = fileclose(fid,'Last chunk does not exist',fid);
                return;
            end
            if chead(2) == 16 % We reach end of file
                break;
            else
                fseek(fid,chead(2)-16,'cof');
                nfAnno = nfAnno + 1;
            end
        end
        fseek(fid,insloc,'bof');
        fAnno  = repmat(struct('chead',[],'note',[],'stamp',[]),nfAnno,1);
        nfAnno = 1;
        while nfAnno <= length(fAnno)
            fAnno(nfAnno).chead = fread(fid,[1 4],'int32');
            if fAnno(nfAnno).chead(2) == 16 % We reach end of file 
                errmsg = fileclose('Annotation file changed during writing!',fid);
                return;
            else
                fAnno(nfAnno).note = fread(fid,[1 fAnno(nfAnno).chead(2)-18],'*char');
                fseek(fid,2,'cof'); % Skip last 2 bytes, they are zero
            end
            fAnno(nfAnno).stamp = regexp(fAnno(nfAnno).note,'\(\."Stamp", ([^\)]*)\)','tokens');
            if length(fAnno(nfAnno).stamp) ~= 1
                errmsg = fileclose('Wrong stamp information',fid);
                return;
            end
            fAnno(nfAnno).stamp = str2double(fAnno(nfAnno).stamp{1}{1});
            nfAnno = nfAnno+1;
        end
        % Write first note
        fseek(fid,insloc,'bof');
        snote = makenote(anno(iAnno),hostname,info.SampleRate,snc,eeg);
        phead = [1 length(snote)+18 phead(2) -1];
        fwrite(fid,int32(phead),'int32');
        fwrite(fid,[snote 0 0],'char');
        iAnno  = iAnno + 1;
        nfAnno = 1;
        while idata <= length(stc) && iAnno <= length(anno)
            info = xltekreaderdfile(fullfile(fparts{1},stc(idata).segmentname),'info');
            if  all((anno(iAnno).timestamp < [info.TOCEntries(1,1) sum(info.TOCEntries(end,[1 3]))]) == [false true])
                % We have place this annotation into here
                if sum(info.TOCEntries(end,2:3)) - 1 == stc(idata).endstamp - stc(idata).startstamp ...
                        || any(all(anno(iAnno).timestamp < [info.TOCEntries(:,1) sum(info.TOCEntries(:,[1 3]),2)] == repmat([false true],size(info.TOCEntries,1),1),2));
                    % Write in between annotations
                    while nfAnno <= length(fAnno) && fAnno(nfAnno).stamp < anno(iAnno).timestamp 
                        phead = [1 fAnno(nfAnno).chead(2) phead(2) -1];
                        fwrite(fid,int32(phead),'int32');
                        fwrite(fid,[fAnno(nfAnno).note 0 0],'char');
                        nfAnno = nfAnno + 1;
                    end
                    % Write new annotation
                    snote = makenote(anno(iAnno),hostname,info.SampleRate,snc,eeg);
                    phead = [1 length(snote)+18 phead(2) -1];
                    fwrite(fid,int32(phead),'int32');
                    fwrite(fid,[snote 0 0],'char');
                end
                iAnno = iAnno + 1;
                continue; % No break in data file
            end
            idata = idata + 1;
            if idata <= length(stc)
                while  iAnno <= length(anno) && anno(iAnno).timestamp < stc(idata).startstamp
                    iAnno = iAnno + 1;
                end
            end
        end
        % Write remaining annotations
        while nfAnno <= length(fAnno)
            phead = [1 fAnno(nfAnno).chead(2) phead(2) -1];
            fwrite(fid,int32(phead),'int32');
            fwrite(fid,[fAnno(nfAnno).note 0 0],'char');
            nfAnno = nfAnno + 1;
        end
        fwrite(fid,int32([0 16 phead(2) 0]),'int32');
    end
    fclose(fid);
catch errmsg
    if exist('fid','var')
        fclose(fid);
    end
    rethrow(errmsg);
end


function str = makenote(anno,hostname,SampleRate,snc,eeg)
% STR  = MAKENOTE(ANNO,HOSTNAME,SAMPLERATE,SNC,EEG)
% ANNO.COMMENT   : User comment
% ANNO.NOTE      : User Note
% ANNO.TIMESTAMP : The sample index from beginning
% ANNO.USER      : User Name
% ANNO.ORIGIN    : Origin of note
notTime = stamp2time(anno.timestamp,snc,eeg,'o');
str = sprintf(['(.(."Comment", "%s"), ' ...
    '(."Data", (.(."CreationTime", %s), (."ModificationTime", %s)' ...
    ', (."Type", "Custom"), (."User", "%s"))), ' ...
    '(."GUID", "{%s}"), (."Host", "%s"), (."Origin", "%s"), ' ... origin = Review or Acquisition
    '(."ReadOnly", 0), (."Stamp", %d), (."Text", "%s"), (."Type", "Annotation"))']...
    ,anno.comment,notTime,notTime,anno.user,upper(createguid),hostname,anno.origin,anno.timestamp,anno.note);

function msg = fileclose(msg,fid)
fclose(fid);

function [var,errmsg] = var2cell(var,name,num,order)
errmsg = '';
if iscell(var)
    if num ~= numel(var)
        errmsg = ['Wrong ' name ' format (it should have same number of elements as timestamp)'];
        return;
    else
        var = var(order);
    end
else
    var = repmat({var},num,1);
end
