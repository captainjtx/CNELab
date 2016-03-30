function cdata = icon(Type, how)
% ICON Icon library


% The image data. matrix or m-by-n-by-3 array
% A matrix or 3D array of values specifying the color of each rectangular area 
% defining the image. image(C) assigns the values of C to CData. 
defaultcolor = ColorMap(17);
W = 16;
cdata(1:W,1:W,1) = defaultcolor(1);
cdata(1:W,1:W,2) = defaultcolor(2);
cdata(1:W,1:W,3) = defaultcolor(3);

ColorCode = 17 * ones(W,W);

if nargin < 1, return; end
switch lower(Type)
    case 'clock'
        ColorCode = [17 17 17 17 17 12 12 12 12 12 17 17 17 17 17 17;17 17 17 17 12 17 17 17 17 17 12 12 17 17 17 17;17 17 17 12 17 7 7 7 7 4 17 17 12 17 17 17;17 17 12 17 7 3 7 4 4 7 4 17 17 12 17 17;17 12 5 7 3 7 1 4 4 4 4 4 16 17 12 17;17 12 7 3 3 7 1 4 4 4 4 16 4 17 12 17;12 7 3 3 7 1 4 4 17 4 16 4 4 17 17 12;12 7 3 3 7 4 17 17 17 16 17 4 4 17 17 12;7 3 3 3 3 3 7 16 12 16 16 16 16 17 11 12;17 7 3 3 3 7 17 17 16 17 4 4 4 17 1 12;17 12 7 3 7 4 4 17 17 4 4 4 4 17 1 12;17 12 1 7 4 4 4 4 4 4 4 4 17 1 12 17;17 17 12 1 17 4 4 4 4 4 4 17 1 12 17 17;17 17 17 12 1 17 4 4 4 17 17 1 12 17 17 17;17 17 17 17 12 1 17 11 17 1 12 12 17 17 17 17;17 17 17 17 17 12 12 12 12 12 17 17 17 17 17 17];
    case 'configure'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 16 16 16 16 16 16 17 13 13;17 17 17 17 17 17 16 5 5 5 5 5 5 16 13 13;17 17 17 17 17 16 5 16 5 5 5 5 5 16 13 13;16 16 16 16 16 5 16 5 16 5 5 5 5 16 13 13;16 1 1 16 5 16 5 16 5 16 5 5 5 16 13 13;16 1 16 5 16 1 16 5 16 5 16 16 16 17 13 13;16 1 16 16 1 1 1 16 5 16 9 16 17 17 17 13;16 1 1 1 1 1 1 1 16 9 9 16 17 2 2 17;16 1 1 1 1 1 1 1 1 1 9 9 9 9 2 17;16 1 16 16 1 16 16 16 16 16 1 2 2 9 9 17;16 1 1 1 1 1 1 1 1 1 2 16 17 17 17 9;16 1 16 16 1 16 16 16 16 16 2 2 17 17 17 9;16 1 1 1 1 1 1 1 1 1 1 2 2 2 9 17;16 16 16 16 16 16 16 16 16 16 16 16 2 9 2 17;17 17 17 17 17 17 17 17 17 17 17 9 9 17 2 2];
    case 'configuration'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 16 16 16 16 16 16 17 13 13;17 17 17 17 17 17 16 5 5 5 5 5 5 16 13 13;17 17 17 17 17 16 5 16 5 5 5 5 5 16 13 13;16 16 16 16 16 5 16 5 16 5 5 5 5 16 13 13;16 1 1 16 5 16 5 16 5 16 5 5 5 16 13 13;16 1 16 5 16 1 16 5 16 5 16 16 16 17 13 13;16 1 16 16 1 1 1 16 5 16 1 16 17 17 17 13;16 1 1 1 1 1 1 1 16 1 1 16 17 17 17 17;16 1 1 1 1 1 1 1 1 1 1 16 17 17 17 17;16 1 16 16 1 16 16 16 16 16 1 16 17 17 17 17;16 1 1 1 1 1 1 1 1 1 1 16 17 17 17 17;16 1 16 16 1 16 16 16 16 16 1 16 17 17 17 17;16 1 1 1 1 1 1 1 1 1 1 16 17 17 17 17;16 16 16 16 16 16 16 16 16 16 16 16 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'copy'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;16 16 16 16 16 16 17 17 17 17 17 17 17 17 17 17;16 1 1 1 1 16 16 17 17 17 17 17 17 17 17 17;16 1 1 1 1 16 1 16 17 17 17 17 17 17 17 17;16 1 16 16 1 16 13 13 13 13 13 13 17 17 17 17;16 1 1 1 1 1 13 1 1 1 1 13 13 17 17 17;16 1 16 16 16 16 13 1 1 1 1 13 1 13 17 17;16 1 1 1 1 1 13 1 16 16 1 13 13 13 13 17;16 1 16 16 16 16 13 1 1 1 1 1 1 1 13 17;16 1 1 1 1 1 13 1 16 16 16 16 16 1 13 17;16 16 16 16 16 16 13 1 1 1 1 1 1 1 13 17;17 17 17 17 17 17 13 1 16 16 16 16 16 1 13 17;17 17 17 17 17 17 13 1 1 1 1 1 1 1 13 17;17 17 17 17 17 17 13 13 13 13 13 13 13 13 13 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'help'
        ColorCode = [17 17 17 16 16 16 16 16 16 16 16 16 16 16 17 17;17 17 16 1 1 1 2 1 1 1 2 1 1 1 16 17;17 17 16 1 2 1 1 1 2 1 1 1 2 1 16 12;17 17 16 1 1 1 1 13 13 13 13 1 1 1 16 12;17 17 16 1 2 1 13 13 2 5 13 13 2 1 16 12;17 17 16 1 1 1 13 12 1 1 13 13 1 1 16 12;17 17 16 1 2 1 1 1 2 12 13 1 2 1 16 12;17 17 16 1 1 1 2 1 12 13 1 1 1 1 16 12;17 17 16 1 2 1 1 1 13 1 1 1 2 1 16 12;17 17 16 1 1 1 2 1 1 1 2 1 1 1 16 12;17 17 16 1 2 1 1 1 13 13 1 1 2 1 16 12;17 17 16 1 1 1 2 1 2 1 2 1 1 1 16 12;17 17 17 16 16 16 16 16 16 16 1 1 16 16 12 17;17 17 17 17 12 12 12 12 12 12 16 2 16 12 17 17;17 17 17 17 17 17 17 17 17 17 17 16 16 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 16 17 17 17];
    case 'letter'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;17 16 12 12 12 12 12 12 12 12 12 12 12 12 12 16;17 16 17 17 17 17 17 17 17 17 17 17 17 17 17 16;17 16 17 17 17 17 17 17 17 17 17 17 17 17 17 16;17 16 17 16 16 17 16 16 16 16 17 17 17 17 17 16;17 16 17 17 17 17 17 17 17 17 17 17 17 17 17 16;17 16 17 16 16 17 16 16 16 16 16 16 17 17 17 16;17 16 17 17 17 17 17 17 17 17 17 17 17 17 17 16;17 16 17 16 16 17 16 16 16 16 16 16 17 17 17 16;17 16 17 17 17 17 17 17 17 17 17 17 17 17 17 16;17 16 17 16 16 17 16 16 16 16 16 16 16 17 17 16;17 16 17 17 17 17 17 17 17 17 17 17 17 17 17 16;17 16 17 16 16 17 16 16 16 16 16 16 16 17 17 16;17 16 17 17 17 17 17 17 17 17 17 17 17 17 17 16;17 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
    case 'new'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 16 16 16 16 16 16 16 16 17 17 17 17 17 17;17 17 16 1 1 1 1 1 1 16 16 17 17 17 17 17;17 17 16 1 1 1 1 1 1 16 1 16 17 17 17 17;17 17 16 1 1 1 1 1 1 16 16 16 16 17 17 17;17 17 16 1 1 1 1 1 1 1 1 1 16 17 17 17;17 17 16 1 1 1 1 1 1 1 1 1 16 17 17 17;17 17 16 1 1 1 1 1 1 1 1 1 16 17 17 17;17 17 16 1 1 1 1 1 1 1 1 1 16 17 17 17;17 17 16 1 1 1 1 1 1 1 1 1 16 17 17 17;17 17 16 1 1 1 1 1 1 1 1 1 16 17 17 17;17 17 16 1 1 1 1 1 1 1 1 1 16 17 17 17;17 17 16 1 1 1 1 1 1 1 1 1 16 17 17 17;17 17 16 16 16 16 16 16 16 16 16 16 16 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'open'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 16 16 16 17 17 17 17;17 17 17 17 17 17 17 17 16 17 17 17 16 17 16 17;17 17 17 17 17 17 17 17 17 17 17 17 17 16 16 17;17 16 16 16 17 17 17 17 17 17 17 17 16 16 16 17;16 2 17 2 16 16 16 16 16 16 16 17 17 17 17 17;16 17 2 17 2 17 2 17 2 17 16 17 17 17 17 17;16 2 17 2 17 2 17 2 17 2 16 17 17 17 17 17;16 17 2 17 2 16 16 16 16 16 16 16 16 16 16 16;16 2 17 2 16 6 6 6 6 6 6 6 6 6 16 17;16 17 2 16 6 6 6 6 6 6 6 6 6 16 17 17;16 2 16 6 6 6 6 6 6 6 6 6 16 17 17 17;16 16 6 6 6 6 6 6 6 6 6 16 17 17 17 17;16 16 16 16 16 16 16 16 16 16 16 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'pen'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 16 16 16 17;17 17 17 17 17 17 17 17 17 17 17 12 16 15 15 16;17 17 17 17 17 17 17 17 17 17 17 16 2 16 16 12;17 17 17 17 17 17 17 17 17 17 12 16 2 12 16 17;17 17 17 17 17 17 17 17 17 17 16 2 5 16 12 17;17 17 17 17 17 17 17 17 17 12 16 2 12 16 17 17;17 17 17 17 17 17 17 17 17 16 2 5 16 17 17 17;17 17 17 17 17 17 17 17 17 16 2 12 16 17 17 17;17 17 17 17 17 17 17 17 12 2 5 16 17 17 17 17;17 17 17 17 17 17 17 17 16 2 12 16 17 17 17 17;17 17 17 17 17 17 17 17 16 16 16 17 17 17 17 17;17 17 17 17 17 17 17 17 16 16 17 17 17 17 17 17;16 16 16 16 16 16 16 16 16 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'picture'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;17 16 2 17 2 17 2 17 2 17 2 17 2 17 2 16;17 16 17 2 17 2 17 2 17 2 12 16 16 12 17 16;17 16 2 17 2 17 2 17 2 17 16 6 6 16 2 16;17 16 17 2 17 2 17 2 17 2 16 6 6 16 17 16;17 16 2 17 2 17 2 17 2 17 12 16 16 12 2 16;17 16 17 2 17 2 17 2 17 2 17 2 17 2 17 16;17 16 2 17 2 17 16 16 2 17 2 17 2 17 2 16;17 16 17 2 17 16 12 12 16 2 16 16 17 2 17 16;17 16 2 17 16 12 12 16 12 16 5 5 16 17 2 16;17 16 17 16 12 12 12 12 12 12 16 5 5 16 17 16;17 16 16 12 12 16 12 12 16 12 12 16 5 5 16 16;17 16 12 12 12 12 16 12 12 16 12 12 16 5 5 16;17 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'plot'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 16 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 16 17 17 17 17 17 17 17 17 17 17 17 17 9 9;17 16 17 17 17 17 17 17 11 11 17 17 17 17 9 9;17 16 17 17 17 17 17 17 11 11 17 17 17 17 9 17;17 16 17 17 17 17 17 11 17 17 11 17 17 9 17 17;17 16 17 17 17 17 11 17 17 17 17 11 17 9 17 17;17 16 17 17 17 11 17 17 17 17 17 17 9 17 17 17;17 16 17 11 11 17 17 17 17 17 17 9 17 11 17 17;17 16 17 11 11 17 17 17 17 17 9 17 17 17 11 11;17 16 17 17 17 17 17 17 17 9 17 17 17 17 11 11;17 16 17 9 9 17 17 9 9 17 17 17 17 17 17 17;17 16 17 9 9 9 9 9 9 17 17 17 17 17 17 17;17 16 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'progress'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 15 17 17 15 17 17 17 17 15 17 17 15 17 17;17 15 17 17 15 17 17 17 17 17 17 15 17 17 15 17;15 17 17 15 17 17 17 17 17 17 17 17 15 17 17 15;15 17 17 15 17 17 17 17 17 17 17 17 15 17 17 15;17 15 17 17 15 17 17 17 17 17 17 15 17 17 15 17;17 17 15 17 17 15 17 17 17 17 15 17 17 15 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;16 16 4 1 4 12 17 12 16 1 1 1 1 1 16 17;16 16 17 4 17 12 4 1 16 12 12 12 12 1 16 17;16 16 12 17 4 12 1 17 16 1 1 1 1 1 16 17;16 1 16 12 17 12 12 16 15 16 12 12 1 1 16 17;16 1 1 16 16 16 16 11 1 15 16 1 1 1 16 17;16 1 1 1 1 1 1 1 11 1 15 16 1 1 16 17;16 16 16 16 16 16 16 16 16 11 15 16 16 16 16 17;17 17 17 17 17 17 17 17 17 17 16 16 17 17 17 17];
    case 'reply'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 16 16 16 16 16 17 17 17 17 17 17 17 17 17;17 16 16 16 16 16 16 16 16 17 17 17 17 17 17 17;16 16 16 16 16 16 16 17 16 17 17 17 17 17 14 17;16 16 16 16 16 17 17 16 17 17 17 17 17 17 17 14;16 16 16 17 17 17 16 16 17 17 17 17 17 17 17 14;16 16 16 17 17 17 17 17 16 17 17 17 14 17 17 14;16 16 16 16 17 17 17 16 17 17 17 14 14 17 14 14;17 16 16 17 17 17 17 16 17 17 14 14 14 14 14 14;17 17 16 17 16 16 16 17 17 14 14 14 14 14 14 17;17 16 16 17 17 16 17 17 17 17 14 14 14 14 17 17;16 17 17 16 16 16 17 17 17 17 17 14 14 17 17 17;16 17 17 17 17 17 16 17 17 17 17 17 14 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'run'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 13 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 13 13 17 17 17 17;17 17 17 17 17 17 17 17 17 17 13 13 13 17 17 17;17 17 17 17 17 17 17 17 17 17 13 13 13 13 17 17;17 17 17 17 17 17 17 17 17 17 13 13 13 13 13 17;17 17 17 17 17 17 17 17 17 17 13 13 13 13 17 17;17 17 17 17 17 17 17 17 17 17 13 13 13 17 17 17;17 17 17 17 17 17 17 17 17 17 13 13 17 17 17 17;17 17 17 17 17 17 17 17 17 17 13 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'runasmaster'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 12 15 15 15 15 12 17 17 17 17 17 17;17 17 17 17 15 15 15 15 15 15 17 17 17 17 17 17;17 17 17 17 14 12 14 14 15 15 12 17 17 17 17 17;17 17 17 17 16 5 16 2 15 15 12 17 17 17 17 17;17 17 17 6 14 2 14 1 15 15 12 17 17 17 17 17;17 17 12 17 14 16 1 17 17 15 14 17 17 17 17 17;17 17 17 16 16 14 12 1 16 14 17 17 13 17 17 17;17 17 17 17 6 16 1 1 16 17 17 17 13 13 17 17;17 17 17 17 12 1 2 6 16 17 17 17 13 13 13 17;17 17 17 17 12 14 6 12 12 17 17 17 13 13 13 13;17 17 12 12 1 16 16 14 14 16 16 17 13 13 13 17;17 12 14 1 1 14 14 2 14 14 12 12 13 13 17 17;17 17 17 17 17 17 17 17 17 17 17 17 13 17 17 17];
    case 'save'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 16 16 16 16 16 16 16 16 16 16 16 16 16 16 17;17 16 6 16 17 17 17 17 17 17 17 17 16 17 16 17;17 16 6 16 17 17 17 17 17 17 17 17 16 16 16 17;17 16 6 16 17 17 17 17 17 17 17 17 16 6 16 17;17 16 6 16 17 17 17 17 17 17 17 17 16 6 16 17;17 16 6 16 17 17 17 17 17 17 17 17 16 6 16 17;17 16 6 16 17 17 17 17 17 17 17 17 16 6 16 17;17 16 6 6 16 16 16 16 16 16 16 16 16 6 16 17;17 16 6 6 6 6 6 6 6 6 6 6 6 6 16 17;17 16 6 6 16 16 16 16 16 16 16 16 16 6 16 17;17 16 6 6 16 16 16 16 16 16 17 17 16 6 16 17;17 16 6 6 16 16 16 16 16 16 17 17 16 6 16 17;17 16 6 6 16 16 16 16 16 16 17 17 16 6 16 17;17 17 16 16 16 16 16 16 16 16 16 16 16 16 16 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'test'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 11 11 11 11 11 17 17 17 17 17 17;17 17 17 17 17 11 17 17 17 11 17 17 17 17 17 17;17 17 17 17 17 11 17 17 17 11 17 17 17 17 17 17;17 17 17 17 17 11 17 17 17 11 17 17 17 17 17 17;17 17 17 17 17 11 17 17 17 11 17 17 17 17 17 17;17 17 17 17 17 11 11 11 11 11 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'watch'
        ColorCode = [17 17 13 13 13 13 13 13 13 13 13 13 13 13 13 13;17 17 13 13 13 13 13 13 13 13 13 13 13 13 13 13;17 17 16 17 17 17 17 17 17 17 17 17 17 17 17 16;17 17 16 17 12 12 12 12 17 12 12 17 17 17 17 16;17 17 16 17 17 17 17 17 17 17 17 17 17 17 17 16;17 17 16 17 12 12 12 17 12 12 17 17 17 17 17 16;17 17 16 17 17 17 16 16 17 17 17 17 17 17 17 16;17 17 16 17 17 16 5 16 5 12 17 17 16 16 17 16;17 17 16 17 16 17 17 16 17 17 17 16 17 16 17 16;17 17 16 16 5 5 5 17 17 17 16 17 17 16 17 16;17 16 16 17 17 17 17 16 16 16 17 17 17 17 17 16;16 4 4 16 16 16 16 4 4 16 16 16 16 16 16 16;16 4 17 16 17 17 16 4 17 16 17 17 17 17 17 17;16 5 5 16 17 17 16 5 5 16 17 17 17 17 17 17;17 16 16 17 17 17 17 16 16 17 17 17 17 17 17 17;17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17];
    case 'viewbest'
        ColorCode = [17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17;16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;16 17 17 17 17 17 17 17 17 17 17 17 17 17 17 16;16 17 17 9 9 9 17 17 17 17 17 17 17 17 13 16;16 17 17 9 9 9 17 16 16 16 16 16 16 13 17 16;16 17 17 9 9 9 17 17 17 17 17 17 13 17 17 16;16 17 17 17 17 17 17 17 17 17 17 13 17 17 17 16;16 17 17 11 11 11 17 17 17 17 13 17 17 17 17 16;16 17 17 11 11 11 17 16 16 13 16 16 16 16 17 16;16 17 13 11 11 11 17 17 13 17 17 17 17 17 17 16;16 13 13 13 17 17 17 13 13 17 17 17 17 17 17 16;16 17 13 13 13 2 13 13 17 17 17 17 17 17 17 16;16 17 17 13 13 13 13 13 16 16 16 16 16 16 17 16;16 17 17 2 13 13 13 17 17 17 17 17 17 17 17 16;16 17 17 17 17 13 17 17 17 17 17 17 17 17 17 16;16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
end

if nargin > 1
    cdata = ColorCode;
    return;
end
for y = 1:W
    for x = 1:W
        cdata(x,y,:) = ColorMap(ColorCode(x,y));
    end
end


% ====================
function handle = PaintRectangle(XBlockNo, YBlockNo, Color, N)
% show color of selected pixel

handle = [];
if Color > 16, return; end
FaceColor = ColorMap(Color);

handle = rectangle('Position', [XBlockNo, YBlockNo, 1, 1] ./ N, ...
    'FaceColor', FaceColor, 'EdgeColor', 'none');


% ========================
function c = ColorMap(k)
% convert color index k into colorcode

% color pellet from Microsoft Word custom toolbar icon editor

Color = {[1 1 1] % white
[1 1 0] % yellow
[    0    1.0000    0.5020] % light green
[0.5020    1.0000    1.0000] % blue green
[0.8353    0.8157    0.7843] % gray
[0.5020    0.5020         0] % horse shit
[    0    0.5020         0] % deep green
[  0    0.5020    0.5020] % school green
[0 0 1] % blue   
[1 0 1] % magenta 
[1 0 0] % red
[   0.5020    0.5020    0.5020] % smoke
[    0         0    0.5020] % deep blue
[ 0.5020         0    0.5020] % deep magenta
[  0.5020         0    0.2510] % deep magenta red
[0 0 0] % black
[0.83137254901961   0.81568627450980   0.78431372549020] % default background color
};

c = Color{k};        