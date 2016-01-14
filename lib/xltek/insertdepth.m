function errmsg = insertdepth(varargin)
% INSERTDEPTH(fname)
%   Insert depths automatically
% INSERTDEPTH(fname,depthname)
%   Insert depths automatically and check them with
% INSERTDEPTH(fname,depthname,delay) (delay in seconds)
%   Insert depths manually from depthname file with range set to [-1 5]
% INSERTDEPTH(fname,depthname,delay,range) (range in seconds)
%   Insert depths manually from depthname file
% INSERTDEPTH(...,anno)
%   Use anno as annotation structure.
% fnname    = Path for eeg file without extension
% depthname = Depth text file name
% delay     = Delay between text and binary files. If txt file time is
%             later than the xltek synch signal start then this value will
%             be negative. delay = XltekTime - TextTime
% range     = The range of signal that we search for a synch signal,
%             typically [-1 5]
% Check the results. This may mishandle some of the synch pulses.
% Needs: erd, stc and snc files.

%%
numargin = nargin;
if numargin < 1
    error('At least 1 input parameters are requested.');
end
fname = varargin{1};
if isstruct(varargin{end})
    anno = varargin{end};
    varargin(end) = [];
    numargin = numargin -1;
end
depthname = '';
delay = [];
range = [];
if numargin > 1
    depthname = varargin{2};
    if numargin > 2
        delay = varargin{3};
        if numargin > 3
            range = varargin{4};
        else
            range = [-1 5];
        end
    end
end

[fParts{1:3}] = fileparts(fname);
fname = fullfile(fParts{1:2});
if ~exist([fname '.eeg'],'file')
    fnm = dir(fullfile(fname,'*.eeg'));
    if isempty(fnm)
        error(['matlab:' mfilename],msg);
    else
        [~,fnm] = fileparts(fnm.name);
    end
    fname = fullfile(fname,fnm);
    [fParts{1:3}] = fileparts(fname);
end

% Read depth values
if exist(depthname,'file')
    depths = aomreaddepth(depthname);
    if isempty(depths)
        error(['Wrong depth file "' depthmane '"']);
    end
    % Convert times to datenum and add delay
    if ~isempty(delay)
        danum = datenum({depths.LocalTime})+delay/86400; % Delay in seconds
    else
        danum = [];
    end
    depths = str2double({depths.Depth}');
else
    delay = [];
    danum = [];
    depths = [];
end

% Read xltek files
eeg       = xltekreadeegfile(fname);
snc       = xltekreadsncfile(fname);
stc       = xltekreadstcfile(fname);
datainfo  = xltekreaderdfile(fname,'info'); % Get sampling rate
[b,a]     = butter(2,10/datainfo.SampleRate,'high'); % filter
if ~exist('anno','var')
    anno      = xltekreadentfile(fname); % annotations
end
% Extract all annotation text strings and stamps
annostr  = {anno.Text};
annostp  = arrayfun(@(ann) str2double(ann.Stamp),anno,'UniformOutput',true);
% Find montage annotations
monidx   = find(strncmpi(annostr,'Montage:',8));
nStc     = numel(stc);
pStc     = 1;
%%
microStart = ismember(lower(annostr),{'or micro start','or macrodepth start'});
microStart = anno(microStart);
microEnd   = ismember(lower(annostr),{'or micro end','or macrodepth end'});
microEnd   = anno(microEnd);
%%
if isempty(microStart) || isempty(microEnd)
    if isempty(range)
        error('["OR Micro Start","OR MacroDepth Start"] or ["OR Micro End","OR MacroDepth End"] annotation is missing');
    else
        microStart = 1;
        microEnd = inf;
    end
else
    microStart = str2double({microStart.Stamp});
    microEnd   = str2double({microEnd.Stamp});
    if any(microStart>microEnd)
        error(['matlab::' mfilename],'Study start labels should be before the study end labels');
    end
end
for iSection = 1:length(microStart)
    if ~isempty(danum)
        danum1   = max(microStart(iSection),time2stamp(danum(1),datainfo.SampleRate,snc,eeg));
        if danum1 < annostp(monidx(1))
            error(['matlab::' mfilename],['No Montage before this depth information,\n' ...
                '1. Check delay and your depth text file if the time matches the actual file\n' ...
                '2. Check the depth text file and xltek files belongs to same patient\n' ...
                '3. This software uses US/Central timezone, if you record the data in different timezone it may cause problems']);
        end
    end
    
    idmon = find(annostp(monidx)<microStart(iSection),1,'last');
    % Find sync channels, if we do not have any, then use next montage
    synchchans = find(ismember(anno(monidx(idmon)).Data.ChanNames,{'Sync Ref', 'Sync','Synch','Sync ref'}));
    if isempty(synchchans) || length(synchchans)~=2
        error(['matlab::' mfilename],'No Synch channels\n');
    end
    % Find the first file that we have synch channels
    while pStc <= nStc
        % Skip the files that we do not have montage
        if any(stc(pStc).endstamp < [annostp(monidx(idmon)) microStart(iSection)])
            pStc = pStc + 1;
            continue;
        end
        break;
    end
    
    % We want to compute the depths from the signal
    if isempty(delay)
        %% Read all synch channels assuming montage was not changed
        [datac{1},channelsc{1},stampsc{1}] = xltekreaderdfile(fullfile(fParts{1},stc(pStc).segmentname),synchchans,[],'dm');
        idata = 2;
        for mStc = pStc+1:nStc
            % Extends all data
            [datac{idata},channelsc{idata},stampsc{idata}] = xltekreaderdfile(fullfile(fParts{1},stc(mStc).segmentname),synchchans,[],'dm'); %#ok<AGROW>
            if stampsc{idata}(end) > microEnd(iSection)
                break; % We do not use the remaining files
            end
            idata = idata + 1;
        end
        %%
        signal      = cat(1,datac{:});
        timestamps  = cat(1,stampsc{:});
        channels = unique(cat(1,channelsc{:}),'rows');
        if size(channels,1) ~= 1
            error(['matlab:' mfilename],'Channel Order Changed During tasks');
        end
        startEnd = [find(timestamps == microStart(iSection),1) find(timestamps == microEnd(iSection),1)];
        timestamps = timestamps(startEnd(1):startEnd(2));
        if any(diff(timestamps) ~= 1)
            jumps = find(diff(timestamps) ~= 1);
            if any(microStart(iSection)<jumps & microEnd(iSection) > jumps)
                error(['matlab:' mfilename],'%s: Break in the data',stamp2time(timestamps(find(diff(timestamps)~=1,1)),snc,eeg));
            end
        end
        signal   = diff(signal(startEnd(1):startEnd(2),:),[],2);
        [sdepth,danum] = xltekdepthfind(signal,2000,timestamps,2);
        if isempty(depths)
            depths = sdepth;
        else
            [idep,kdep] = min(abs(bsxfun(@minus,depths,sdepth')));
            fprintf('Maximum difference between computed and stored depth value is %-g mm\n',max(idep));
            depths = depths(kdep);
        end
        danum = danum(:,1);
    else
        for inum = 1:length(danum)
            danum(inum) = time2stamp(danum(inum),datainfo.SampleRate,snc,eeg);
            % Find current montage
            if idmon < length(monidx) && danum(inum) > annostp(monidx(idmon+1))
                while idmon < length(monidx) && danum(inum) > annostp(monidx(idmon+1))
                    idmon = idmon + 1;
                end
                if idmon ~= length(monidx)
                    idmon = idmon - 1;
                end
            end
            % This is the range we search for the synch signal
            taskStamp = datainfo.SampleRate*range + danum(inum);
            try
                % Read data for a given range
                for kStc = pStc:nStc
                    % Assume montage is not changing here
                    if all(([stc(kStc).startstamp stc(kStc).endstamp] < taskStamp(1))==[1 0])
                        if taskStamp(2) < stc(kStc).endstamp
                            [signal,channels,timestamps,datainfo] = xltekreaderdfile(fullfile(fParts{1},stc(kStc).segmentname),synchchans,{taskStamp},'dm'); %#ok<ASGLU>
                        else
                            [datac{1},channelsc{1},stampsc{1},datainfo] = xltekreaderdfile(fullfile(fParts{1},stc(kStc).segmentname),synchchans,{[taskStamp(1) stc(kStc).endstamp]},'dm');
                            for mStc = kStc+1:nStc
                                idata = mStc-kStc+1;
                                if stc(mStc).startstamp > taskStamp(2)
                                    mStc = mStc - 1; %#ok<FXSET>
                                    break;
                                end
                                if taskStamp(2) > stc(mStc).endstamp
                                    % Extends all data
                                    [datac{idata},channelsc{idata},stampsc{idata}] = xltekreaderdfile(fullfile(fParts{1},stc(mStc).segmentname),synchchans,[],'dm'); %#ok<AGROW>
                                else
                                    % data ends in this file
                                    [datac{idata},channelsc{idata},stampsc{idata}] = xltekreaderdfile(fullfile(fParts{1},stc(mStc).segmentname),synchchans,{[stc(mStc).startstamp taskStamp(2)]},'dm'); %#ok<AGROW>
                                end
                            end
                            signal    = cat(1,datac{:});
                            timestamps  = cat(1,stampsc{:});
                            channels = unique(cat(1,channelsc{:}),'rows');
                            if size(channels,1) ~= 1
                                error(['matlab:' mfilename],'Channel Order Changed During tasks');
                            end
                            kStc = mStc; %#ok<FXSET>
                        end
                        break;
                    end
                end
                pStc = kStc; % data and timestapms are ready here
                % We have the signal here try to estimate the beginning of sinosoid
                % Use simple thersholding to find the beginning of signal;
                signal = filtfilt(b,a,signal);
                beginstamp = timestamps(find(abs(detrend(diff(signal,[],2)))>2,1))-5;
                if ~isempty(beginstamp)
                    danum(inum) = beginstamp;
                end
            catch errmsg
                rethrow(errmsg);%fprintf('Error %s\n',errmsg.message);
            end
        end
    end
    % Ready to write depth annotations, check the results please. This may not
    % handle some of the synch pulses.
    note  = cellstr(num2str(depths,'Depth is %-g')); % Prepare notes
    errmsg = xltekwritenote(fname,danum,note,'',getenv('UserName'),'Acquisition');
end