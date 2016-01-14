function str = dqtrim(str)
% Removes double quotes at the end and beginning of a string or cell str
% s = '"test"'; c = {'"test"','"test2"'};
% dqtrim(s)
% ans =
% test
% dqtrim(c)
% ans = 
%     'test'    'test2'

ostr = regexp(str,'(?<=^")(?<trimed>.*)(?="$)','names');
if ischar(str)
    if ~isempty(ostr)
        str = ostr.trimed;
    elseif strcmpi(str,'""')
        str = '';
    end
elseif iscellstr(str)
    estr = cellfun(@isempty,ostr);
    if any(estr(:))
        fstr = find(estr);
        istr = strcmpi(str(fstr),'""');
        if any(istr)
            [ostr{fstr(istr)}] = deal(struct('trimed',''));
        end
        if any(~istr)
            ostr(fstr(~istr)) = num2cell(struct('trimed',str(fstr(~istr))));
        end
    end
    ostr = cat(1,ostr{:});
    str = reshape({ostr.trimed},size(str));
end