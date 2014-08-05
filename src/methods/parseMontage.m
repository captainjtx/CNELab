function [montage_channames,mat]=parseMontage(montage,channames)
%For example:
%ECG_L-ECG_R
%Note: + - * is reserved for montage expression
%mat is a row-wise projection matrix
chanNum=length(channames);

montage_channames=cell(length(montage),1);
mat=zeros(length(montage),chanNum);
for i=1:length(montage)
    montage_channames{i}=montage{i}.name;
    
    if isfield(montage{i},'exp')
        mat(i,:)=parseMontageExpStr(montage{i}.exp,channames);
        continue
    end
    
    if isfield(montage{i},'vector')
        continue
    end
end

end

function vec=parseMontageExpStr(expstr,channames)
vec=zeros(1,length(channames));

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