function [errmsg,anno] = inserttriggers(fname,matname,taskname,delay,anno)
% INSERTTRIGGERS(fname,matname,taskname)
% Needs: erd, stc and snc files.

%%
numargin = nargin;
if numargin < 3
    error('At least 3 input parameters are requested.');
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
end

% Read xltek files
snc       = xltekreadsncfile(fname);
% stc       = xltekreadstcfile(fname);
eeg       = xltekreadeegfile(fname);
datainfo  = xltekreaderdfile(fname,'info'); % Get sampling rate
if ~exist('anno','var')
    anno      = xltekreadentfile(fname); % annotations
end
% Load matfile
potentialTasks = find(strcmpi({anno.Text}',[taskname ' Start'])');
if isempty(potentialTasks)
    errmsg = 'No Potential target';
    return;
end
stamps   = str2double({anno(potentialTasks).Stamp});
% Load matfile
matfile = load(matname);
% Choose the one that is closest to matname time, this can cause that
% we choose the wrong file, anyways you should check the resulting
% xltek file.
matstamp = time2stamp(datenum(double(matfile.settings.LocalTime([1:2 4:end-1]))),datainfo.SampleRate,snc,eeg,'m');
[~,targetTask] = min(abs(stamps-matstamp));
targetTime = stamp2time(stamps(targetTask),snc,eeg,'m');
switch lower(taskname)
    case 'centerout'
        %{
        Detail notes on task and patient specific conditions
        1. 03/07/2012 Day3 Co task2: there is 45 sec delay after
        14:28:50 so delay should be [datenum('03/07/2012 14:28:50.XXX'),45] x is ms and
        optional
        %}
        ErrorNames = matfile.errorNames;
        for inm = 1:numel(ErrorNames)
            ErrorNames{inm} = ErrorNames{inm}(1:end-5);
        end
        ErrorNames = ['SUCCESS';ErrorNames];
        % These were changed: TrialIndex;SucessTrialIndex;TrialStart;CenterInTime;CueShowTime;TargetShowTime;CenterOutTime;TargetInTime;TargetSuccess;TrialEndTime;ErrorCode
        % CenterInTime = 0 so it is assumed to be TrialStart+10ms
        % TrialEndTime was in the wrong position with lag 1 to sec so
        % move it back 1.5 seconds
        eventNames = matfile.eventNames;
        events = [matfile.trials.Events];
        events(4,:) = events(3,:) + 0.01;
        events(10,:) = events(10,:) - 1.5;
        eventNames=repmat(eventNames,1,size(events,2));
        eventNames(9,:) = ErrorNames(events(11,:)+1);
        events([1:2 end],:) = [];
        eventNames([1:2 end],:) = [];
        zk = events~=0;
        events = events(zk);
        eventNames = eventNames(zk);
        events = targetTime + events/86400;
        if exist('delay','var') && ~isempty(delay)
            events(events > delay(1)) = events(events > delay(1))+delay(2)/864e5;
        end
        events = time2stamp(events,datainfo.SampleRate,snc,eeg,'m');
    case 'forcetrial'
        %{
        Detail notes on task and patient specific conditions
        %}
        ErrorNames = ['SUCCESS';matfile.errorNames];
        % These were changed: TrialIndex;SucessTrialIndex;TrialStartTime;ShowCueTime;ShowLevelTime;MoveStartTime;MoveEndTime;TrialEndTime;TrialLevel;ErrorCode
        eventNames = matfile.eventNames;
        events = [matfile.trials.Events];
        % events(4,:) = events(3,:) + 0.01;
        % events(10,:) = events(10,:) - 1.5;
        eventNames=repmat(eventNames,1,size(events,2));
        eventNames(8,:) = ErrorNames(events(10,:)+1);
        events([1:2 end-1:end],:) = [];
        eventNames([1:2 end-1:end],:) = [];
        zk = events~=0;
        events = events(zk);
        eventNames = eventNames(zk);
        events = targetTime + events/86400;
        if exist('delay','var') && ~isempty(delay)
            events(events > delay(1)) = events(events > delay(1))+delay(2)/864e5;
        end
        events = time2stamp(events,datainfo.SampleRate,snc,eeg,'m');
    otherwise
        fprintf('%s is probably not a trial based task\n',taskname);
        return;
end
errmsg = xltekwritenote(fname,events(:),eventNames(:),'',getenv('UserName'),'Acquisition');

