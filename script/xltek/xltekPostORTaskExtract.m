clc
clear

% Modified by Tianxiao Jiang from POREXTRACT
% 06/24/2014

XLTEKFilePath=uigetdir(matlabroot,'Select the folder of XLTEK Files');
if ~XLTEKFilePath
    return 
end

OutPutFilePath=uigetdir([XLTEKFilePath,'/..'],'Select the folder of the output files');
if ~OutPutFilePath
    return
end

gennames = genfilenamepat(OutPutFilePath);

[xlnames,~,gen2xl] = unique({gennames.info.EEGPath});
ngen = length(xlnames);
if ~exist('annosi','var') || isempty(annosi)
    annosi      = cell(3,ngen);
    annosi(1,:) = xlnames;
elseif ~all(strcmp(annosi(1,:),xlnames))
    error(['matlab:' mfilename],'Wrong number of files');
end
[efid,msg] = fopen(fullfile(OutPutFilePath,'Report.txt'),'a+');error(msg);
try
    fprintf(efid,'Initializing Extraction %s\n',datestr(now));
    ngen = numel(gennames.info);
    for igen = 1:ngen
        if gennames.info(igen).Extract == '0'
            fprintf('Pt%s - %s> Skip patient\n',gennames.info(igen).Index ,gennames.info(igen).Initials);
            continue;
        end
        clear patientInfo data montage
        % Patient Info Static
        patientInfo.Study      = gennames.info(igen).Study ;     % LFPII, UMII, NSF etc.
        patientInfo.Experiment = gennames.info(igen).Experiment; % This file is designed for Files those includes depth info ('ORMicro', 'ORMacroDepth')
        patientInfo.Case       = gennames.info(igen).Case;       % scase : The desease, PD=> Parkinson's desease
        patientInfo.FileName   = gennames.info(igen).EEGPath; % Only the Name field of the full file path
        fName                  = gennames.info(igen).EEGPath;
        fPath                  = fullfile(XLTEKFilePath,[gennames.info(igen).FirstName ' ' gennames.info(igen).LastName],fName);
        
        % Read Files
        fName = fullfile(fPath,fName);
        eeg   = xltekreadeegfile(fName);
        snc   = xltekreadsncfile(fName);
        stc   = xltekreadstcfile(fName);
        if ~any(strcmpi(patientInfo.Experiment,'PostOR'))
            msg = sprintf('Pt%s - %s> Unexpected experiment %s',gennames.info(igen).Index ,gennames.info(igen).Initials,patientInfo.Experiment);
            fprintf(2,'%s\n',msg); fprintf(efid,'%s\n',msg);
            continue;
        end
        if isempty(annosi{2,gen2xl(igen)})
            annosi{2,gen2xl(igen)} = xltekreadentfile(fName);
            annosi{3,gen2xl(igen)} = eeg;
        else
            names = {eeg.Info.Name.FirstName,eeg.Info.Name.MiddleName,eeg.Info.Name.LastName
                annosi{3,gen2xl(igen)}.Info.Name.FirstName,annosi{3,gen2xl(igen)}.Info.Name.MiddleName,annosi{3,gen2xl(igen)}.Info.Name.LastName};
            iem = ~cellfun(@isempty,names);
            if any(iem(1,:)  ~= iem(2,:)) || ~isempty(setdiff(names(1,iem(1,:)),names(2,iem(2,:))))
                error(['matlab:' mfilename],'Wrong Annotation');
            end
        end
        annos = annosi{2,gen2xl(igen)};
        % Make stamps numeric
        stamps = num2cell(str2double({annos.Stamp}));
        [annos.Stamp] = deal(stamps{:});
        
        if ~isempty(eeg.Info.Name.MiddleName)
            patientInfo.Name = [eeg.Info.Name.FirstName ' ' eeg.Info.Name.MiddleName ' ' eeg.Info.Name.LastName];
        else
            patientInfo.Name = [eeg.Info.Name.FirstName ' ' eeg.Info.Name.LastName];
        end
        % Check first and last name only
        patientNum = find(strcmpi({gennames.info(igen).FirstName},strtrim(eeg.Info.Name.FirstName))&strcmpi({gennames.info.LastName},strtrim(eeg.Info.Name.LastName)));
        if length(unique({gennames.info(patientNum).Index}))  ~= 1
            error(['matlab:' mfilename],'See PatientNames.txt to add initials for %s',patientInfo.Name);
        end
        % Patients = > [Initials FirstName MiddleName LastName index]
        patientInfo.Initials  = gennames.info(patientNum(1)).Initials;
        patientInfo.Index     = str2double(gennames.info(patientNum(1)).Index);
        patientInfo.ID        = eeg.Info.Admin.ID;
        patientInfo.FileTime  = converttime(eeg.Study.CreationTime,'o','yyyy/mm/dd HH:MM:SS');
        patientInfo.StudyName = eeg.Study.StudyName;
        
        fprintf('Pt%g - %s>',patientInfo.Index,patientInfo.Initials)
        gtask = find(strcmpi({gennames.task.Study},patientInfo.Study) & strcmpi({gennames.task.Experiment},patientInfo.Experiment));
        if isempty(gtask)
            error(['matlab:' mfilename],'Task is not define in TaskNames.txt for [%s %s]',patientInfo.Study,patientInfo.Experiment);
        end
        % Tasks
        tasks = {gennames.task(gtask).TaskName};
        
        % The task regexp pattern
        % (optional Side|LH:Left Hand,RH:Right Hand, etc) Task (Optional
        % TaskNumber) (start or end) (remaining string)
        % Handling tasks with space
        tasksexp = sprintf(['(?<Side>(%s))?(?<Task>(%s))([\\t ]*|[^0-9]*)'...
            '(?<TaskNumber>[0-9]*)?[\\t ]*(?<StartEnd>(start|end))(?<Remaining>.*)'],...
            [gennames.limbs{2,2} sprintf('|%s',gennames.limbs{2,3:end})],...
            [tasks{1} sprintf('|%s',tasks{2:end})]);
        
        % Tremor, artifact or other interested non Task segment
        taskexp = sprintf(['(?<Side>(%s))?(?<Task>([^\\t ]*))([\\t ]*|[^0-9]*)'...
            '(?<TaskNumber>[0-9]*)?[\\t ]*(?<StartEnd>(start|end))(?<Remaining>.*)'],...
            [gennames.limbs{2,2} sprintf('|%s',gennames.limbs{2,3:end})]);
        
        nMinimumChans = [1:9 12:20 23:26 29:40 41]; % These channels should exist
        nMaximumChans = [1:41];      % Do not select other than these channels
        
        
        % Important variables
        tmExtend                         = 2; % Extend both sides by this amount of time
        tmMinimumData                    = 1; % The minimum amount of time to save it
        patientInfo.Params.tmExtend      = tmExtend;
        patientInfo.Params.tmMinimumData = tmMinimumData;
        
        % Montage
        montage.Name        = patientInfo.Experiment;
        montage.HeadboxType = eeg.Study.HeadboxType;
        if length(fieldnames(eeg.Study.Headbox))~=1
            error(['matlab:' mfilename],'More than 1 headbox!');
        end
        SampleRate = str2double(eeg.Study.Headbox.HB0.SamplingFreq);
        if SampleRate == 1024
            nDownSample = 2; % Downsample signal by this factor
        else
            nDownSample = 1; % Downsample signal by this factor
        end
        montage.SampleRate  = SampleRate/nDownSample;
        patientInfo.Params.nDownSample = nDownSample;
        
        
        % Analyzing Annotations
        % Columns of idxFound
        % 1. Start          : TaskNumber if has start label of a requested task
        % 2. End            : TaskNumber if has end label of a requested task
        % 3. Montage        : 1 if it's a montage annotation
        % 4. Stamp          : Stamp of this annotation
        % 5. StartEnd       : [Start End]=>[1 2];
        % 6. Movement       : 1,2,3,4,5 [N,LH,RH,LL,RL],
        % 7. StateIndex     : (MedicineOff1, MedicineOn1,It will be a number that
        %                    according to gennames.states variable
        % 8. StateEndStamp  : End of the state, computed from clip annotation
        % 9. SideLabel      : LeftSTN, RightSTN etc. It will be a number that
        %                    according to gennames.brainside variable
        
        idxFound        = zeros(length(annos),9);
        idxFound(:,4)   = inf;    % We need to make it inf to find the state boundaries
        idxFound(:,6)   = 1;      % No side by default
        bStart          = zeros(1,numel(tasks));
        bArtifact       = false;     % if we are in artifact
        iCurTask        = 0; % Current task id
        iTaskAnno       = 0; % Current task start annotation id
        nArtifactLength = 0; % Artifact length in current task
        iArtifactStart  = 0; % Artifact Start stamp
        nState          = 0;
        for iAnno = 1:size(idxFound,1)
            % find out if this is a deleted annotation
            if isempty(annos(iAnno).Type) || (isfield(annos(iAnno).Data,'Deleted') && strcmp(annos(iAnno).Data.Deleted,'1'))
                continue;
            end
            annotext = strtrim(annos(iAnno).Text);                 % Annotation Text,
            stampv   = annos(iAnno).Stamp; % Stamp value for this label
            stateIdx = strcmpi(annotext,gennames.states);            % State Index
            sideIdx  = strcmpi(annotext,gennames.brainside(1,:));  % Side index
            if strncmpi(annotext,'Montage:',8)  % Montage found
                idxFound(iAnno,3) = 1;
            elseif any(sideIdx)  % Side found,Left STN, Right STN etc.
                idxFound(iAnno,9) = find(sideIdx);
            elseif any(stateIdx)
                nState = nState + 1;
                idxFound(iAnno,7) = find(stateIdx); % State Index
                % Find the end point of the sate
                idxFound(iAnno,8) = stampv + round(time2stamp(annos(iAnno).Data.EndTime,SampleRate,snc,eeg,'f') - time2stamp(annos(iAnno).Data.StartTime,SampleRate,snc,eeg,'f'));
            else
                stask = regexpi(annotext,tasksexp,'names'); % Is this a task annotation?
                if isempty(stask) || isempty(stask.Task) || ~isempty(stask.Remaining)
                    stask = regexpi(annotext,taskexp,'names');
                    if ~isempty(stask) && ~isempty(stask.Task) && isempty(stask.Remaining) % This is regular start/end label
                        % Tremor, artifact or other interested non Task segment
                        iStartEnd = strcmpi(stask.StartEnd,{'start','end'});
                        if ~strncmpi(stask.Task,'Tremor',8) % We assume Tremors does not affect the analysis
                            idxFound(iAnno,5) = find(iStartEnd);
                            if strcmpi(stask.Task,'Artifact')
                                if bArtifact && idxFound(iAnno,5) == 1
                                    error(['matlab:' mfilename],'%s: Artifact in artifacts',stamp2time(stampv,snc,eeg));
                                end
                                bArtifact = idxFound(iAnno,5) == 1;
                                if iCurTask  ~= 0
                                    if ~bArtifact
                                        nArtifactLength = nArtifactLength + (stampv-iArtifactStart) + 1;
                                        if bStart(iCurTask) == 2
                                            bStart(iCurTask) = 1;
                                        end
                                    else
                                        iArtifactStart = stampv;
                                    end
                                end
                            end
                        end
                    end
                else
                    iTask = find(strcmpi(stask.Task,tasks));
                    % Find the task index
                    if bStart(iTask)
                        % Task start was found, so this should be end of the task
                        % Or a task is inside another task
                        if ~strcmpi(stask.StartEnd,'end') || idxFound(iTaskAnno,1) ~= iTask
                            error(['matlab:' mfilename],'%s: Wrong Annotation %s',stamp2time(stampv,snc,eeg),annotext);
                        end
                        if bArtifact
                            nArtifactLength = nArtifactLength + (stampv-iArtifactStart) + 1;
                        end
                        if bStart(iTask) == 2 || ((stampv-idxFound(iTaskAnno,4))-nArtifactLength) < SampleRate
                            idxFound(iTaskAnno,[1 5 6]) = 0; % Entire task in an artifact!
                        else
                            idxFound(iAnno,[2 5]) = [iTask 2];  % Save task index
                        end
                        nArtifactLength = 0;
                        iArtifactStart = 0;
                        bStart(iTask) = 0;              % We found task end so make bStart false for this task
                        iCurTask = 0;
                    else
                        % Task end was found, so this should be start of the task
                        if ~strcmpi(stask.StartEnd,'start')
                            error(['matlab:' mfilename],'%s: Wrong Annotation %s',stamp2time(stampv,snc,eeg),annotext);
                        end
                        idxFound(iAnno,[1 5]) = [iTask 1];  % Save task index
                        iCurTask = iTask;
                        iTaskAnno = iAnno;
                        if bArtifact
                            bStart(iTask) = 2; % We are in an artifact
                            iArtifactStart = stampv;
                        else
                            bStart(iTask) = 1; % We found task start so make bStart true for this task
                            iArtifactStart = 0; % Reset artifact start
                        end
                        nArtifactLength = 0;
                    end
                    % Determine the limb here
                    idxFound(iAnno,6) = find(strcmpi(stask.Side,gennames.limbs(2,:)));
                end
            end
            idxFound(iAnno,4) = stampv;
        end
        IMontage = find(idxFound(:,3));   % Montage indexes
        idxStateIndex = find(idxFound(:,7));   % State indexes
        ISide = find(idxFound(:,9));   % Side Indexes
        if isempty(ISide) && ~any(ismember({'na','xltekfile','n/a'},lower(gennames.info(igen).Side)))
            warning(['matlab:' mfilename],'No side information (Left STN, Right STN etc). Default to %s',gennames.info(igen).Side);
            patientInfo.Side  =  gennames.info(igen).Side;
        elseif length(unique(idxFound(ISide,9))) > 1
            error(['matlab:' mfilename],'Different side informations to {%s }.',sprintf(' %s',gennames.brainside{1,unique(ISide)}));
        else
            patientInfo.Side = gennames.brainside{2,idxFound(ISide(1),9)};
        end
        
        OriginalStateInfo = {patientInfo,montage}; % Save original info to restore it in the loop
        pStc = 1;           % pStc: index of the current data file
        nStc = length(stc); % nStc: number of data files
        for iState = 1:nState
            patientInfo = OriginalStateInfo{1};
            montage = OriginalStateInfo{2};
            StateName = gennames.states{idxFound(idxStateIndex(iState),7)};
            patientInfo.State = StateName(1:end-1);
            patientInfo.StateIndex = str2double(StateName(end));
            
            % From state index beginning to the end of state index, which is
            % extracted from clip info
            idxStateRange = idxStateIndex(iState):find(idxFound(:,4)<idxFound(idxStateIndex(iState),8),1,'last');
            if sum(idxFound(idxStateRange,1)) ~= sum(idxFound(idxStateRange,2))
                error(['matlab:' mfilename],'The task labels should be even, check study');
            end
            % Reset important varaibles for every task for this study
            OriginalTaskInfo = {patientInfo,montage};
            OriginalpStc = pStc;
            for iTasks = 1:numel(tasks)
                pStc = OriginalpStc;
                patientInfo = OriginalTaskInfo{1};
                montage = OriginalTaskInfo{2};
                task = regexprep(strtrim(tasks{iTasks}),'[\\/*<>:\| ?"]','-');
                fprintf('\n Task: %s%d_%s>',patientInfo.State,patientInfo.StateIndex,tasks{iTasks});
                % Find the task
                ITaskStartEnd = [find(idxFound(idxStateRange,1)==iTasks) find(idxFound(idxStateRange,2)==iTasks)]+idxStateRange(1)-1;
                if isempty(ITaskStartEnd)
                    msg = sprintf('Pt%d_%s%d, Task %s is not found ',patientInfo.Index,patientInfo.State,patientInfo.StateIndex,task);
                    fprintf(2,'%s',msg); fprintf(efid,'%s\n',msg);
                    continue;
                elseif isscalar(ITaskStartEnd)
                    msg = sprintf('Pt%d_%s%d, corrupted Task %s',patientInfo.Index,patientInfo.State,patientInfo.StateIndex,task);
                    fprintf(2,'%s',msg); fprintf(efid,'%s\n',msg);
                    continue;
                end
                % If processed, do not process again!
                matName = sprintf(gennames.sprintfpatnum,patientNum,patientInfo.Study,patientInfo.Case,patientInfo.Experiment,patientInfo.State,patientInfo.StateIndex,task,patientInfo.Side);
                matPath = fullfile(OutPutFilePath,matName);
%                 if exist(matPath,'file')
%                     fprintf('"%s" exists',matName);
%                     continue;
%                 end
                % Check if montage changed between tasks
                for iMontage = 2:length(IMontage)
                    errCheck = find(IMontage(iMontage) > ITaskStartEnd(:,1) & IMontage(iMontage) < ITaskStartEnd(:,2),1);
                    if ~isempty(errCheck) && ~strncmp(annos(IMontage(iMontage-1)).Text,annos(IMontage(iMontage)).Text,...
                            min(length(annos(IMontage(iMontage-1)).Text),length(annos(IMontage(iMontage)).Text)))
                        warning(['matlab:' mfilename],'Montage Changed between %s and %s for task %s',stamp2time(annos(ITaskStartEnd(errCheck,1)).Stamp,snc,eeg),...
                            stamp2time(annos(ITaskStartEnd(errCheck,2)).Stamp,snc,eeg),task);
                    end
                end
                % Prepare data
                data = repmat(struct('data',[],'timestamps',[],'annotations',[],'limb',[],'time',[]),[1,size(ITaskStartEnd,1)]);
                for iTask = 1:size(ITaskStartEnd,1)
                    fprintf('%d ',iTask);
                    % If this task is less than 1 second then skip it
                    if diff(idxFound(ITaskStartEnd(iTask,:),4))<SampleRate
                        error('This was checked earlier, so this is an error');
                    end
                    % Skip ipsalateral movements
                    data(iTask).limb = gennames.limbs{1,idxFound(ITaskStartEnd(iTask,1),6)};
                    if ~isempty(data(iTask).limb) && ~strcmpi(patientInfo.Side,'BilateralSTN') && strcmpi(patientInfo.Side(1),data(iTask).limb(1))
                        continue; % do not save ipsalateral side
                    end
                    % Compute start and end of task
                    taskStamp = idxFound(ITaskStartEnd(iTask,:),4)'+[-tmExtend tmExtend]*SampleRate;
                    % Scan files to get data
                    kStc = pStc;
                    while kStc <= nStc
                        if kStc > 1 && all(([stc(kStc-1).startstamp stc(kStc-1).endstamp] < taskStamp(1))==[1 0])
                            kStc = kStc - 1;
                        end
                        if all(([stc(kStc).startstamp stc(kStc).endstamp] < taskStamp(1))==[1 0])
                            if taskStamp(2) <= stc(kStc).endstamp
                                datainfo = xltekreaderdfile(fullfile(fPath,stc(kStc).segmentname),'i');
                                channels = intersect(nMaximumChans,union(nMinimumChans,find(~datainfo.ShortedChannel)));
                                [signal,channels,timestamps] = xltekreaderdfile(fullfile(fPath,stc(kStc).segmentname),channels,{taskStamp},'dm');
                            else
                                datainfo = xltekreaderdfile(fullfile(fPath,stc(kStc).segmentname),'i');
                                channelsc = {intersect(nMaximumChans,union(nMinimumChans,find(~datainfo.ShortedChannel)))};
                                datac = {}; stampsc = {};
                                [datac{1},channelsc{1},stampsc{1}] = xltekreaderdfile(fullfile(fPath,stc(kStc).segmentname),channelsc{1},{[taskStamp(1) stc(kStc).endstamp]},'dm');
                                for mStc = kStc+1:nStc
                                    idata = mStc-kStc+1;
                                    if stc(mStc).startstamp > taskStamp(2)
                                        mStc = mStc - 1; %#ok<FXSET>
                                        break;
                                    end
                                    datainfo = xltekreaderdfile(fullfile(fPath,stc(mStc).segmentname),'i');
                                    channelsc{idata} = intersect(nMaximumChans,union(nMinimumChans,find(~datainfo.ShortedChannel)));
                                    if taskStamp(2) > stc(mStc).endstamp
                                        % Data includes this file
                                        [datac{idata},channelsc{idata},stampsc{idata}] = xltekreaderdfile(fullfile(fPath,stc(mStc).segmentname),channelsc{idata},[],'dm'); %#ok<AGROW>
                                    else
                                        % Data ends in this file
                                        [datac{idata},channelsc{idata},stampsc{idata}] = xltekreaderdfile(fullfile(fPath,stc(mStc).segmentname),channelsc{idata},{[stc(mStc).startstamp taskStamp(2)]},'dm'); %#ok<AGROW>
                                    end
                                end
                                chanlen = zeros(size(channelsc));
                                for iij = 1:numel(chanlen)
                                    chanlen = length(channelsc{iij});
                                end
                                if length(unique(chanlen))~=1
                                    % Select the minimum number of channels, some
                                    % irrelevant channels may be kept open
                                    channels = 1:str2double(eeg.Study.Headbox.HB0.NumACChannels);
                                    for idata = 1:length(datac)
                                        channels = intersect(channelsc{idata},channels);
                                    end
                                    for iij = 1:numel(channelsc)
                                        [~,channelsc{iij}] = intersect(channelsc{iij},channels);
                                        datac{iij} = datac{iij}(:,channelsc{iij}); %#ok<AGROW>
                                    end
                                else
                                    channels = unique(cat(1,channelsc{:}),'rows');
                                end
                                signal = cat(1,datac{:});
                                timestamps = cat(1,stampsc{:});
                                if size(channels,1) ~= 1
                                    error(['matlab:' mfilename],'Channel Order Changed During tasks');
                                end
                                kStc = mStc;
                            end
                            break;
                        end
                        kStc = kStc + 1;
                    end
                    pStc = kStc; % data and timestapms are ready here
                    % Check time stamps if there is a break in data or start and end mismatch
                    if ~all(taskStamp == timestamps([1 end])') && ~all(diff(timestamps)==1)
                        error(['matlab:' mfilename],'Timestamp mismatch or there is break in task');
                    end
                    % Find the latest montage
                    iMontage = find(idxFound(1:ITaskStartEnd(iTask,1),3),1,'last');
                    montageAnno = annos(iMontage);
                    % Get channel names and find trigger channel
                    montage.ChannelNames = montageAnno.Data.ChanNames(channels);
                    if patientNum == 1
                        TriggerChannelId = find(strncmpi('DC1',montage.ChannelNames,3),1);
                    else
                        TriggerChannelId = find(strncmpi('MCC',montage.ChannelNames,3),1);
                    end
                    if isempty(TriggerChannelId)
                        msg = sprintf('No Trigger channel found, default trigger channel is DC1 or MCC which is 41st channel?');
                        fprintf(2,'\n%s',msg); fprintf(efid,'%s\n',msg);
                        TriggerChannelId = find(41 == channels,1);
                    end
                    % Correct Voltage levels on trigger channel
                    TriggerData = signal(:,TriggerChannelId)*0.57488;
                    switch lower(task)
                        case {'joshrigidity-ul' 'joshrigidity-ul-w-task'}
                            % Rest is from EndTask to EndRest
                            % TaskType: 1 flexion, 2 extension
                            patientInfo.TaskTypeNames = {'Flexion','Extension'};
                            patientInfo.TriggerNames = {'StartTask','EndTask','EndRest','TaskType'};
                            dTriggerData = ITaskStartEnd(iTask,1):ITaskStartEnd(iTask,2);
                            dTriggerData = [idxFound(dTriggerData,4:5) dTriggerData'];
                            dTriggerData(isinf(dTriggerData(:,1))|~dTriggerData(:,2),:) = []; % Remove deleted and other annotations that have not
                            fstask = find(dTriggerData(2:end-1,2),1,'first');
                            stask = regexpi({annos(dTriggerData(1+fstask:end-1,3)).Text},taskexp,'names'); % extension, flexion no space between tasks
                            stask = cat(1,stask{:});
                            if isempty(stask)
                                break;
                            end
                            stask = {stask.Task;stask.StartEnd};
                            for istask = 1:size(stask,2)-1
                                if strcmpi(stask{2,istask},stask{2,istask+1})
                                    error(['matlab:' mfilename],'%s: Start-End Mismacth "%s" "%s"',stamp2time(annos(dTriggerData(fstask+istask,3)).Stamp,snc,eeg),annos(dTriggerData(fstask+istask+[0 1],3)).Text);
                                end
                                if istask<size(stask,2)-2 && strcmpi(stask{1,istask},stask{1,istask+2})
                                    error(['matlab:' mfilename],'%s: Felexion-Extension Mismacth "%s" "%s"',stamp2time(annos(dTriggerData(fstask+istask,3)).Stamp,snc,eeg),annos(dTriggerData(fstask+istask+[0 2],3)).Text);
                                end
                            end
                            dTriggerData(1,:) = [];
                            rTriggerData = [dTriggerData(1:2:end-2,1) dTriggerData(2:2:end-1,1) dTriggerData(3:2:end,1)];
                            stask = arrayfun(@(arg) find(strcmpi(arg.Text,{'Flexion start','Extension start'})),annos(dTriggerData(1:2:end-2,3)),'UniformOutput',0);
                            if any(cellfun(@isempty,stask))
                                error(['matlab:' mfilename],'%s: Flexion or Extension missing or typing error %s',stamp2time(annos(dTriggerData(1,3)).Stamp,snc,eeg),task);
                            end
                            triggerCodes = [round((rTriggerData-taskStamp(1)+1)/nDownSample) cat(1,stask{:})];
                        case 'force'
                            rTriggerData = round(TriggerData*2);
                            dTriggerData = [0;find(rTriggerData(1:end-1)~=rTriggerData(2:end))]+1;
                            % Exclude the borders close each other less than 30 samples, to remove rising and falling effect
                            dTriggerData(diff(dTriggerData)<30) = [];
                            sectionCodes  = [dTriggerData(1:end-1) dTriggerData(2:end)-1 rTriggerData(dTriggerData(1:end-1))];
                            TriggerStartIndex  = find(sectionCodes(:,3)==1);
                            if TriggerStartIndex(end) < size(sectionCodes,1)
                                TriggerIndex = [TriggerStartIndex(1:end-1) TriggerStartIndex(2:end)-1;TriggerStartIndex(end) size(sectionCodes,1)];
                            else
                                TriggerIndex = [TriggerStartIndex(1:end-1) TriggerStartIndex(2:end)-1];
                            end
                            for iTrigger = 1:size(TriggerIndex,1)
                                if sectionCodes(TriggerIndex(iTrigger,2),3)<14
                                    fTrig = sectionCodes(TriggerIndex(iTrigger,1):TriggerIndex(iTrigger,2),3);
                                    fTrig = find(fTrig>=7,1)-1;
                                    if ~isempty(fTrig)
                                        TriggerIndex(iTrigger,2) = TriggerIndex(iTrigger,1) + fTrig;
                                    end
                                end
                            end
                            % Remove tremor trials
                            TriggerIndex(diff(TriggerIndex,[],2)<2,:) = [];
                            patientInfo.TriggerNames = {'BaseIn','Go','Exit','Success','TrialEnd','Level','ErrorCode'};
                            patientInfo.LevelNames = {'Low','High'};
                            triggerCodes = zeros(size(TriggerIndex,1),length(patientInfo.TriggerNames));
                            for iTrial = 1:size(TriggerIndex,1)
                                fTrig = sectionCodes(TriggerIndex(iTrial,1):TriggerIndex(iTrial,2),3);
                                fTrig = find(fTrig == 7, 1);
                                if ~isempty(fTrig) % Means a success
                                    triggerCodes(iTrial,1:6) = [sectionCodes(TriggerIndex(iTrial,1):TriggerIndex(iTrial,2),1)' ...
                                        sectionCodes(TriggerIndex(iTrial,2),2)  sectionCodes(TriggerIndex(iTrial,1)+1,3)];
                                    triggerCodes(iTrial,7) = 0;
                                else
                                    triggerCodes(iTrial,[1 5]) = [sectionCodes(TriggerIndex(iTrial,1),1) sectionCodes(TriggerIndex(iTrial,2),2)];
                                    triggerCodes(iTrial,6) = sectionCodes(TriggerIndex(iTrial,1)+1,3);
                                    triggerCodes(iTrial,end) = 1;
                                end
                            end
                            triggerCodes(:,6) = (triggerCodes(:,6)-1)/2;
                            triggerCodes(:,1:5) = round(triggerCodes(:,1:5)/nDownSample);
                        case 'keyboard'
                            patientInfo.TriggerNames = {'Start','End','KeySide','ErrorCode'};
                            if patientNum == 1
                                % DW
                                patientInfo.KeySideNames = {'Left','Right'};
                                rTriggerData = round(TriggerData);
                            else
                                % WY&others
                                patientInfo.KeySideNames = {'Left','Right','Other','TwiceLR','TwiceOther'};
                                rTriggerData = round(TriggerData*2);
                                % Error code: 0 success,
                            end
                            dTriggerData = find(rTriggerData(1:end-1)~=rTriggerData(2:end));
                            dTriggerData(diff(dTriggerData)<30) = [];   % Exclude the borders close each other less than 30 samples, to remove rising and falling effect
                            rTriggerData  = rTriggerData(dTriggerData(1:end-1)+1);
                            rTriggerData([false; rTriggerData(1:end-1)==rTriggerData(2:end) & (rTriggerData(1:end-1)==1 | rTriggerData(1:end-1)==2)])  = 4;
                            triggerCodes  = [dTriggerData(1:end-1)+1 dTriggerData(2:end) rTriggerData rTriggerData>2];
                            triggerCodes(:,1:2) = round(triggerCodes(:,1:2)/nDownSample);
                        case 'uncertainty'
                            % cue, go, move onset, target enter, trial end, dir1, dir2, dir3, target dir, error code
                            patientInfo.TriggerNames = {'CenterHold','ShowCue','FillTarget','MoveToTarget','TargetEnter','InterTrialInterval','TrialEnd','Angle1','Angle2','Angle3','TargetAngle','ErrorCode'};
                            if patientNum == 1
                                % sectionCodes = [start end code]
                                % 'Center Hold' = 1,'Cue' = 2,'Target' = 3,'Move Onset' = 4,
                                % 'Target Enter' = 5,'Target exit' = 6, 'Trial End' = 7,
                                % 'Trial end with error',8, 5&6 should not exist
                                % 5&6 appears at the same time for pulse mode success
                                % Convert voltages to codes
                                rTriggerData = round(TriggerData*2);
                                % Find the positions when the codes change
                                dTriggerData = [0;find(rTriggerData(1:end-1)~=rTriggerData(2:end))]+1;
                                % Exclude the borders close each other less than 30
                                % samples, to remove rising and falling effect
                                dTriggerData(diff(dTriggerData)<30) = [];
                                % Compute sectionCodes = [start end code]
                                sectionCodes = [dTriggerData(1:end-1) dTriggerData(2:end)-1 rTriggerData(dTriggerData(1:end-1))];
                                % Find start index, we start the trial with code 1
                                TriggerStartIndex = find(sectionCodes(:,3) == 1);
                                % If we have a start code at the end, exclude it from
                                % trials
                                if TriggerStartIndex(end) < size(sectionCodes,1)
                                    TriggerIndex = [TriggerStartIndex(1:end-1) TriggerStartIndex(2:end)-1;TriggerStartIndex(end) size(sectionCodes,1)];
                                else
                                    TriggerIndex = [TriggerStartIndex(1:end-1) TriggerStartIndex(2:end)-1];
                                end
                                % if the end of the code is less then sucess or error code
                                % then try to find the postion of sucess or error
                                for iTrigger = 1:size(TriggerIndex,1)
                                    rTrial = TriggerIndex(iTrigger,1):TriggerIndex(iTrigger,2);
                                    if all(sectionCodes(rTrial(end),3)~=[7 8]) % Sucess = 7, error = 8
                                        fTrig = sectionCodes(rTrial,3);
                                        fTrig = find(fTrig==8|fTrig==7,1)-1;
                                        if ~isempty(fTrig) % If we can find error or success compute the trial segment again
                                            TriggerIndex(iTrigger,2) = TriggerIndex(iTrigger,1) + fTrig;
                                        end
                                    end
                                    fTrig = [sectionCodes(rTrial,3)==7 sectionCodes(rTrial,3)==8];
                                    if all(any(fTrig)) % Eliminate 8
                                        fTrig = [find(fTrig(:,1),1) find(fTrig(:,2),1)];
                                        if fTrig(1) > fTrig(2)
                                            error(['matlab:' mfilename],'Success after error?');
                                        end
                                        TriggerIndex(iTrigger,2) = TriggerIndex(iTrigger,1) + fTrig(1) -1;
                                    end
                                end
                                % Remove tremor trials
                                TriggerIndex(diff(TriggerIndex,[],2)<2,:) = [];
                                triggerCodes = zeros(size(TriggerIndex,1),length(patientInfo.TriggerNames));
                                % Read Binary File
                                patientInfo.BinaryFile = fullfile(cd(cd([fPath '\..'])),gennames.info(igen).BFPath,[StateName '_' task num2str((iTask+1)/2) '.bin']);
                                bdata = BinaryReadWdbs(patientInfo.BinaryFile);
                                bdata = [bdata.behv];
                                bdata = cat(2,bdata.r);
                                bdata = bdata(:,~bdata(2,:));
                                ibdata = 1;
                                iTrial = 1;
                                while iTrial <= size(TriggerIndex,1)
                                    % First one is always 1, second element is the cue and
                                    % target angle, last one is 7 if sucessful
                                    rTrial = TriggerIndex(iTrial,1):TriggerIndex(iTrial,2); % The trial range
                                    fTrial = sectionCodes(rTrial,3);                        % Trial codes
                                    if fTrial(end) == 7  % Means a success
                                        triggerCodes(iTrial,8:11) = bdata(11:14,ibdata);    % Cue angles
                                        mTrial = fTrial == 6;
                                        if any(mTrial)
                                            fTrial(mTrial) = [];
                                            rTrial(mTrial) = [];
                                        end
                                        mTrial = fTrial>5; % Eliminate exit trial code(6), we can not observe it ideally
                                        fTrial(mTrial) = fTrial(mTrial) - 1;
                                        % Start points
                                        triggerCodes(iTrial,[fTrial;7]) = [sectionCodes(rTrial,1);sectionCodes(TriggerIndex(iTrial,2),2)];
                                        zTrigger = find(~triggerCodes(iTrial,2:6))+1;
                                        if ~isempty(zTrigger)
                                            for izTrigger = length(zTrigger):-1:1
                                                triggerCodes(iTrial,zTrigger(izTrigger)) = triggerCodes(iTrial,zTrigger(izTrigger)+1);
                                            end
                                        end
                                        ibdata = ibdata+1;
                                    else
                                        if iTrial == size(TriggerIndex,1) && ibdata == size(bdata,2)
                                            iTrial = iTrial - 1;
                                        else
                                            mTrial = fTrial >= 6 | ~fTrial;
                                            fTrial(mTrial) = [];
                                            rTrial(mTrial) = [];
                                            triggerCodes(iTrial,[fTrial;6;7]) = [sectionCodes(rTrial,1);sectionCodes(TriggerIndex(iTrial,2),1:2)'];
                                            zTrigger = find(~triggerCodes(iTrial,2:6))+1;
                                            if ~isempty(zTrigger)
                                                for izTrigger = length(zTrigger):-1:1
                                                    triggerCodes(iTrial,zTrigger(izTrigger)) = triggerCodes(iTrial,zTrigger(izTrigger)+1);
                                                end
                                            end
                                            triggerCodes(iTrial,end) = 1;
                                        end
                                    end
                                    iTrial = iTrial+1;
                                end
                            else
                                % cue, go, move onset, target enter, trial end, dir1, dir2, dir3, target dir, error code
                                % sectionCodes = [start end code]
                                % 'Center Hold' = 1,'Cue' = 2,'Target' = 3,'Move Onset' = 4,
                                % 'Target Enter' = 5,'Trial End' = 6, 'Trial end with error',7
                                % 5&6 appears at the same time for pulse mode success
                                % For directions
                                % Code   Voltage    Cue Angle   Target Angle
                                % 8      2          45          45
                                % 9      2.25       165         165
                                % 10     2.5        285         285
                                % 11     2.75       45-165      45
                                % 12     3          45-165      165
                                % 13     3.25       165-285     165
                                % 14     3.5        165-285     285
                                % 15     3.75       45-285      45
                                % 16     4          45-285      285
                                Directions = [8 9 10 11 12 13 14 15 16
                                    45 165 285 45 45 165 165 45 45
                                    -1 -1 -1 165 165 285 285 285 285
                                    -1 -1 -1 -1 -1 -1 -1 -1 -1
                                    45 165 285 45 165 165 285 45 285];
                                % Convert voltages to codes
                                rTriggerData = round(TriggerData*4);
                                % Find the positions when the codes change
                                dTriggerData = [0;find(rTriggerData(1:end-1)~=rTriggerData(2:end))]+1;
                                % Exclude the borders close each other less than 30
                                % samples, to remove rising and falling effect
                                dTriggerData(diff(dTriggerData)<30) = [];
                                % Compute sectionCodes = [start end code]
                                sectionCodes = [dTriggerData(1:end-1) dTriggerData(2:end)-1 rTriggerData(dTriggerData(1:end-1))];
                                % Find start index, we start the trial with code 1
                                TriggerStartIndex = find(sectionCodes(:,3) == 1);
                                % If we have a start code at the end, exclude it from
                                % trials
                                if TriggerStartIndex(end) < size(sectionCodes,1)
                                    TriggerIndex = [TriggerStartIndex(1:end-1) TriggerStartIndex(2:end)-1;TriggerStartIndex(end) size(sectionCodes,1)];
                                else
                                    TriggerIndex = [TriggerStartIndex(1:end-1) TriggerStartIndex(2:end)-1];
                                end
                                % if the end of the code is less then sucess or error code
                                % then try to find the postion of sucess or error
                                for iTrigger = 1:size(TriggerIndex,1)
                                    rTrial = TriggerIndex(iTrigger,1):TriggerIndex(iTrigger,2);
                                    if all(sectionCodes(rTrial(end),3)~=[6 7]) % Sucess = 6, error = 7
                                        fTrig = sectionCodes(rTrial,3);
                                        fTrig = find(fTrig==6|fTrig==7,1)-1;
                                        if ~isempty(fTrig) % If we can find error or success compute the trial segment again
                                            TriggerIndex(iTrigger,2) = TriggerIndex(iTrigger,1) + fTrig;
                                        end
                                    end
                                    fTrig = [sectionCodes(rTrial,3)==6 sectionCodes(rTrial,3)==7];
                                    if all(any(fTrig)) % Eliminate 7
                                        fTrig = [find(fTrig(:,1),1) find(fTrig(:,2),1)];
                                        if fTrig(1) > fTrig(2)
                                            error(['matlab:' mfilename],'Success after error?');
                                        end
                                        TriggerIndex(iTrigger,2) = TriggerIndex(iTrigger,1) + fTrig(1) -1;
                                    end
                                end
                                % Remove tremor trials
                                TriggerIndex(diff(TriggerIndex,[],2)<2,:) = [];
                                triggerCodes = zeros(size(TriggerIndex,1),length(patientInfo.TriggerNames));
                                % Read Binary File
                                patientInfo.BinaryFile = fullfile(cd(cd([fPath '\..'])),gennames.info(igen).BFPath,[StateName '_' task num2str((iTask+1)/2) '.bin']);
                                bdata = BinaryReadWdbs(patientInfo.BinaryFile);
                                bdata = [bdata.behv];
                                bdata = cat(2,bdata.r);
                                bdata = bdata(:,~bdata(2,:));
                                ibdata = 1;
                                iTrial = 1;
                                % Loop on the possible trials
                                while iTrial <= size(TriggerIndex,1)
                                    % First one is always 1, second element is the cue and
                                    % target angle, last one is 6 if sucessful
                                    rTrial = TriggerIndex(iTrial,1):TriggerIndex(iTrial,2); % The trial range
                                    fTrial = sectionCodes(rTrial,3);                        % Trial codes
                                    if fTrial(end) == 6  % Means a success
                                        triggerCodes(iTrial,8:11) = bdata(11:14,ibdata);    % Cue angles
                                        if ~all(Directions(2:end,fTrial(2)==Directions(1,:)) == triggerCodes(iTrial,8:11)')
                                            error(['matlab:' mfilename],'Mismatch between trigger and binary file in terms of cue angle');
                                        end
                                        % Start points
                                        triggerCodes(iTrial,[fTrial([1 3:end]);7]) = [sectionCodes(rTrial([1 3:end]),1);sectionCodes(rTrial(end),2)];
                                        zTrigger = find(~triggerCodes(iTrial,2:6))+1;
                                        if ~isempty(zTrigger)
                                            for izTrigger = length(zTrigger):-1:1
                                                triggerCodes(iTrial,zTrigger(izTrigger)) = triggerCodes(iTrial,zTrigger(izTrigger)+1);
                                            end
                                        end
                                        ibdata = ibdata+1;
                                    else
                                        fTrial = fTrial([1 3:end]);
                                        rTrial = rTrial([1 3:end]);
                                        mTrial = fTrial>6 | fTrial == 0;
                                        fTrial(mTrial) = [];
                                        rTrial(mTrial) = [];
                                        triggerCodes(iTrial,[fTrial;7]) = [sectionCodes(rTrial,1);sectionCodes(TriggerIndex(iTrial,2),2)];
                                        zTrigger = find(~triggerCodes(iTrial,2:6))+1;
                                        if ~isempty(zTrigger)
                                            for izTrigger = length(zTrigger):-1:1
                                                triggerCodes(iTrial,zTrigger(izTrigger)) = triggerCodes(iTrial,zTrigger(izTrigger)+1);
                                            end
                                        end
                                        triggerCodes(iTrial,end) = 1;
                                    end
                                    iTrial = iTrial+1;
                                end
                            end
                            triggerCodes(:,1:7) = round(triggerCodes(:,1:7)/nDownSample);
                            patientInfo.TriggerNames = patientInfo.TriggerNames([1:5 7:end]);
                            triggerCodes = triggerCodes(:,[1:5 7:end]);
                        case 'side2sidetm'
                            % Fill Right Box 1;Fill Left Box 2;Exit Right Box 3;
                            % Exit Left Box 4;Enter Right Box 5;Enter Left Box 6;End No
                            % Error 7;
                            rTriggerData = round(TriggerData*2);
                            % Find the indexes that is not equal to next index for
                            % triggerData
                            dTriggerData = [0;find(rTriggerData(1:end-1)~=rTriggerData(2:end))]+1;
                            % Exclude the borders close each other less than 30 samples, to remove rising and falling effect
                            dTriggerData(diff(dTriggerData)<30) = [];
                            sectionCodes  = [dTriggerData(1:end-1) dTriggerData(2:end)-1 rTriggerData(dTriggerData(1:end-1))];
                            TriggerStartIndex  = find(sectionCodes(:,3)==5 | sectionCodes(:,3) == 6);
                            TriggerIndex = [TriggerStartIndex(1:end-1) TriggerStartIndex(2:end)-1;TriggerStartIndex(end) size(sectionCodes,1)];
                            patientInfo.TriggerNames = {'EnterStartBox','FillTargetBox','ExitStartBox','EnterTargetBox','TrialEnd','Direction','ErrorCode'};
                            patientInfo.DirectionNames = {'Left','Right'};
                            triggerCodes = zeros(size(TriggerIndex,1),length(patientInfo.TriggerNames));
                            for iTrial = 1:size(TriggerIndex,1)
                                Direction = find(sectionCodes(TriggerIndex(iTrial,2),3) == [3 4]);
                                if any(Direction)  && diff(TriggerIndex(iTrial,:)) == 2 % Means a success
                                    triggerCodes(iTrial,1:5) = [sectionCodes(TriggerIndex(iTrial,1):TriggerIndex(iTrial,2),1)
                                        sectionCodes(TriggerIndex(iTrial,[2 2]),2)];
                                    triggerCodes(iTrial,6) = Direction;
                                else
                                    triggerCodes(iTrial,[1 5]) = [sectionCodes(TriggerIndex(iTrial,1),1); sectionCodes(TriggerIndex(iTrial,2),2)];
                                    triggerCodes(iTrial,end) = 1;
                                end
                            end
                            triggerCodes(:,1:5) = round(triggerCodes(:,1:5)/nDownSample);
                        case {'side2sidetr','side2sidetrmouse','side2sidetrsmallpad'}
                            % Todo: Check errors as in uncertainty task
                            % codes
                            % Enter Start Box 2;Show Target Box 4;Fill Target Box 6;
                            % Exit Start Box 8;Enter Target Box 10;End Target 12;End No
                            % Error 14;End Error 16; move left 1, move right 3
                            if patientNum == 1
                                continue;
                            end
                            rTriggerData = round(TriggerData*4);
                            % Error code: 0 success,
                            dTriggerData = [0;find(rTriggerData(1:end-1)~=rTriggerData(2:end))]+1;
                            dTriggerData(diff(dTriggerData)<30) = []; % Exclude the borders close each other less than 30 samples, to remove rising and falling effect
                            sectionCodes  = [dTriggerData(1:end-1) dTriggerData(2:end)-1 rTriggerData(dTriggerData(1:end-1))];
                            TriggerStartIndex  = find(sectionCodes(:,3)==2);
                            if TriggerStartIndex(end) < size(sectionCodes,1)
                                TriggerIndex = [TriggerStartIndex(1:end-1) TriggerStartIndex(2:end)-1;TriggerStartIndex(end) size(sectionCodes,1)];
                            else
                                TriggerIndex = [TriggerStartIndex(1:end-1) TriggerStartIndex(2:end)-1];
                            end
                            for iTrigger = 1:size(TriggerIndex,1)
                                if sectionCodes(TriggerIndex(iTrigger,2),3)<14
                                    fTrig = sectionCodes(TriggerIndex(iTrigger,1):TriggerIndex(iTrigger,2),3);
                                    fTrig = find(fTrig>=14,1)-1;
                                    if ~isempty(fTrig)
                                        TriggerIndex(iTrigger,2) = TriggerIndex(iTrigger,1) + fTrig;
                                    end
                                end
                            end
                            % Remove tremor trials
                            TriggerIndex(diff(TriggerIndex,[],2)<2,:) = [];
                            patientInfo.TriggerNames = {'StartBox','ShowTarget','FillTarget','ExitStart','EnterTarget','EndTarget','TrialEnd','Direction','ErrorCode'};
                            patientInfo.DirectionNames = {'Left','Right'};
                            triggerCodes = zeros(size(TriggerIndex,1),length(patientInfo.TriggerNames));
                            for iTrial = 1:size(TriggerIndex,1)
                                % fTrig = TriggerIndex(iTrial,1):TriggerIndex(iTrial,2);
                                fTrig = sectionCodes(TriggerIndex(iTrial,1):TriggerIndex(iTrial,2),3);
                                fTrig(fTrig == 12) = []; % Remove EndTarget, it would be same as End No Error
                                fTrig = find(fTrig == 14);
                                if ~isempty(fTrig) % Means a success
                                    if diff(TriggerIndex(iTrial,:)) == 5
                                        error(['matlab:' mfilename],'Selection is not in pulse mode');
                                        % triggerCodes(iTrial,1:6) = TriggerIndex(1,iTrial) + dTrialData([1 3:6 6]);
                                    else
                                        triggerCodes(iTrial,1:7) = [sectionCodes(setdiff(TriggerIndex(iTrial,1)+(0:fTrig-1),...
                                            TriggerIndex(iTrial,1)+1),1);sectionCodes(TriggerIndex(iTrial,1)+fTrig-1,2)];
                                    end
                                    triggerCodes(iTrial,8) = ceil(sectionCodes(TriggerIndex(iTrial,1)+1,3)/2);
                                else
                                    triggerCodes(iTrial,[1 7]) = [sectionCodes(TriggerIndex(iTrial,1),1) sectionCodes(TriggerIndex(iTrial,2),2)];
                                    triggerCodes(iTrial,end) = 1;
                                end
                            end
                            triggerCodes(:,1:7) = round(triggerCodes(:,1:7)/nDownSample);
                        otherwise
                            triggerCodes = [];
                    end
                    % Save only annotations that have 'start' and 'end' markers at
                    % the end of them
                    annotations = num2cell(annos(ITaskStartEnd(iTask,1)+find(idxFound(ITaskStartEnd(iTask,1):ITaskStartEnd(iTask,2),5))-1));
                    annotations(cellfun(@(a)isfield(a.Data,'Deleted'),annotations)) = [];
                    for iAnno = 1:length(annotations)
                        annotations{iAnno} = {annotations{iAnno}.Stamp annotations{iAnno}.Text};
                    end
                    annotations = cat(1,annotations{:});
                    data(iTask).time = stamp2time(annotations{1,1},snc,eeg,'yyyy/mm/dd HH:MM:SS.FFF');
                    
                    data(iTask).annotations = annotations;
                    if SampleRate ~= datainfo.SampleRate
                        error(['matlab:' mfilename],'Sample Rate in eeg and erd files are different');
                    end
                    timestamps = timestamps(1:nDownSample:end);
                    % Prepare artifact
                    AStart = find(~cellfun(@isempty,regexpi(annotations(:,2),'^[\t ]*Artifact[\t ]*Start[\t ]*$')));
                    AEnd = find(~cellfun(@isempty,regexpi(annotations(:,2),'^[\t ]*Artifact[\t ]*End[\t ]*$')));
                    if isempty(AStart)
                        if ~isempty(AEnd)
                            data(iTask).artifact = [1 find(timestamps>=annotations{AEnd,1},1)];
                        else
                            data(iTask).artifact = [];
                        end
                    else
                        if isempty(AEnd)
                            data(iTask).artifact = [find(timestamps >= annotations{AStart,1},1) length(timestamps)];
                        else
                            if length(AStart) == length(AEnd)
                                if AStart(1)>AEnd(1)
                                    AStart = [1 AStart'];
                                    AEnd = [AEnd' size(annotations,1)];
                                else
                                    AStart = AStart';
                                    AEnd = AEnd';
                                end
                            else
                                if length(AStart)>length(AEnd)
                                    AEnd = [AEnd' size(annotations,1)];
                                    AStart = AStart';
                                else
                                    AStart = [1 AStart'];
                                    AEnd = AEnd';
                                end
                            end
                            data(iTask).artifact = [cellfun(@(a)find(timestamps>=a,1),annotations(AStart,1)) cellfun(@(a)find(timestamps>=a,1),annotations(AEnd,1))];
                        end
                    end
                    signal = detrend(signal,'constant');
                    if nDownSample ~= 1
                        % Process data here
                        notchFilter = [load('FIR_Notch_Filter_60Hz_Fs_512Hz') load('FIR_Notch_Filter_120Hz_Fs_512Hz') load('FIR_Notch_Filter_180Hz_Fs_512Hz')];
                        LPFilter = load('FIR_LowPass_Filter_220Hz_Fs_1024Hz');
                        signal = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(LPFilter.hL,1,signal,[],0,'fir');
                        signal = signal(1:nDownSample:end,:);
                        signal = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(notchFilter(1).hNotch,1,signal,[],0,'fir');
                        signal = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(notchFilter(2).hNotch,1,signal,[],0,'fir');
                        signal = cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(notchFilter(3).hNotch,1,signal,[],0,'fir');
                        signal(:,TriggerChannelId) = TriggerData(1:nDownSample:end);
                    end
                    patientInfo.Task = task;
                    montage.Reference = montageAnno.Text;
                    data(iTask).data = signal;
                    data(iTask).timestamps = timestamps;
                    if ~isempty(triggerCodes)
                        data(iTask).triggerCodes = triggerCodes;
                    end
                end
                patientInfo.Info.Action = 'create';
                patientInfo.Info.Note = sprintf(['Data is created,tmExtend:%g ' ...
                    ' tmMinimumData:%g nDownSample:%g'],tmExtend,tmMinimumData,nDownSample);
                patientInfo.Info.Time = now;
                % Delete Empty Data
                data(arrayfun(@(a)isempty(a.data),data)) = [];  % Delete unassigned data
                patientInfo.TaskCount = length(data);
                if ~isempty(data)
                    data = orderfields(data);        %#ok<NASGU>
                    patientInfo = orderfields(patientInfo);
                    montage = orderfields(montage);
                    save(matPath,'data','montage','patientInfo');
                else
                    msg = sprintf('No data for %s',matName);
                    fprintf(2,'\n%s',msg); fprintf(efid,'%s\n',msg);
                end
            end
        end
        fprintf('\n');
    end
    fclose(efid);
catch errmsg
    fclose(efid);
    printerror(errmsg);
end

