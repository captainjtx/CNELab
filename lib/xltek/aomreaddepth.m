function depth = aomreaddepth(fname,tmformat)
% depth = aomreaddepth(fname,tmformat)
% Reads AlphaOmega Depth Files
% Which is produced by AlphaOmega software. AlphaOmega is a GUI tool that 
% is written in matlab, and recieves depth information from AlphaOmega
% station and send this information to xltek machine with sinosoid
% impulses. 

% Sample depth file content
% 05/09/2012 10:17:51.136 AM: Start Recording [Depth (mm) DepthId LocalTime]
% 25 000 05/09/2012 10:22:38.717 AM
% 24 000 05/09/2012 10:23:25.524 AM
% ...

if ~exist('tmformat','var')
    tmformat = '[0-9]*/[0-9]*/[0-9]*[ ]*[0-9]*\:[0-9]*\:[0-9]*(\.[0-9]*)? (AM|PM)';
end
fid           = fopen(fname,'rt');
fcontent      = textscan(fid,'%[^\n]');
fclose(fid);  
fcontent      = fcontent{1};
fcontent{1}   = regexp(fcontent{1}(find(fcontent{1}=='[')+1:find(fcontent{1}==']')-1),'(?<head>[^\t ]*)[\t ]*','names');
regexfmt      = {fcontent{1}(4:end).head};
regexfmt(2,:) = {tmformat};
regexfmt      = [sprintf('(?<%s>[^\\t ]*)[\\t ]*','Depth','DepthNo') sprintf('(?<%s>%s)[\\t ]*',regexfmt{:})];
depth         = regexpi(fcontent(2:end),regexfmt,'names');
depth         = cat(1,depth{:});