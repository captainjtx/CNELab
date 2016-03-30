function [depth,timestamps] = xltekdepthfind(data,fsamp,timestamps,thresh)
% [depth,ndepth,ddata,mdata,hdata] = xltekdepthfind(data,fs,thresh)
% Calculate depth information from duration of the pulse

%% Reduce Sampling rate to 500Hz
if fsamp == 2000
    fsamp = 500;
    data = resample(data,fsamp,2000);
    timestamps = timestamps(1:4:end);
end
%% Filter the signal find envelope
[b,a] = butter(2,[20 80]/fsamp*2);
fdata = filtfilt(b,a,data);
fdata([1:40 end:-1:end-39]) = 0;
hdata = abs(hilbert(fdata));
%%
if ~exist('thresh','var')
    %% If threshold was not entred obtain a threshold from user
    figure(1);
    plot([fdata hdata]);
    uiwait(warndlg('Observe the plot to determine the threshold.\nPress Ok','Observe Plot'))
    pause;
    answ = inputdlg('Enter Threshold','The Threshold was not entered');
    thresh = str2double(answ{1});
end
%% Find the impulses and prepare output
tdata = hdata > thresh;
mdata = tdata;
depth = diff(mdata);
ndepth = find(depth == 1);
depth = [ndepth find(depth== -1)];
timestamps = timestamps(depth);
depth = diff(depth,1,2);
% depth = round(50*ddata/fsamp)/10-5;
depth = (5*depth/fsamp)-5;
