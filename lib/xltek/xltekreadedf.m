function [data,header] = xltekreadedf(filename)
% [data,header] = xltekreadedf(filename)
% xltekreadedf() - read eeg data in EDF format.
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

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) Jeng-Ren Duann, CNL/Salk Inst., 2001-12-21
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% $Log: xltekreadedf.m,v $
% Revision 1.2  2002/08/12 19:00:57  arno
% errordlg->error
%
% Revision 1.1  2002/04/05 17:36:45  jorn
% Initial revision
%
% 03-21-02 editing header, add help -ad 

if nargin < 1
    help xltekreadedf;
    return;
end;
fp = fopen(filename,'r','ieee-le');
if fp == -1,
    error('File not found ...!');
end
try
    hdr = char(fread(fp,256,'uchar')');
    header.length = str2num(hdr(185:192)); %#ok<*ST2NM>
    header.records = str2num(hdr(237:244));
    header.duration = str2num(hdr(245:252));
    header.channels = str2num(hdr(253:256));
    header.channelname = cellstr(char(fread(fp,[16,header.channels],'char')'));
    header.channelname = strtrim(header.channelname);
    header.transducer = char(fread(fp,[80,header.channels],'char')');
    header.physdime = char(fread(fp,[8,header.channels],'char')');
    header.physmin = str2num(char(fread(fp,[8,header.channels],'char')'));
    header.physmax    = str2num(char(fread(fp,[8,header.channels],'char')'));
    header.digimin    = str2num(char(fread(fp,[8,header.channels],'char')'));
    header.digimax    = str2num(char(fread(fp,[8,header.channels],'char')'));
    header.prefilt    = char(fread(fp,[80,header.channels],'char')');
    header.windowsize = str2num(char(fread(fp,[8,header.channels],'char')'));
    header.samplerate = floor(header.windowsize(1)/header.duration);
    fseek(fp,header.length,-1);
    data = cell(header.channels,header.records);
    for i=1:header.records
        for c=1:header.channels
            data{c,i} = fread(fp,header.windowsize(c),'int16');
        end
    end
    for c=1:header.channels
        data{c,1} = (cat(1,data{c,:})-header.digimin(c))/(header.digimax(c)-header.digimin(c))*(header.physmax(c) - header.physmin(c))+header.physmin(c);
    end
    data = cat(2,data{:,1});
catch last_error 
    fclose(fp);
    rethrow(last_error);
end
fclose(fp);
