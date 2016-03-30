function sz = chsize(varargin)
% sz = chsize(fpath), returns size of file
% sz = chsize(fpath,size), change size and returns old size
if nargin && ~ischar(varargin{1}) 
    varargin{1} = fopen(varargin{1});
    if isempty(varargin{1})
        error(['matlab:' mfilename],'Invalid Handle');
    end
end
sz = cfunction(mfilename,varargin{:});
