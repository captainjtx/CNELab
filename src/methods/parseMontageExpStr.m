function vec=parseMontageExpStr(expstr,channames)
vec=zeros(1,length(channames));
if isnumeric(expstr)
    expstr=num2str(expstr);
end

if ~ismember(expstr(1),{'-','+'})
    expstr=['+',expstr];
end

if ~ismember(expstr(end),{'-','+'})
    expstr=[expstr,'+'];
end

for i=1:length(channames)
    [si,ei]=regexp(expstr,['[+*-]',channames{i},'[+-]']);
    
    if ~isempty(si)
        if expstr(si)=='*'
            ii=si-1;
            while (ii>0)
                if expstr(ii)=='-'||expstr(ii)=='+'
                    break
                end
                ii=ii-1;
            end
            
            if ~ii
                ii=1;
            end
            param=str2double(expstr(ii:si-1));
        elseif expstr(si)=='-'
            param=-1;
        elseif expstr(si)=='+'
            param=1;
        end
    else
        param=0;
    end
    
    vec(i)=param;
    
end

end