function eeg=filter_symmetric(b,a,eeg,ext,phs,ftyp)
% function eeg=filter_symmetric(b,a,eeg,ext,phs,ftyp);
% extends the signal on the edges symetrically with ext number of samples:
% [eeg(ext+1) ... eeg(2) eeg eeg(end-1) ... eeg(end-ext)]
% b and a are filter parameters.
% phs if set to 0 then zero phase filtering from left/right
% ftyp if set to 'fir' then uses convolution with the impulse response
% given by b. if set to 'iir' then uses filter function to compute output.
%
% Written by Firat Ince. 2008-2009.
% Modified by Sami Arica. 01/19/2009.


if nargin<6
    ftyp='iir';
end
if nargin<5
    phs=1;
end
if (isempty(ext)&&(strcmpi(ftyp, 'fir')))
    ext = floor((length(b)-1)/2);
end

if (isempty(a)) || (strcmpi(ftyp, 'fir'))
    a=1;
end
if phs~=0
    phs=1;
end

[eeg,ext]=symtrcextend(eeg,ext);

if strcmpi(ftyp, 'iir')
    if ~phs
        eeg=filtfilt(b,a,eeg);
    else
        eeg=filter(b,a,eeg);
    end
elseif strcmpi(ftyp, 'fir')
    if ~phs
        eeg=conv2(eeg, b(:),'same');
    else
        eeg=conv(eeg,b(:));
    end
end
N=size(eeg,1);
eeg=eeg([ext+1:N-ext],:);

function [eeg,ext]=symtrcextend(eeg,ext)
[N,T]=size(eeg);
if ext>0
    leftSide=[ext+1:-1:2];
    rightSide=[N-1:-1:N-ext];
    eeg=[eeg(leftSide,:); eeg; eeg(rightSide,:)];
else
    ext=0;
end