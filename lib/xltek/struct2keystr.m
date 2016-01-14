function str = struct2keystr(mntg)
if ~isempty(mntg) 
    if isstruct(mntg) 
        if ~isscalar(mntg) % Cells can also be scalar
            error('Non scalar keys expected to be cell array');
        end
        if isfield(mntg,'NonStandard')
            NonStandard = mntg.NonStandard;
            mntg = rmfield(mntg,'NonStandard');
            fnames = [fieldnames(mntg);NonStandard(:,1)];
            values = [struct2cell(mntg);NonStandard(:,2)];
            [fnames,ifnames] = sort(fnames);
            values = values(ifnames);
        else
            fnames = fieldnames(mntg);
            values = struct2cell(mntg);
        end
        keystr = cellfun(@(keys) sprintf('"%s"',keys),fnames,'UniformOutput',false);
        str = '';
        for jvalue = 1:size(values,2)
            str = [str '(.']; %#ok<AGROW>
            for inames = 1:length(fnames)
                values{inames,jvalue} = struct2keystr(values{inames,jvalue});
                if ~isempty(values{inames})
                    values{inames,jvalue} = ['(.' keystr{inames} ', ' values{inames,jvalue} '), '];
                else
                    values{inames,jvalue} = ['(.' keystr{inames} '), '];
                end
            end
            values{end,jvalue}=values{end,jvalue}(1:end-2); 
            str = [str cat(2,values{:,jvalue}) '), ']; %#ok<AGROW>
        end
        str = str(1:end-2);
        if ~isscalar(mntg)
            str = ['(' str ')'];
        end
    elseif iscell(mntg) 
        for inames = 1:length(mntg)
            mntg{inames} = struct2keystr(mntg{inames});
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