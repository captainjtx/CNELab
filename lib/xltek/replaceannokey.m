function [bfound,pkeys] = replaceannokey(pkeys,npath,scondition,sexpression,sreplace)
% [bFound,pkeys] = REPLACEANNOKEY(pkeys,nPath,sCondition,sExpression,sReplace)
% pkeys = 
% pnote = fread(fidsrc,[1 chead(2)-18],'*char'); % Raw string read from source file
% pkeys = readkeylist(pnote,0); % Key and value structure
% npath: i.e Data.Type
% scondition : r-i for string, relation operators for others
% sreplace : new value
%
% This is a helper function for XLTEKMODIFYNOTE, do not use directly. 
% See also XLTEKMODIFYNOTE

iPath  = find(npath=='.',1);
bfound = false;
if isempty(iPath) % do the operation
    % Scalar, string case, just compare
    iKey = ismember({pkeys.Key},npath);
    if any(iKey)
        if isstruct(pkeys(iKey).Value) || (iscell(pkeys(iKey).Value) && scondition ~= 'r')
            error('Keys or lists are not supported');
        end
        if ~any(scondition=='dri') && ~isnumeric(sexpression)
            error('Numeric Value required for numeric comparisons');
        end
        switch scondition
            case 'r' % Can handle lists
                % Place " for literals
                if iscell(sexpression)
                    if iscell(pkeys(iKey).Value)
                        bfound = cellfun(@(string) regexp(string,sexpression, 'once'),pkeys(iKey).Value,'UniformOutput',false);
                        [iExpression,bfound] = find(~cellfun(@isempty,cat(1,bfound{:})'));
                        [~,buFound] = unique(bfound,'first');
                        bfound = bfound(buFound);
                        sexpression = sexpression(iExpression(buFound));
                        if iscell(sreplace)
                            sreplace = sreplace(iExpression(buFound));
                        end
                    else
                        bfound = regexp(pkeys(iKey).Value,sexpression, 'once');
                        bfound = find(~cellfun(@isempty,bfound),1);
                        sexpression = sexpression(bfound);
                        if iscell(sreplace)
                            sreplace = sreplace(bfound);
                        end
                    end
                else
                    if iscell(pkeys(iKey).Value)
                        bfound = regexp(pkeys(iKey).Value,sexpression,'once');
                        bfound = find(~cellfun(@isempty,bfound));
                    else
                        bfound = 1;
                        if isempty(regexp(pkeys(iKey).Value,sexpression, 'once'))
                            bfound = [];
                        end
                    end
                end
            case '=='
                bfound = str2double(pkeys(iKey).Value) == sexpression;
            case '<'
                bfound = str2double(pkeys(iKey).Value) < sexpression;
            case '>'
                bfound = str2double(pkeys(iKey).Value) > sexpression;
            case '>='
                bfound = str2double(pkeys(iKey).Value) >= sexpression;
            case '<='
                bfound = str2double(pkeys(iKey).Value) <= sexpression;
            case '~='
                bfound = str2double(pkeys(iKey).Value) ~= sexpression;
            case {'i','d'}
                bfound = true;
            otherwise
                bfound  = false;
                fprintf('%s\n',['Condition ' scondition ' is not recognized']);
        end
        if ~isempty(sreplace)
            if isnumeric(sexpression)
                pkeys(iKey).Value = num2str(sreplace);
            elseif scondition == 'i'
                pkeys(iKey).Value = sreplace;
            elseif ~isempty(bfound) 
                if iscell(sexpression)
                    if iscell(pkeys(iKey).Value)
                        if iscell(sreplace)
                            pkeys(iKey).Value(bfound) = cellfun(@(str,exp,rep) regexprep(str,exp,rep),pkeys(iKey).Value(bfound),sexpression,sreplace,'UniformOutput',false);
                        else
                            pkeys(iKey).Value(bfound) = cellfun(@(str,exp) regexprep(str,exp,sreplace),pkeys(iKey).Value(bfound),sexpression,'UniformOutput',false);
                        end
                    else
                        pkeys(iKey).Value = regexprep(pkeys(iKey).Value,sexpression,sreplace);
                    end
                else
                    if iscell(pkeys(iKey).Value)
                        pkeys(iKey).Value(bfound) = regexprep(pkeys(iKey).Value(bfound),sexpression,sreplace);
                    else
                        pkeys(iKey).Value = regexprep(pkeys(iKey).Value,sexpression,sreplace);
                    end
                end
            end
        elseif scondition == 'd'
            pkeys(iKey) = [];
        end
        bfound = ~isempty(bfound);
    elseif isempty(npath) && scondition == 'd'
        bfound = true;
        pkeys  = [];
    end
else
    cPath = npath(1:iPath-1);
    npath = npath(1+iPath:end);
    iKey  = ismember({pkeys.Key},cPath);
    if ~any(iKey)
        bfound = false;
        return;
    end
    if iscell(pkeys(iKey).Value)
        bfound = false;
        for ickeys = 1:numel(pkeys(iKey).Value)
            pckeys = pkeys(iKey).Value{ickeys};
            [bifound,pckeys] = replaceannokey(pckeys,npath,scondition,sexpression,sreplace);
            if bifound
                pkeys(iKey).Value{ickeys} = pckeys;
                bfound = true;
            end
        end
    else
        [bfound,pkeys(iKey).Value] = replaceannokey(pkeys(iKey).Value,npath,scondition,sexpression,sreplace);
    end
end
