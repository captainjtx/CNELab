function vec=parseMontageExpStr(expstr,channames)
vec=zeros(1,length(channames));
if isnumeric(expstr)
    expstr=num2str(expstr);
end

expstr=['+',expstr,'+'];

for i=1:length(channames)
    %Disable special +/- characters contained in channames
    channames{i}=regexprep(channames{i},'[+-]','\\$0');
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