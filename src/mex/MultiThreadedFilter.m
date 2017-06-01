function sig = MultiThreadedFilter(b,a,sig)
%MULTITHREADEDFILTER Summary of this function goes here
%   Detailed explanation goes here
if ismac
    sig=UnixMultiThreadedFilter(b,a,sig);
elseif ispc
    sig=WinMultiThreadedFilter(b,a,sig);
end
end

