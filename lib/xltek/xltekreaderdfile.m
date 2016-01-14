function varargout = xltekreaderdfile(varargin)
% [data,channels,timestamps,info] = xltekreaderdfile(filename,channels,samplerange,datatype)
% information = xltekreaderdfile(filename,'info')
% INPUTS
% FileName   : The full path of erd file.
% Channels   : 
%    - A numeric vector that contains requested channels (1 based index)
%    - 'a' for available channels 
%    - '' for all channels.(default)
% SampleRange   : The range of samples. (default: all samples)
% length(SampleRange) = 1 => First SampleRange samples
% length(SampleRange) = 1 && SampleRange<0, Last SampleRange samples
% length(SampleRange) = 2 => First and last index of the samples [1 based index]
% if it is one element cell with 2 element vector, then the elements are
% the stamps of the data that is requested.
%
% DataType 
%    'dm': Double millivolts (default)
%    'dv': Double volts
%    'du': Double microvolts
%    'dr': Double raw data
%     'i': Integer raw data
%             
% OUTPUTS
% data        : Data requested
% channels    : The obtained channels from function
% timestamps  : The sample index from beginning of data recording.
% Information
%       CreationDate: Date of file creation
%               Name: 'Name'
%         MiddleName: 'MiddleName'
%           LastName: 'LastName'
%                 ID: 'Patient ID'
%         SampleRate: 2000
%        DiscardBits: 6 -> The amount of shift on data
%          DeltaBits: 8 -> The Differential coding bits
%     PysicalChannel: [1x128 double]
%     ShortedChannel: [1x128 double]
%     TimeStampLimit: [2x1 double] -> The time stamp range for this file
%         TOCEntries: 1 -> Number of table of contents (TOC) structre in TOC file
%  You can use Information = XLTEKREADDATA(FileName,'info')
%  You may need Microsoft Visual C++ 2008 Redistributable Package (x86) you
%  may download it from
%  http://www.microsoft.com/downloads/details.aspx?FamilyID=9b2da534-3e03-4391-8a4d-074b9f2bc1bf&displaylang=en
%  See also XLTEKREADENTFILE TIMEZONECONVERT XLTEKWRITENOTE


% Ibrahim ONARAN
% V1.0

%% Use mex file
if nargout 
    [varargout{1:nargout}] = erdread(varargin{:});
    %  Note: CreationDate information in terms of (GMT), we should convert it
    %  to local timezone
    if isstruct(varargout{1})
        varargout{1}.CreationDate = [datestr(varargout{1}.CreationDate/86400+datenum([1970 1 1 0 0 0])), ' GMT'];
    elseif nargout == 4
        varargout{4}.CreationDate = [datestr(varargout{4}.CreationDate/86400+datenum([1970 1 1 0 0 0])), ' GMT'];
    end
    varargout{1} = varargout{1}';
else
     help(mfilename);
end