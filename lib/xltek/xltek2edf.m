function [data,header] = xltek2edf(xlfile,edfile)
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
% snc = xltekreadsncfile(fullfile(xldir,[xlfnm,'.snc']));
annos = xltekreadentfile(fullfile(xldir,[xlfnm,'.ent']));

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



[edfdir,edfname,header.TYPE] = fileparts(edfile);
if ~any(strcmpi(header.TYPE,{'.edf','.bdf'}))
    % select file format
    % HDR.TYPE='GDF';
    %HDR.TYPE='BDF';
    %HDR.TYPE='CFWB';
    %HDR.TYPE='CNT';
    error('Edf or bdf file is required');
end

% if exist(edfile,'file')
%     anw = input(['Do you want to overwrite ' edfile '?(0 or 1):']);
%     if ~anw
%         return;
%     end
% end



% set Filename
header.FileName = fullfile(edfdir,[edfname header.TYPE]);
header.TYPE = upper(header.TYPE(2:end));

% description of recording device
header.Manufacturer.Name           = 'CNEL-UH';
header.Manufacturer.Model          = mfilename;
header.Manufacturer.Version        = '1.0';
header.Manufacturer.SerialNumber   = '00000001';

%% Get the channel information
[data,iChannels] = xltekreaderdfile(fullfile(xldir,[xlfnm,'.erd']),'a',1,'dr');

% recording identification, max 80 char.
header.RID = 'TestFile 001'; %StudyID/Investigation [consecutive number];
header.REC.Hospital   = 'CNEL University of Houston';
header.REC.Techician  = 'Ibrahim Onaran';
header.REC.Equipment  = 'XLTeK';
header.REC.IPaddr	   = [127,0,0,1];	% IP address of recording system
if isempty(eeg.Info.Name.MiddleName)
    header.Patient.Name   = [eeg.Info.Name.FirstName ' ' eeg.Info.Name.LastName];
else
    header.Patient.Name   = [eeg.Info.Name.FirstName ' ' eeg.Info.Name.MiddleName ' ' eeg.Info.Name.LastName];
end

% header.Patient.Id     = eeg.Info.Admin.ID;
% header.Patient.Birthday = datevec(converttime(eeg.Info.Personal.BirthDate,'o','m'));
% header.Patient.Weight = str2double(eeg.Info.Personal.Weight); 	% undefined
% header.Patient.Height = str2double(eeg.Info.Personal.Height); 	% undefined
% header.Patient.Sex    = eeg.Info.Personal.Gender(1); 	% 0: undefined,	1: male, 2: female
% header.Patient.Impairment.Heart = 0;  %	0: unknown 1: NO 2: YES 3: pacemaker
% header.Patient.Impairment.Visual = 0; %	0: unknown 1: NO 2: YES 3: corrected (with visual aid)
% header.Patient.Smoking = 0;           %	0: unknown 1: NO 2: YES
% header.Patient.AlcoholAbuse = 0; 	   %	0: unknown 1: NO 2: YES
% header.Patient.DrugAbuse = 0; 	   %	0: unknown 1: NO 2: YES
% header.Patient.Handedness = 0; 	   % 	unknown, 1:left, 2:right, 3: equal

% recording time [YYYY MM DD hh mm ss.ccc]
header.T0 = clock;

% number of channels
header.NS = size(data,2);

% % % Duration of one block in seconds
header.SampleRate = str2double(eeg.Study.Headbox.HB0.SamplingFreq);
header.Dur = 0.5; % HDR.SPR/HDR.SampleRate;
header.SPR = header.Dur*header.SampleRate;

% % % Samples within 1 block
% % HDR.AS.SPR = 3*[1000;100;200;100;20;0];	% samples per block; 0 indicates a channel with sparse sampling
% % %HDR.AS.SampleRate = [1000;100;200;100;20;0];	% samplerate of each channel


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
% channel identification, max 80 char. per channel
header.Label=annos(iAnno).Data.ChanNames(iChannels);
for iLabel = 1:length(header.Label)
    header.Label{iLabel} = sprintf('%-8s',header.Label{iLabel});
end
% % % Transducer, mx 80 char per channel
% % HDR.Transducer = {'Ag-AgCl ';'Airflow ';'xyz     ';'        ';'        ';'Thermome'};

% % % % define datatypes (GDF only, see GDFDATATYPE.M for more details)
% % % HDR.GDFTYP = 3*ones(1,HDR.NS);

% define scaling factors
header.PhysMax = physMax(iChannels);
header.PhysMin = physMin(iChannels);
header.DigMax  = digiMax(iChannels);
header.DigMin  = digiMin(iChannels);
% HDR.FLAG.UCAL = 1, data x is already converted to internal (usually integer) values (no rescaling within swrite);
% HDR.FLAG.UCAL = 0, data x will be converted from physical to digital values within swrite.
header.FLAG.UCAL = 1;
% Define filter settings
header.Filter.Lowpass = NaN(1,header.NS);
header.Filter.Highpass = NaN(1,header.NS);
header.Filter.Notch = zeros(1,header.NS);
% define sampling delay between channels
header.TOffset = zeros(1,header.NS);


% define physical dimension
header.PhysDim = physDime(iChannels);
header.Impedance = NaN(1,header.NS);         % electrode impedance (in Ohm) for voltage channels
header.fZ = NaN(1,header.NS);                % probe frequency in Hz for Impedance channel

% t = [100:100:size(data,1)]';
% %HDR.NRec = 100;
% HDR.VERSION = 2.22;        % experimental
% HDR.EVENT.POS = t;
% HDR.EVENT.TYP = t/100;


% if 0,
% HDR.EVENT.CHN = repmat(0,size(t));
% HDR.EVENT.DUR = repmat(1,size(t));
% HDR.EVENT.VAL = repmat(NaN,size(t));
% %% This defines the sparse samples in channel 6
% ix = 6:5:60;
% HDR.EVENT.CHN(ix) = 6;
% HDR.EVENT.VAL(ix) = 373+round(100*rand(size(ix))); % HDR.EVENT.TYP(ix) becomes 0x7fff
% ix = 8;
% %% The following sparse samples are not valid because channel 5 is not defined as sparse (see HDR.AS.SPR)
% HDR.EVENT.CHN(ix) = 5; % not valid because #5 is not sparse sampleing
% HDR.EVENT.VAL(ix) = 374;
% end;

% if 0, %try,
% 	mexSSAVE(HDR,x);
% else %catch
header = sopen(header,'w');
[data,iChannels] = xltekreaderdfile(fullfile(xldir,[xlfnm,'.erd']),'a',[],'du');
idfile = 1;
while true
    fname = fullfile(xldir,[xlfnm num2str(idfile,'_%04d') '.erd']);
    if exist(fname,'file')
        [nData,nChannels] = xltekreaderdfile(fname,'a',[],'du');
        if length(nChannels) ~= length(iChannels) || ~all(iChannels==nChannels)
            error('The channels are changed, pruning the study may eliminate this error.');
        end
        data = [data;nData]; %#ok<AGROW>
    else
        break;
    end
end
header = swrite(header,data);
header = sclose(header);
