clear variables
%% Prepare data for reading
% The Filename path, do not put extensions, xltek functions will determine
% the default extensions.
[fparts{1:3}] = fileparts(which(mfilename));
fname = fullfile(fparts{1},'TestData\TestStudy\TestSignal');
%% Read data
% %% Read info and show it
% info = xltekdataread(fname,'i');
% %% Read All Info 
% files = dir([fname '*.erd']);
% infoall = arrayfun(@(a)erdread([fileparts(fname),filesep,a.name],'info'),files);

%% Read Annotations
% Find Montage Channels
tic
montage = xltekreadentfile(fname); % Montage:UMII - Bipolar, External
montage = montage(6);
etm = toc;
fprintf('Read Monatge Annotation: %g s\n',etm);
%% Read Data from a data file
channels = [7 8 20];
datalims = [1001 9998];
tic;
[erddata,channels,timestamp,info] = xltekreaderdfile([fname '_001'],channels,datalims-datalims(1)+1,'dm');
%%Syncronize time
snc    = xltekreadsncfile(fname);
syncPos = stamp2time(timestamp(1),snc,eeg,'m');

%%
etm(2) = toc;
fprintf('Read Erd File: %g s, Total Loading Time: %g s\n',etm(2),sum(etm));
tic;
[data,fseekpos,timespan,dbsinfo] = xltekreadtxt([fname '.txt'],[datalims(1) diff(datalims)+1],channels);
etm(3) = toc;
fprintf('Read Txt File: %g s, Total Loading Time: %g s\n',etm(3),sum(etm));

channames = montage(end).Data.ChanNames;
%% Scale data
rat = (erddata(:,3)./ data(:,3));
rat(isnan(rat)) = [];
rat = median(rat);
if rat > 2 
    rat    = floor(rat);
end
erddata = erddata/rat;
%% Change x axis to time 
figure(1)
xlims = rem(syncPos,1) + datalims/info.SampleRate/86400;
xdata = linspace(xlims(1),xlims(2),size(erddata,1));
plot(xdata,[erddata(:,2)-erddata(:,1),erddata(:,end)/5]);
ylabel(sprintf('Scaled by %g (mV)',rat))
axis tight;
legend([channames{channels(2)} ' - ' channames{channels(1)}],[channames{channels(end)} '/5'])
datetick('x','HH:MM:SS','keeplimits')
axis tight; zoom('reset')
title(sprintf('Data from binary file\n%s %s %s %s',info.FirstName,info.MiddleName,info.LastName,datestr(syncPos)))
%% Change x axis to time 
figure(2);
xlims = rem(datenum(timespan{1}),1)+datalims/dbsinfo{6,2}/86400;
xdata = linspace(xlims(1),xlims(2),size(data,1));
plot(xdata,[data(:,2)- data(:,1), data(:,end)/5]);
ylabel('Amplitude (mV)')
axis tight;
legend([dbsinfo{end,2}{channels(2)} ' - ' dbsinfo{end,2}{channels(1)}],[dbsinfo{end,2}{channels(end)} '/5'])
datetick('x','HH:MM:SS','keeplimits')
axis tight; zoom('reset')
title(sprintf('Data From Text file\n%s %s',dbsinfo{5,2},timespan{1}))

