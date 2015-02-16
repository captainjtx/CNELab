function remakeMontage(obj)
%Assure Montage properties Coherence

if iscell(obj.Montage_)
    if length(obj.Montage_)~=obj.DataNumber
        msgbox('If montage is cell, it must be of same length with data','Montage','error');
    end
elseif isempty(obj.Montage)
    obj.Montage_=cell(obj.DataNumber,1);
end

if isempty(obj.ChanNames_)
    obj.ChanNames_=cell(1,obj.DataNumber);
    [obj.ChanNames_{:}]=deal([]);
end

if isempty(obj.GroupNames_)
    obj.GroupNames_=cell(1,obj.DataNumber);
    [obj.GroupNames_{:}]=deal([]);
end

if obj.DataNumber==1&&~iscell(obj.ChanNames_{1})&&~isempty(obj.ChanNames_{1})
    obj.ChanNames_{1}=obj.ChanNames_;
end

if obj.DataNumber==1&&~iscell(obj.GroupNames_{1})&&~isempty(obj.GroupNames_{1})
    obj.GroupNames_{1}=obj.GroupNames_;
end

for i=1:obj.DataNumber
    if isempty(obj.ChanNames_{i})
        obj.ChanNames_{i}=num2cell(1:size(obj.Data{i},2));
        obj.ChanNames_{i}=cellfun(@num2str,obj.ChanNames_{i},'UniformOutput',false);
        obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
    elseif ~isempty(obj.Montage{i})
        
        if length(obj.ChanNames_{i})==length(obj.Montage_{i}(1).channames)
            obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
            obj.Montage_{i}(1)=struct('name','Raw','mat',eye(obj.ChanNumber(i)),'channames',obj.ChanNames_(i),'groupnames',obj.GroupNames_(i));
            obj.Montage_{i}(2)=struct('name','Mean Ref','mat',MeanRefMat(obj.ChanNumber(i)),'channames',obj.ChanNames_(i),'groupnames',obj.GroupNames_(i));
        elseif all(ismember(obj.ChanNames_{i},obj.Montage_{i}(1).channames))
            obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
            p=zeros(1,size(obj.ChanOrderMat{i},1));
            
            for j=1:size(obj.ChanOrderMat{i},1)
                for k=1:length(obj.ChanNames_{i})
                    if strcmpi(obj.Montage_{i}(1).channames{j},obj.ChanNames_{i}{k})
                        p(j)=k;
                    end
                end
            end
            obj.ChanOrderMat{i}(1:size(obj.ChanOrderMat{i},1),:)=obj.ChanOrderMat{i}(p(1:size(obj.ChanOrderMat{i},1)),:);
        end
    end
    
    if isempty(obj.Montage{i})
        obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
        obj.Montage_{i}(1)=struct('name','Raw','mat',eye(obj.ChanNumber(i)),'channames',obj.ChanNames_(i),'groupnames',obj.GroupNames_(i));
        obj.Montage_{i}(2)=struct('name','Mean Ref','mat',MeanRefMat(obj.ChanNumber(i)),'channames',obj.ChanNames_(i),'groupnames',obj.GroupNames_(i));
    end
    
end

remakeMontageMenu(obj);

end

function mat=MeanRefMat(channum)
%Raw wised matrix for Mean Reference Montage
if ~channum
    mat=[];
    return;
end

mat=eye(channum)-1/channum*ones(channum,channum);
end