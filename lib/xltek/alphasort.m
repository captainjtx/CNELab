function [varargout] = alphasort(varargin)
%[sorted,index] = alphasort(unsorted,Options)
%Sorts (rows of) char matrix 
%and elements of cellstr matrix
%alphanumerically.
% Options: 'f' : index first, 'n'= no ignore case
% example 
%   [a,b] = alphasort({'ali' 'ali1' 'ali10' 'ali3' 'ali2'})
%   [a,b] = alphasort({'ali' 'ali1' 'ali10' 'ali3' 'ali2'},'n')
%   [a,b] = alphasort(strvcat({'ali' 'ali1' 'ali10' 'ali3' 'ali2'}),'f')
%   See also SORTROWS
[varargout{1:nargout}] = alphWin32(varargin{:});
	