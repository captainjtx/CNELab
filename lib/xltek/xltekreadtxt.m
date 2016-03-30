function [data,fseekpos,timespan,dbsinfo] = xltekreadtxt(fname,ndata,chansel,fseekpos)
%% Initialize variables
% [data,fseekpos,timespan,dbsinfo] = xltekreadtxt(fname,ndata,chansel,fseekpos)
% fname     : File name
% ndata     : [1st index (1 based), # of data we want to extract(optional, can be inf)]
% chansel   : The channels those are required to read
% fseekpos  : The postions that we should start extracting data, it should
% be obtained through this function, could be 0 if we start from the
% beginning
%
% data      : The data of selected channels
% fseekpos  : Current offset of data
% dbsinfo   : Information about channels

%% Open and read file
[fid,msg]  = fopen(fname,'rt');
error(msg);
try
    %% Skip header
    if nargout < 3
        %%
        textscan(fid,'%*[^\n]\n',2);
        txtout  = textscan(fid,'%%%[^:]:%[^\n]\n',1);
        tmformat = any(regexpi(txtout{2}{1},'am|pm'));
        textscan(fid,'%*[^\n]\n',10);
        % Read only channels to determine the number of channels
        txtout = textscan(fid,'%[^\n]\n',1);
        txtout = txtout{1}{1};
        txtout = textscan(txtout,'%s');
        dbsinfo = {'channels',txtout{1}(5:end-1)'};
        textscan(fid,'%*[^\n]\n',1);
    else
        %% Read Header
        textscan(fid,'%*[^\n]\n',1);
        txtout = textscan(fid,'%%%[^:]:%[^\n]\n',4);
        tmformat = any(regexpi(txtout{2}{2},'am|pm'));
        dbsinfo = [txtout{:}];
        textscan(fid,'%*[^\n]\n',1);
        txtout = textscan(fid,'%%%[^:]:%[^\n]\n',1);
        dbsinfo = [dbsinfo; [txtout{:}]];
        txtout = textscan(fid,'%% Sampling Rate%fHz%*[^\n]\n',1); % Sampling Rate			2000.000000 Hz
        dbsinfo  = [dbsinfo;{'Sampling Rate' txtout{1}}];
        txtout = textscan(fid,'%%  Channels%f%*[^\n]\n',1); % Channels			128
        dbsinfo   = [dbsinfo;{'Channels' txtout{1}}];
        txtout = textscan(fid,'%%  Patient ID Study ID%f %f%*[^\n]\n',1);% Patient ID Study ID		0 0
        dbsinfo   = [dbsinfo;{'Patient ID' [txtout{1}];'Study ID' [txtout{2}]}];
        txtout = textscan(fid,'%%  Headbox SN%f*[^\n]\n',1);% Headbox SN			65535
        dbsinfo   = [dbsinfo;{'Headbox SN' txtout{1}}];
        textscan(fid,'%*[^\n]\n',3);
        txtout = textscan(fid,'%[^\n]\n',1);
        txtout = txtout{1}{1};
        txtout = textscan(txtout,'%s');
        dbsinfo = [dbsinfo;{'channels',txtout{1}(5:end-1)'}];
        textscan(fid,'%*[^\n]\n',1);
    end
    %%
    datapos = ftell(fid);
    if ~exist('fseekpos','var') || isempty(fseekpos)
        fseekpos = 0;
    elseif fseekpos ~= 0
        fseek(fid,fseekpos,'cof');
        if feof(fid)
            [data,fseekpos,timespan] = deal([]);
            return;
        end
    end
    %%
    if ~exist('chansel','var') || isempty(chansel);
        chansel = 1:length(dbsinfo{end,2});
    else
        if iscellstr(chansel)
            [chanidx{1:3}] = intersect(dbsinfo{end,2},chansel);
            chansel = chanidx{2}(chanidx{3});
        end
    end
    chansel(chansel<1 | chansel>length(dbsinfo{end,2})) = [];
    if isempty(chansel)
        [data,fseekpos,timespan] = deal([]);
        return;
    end
    strchan          = repmat({' %*f'},size(dbsinfo{end,2}));
    strchan(chansel) = {' %f'};
    [chanidx{1:3}]   = unique(chansel);
    chansel          = chanidx{3};
    nchan            = length(chansel);

    %%
    if tmformat
        tmformat       = '%*s %*s %*s ';
    else
        tmformat       = '%*s %*s ';
    end
    
    %%
    if exist('ndata','var')
        % Skip lines
        if ndata(1)> 1
            textscan(fid,'%*[^\n]\n',ndata(1)-1);
            fseekpos = ftell(fid)-datapos;
            % If we skip all data, then return
            if feof(fid)
                [data,fseekpos,timespan] = deal([]);
                return;
            end
        end
    else
        ndata = [1 inf];
    end
    v        = textscan(fid,'%[^\n]',1);
    timespan = {v{1}{1}(1:find(v{1}{1}==9,1)-1),[];sscanf(v{1}{1}(1+find(v{1}{1}==9,1):end),'%d',1) []};
    fseek(fid,fseekpos+datapos,'bof');
    if length(ndata) == 1 || isinf(ndata(2))
        %%
        str = {' ',''};
        fseek(fid,0,'eof');
        nSeek = 200;
        fseek(fid,-nSeek,'cof');
        numNL = 1;
        %%
        while true
            %%
            str{1} = fread(fid,[1 nSeek],'*char');
            fseek(fid,-2*nSeek,'cof');
            %%
            if ~isempty(str{2})
                str{2} = [str{1} str{2}];
            else
                str{2} = str{1};
                numNL = (str{1}(end)==10)+1;
            end
            newLinePos = find(str{2}==10,numNL,'last');
            if length(newLinePos) == numNL
                % We find last line
                str = str{2}(newLinePos(1):end);
                break;
            end
        end
        ndata(2) = sscanf(str,[tmformat '%f'],[1 1])-timespan{2,1}+1;
        clear str
        fseek(fid,fseekpos+datapos,'bof');
    end
    
    data     = zeros(ndata(2),nchan);

    % Date Time & EventByte [Data] and remaining?, events?
    fmtstr       = [tmformat '%*f' strchan{:} '%*s'];
    % if requested data samples is larger than nChunk, then try to read nChunk
    % samples at a time
    nChunk = 100000;
    iData  = [floor(ndata(2)/nChunk) rem(ndata(2),nChunk)];
    iwin = 0; msg = ''; iIdx = 0;
    lxtime = [];
    while iwin < iData(1) && ~feof(fid) && isempty(msg)
        [chunk,xtime,msg] =  readdata(fid,nChunk,chansel,fmtstr);
        if isempty(msg)
            data((1:size(chunk,1))+iwin*nChunk,1:nchan) = chunk;
            iIdx = iIdx+size(chunk,1);
            iwin = iwin+1;
            if ~isempty(xtime)
                lxtime = xtime;
            end
        else
            fprintf('Error: %s\n',msg);
        end
    end
    
    if isempty(msg) && ~feof(fid) && iData(2)
        [chunk,xtime,msg] =  readdata(fid,iData(2),chansel,fmtstr);
        if isempty(msg)
            data((1:size(chunk,1))+iIdx,1:nchan) = chunk;
            iIdx = iIdx+size(chunk,1);
            if ~isempty(xtime)
                lxtime = xtime;
            end
        else
            fprintf('Error: %s\n',msg);
        end
    end
    if isempty(lxtime)
        timespan(:,2) = timespan(:,1);
        timespan{2,2} = timespan{2,2}-1;
    else
        timespan(:,2) = lxtime;
    end
    data(iIdx+1:end,:) = [];
    fseekpos = ftell(fid)-datapos;
catch last_error
    fclose(fid);
    rethrow(last_error);
end


function [chunk,xtime,msg] =  readdata(fid,nChunk,chansel,fmtstr)
msg = '';
chunk = [];
xtime = [];
try
    v = textscan(fid,'%[^\n]',nChunk);v = v{1};
    if isempty(v)
        msg = 'Trancated chunk';
        return;
    end
    %% Replace AMPSAT & SHORT with NaN to convert string to numbers
    v = cellfun(@(x) strrep(strrep(strrep(x,'AMPSAT','NaN'),'SHORT','NaN'),'PSAT','NaN'),v,'UniformOutput',false);
    % Data format
    chunk   = cellfun(@(x) sscanf(x,fmtstr),v,'UniformOutput',false);
    vc = cellfun(@(x) ischar(x),chunk);
    if any(vc)
        chunk(vc)= [];
    end
    xtime = {v{end}(1:find(v{end}==9,1)-1);sscanf(v{end}(1+find(v{end}==9,1):end),'%d',1)};
    %% Read data and reshape it
    chunk = cellfun(@(x) x(chansel),chunk,'UniformOutput',false);
    chunk = cat(2,chunk{:})';
catch last_error
    msg = last_error.message;
end
