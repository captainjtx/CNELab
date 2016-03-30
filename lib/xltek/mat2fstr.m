function str = mat2fstr(x,name,fmt,flg,szMat)
% STR = MAT2FSTR(X,NAME,FMT)
% Convert Matrix to string so that this string can be used with fprintf
% method. ie: fprintf(1,'%s',mat2fstr(x));
%Usage :
% mat2fstr(x,fmt); fmt should not contain '%'
% mat2fstr(x,name,[]),  mat2fstr(x,name,fmt)
% mat2fstr(x)
% fmt can be 'MxN %g' to print maximum MxN matrices
if nargin < 5
    szMat = [];
    if nargin < 4
        flg = 0;
        if nargin < 3
            if nargin==2
                if any(name == '%')
                    fmt = name;
                    name = [];
                else
                    fmt = [];
                end
            elseif nargin == 1
                name = [];fmt = [];
            end
        end
    end
    if ~isempty(fmt) && ((any(fmt=='x') && ~any(fmt=='%')) || (any(fmt=='x') && any(fmt=='%') && find(fmt=='x',1)<find(fmt=='%',1)))
        szMat = sscanf(fmt,'%gx%g')';
        if any(fmt=='%')
            fmt = fmt(find(fmt=='%'):end);
        else
            fmt = [];
        end
    end
end
str = [];
if iscell(x)
    if isempty(name), name = inputname(1);end
    if isempty(name), name = 'ans';end
    if isempty(x)
        str = [str name ' = {}' 10];
    else
        if iscellstr(x) && all(cellfun(@(a)size(a,1),x)==1) && all(cellfun(@(a)size(a,2),x)<1000)
            if sum(cellfun(@(a)size(a,2),x))<1000-length(x)
                str = [str sprintf('%s={%s}\n',name,[sprintf('%s,',x{1:end-1}) x{end}])]; 
            else
                str = [str sprintf('%s={\n%s}',name,sprintf([repmat('  ',1,flg) '%s\n'],x{:}))]; 
            end
        else
            for i = 1:numel(x)
                if iscell(x{i}) || isstruct(x{i})
                    str = [str mat2fstr(x{i},[name '{' num2str(i) '}'],fmt,flg+1,szMat)]; %#ok<AGROW>
                else
                    str = [str mat2fstr(x{i},[name '{' num2str(i) '} = '],fmt,flg+1,szMat)]; %#ok<AGROW>
                end
            end
        end
    end
    if ~flg, str(end) = [];end
elseif isstruct(x)
    if isempty(name), name = inputname(1);end
    if isempty(name), name = 'ans';end
    fields = fieldnames(x);
    if isempty(x)
        str = [str name ' = EmptyStruct' 10];
        if ~isempty(fields)
        str = [str 'fields' sprintf(': %s ',fields{:}) 10];
        end
    else
        if numel(x)>1
            for i = 1:numel(x)
                if flg
                    for j = 1:numel(fields)
                        str = [str mat2fstr(x(i).(fields{j}),...
                            [name '.' fields{j}],fmt,flg+1,szMat)]; %#ok<AGROW>
                    end
                else
                    str = [str name '(' num2str(i) ') = ' 10]; %#ok<AGROW>
                end
            end
        else
            for j = 1:numel(fields)
                if iscell(x.(fields{j})) || isstruct(x.(fields{j}))
                    str = [str mat2fstr(x.(fields{j}),...
                        [name '.' fields{j}],fmt,flg+1,szMat)]; %#ok<AGROW>
                else
                    str = [str mat2fstr(x.(fields{j}),...
                        [name '.' fields{j} ' = '],fmt,flg+1,szMat)]; %#ok<AGROW>
                end
            end
        end
    end
    if ~flg, str(end) = [];end
else
    if ~exist('flg','var'), flg = 0;end
    str = matrix2fstr(x,name,fmt,flg,szMat);
    if ~flg, str(end) = [];end
end

function str = matrix2fstr(x,name,fmt,flg,szMat)
if isa(x,'function_handle')
    str = func2str(x);
    if str(1)=='@'
        str = strtrim(str(find(str==')',1,'first')+1:end));
    end
    str = [name str 10];
    return;
end

x = x(:,:,:);
rlsz = size(x);
strsz = '';
if ~isempty(szMat)
    x = x(1:min(end,szMat(1)),1:min(end,szMat(2)),:);
    if any(rlsz(1:2) > szMat)
        strsz = sprintf('%gx%g Matrix ',szMat);
    end
end

if isempty(x)
    str = [name ' []' 10];
    return;
end

if ndims(x)<3
    if ~ischar(x)
        if ~isempty(fmt)
            str = num2str(x,fmt)';
        else
            str = num2str(x)';
        end
    else
        str = x';
    end
    str(end+1,:) = 10;
    if flg
        str = [repmat([32 32]',flg,size(str,2));str];
    end
    str = str(:)';
    if ~isempty(name)
        if flg
            str = [strsz name 10 str];
        else
            str = [strsz name ' =' 10 str];
        end
    end
else
    str = [];
    for i = 1:size(x,3)
        if ~ischar(x)
            if exist('fmt','var') && ~isempty(fmt)
                strp = num2str(x(:,:,i),fmt)';
            else
                strp = num2str(x(:,:,i))';
            end
        else
            strp = x(:,:,i)';
        end
        strp(end+1,:) = 10; %#ok<AGROW>
        if flg
            strp = [repmat([32 32]',flg,size(strp,2));strp]; %#ok<AGROW>
        end
        strp = strp(:)';
        if flg
            str  = [str name '(:,:,' int2str(i) ')' 10 strp]; %#ok<AGROW>
        else
            str  = [str name '(:,:,' int2str(i) ') =' 10 strp]; %#ok<AGROW>
        end
    end
end
