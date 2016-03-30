function cmds = xltekprocessinput(cmds,inargs)
% Sort ignoring case
sortout = cell(2,1);
sortout{1} = cellfun(@lower,cmds(1,:),'UniformOutput',0);
[sortout{1:2}] = sort(sortout{1});
cmds = cmds(:,sortout{2});
oarg = cmds(1,:);
iarg = inargs(1:2:end);
varg = inargs(2:2:end);
if length(iarg) ~= length(varg) || ~iscellstr(iarg)
    error(['matlab:' mfilename],'Wrong parameter/value pair');
end
for ip = 1:length(iarg)
    iv = strncmpi(iarg{ip},oarg,length(iarg{ip}));
    if sum(iv) > 1
        iv = strcmpi(iarg{ip},oarg);
        if ~sum(iv)
            error(['Parameter not found: ',iarg{ip}])
        end
    elseif ~sum(iv)
        error(['matlab:' mfilename],['Parameter not found: ',iarg{ip}])
    end
    if iscell(varg{ip})
        cmds{2,iv} = varg(ip);
    else
        cmds{2,iv} = varg{ip};
    end
end
cmds = struct(cmds{:});