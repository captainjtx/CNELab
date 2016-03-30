function [data,header] = xltekwriteedf(xlfile,edfile)
% [data,header] = xltek2edf(xlfile,edfile)
% xltekreadedf() - Convert XLTeK file to EDF file
%
% TODO: Write layout f
%
%
% Input:
%    filename - file name of the eeg data
%
% Output:
%    data   - eeg data in (channel, timepoint)
%    header - structured information about the read eeg data
%      header.length - length of header to jump to the first entry of eeg data
%      header.records - how many frames in the eeg data file
%      header.duration - duration (measured in second) of one frame
%      header.channels - channel number in eeg data file
%      header.channelname - channel name
%      header.transducer - type of eeg electrods used to acquire
%      header.physdime - details
%      header.physmin - details
%      header.physmax - details
%      header.digimin - details
%      header.digimax - details
%      header.prefilt - pre-filterization spec
%      header.samplerate - sampling rate
%
% Author: Jeng-Ren Duann, CNL/Salk Inst., 2001-12-21

[~,~,edext] = fileparts(edfile);

% if exist(edfile,'file')
%     anw = input(['Do you want to overwrite ' edfile '?(0 or 1):']);
%     if ~anw
%         return;
%     end
% end

if ~any(strcmpi(edext,{'.edf'}))
    error('Edf file is required');
end

[xldir,xlfnm,xlext] = fileparts(xlfile);
if isdir(fullfile(xldir,xlfnm)) % In case we entered the path
    xldir = fullfile(xldir,xlfnm);
    xlfile = fullfile(xldir,xlfnm);
end
if isempty(xlext)
    xlext = '.eeg';
    xlfile = [xlfile xlext];
end

if nargin < 1
    help xltek2edf;
    return;
end

if ~exist(xlfile,'file')
    error('Invalid xltek file');
end

eeg = xltekreadeegfile(fullfile(xldir,[xlfnm,'.eeg']));
snc = xltekreadsncfile(fullfile(xldir,[xlfnm,'.snc']));
annos = xltekreadentfile(fullfile(xldir,[xlfnm,'.ent']));
[~,iChannels,stamp,info] = xltekreaderdfile(fullfile(xldir,[xlfnm,'.erd']),'a',[],'du');

switch eeg.Study.Headbox.HB0.HBType
    case '17'
        physMax = [8711*ones(40,1);10303200*ones(4,1);102.3000;1023];
        physMin = [-8711*ones(40,1);0*ones(6,1)];
        physDime = [repmat({'uV'},44,1);'%';'bpm'];
        digiMax = [32767*ones(44,1);32704;32704];
        digiMin = -32768*ones(46,1);
    otherwise
        error('Unsupported headbox');
end

fs = str2double(eeg.Study.Headbox.HB0.SamplingFreq);


fid = fopen(edfile,'wb');
try
    fprintf(fid,'%-8s','0');
    if isempty(eeg.Info.Name.MiddleName)
        strTemp = [eeg.Info.Name.LastName ', ' eeg.Info.Name.FirstName];
    else
        strTemp = [eeg.Info.Name.FirstName ', ' eeg.Info.Name.FirstName ' ' eeg.Info.Name.MiddleName];
    end
    fprintf(fid,'%-80s',strTemp);
    strTemp = sprintf('Date: %s Time:%s',converttime(eeg.Study.CreationTime,'o','dd.mm.yy'),converttime(eeg.Study.CreationTime,'o','HH.MM.SS'));
    fprintf(fid,'%-80s',strTemp);
    fprintf(fid,'%-16s',stamp2time(stamp(1),snc,eeg,'DD.MM.YYHH.mm.SS'));
    fprintf(fid,'%-8d',256*(length(iChannels)+1)); % The length of the header
    fprintf(fid,'%-44s',' '); % Skip 44 bytes 
    fprintf(fid,'%-8s','#record'); % The number of records

    windowsize = floor(61440/length(iChannels)/2);
    strTemp =  windowsize/fs;
    fprintf(fid,'%-8g',strTemp); % The Length of records in seconds
    fprintf(fid,'%-4d',length(iChannels));
    
    % Write channel names
    for iAnno = 1:length(annos)
        % find out if this is a deleted annotation
        if isempty(annos(iAnno).Type) || (isfield(annos(iAnno).Data,'Deleted') && strcmp(annos(iAnno).Data.Deleted,'1'))
            continue;
        end
        annotext = strtrim(annos(iAnno).Text);                 % Annotation Text,
        if strncmpi(annotext,'Montage:',8)  % Montage found
            break;
        end
    end
    annotext = strtrim(annos(iAnno).Text);                 % Annotation Text,
    if ~strncmpi(annotext,'Montage:',8)  % Montage found
        error('No Annotation');
    end
    
    strTemp = annos(1).Data.ChanNames(iChannels);
    for iChan = 1:length(strTemp)
        fprintf(fid,'%-16s',strTemp{iChan});
    end
    strTemp = sprintf('%%-%ds',length(iChannels)*80);
    fprintf(fid,strTemp,' ');

    strTemp = physDime(iChannels);
    for iChan = 1:length(strTemp)
        fprintf(fid,'%-8s',strTemp{iChan});
    end
    
    for iChan = 1:length(iChannels)
        fprintf(fid,'%-8d',physMin(iChan));
    end
    for iChan = 1:length(iChannels)
        fprintf(fid,'%-8d',physMax(iChan));
    end
    for iChan = 1:length(iChannels)
        fprintf(fid,'%-8d',digiMin(iChan));
    end
    for iChan = 1:length(iChannels)
        fprintf(fid,'%-8d',digiMax(iChan));
    end
    
    strTemp = sprintf('%%-%ds',length(iChannels)*80);
    fprintf(fid,strTemp,' ');
    for iChan = 1:length(iChannels)
        fprintf(fid,'%-8d',windowsize);
    end
    strTemp = sprintf('%%-%ds',length(iChannels)*32);
    fprintf(fid,strTemp,' ');

    % Now write the data
    [data,iChannels] = xltekreaderdfile(fullfile(xldir,[xlfnm,'.erd']),'a',[],'dr');
    % Read all data
    idfile   = 1;
    while true
        fname = fullfile(xldir,[xlfnm num2str(idfile,'_%04d') '.erd']);
        if exist(fname,'file')
            [nData,nChannels] = xltekreaderdfile(fname,'a',[],'dr');
            if length(nChannels) ~= length(iChannels) || ~all(iChannels==nChannels)
                error('The channels are changed, pruning the study may eliminate this error.');
            end
            data = [data;nData]; %#ok<AGROW>
        else
            break;
        end
    end
    mData = size(data,1);
    for irecord=0:windowsize:mData-1
        if mData-irecord < windowsize
            window = [data(irecord+1:mData,:); zeros(irecord+windowsize-mData,size(data,2))];
        else
            window = data(irecord+(1:windowsize),:);
        end
        fwrite(fid,window/2^info.DiscardBits,'int16');
    end
    irecord = ceil(mData/windowsize);
    fseek(fid,236,'bof');
    fprintf(fid,'%-8d',irecord);

    
catch cerr
    fclose(fid);
    rethrow(cerr);
end
fclose(fid);
return


