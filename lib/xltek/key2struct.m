function Annotation = key2struct(Annotation,bList)
% ANNOTATION = KEY2STRUCT(ANNOTATION,BLIST)
% Annotation[input]:
%   The keylist obtained from READKEYLIST function.
% bList: A logical value (true or false)
%       xltek stores its annotation and other information data as keys 
%       A typical keylist
%       (.(."KeyName1", KeyValue1), (."KeyName2", KeyValue2), ...(."KeyNameN", KeyValueN))
%       KeyValue can be 
%           1. Another Keylist (.(."Key1", val1), (."Key2", val2))
%           2. A list (I1 I2 I3)
%           3. A string or a numeric value
%           4. Nothing like (."Keyname"), no value presents
%       If bList is false we store our list data in an cell matrix
%       othewise we transform the cell array into structure if it has
%       struct elements in it.
% Annotation[output]:
%   The structural represantation of the keylist.
% See also READKEYLIST XLTEKREADENTFILE

% Ibrahim ONARAN
% 2012-01-09 18:41
if ~isempty(Annotation)
    if isstruct(Annotation)
        isVarName  = cellfun(@isvarname,{Annotation.Key})';
        if any(~isVarName)
            NonStandard = [{Annotation(~isVarName).Key}' arrayfun(@(Key)key2struct(Key.Value,bList),Annotation(~isVarName),'UniformOutput',false)];
            %             if ~isempty(strmatch(Annotation,{Annotation(isVarName).Key}))
            %                 error(['matlab:' mfilename],'Use Other name for nonStandard Fields');
            %             end
            Annotation = cell2struct([arrayfun(@(Key)key2struct(Key.Value,bList),Annotation(isVarName),'UniformOutput',false);{NonStandard}],{Annotation(isVarName).Key 'NonStandard'});
        else
            Annotation = cell2struct(arrayfun(@(Key)key2struct(Key.Value,bList),Annotation(isVarName),'UniformOutput',false),{Annotation(isVarName).Key});
        end
    elseif iscell(Annotation) && all(cellfun(@isstruct,Annotation))
        Annotation = cellfun(@(Key)key2struct(Key,bList),Annotation,'UniformOutput',false);
        if ~bList 
            try
                Annotation = cat(1,Annotation{:});
            catch   %#ok<CTCH> % If the elements are not identical, probably structs those have different fields
                % Fill non existing fields with empty matrix
                fnames = cellfun(@fieldnames,Annotation,'UniformOutput',false);
                fnames = unique(cat(1,fnames{:}));
                for iCell = 1:length(Annotation)
                    difField = setdiff(fnames,fieldnames(Annotation{iCell}));
                    if ~isempty(difField)
                        for iField = 1:length(difField)
                            Annotation{iCell}.(difField{iField}) = [];
                        end
                    end
                end
                Annotation = cat(1,Annotation{:});
            end
        end
    end
end