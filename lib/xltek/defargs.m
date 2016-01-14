function cmds = defargs(cmds,inargs)
% function cmds = processinput(cmds,inargs)
% Private function to be used for value params inputs

% Todo, validate with default arguments

% Support structure input to resimulate old input saved as structure
if numel(inargs) == 1
    if iscell(inargs)
        inargs = inargs{1};
        if isstruct(inargs)
            inargs = [fieldnames(inargs) struct2cell(inargs)]';
            inargs(:,ismember(inargs(1,:),setdiff(inargs(1,:),cmds(:,1)))) = [];
        else
            error(['matlab:' mfilename],'Structure is expected');
        end
    else
        error(['matlab:' mfilename],'Cell array is expected');
    end
end
oarg = cmds(:,1);
iarg = inargs(1:2:end);
varg = inargs(2:2:end);
if length(iarg) ~= length(varg) || ~iscellstr(iarg)
    error('Wrong parameter/value pair');
end
for ip = 1:length(iarg)
    % Find partial match
    iv = strncmpi(iarg{ip},oarg,length(iarg{ip}));
    ivs = sum(iv);
    if ivs ~= 1
        if ivs == 0
            fprintf('Valid Arguments\n%s\n',sprintf('%s\n',oarg{:}));
            error(['matlab:' mfilename],'%s is not a valid argument',iarg{ip});
        else
            % Try to find exact match
            ix = strcmpi(iarg{ip},oarg(iv));
            if sum(ix) ~= 1
                fprintf('Valid Arguments\n%s\n',sprintf('%s\n',oarg{:}));
                error(['matlab:' mfilename],'Ambiguous parameters\n%s',sprintf('%s\n',oarg{iv}));
            else
                iv = find(iv);
                iv = iv(ix);
            end
        end
    end
    cmds{iv,2} = varg{ip};
end
cmds = cell2struct(cmds(:,2),cmds(:,1),1);