function [SMOOTHED] = TF_Smooth(RAW,KERNEL_TYPE,SIZE)
% TF_Smooth(RAW,KERNEL_TYPE) returns a smoothed version of the RAW TF map
% obtained by the convolution with a low pass filter  of the type specified by KERNEL_TYPE
% with dimensions specified by SIZE.
% 
% RAW is the TF map (image) you'd like to smooth.
% KERNEL_TYPE is a string that specifies the type of smoothing filter you want
% to apply. See below for informations
% SIZE is either:
% 1) a 2D vector containing the dimensions [ROWS COLUMNS] of the
% filter you want to apply (example: [15 5]);
% OR
% 1) a scalar, if you want to apply a squared filter of dimension SIZExSIZE
% or you want to apply the 'disk' kernel (see below); in this case the
% kernel will be a squared matrix with side (2*SIZE+1).
%
% SUGGESTION: use as kernel side dimension 1/10 or less of the TF Map's length for
%             such dimension! Example: if the TF Map is a matrix 1025x150
%             then you may want to plug in as a kernel a vector [50 15].
%   
% Valid values for KERNEL_TYPE are: 
% 'gaussian'    : creates a squared Gaussian kernel with default sigma of 2.5
% 'average'     : creates a squared average kernel
% 'disk'        : creates a circular average kernel
%
% Author: Gianluca Meloni, 10/24/2014
% For any question contact: mels.gian@gmail.com

if strcmp(KERNEL_TYPE,'disk')&&(length(SIZE)~=1)
    error('Kernel of type "disk" wants a scalar as SIZE');
end

sigma = 2.5; % default sigma value for gaussian kernel. You can modify it (typical values > 0.5)

switch KERNEL_TYPE
    case 'gaussian'
        kernel = fspecial('gaussian',SIZE,sigma);
    case 'average'
        kernel = fspecial('average',SIZE);
    case 'disk'
        kernel = fspecial('disk',SIZE);
end

SMOOTHED = imfilter(RAW,kernel,'symmetric');

end

