function keys = readkeylist(str,istr,bstr,irange,bDoubleQuotes)
% keys = readkeylist(str,bDQ); %Reads keylist from str
% Reads keylist in the form
% (.(."KeyName1", KeyValue1), (."KeyName2", KeyValue2), ...(."KeyNameN", KeyValueN))
% KeyValue can be 
%   1. Another Keylist (.(."Key1", val1), (."Key2", val2))
%   2. A list (I1 I2 I3)
%   3. A string or a numeric value
%   4. Nothing like (."Keyname"), no value presents
% bDoubleQuotes: Include double quotes around string. This is essential when you want
% to write keylist back to a file. 
% keys[output]: A structre with fields 
%    Key:   The name of the key
%    Value: The Value of the key
% See also KEY2STRUCT XLTEKREADENTFILE

% Ibrahim ONARAN
% 2012-01-09 18:42

if nargin < 5
    bDoubleQuotes = istr;
    istr   = find(str == '(' | str == ')')'; % Find ( and )
    % The keylist mostly relies up on the characters '(' and ')'. However
    % the literal strings may contain paranthesis character which may cause
    % matching problems when idetifying keys. To overcome this problem we
    % need to eliminate the strings first and then try to find matching
    % paranthesis. Another problem arouses when we have double quote '"'
    % chracter in a string. To distiguish the string boundaries xltek
    % company used double quotes, if string itself contains double quotes
    % we need put a backslash '\' character before that double quote. In
    % case we have a backslash character in strings, we need to put double
    % backslashes to get a single backslash. To eliminate the strings and
    % overcome these problems we used regular expressions.
    %%
    [pstr{1:2}] = regexp(str,'"[^"\\]*(\\.[^"\\]*)*"','start','end'); 
    % Why I am using bsxfun here, answer is time and memory considerations
    % Equivalent code bsxfun with tic, toc
    %     >> tic; v ={repmat(pstr{1},size(istr,1),1) repmat(pstr{1},size(istr,1),1) repmat(istr,1,size(pstr{1},2))}; any(v{1}<v{3} & v{2}>v{3},2); toc
    %     Elapsed time is 0.169031 seconds.
    %     >>whos v
    %     Name      Size               Bytes  Class    Attributes
    %     v         1x3             77389380  cell        %
    %     >>y = v{1}; whos y
    %     Name         Size                 Bytes  Class     Attributes
    %     y         2490x1295            25796400  double
    % Another implemetation does not construct variable
    %     >> tic; any(pstr{1}(ones(1,size(istr,1),1),:)< istr(:,ones(1,size(pstr{1},2))) & pstr{2}(ones(1,size(istr,1),1),:)>istr(:,ones(1,size(pstr{1},2))),2); toc
    %     Elapsed time is 0.116374 seconds.
    %     >> tic; any(repmat(pstr{1},size(istr,1),1)<repmat(istr,1,size(pstr{1},2)) & repmat(pstr{1},size(istr,1),1)>repmat(istr,1,size(pstr{1},2)),2); toc
    %     Elapsed time is 0.178529 seconds.
    
    % With bsxfun 3-4 times faster and does not allocate large memory
    %     >> tic; any(bsxfun(@lt,pstr{1},istr) & bsxfun(@gt,pstr{2},istr),2); toc
    %     Elapsed time is 0.044435 seconds.
    %
    pstr = any(bsxfun(@lt,pstr{1},istr) & bsxfun(@gt,pstr{2},istr),2);
    istr(pstr) = [];
    bstr   = cumsum(1-2*(str(istr) == ')'));  % find levels
    irange = [1 length(bstr)]';              % Top Level, from beginning to end 
end
% This is a keylist, it should start with (.(.
if ~strcmp(str(istr(irange(1))+(0:3)),'(.(.')
    error(['matlab:' mfilename],'This is not a keylist');
end
% The parathesis mismatch
if diff(bstr(irange)) ~= -1
    error(['matlab:' mfilename],'Parenthesis mismatch');
end
%% Initialization
% Key ranges
pKeys = irange(1) + find(bstr(irange(1)) == bstr(irange(1)+1:irange(2)));
pKeys = [[irange(1) pKeys(1:end-1)]+1 ; pKeys];
% Key Locations
pLocs = istr(pKeys);
nKeys = size(pKeys,2);
keys  = repmat(struct('Key',[],'Value',[]),nKeys,1);
%% Read Keys
for iKeys = 1:nKeys
    % Read each key
    key = [find(str(pLocs(1,iKeys):pLocs(2,iKeys))=='"',2) find(str(pLocs(1,iKeys):pLocs(2,iKeys))==',',1)];
    keys(iKeys).Key = str(pLocs(1,iKeys)+(key(1):key(2)-2));
    % Read Value
    if diff(pKeys(:,iKeys)) > 1
        % KeyList, List
        if strcmp(str(pLocs(1,iKeys)+key(3)+(1:4)),'(.(.')
            keys(iKeys).Value = readkeylist(str,istr,bstr,pKeys(:,iKeys)+[1 -1]',bDoubleQuotes);
        elseif str(pLocs(1,iKeys)+key(3)+1) == '('
            keys(iKeys).Value = readlist(str,istr,bstr,pKeys(:,iKeys)+[1 -1]',bDoubleQuotes);
        else
            error(['matlab:' mfilename],'Wrong token [%s]',str(pLocs(1,iKeys)+key(3)+(1:4)));
        end
    else
        if length(key) > 2 % Else, this is a key with no value, like calibration in montage channels
            if str(pLocs(1,iKeys)+key(3)+1) == '"' 
                % A string value, replace escape charecters! to convert
                % back use regexprep(string,'("|\\)','\\$1')
                if bDoubleQuotes
                    % To convert it back use string = [string(1) regexprep(string(2:end-1),'("|\\)','\\$1') string(end)]
                    % Include " at the end and beginning of a string
                    keys(iKeys).Value = str(pLocs(1,iKeys)+key(3)+1:pLocs(2,iKeys)-1);
                else
                    % To convert it back use regexprep(string,'("|\\)','\\$1')
                    keys(iKeys).Value = regexprep(str(pLocs(1,iKeys)+key(3)+2:pLocs(2,iKeys)-2),'\\(.)','$1');
                end
            else
                % Possibly a numeric value, never convert to numeric value,
                % user of this function should deal with it.
                keys(iKeys).Value = str(pLocs(1,iKeys)+key(3)+1:pLocs(2,iKeys)-1);
            end
        end
    end
end

function keys = readlist(str,istr,bstr,irange,bDoubleQuotes)
% keys may be string, number, or keylist, or another keys
if str(istr(irange(1))) ~= '('
    error(['matlab:' mfilename],'Not a list');
end
if diff(irange) == 1 % This is list of regular (not key or another list) items
    % TODO: Assume all key items has same type, remove this assumption, no
    % problem so far though
    if str(istr(irange(1))+1) == '"' % A list of strings, remove \\ or \" 
        % Consider escape character (\) for string finding
        if bDoubleQuotes
            %   Match double quotes at the end and beginning of a string
            [keys,e] = regexp(str(istr(irange(1))+1:istr(irange(2))),'"[^"\\]*(\\.[^"\\]*)*"(?=(,|\)))','match','end');
            if e(end) < diff(istr(irange(1:2)))-1 % We subtruct 1 for ) at the end of the string
                error(['matlab:' mfilename],'Incomplete parsing!');
            end
        else
            % Do not match double quotes at the end and beginning of a string
            [keys,e] = regexp(str(istr(irange(1))+1:istr(irange(2))),'(?<=")[^"\\]*(\\.[^"\\]*)*(?=(",|"\)))','match','end');
            if e(end) < diff(istr(irange(1:2)))-2 % We subtruct 2, 1 for " and 1 for ) at the end of the string
                error(['matlab:' mfilename],'Incomplete parsing!');
            end
            % Replace escape characters
            keys = regexprep(keys,'\\(\\|")','$1');
        end
    else
        % Read values which are not strings
        [keys,e] = regexp(str(istr(irange(1)):istr(irange(2))),'(?<=[ \(])[^,\)]*(?=[,\)])','match','end');
        if ~isempty(keys) && e(end) < diff(istr(irange(1:2)))
            error(['matlab:' mfilename],'Incomplete parsing!');
        end
    end
else
    % Either keys or lists; Find same level items with this level of keys
    pKeys = irange(1) + find(bstr(irange(1)) == bstr(irange(1)+1:irange(2)));
    pKeys = [[irange(1) pKeys(1:end-1)]+1 ; pKeys]; % Find index for istr
    pLocs = istr(pKeys);    % Find index for str
    nKeys = size(pKeys,2);  % We have nKeys elements for this list of list or keylist
    keys  = cell(nKeys,1);
    for iKeys = 1:nKeys
        % Read each key
        if strcmp(str(pLocs(1,iKeys)+(0:3)),'(.(.') % Read each key here
            keys{iKeys} = readkeylist(str,istr,bstr,pKeys(:,iKeys),bDoubleQuotes);
        else
            keys{iKeys} = readlist(str,istr,bstr,pKeys(:,iKeys),bDoubleQuotes);
        end
    end
end