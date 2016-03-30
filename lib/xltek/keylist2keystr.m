function str = keylist2keystr(mntg)
if ~isempty(mntg) 
    if isstruct(mntg) 
        fnames = cellfun(@(keys) sprintf('"%s"',keys),{mntg.Key},'UniformOutput',false);
        str = '(.'; 
        for inames = 1:length(fnames)
            if ~isempty(mntg(inames).Value)
                str = [str '(.' fnames{inames} ', ' keylist2keystr(mntg(inames).Value) '), ']; %#ok<AGROW>
            else
                str = [str '(.' fnames{inames} '), ']; %#ok<AGROW>
            end
        end
        str = [str(1:end-2)  ')']; 
    elseif iscell(mntg) 
        for inames = 1:length(mntg)
            mntg{inames} = keylist2keystr(mntg{inames});
            if ~isempty(mntg{inames})
                mntg{inames} = [mntg{inames} ', '];
            else
                mntg{inames} = '';
            end
        end
        str = cat(2,mntg{:});
        str = ['(' str(1:end-2) ')'];
    else
        str = mntg;
    end
else
    if iscell(mntg)
        str = '()';
    else
        str ='';
    end
end    