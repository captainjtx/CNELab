function [outdiff,annos] = depthmerge(varargin)
% depthmerge(...)
% Comparesor modifies all data according to stamp and text
% Accepts param value pairs
% Parameter    Value
% 'RightFile',  a path name  for the right side of the annoatations
% 'LeftFile',   a path name  for the left side of the annoatations
% 'OutputFile',     a path name  for the output file of the annoatations
% 'ShowOption', cell array contains {'Different','Identical',''}
% 'ModifyOption', 'Merge'(Union of),'Diff',''
% 'User', username Change emty user names to this value.
% 'ChangeOrigin', 'Acquisition' or 'Review'
% 'Host', {'FromHost','ToHost'} change fromHost to toHost
% Changes will only apply to writable annotations!

cmds = {...
    'RightFile', ''     % A path name  for the right side of the annoatations
    'LeftFile', ''      % A path name  for the left side of the annoatations
    'OutputFile', ''        % A path name  for the output file of the annoatations
    'ShowOption', {{'Merge'}}    % Cell array contains {'Merge','Identical','RightSideOnly','LeftSideOnly'}
    'ModifyOption', 'Merge'  % 'Identical','Merge','RightOnly','LeftOnly'
    'User', {{'',getenv('UserName')}}          % {'FromUser','ToUser'} User name change emty user names to this value.
    'ChangeOrigin', ''  % 'Acquisition' or 'Review', Also adds 'A2R' or 'R2A' at the end of the comment
    'Host', {{'',getenv('ComputerName')}}          % {'FromHost','ToHost'} change fromHost to toHost
    'LogFile','depthmergelog.txt'
    'LogType','All'
    }';
cmds = xltekprocessinput(cmds,varargin);
filest = [isempty(cmds.LeftFile) isempty(cmds.RightFile)  isempty(cmds.OutputFile)];
if all(filest)
    error(['matlab:' mfilename],'No file to proceed');
end
fid = fopen(cmds.LogFile,'wt'); % Create log file
if fid ~= -1
    fclose(fid);
end
annos   = cell(3,2);
if ~filest(1)
    [annos{1,1:2}] = extractanno(cmds.LeftFile);
end
if ~filest(2)
    [annos{2,1:2}] = extractanno(cmds.RightFile);
end
for ish = 1:numel(cmds.ShowOption)
    cmds.ShowOption{ish} = lower(cmds.ShowOption{ish});
end
% cmds.ModifyOption = lower(cmds.ModifyOption);
if ~filest(1:2) % Compare header
    outdiff = zeros(length(annos{1})+length(annos{2}),1);
    outdiff = struct('Merge',[outdiff outdiff],'Identical',outdiff,'RightOnly',outdiff,'LeftOnly',outdiff);
    % Compare header
    if annos{2,2}.CreationTime ~= annos{1,2}.CreationTime
        error(['matlab:' mfilename],'Only compares files those have same craetion time');
    end
    stamps  = {[annos{1,1}.Stamp];[annos{2,1}.Stamp]};
    iMerge      = 1;
    iIdentical  = 1;
    iLeftOnly   = 1;
    iRightOnly  = 1;
    iLeftRight = [1 1];
    nLeftRight = [length(annos{1,1}) length(annos{2,1})];
    while all(iLeftRight <= nLeftRight)
        if annos{1,1}(iLeftRight(1)).Stamp == annos{2,1}(iLeftRight(2)).Stamp
            lside = find(annos{1,1}(iLeftRight(1)).Stamp == stamps{1});
            rside = find(annos{2,1}(iLeftRight(2)).Stamp == stamps{2});
            csize = [length(lside),length(rside)];
            cside = false(csize);
            for il = 1:csize(1)
                for ir = 1:csize(2)
                    cside(il,ir) = strcmp(annos{1,1}(lside(il)).Text,annos{2,1}(rside(ir)).Text);
                    if annos{1,1}(lside(il)).ReadOnly && annos{2,1}(rside(ir)).ReadOnly
                        cside(il,ir) = cside(il,ir) && strcmp(annos{1,1}(lside(il)).Origin,annos{2,1}(rside(ir)).Origin);
                    end
                end
            end
            if all(diag(cside))
                nfiles = min(csize);
                if csize(1) == csize(2)
                    depthmergelog(cmds.LogFile,annos,lside,rside,'Same Stamp; Same LRNumber, Merge Left',cmds.LogType);
                    outdiff.Merge(iMerge+(0:nfiles-1),1)        = lside;
                    outdiff.Identical(iIdentical+(0:nfiles-1))  = lside;
                    depthmergereport(cmds.LogFile,outdiff.Merge(iMerge+(0:nfiles-1),:),lside,[],[],cmds.LogType);
                elseif csize(2) > csize(1)
                    depthmergelog(cmds.LogFile,annos,lside,rside,'Same Stamp; Different LRNumber, Merge Left',cmds.LogType);
                    outdiff.Merge(iMerge+(0:nfiles-1),1)        = lside;
                    outdiff.Identical(iIdentical+(0:nfiles-1))  = lside;
                    nrfiles = csize(2) - csize(1);
                    outdiff.RightOnly(iRightOnly+(0:nrfiles-1))     = rside(nfiles+1:end);
                    depthmergereport(cmds.LogFile,outdiff.Merge(iMerge+(0:nfiles-1),:),lside,[],rside(nfiles+1:end),cmds.LogType);
                    iRightOnly = iRightOnly + nrfiles;
                else
                    depthmergelog(cmds.LogFile,annos,lside,rside,'Same Stamp; Different LRNumber, Merge Right',cmds.LogType);
                    outdiff.Merge(iMerge+(0:nfiles-1),2)       = rside;
                    outdiff.Identical(iIdentical+(0:nfiles-1)) = lside(1:nfiles);
                    nlfiles = csize(1) - csize(2);
                    outdiff.LeftOnly(iLeftOnly+(0:nlfiles-1))= lside(nfiles+1:end);
                    depthmergereport(cmds.LogFile,outdiff.Merge(iMerge+(0:nfiles-1),:),lside,lside(nfiles+1:end),[],cmds.LogType);
                    iLeftOnly = iLeftOnly + nlfiles;
                end
                iIdentical = iIdentical + nfiles;
                iLeftRight = iLeftRight + csize;
                iMerge     = iMerge + nfiles;
            else
                if isscalar(cside)
                    outdiff.Merge(iMerge,1)      = lside;
                    outdiff.Merge(iMerge,2)      = rside;
                    outdiff.LeftOnly(iLeftOnly)  = lside;
                    outdiff.RightOnly(iRightOnly)= rside;
                    depthmergelog(cmds.LogFile,annos,lside,rside,'Same Stamp; Different LRItems, Merge left-right[scalar]',cmds.LogType);
                    depthmergereport(cmds.LogFile,outdiff.Merge(iMerge,:),[],lside,rside,cmds.LogType);
                    iLeftRight  = iLeftRight + 1;
                    iMerge      = iMerge + 1;
                    iRightOnly  = iRightOnly + 1;
                    iLeftOnly   = iLeftOnly + 1;
                else
                    if csize(1) == csize(2) && all(diag(fliplr(cside)))
                        nfiles  = csize(1);
                        outdiff.Merge(iMerge+(0:nfiles-1),1)        = lside;
                        outdiff.Identical(iIdentical+(0:nfiles-1))  = lside;
                        depthmergelog(cmds.LogFile,annos,lside,rside,'Same Stamp; Has same items in reverse order, Merge left',cmds.LogType);
                        depthmergereport(cmds.LogFile,outdiff.Merge(iMerge+(0:nfiles-1),:),lside,[],[],cmds.LogType);
                        iLeftRight = iLeftRight + csize;
                        iIdentical = iIdentical + nfiles;
                        iMerge     = iMerge + nfiles;
                    elseif csize(1) == 1
                        if any(cside)
                            outdiff.Merge(iMerge,1)       = lside;
                            outdiff.Identical(iIdentical) = lside;
                            depthmergelog(cmds.LogFile,annos,lside,rside,'1. Same Stamp; Has some same items, Merge left[vector]',cmds.LogType);
                            depthmergereport(cmds.LogFile,outdiff.Merge(iMerge,:),lside,[],[],cmds.LogType);
                            iMerge = iMerge + 1;
                            iIdentical = iIdentical + 1;
                            iLeftRight(1) = iLeftRight(1)+1;
                        end
                        outdiff.Merge(iMerge+(0:sum(~cside)-1),2) = rside(~cside);
                        outdiff.RightOnly(iMerge+(0:sum(~cside)-1)) = rside(~cside);
                        depthmergelog(cmds.LogFile,annos,lside,rside,'2. Same Stamp; Has some same items, Merge left[vector]',cmds.LogType);
                        depthmergereport(cmds.LogFile,outdiff.Merge(iMerge+(0:sum(~cside)-1),:),[],[],rside(~cside),cmds.LogType);
                        iLeftRight(2)   = iLeftRight(2)+sum(~cside);
                        iMerge          = iMerge+sum(~cside);
                        iRightOnly      = iRightOnly+sum(~cside);
                    elseif csize(2) == 1
                        if any(cside)
                            outdiff.Merge(iMerge,2)       = rside;
                            outdiff.Identical(iIdentical) = lside(cside); % Error if sum(cside)>1
                            depthmergelog(cmds.LogFile,annos,lside,rside,'1. Same Stamp; Has some same items, Merge right[vector]',cmds.LogType);
                            depthmergereport(cmds.LogFile,outdiff.Merge(iMerge,:),lside(cside),[],[],cmds.LogType);
                            iMerge          = iMerge+1;
                            iIdentical      = iIdentical + 1;
                            iLeftRight(2)   = iLeftRight(2)+1;
                        end
                        outdiff.Merge(iMerge+(0:sum(~cside)-1),1) = lside(~cside);
                        outdiff.LeftOnly(iLeftOnly+(0:sum(~cside)-1)) = lside(~cside);
                        depthmergelog(cmds.LogFile,annos,lside,rside,'2. Same Stamp; Has some same items, Merge left[vector]',cmds.LogType);
                        depthmergereport(cmds.LogFile,outdiff.Merge(iMerge+(0:sum(~cside)-1),:),[],lside(~cside),[],cmds.LogType);
                        iLeftRight(1)   = iLeftRight(1)+sum(~cside);
                        iMerge          = iMerge+sum(~cside);
                        iLeftOnly       = iLeftOnly + sum(~cside);
                    else
                        error(['matlab:' mfilename],'Not Implemented yet');
                    end
                end
            end
            
        else
            while iLeftRight(1) <= nLeftRight(1) && annos{1,1}(iLeftRight(1)).Stamp < annos{2,1}(iLeftRight(2)).Stamp
                outdiff.Merge(iMerge,1) = iLeftRight(1);
                outdiff.LeftOnly(iLeftOnly) = iLeftRight(1);
                depthmergelog(cmds.LogFile,annos,iLeftRight(1),[],'Advancing Left Side',cmds.LogType);
                depthmergereport(cmds.LogFile,outdiff.Merge(iMerge,:),[],iLeftRight(1),[],cmds.LogType);
                iLeftRight(1) = iLeftRight(1) + 1;
                iMerge = iMerge + 1;
                iLeftOnly = iLeftOnly + 1;
            end
            while iLeftRight(2) <= nLeftRight(2) && annos{2,1}(iLeftRight(2)).Stamp < annos{1,1}(iLeftRight(1)).Stamp
                outdiff.Merge(iMerge,2) = iLeftRight(2);
                outdiff.RightOnly(iRightOnly) = iLeftRight(2);
                depthmergelog(cmds.LogFile,annos,[],iLeftRight(2),'Advancing Right Side',cmds.LogType);
                depthmergereport(cmds.LogFile,outdiff.Merge(iMerge,:),[],[],iLeftRight(2),cmds.LogType);
                iRightOnly = iRightOnly + 1;
                iLeftRight(2) = iLeftRight(2)+1;
                iMerge = iMerge + 1;
            end
        end
    end
    side = find(iLeftRight <= nLeftRight);
    if ~isempty(side)
        NFiles = nMerger(side) - iLeftRight(side);
        outdiff.Merge(iMerge+(0:NFiles),side) = iLeftRight(side)+(0:NFiles);
    end
    outdiff.Merge(~any(outdiff.Merge,2),:) = [];
    outdiff.Identical(~any(outdiff.Identical),:) = [];
    outdiff.LeftOnly(~any(outdiff.LeftOnly),:) = [];
    outdiff.RightOnly(~any(outdiff.RightOnly),:) = [];
else
    outdiff.Identical = [];
    if ~filest(1)
        outdiff.Merge = [(1:length(annos{1,1}))' (1:length(annos{1,1}))'*0];
        outdiff.LeftOnly = 1:length(annos{1,1});
        outdiff.RightOnly = [];
    else
        outdiff.Merge     = [(1:length(annos{2,1}))*0; (1:length(annos{2,1}))]';
        outdiff.LeftOnly  = [];
        outdiff.RightOnly = 1:length(annos{2,1});
    end
end
if cmds.OutputFile
    switch lower(cmds.ModifyOption)
        case 'merge'
            if ~filest(1:2)
                outanno = repmat(annos{1,1}(1),size(outdiff.Merge,1),1);
                outanno(outdiff.Merge(:,1)~=0) = annos{1,1}(outdiff.Merge(outdiff.Merge(:,1)~=0,1));
                outanno(outdiff.Merge(:,2)~=0) = annos{2,1}(outdiff.Merge(outdiff.Merge(:,2)~=0,2));
                head = annos{1,2};
            else
                if ~filest(1)
                    outanno = repmat(annos{1,1},size(outdiff.Merge,1),1);
                    outanno(outdiff.Merge(:,1)~=0) = annos{1,1}(outdiff.Merge(outdiff.Merge(:,1)~=0,1));
                    head = annos{1,2};
                else
                    outanno = repmat(annos{2,1}(1),size(outdiff.Merge,1),1);
                    outanno(outdiff.Merge(:,2)~=0) = annos{2,1}(outdiff.Merge(outdiff.Merge(:,2)~=0,2));
                    head = annos{2,2};
                end
            end
        case 'identical'
            error(['matlab:' mfilename],'');
        case 'leftonly'
            error(['matlab:' mfilename],'');
        case 'rightonly'
            error(['matlab:' mfilename],'');
    end
    fwriteanno(cmds.OutputFile,outanno,head);
end

function errmsg = fwriteanno(fname,anno,header)
try
    fid = xltekwriteeegheader(fname,'ent',header);
    chunkhead = [1 anno(1).Size 0  -1];
    fwrite(fid,chunkhead,'int32');
    fwrite(fid,anno(1).String,'char');
    fwrite(fid,0,'uint16');
    for iAnno = 2:length(anno)
        chunkhead = [1 anno(iAnno).Size anno(iAnno-1).Size -1];
        fwrite(fid,chunkhead,'int32');
        fwrite(fid,anno(iAnno).String,'char');
        fwrite(fid,0,'uint16');
    end
    chunkhead = [0 16 anno(end).Size 0];
    fwrite(fid,chunkhead,'int32');
catch errmsg
    if exist('fid','var') && fid ~= -1
        fclose(fid);
    end
    errmsg = errmsg.message;
end


function errmsg = depthmergereport(fname,merge,identical,left,right,logtype)
if strcmp(fname,'"stdout"')
    fid = 1;
else
    [fid,errmsg] = fopen(fname,'at');
    if ~isempty(errmsg), return; end
end
try
    if ismember(lower(logtype),{'merge','all'})
        if isempty(merge)
            fprintf(fid,'merge = []\n');
        else
            fprintf(fid,'merge = [');
            for ir = 1:size(merge,1)-1
                fprintf(fid,'%d %d;',merge(ir,:));
            end
            fprintf(fid,'%d %d]\n',merge(end,:));
        end
    end
    if ismember(lower(logtype),{'identical','all'})
        if isempty(identical)
            fprintf(fid,'identical = []\n');
        else
            fprintf(fid,'identical = %s\n',sprintf('%d ',identical));
        end
    end
    if ismember(lower(logtype),{'leftonly','all'})
        if isempty(left)
            fprintf(fid,'left = []\n');
        else
            fprintf(fid,'left = %s\n',sprintf('%d ',left));
        end
    end
    if ismember(lower(logtype),{'rightonly','all'})
        
        if isempty(right)
            fprintf(fid,'right = []\n');
        else
            fprintf(fid,'right = %s\n',sprintf('%d ',right));
        end
        if fid ~= 1
            fclose(fid);
        end
    end
catch errmsg
    if fid ~= 1
        fclose(fid);
    end
    errmsg = errmsg.message;
end



function errmsg = depthmergelog(fname,annos,left,right,action,logtype)
if strcmp(fname,'"stdout"')
    fid = 1;
else
    [fid,errmsg] = fopen(fname,'at');
    if ~isempty(errmsg), return; end
end
try
    if ~isempty(left)
        stamp = annos{1,1}(left(1)).Stamp;
        lstr = strtrim(sprintf('%g ',left));
    else
        lstr = '';
        stamp = annos{2,1}(right(1)).Stamp;
    end
    if ~isempty(right)
        rstr = strtrim(sprintf('%g ',right));
    else
        rstr = '';
    end
    fprintf(fid,'%s @ %ld [%s:%s]\n',action,stamp,lstr,rstr);
    nlen = 100;
    if ismember(lower(logtype),{'merge','leftonly','all'})
        if ~isempty(left)
            litems = [num2cell(left);arrayfun(@(anno) [sprintf('%3.3s ',anno.Origin) strrep(anno.Text(1:min(nlen,end)),char(10),'\n')],annos{1,1}(left),'UniformOutput',0)'];
            fprintf(fid,'\tLeft Items\n%s',sprintf('\t\t%d %s\n',litems{:}));
        end
    end
    if ismember(lower(logtype),{'merge','rightonly','all'})
        if ~isempty(right)
            ritems = [num2cell(right);arrayfun(@(anno) [sprintf('%3.3s ',anno.Origin) strrep(anno.Text(1:min(nlen,end)),char(10),'\n')],annos{2,1}(right),'UniformOutput',0)'];
            fprintf(fid,'\tRight Items\n%s',sprintf('\t\t%d %s\n',ritems{:}));
        end
    end
    if fid ~= 1
        fclose(fid);
    end
catch errmsg
    if fid ~= 1
        fclose(fid);
    end
    errmsg = errmsg.message;
end

