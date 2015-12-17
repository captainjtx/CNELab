function [retval] = freesurfer_fread3(fid)
 b1 = fread(fid, 1, 'uchar') ;
 b2 = fread(fid, 1, 'uchar') ;
 b3 = fread(fid, 1, 'uchar') ;
 retval = bitshift(b1, 16) + bitshift(b2,8) + b3 ;