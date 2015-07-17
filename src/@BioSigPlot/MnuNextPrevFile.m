function MnuNextPrevFile(obj)

prompt=cell(1,obj.DataNumber);
def=cell(1,obj.DataNumber);
for i=1:obj.DataNumber
    prompt{2*i-1}=['DATA ',num2str(i),' : Previous File: '];
    prompt{2*i}=['DATA ',num2str(i),' : Next File: '];
    def{2*i-1}=obj.PrevFiles{i};
    if isempty(def{2*i-1})
        def{2*i-1}='';
    end
    def{2*i}=obj.NextFiles{i};
    if isempty(def{2*i})
        def{2*i}='';
    end
end

title='Set Next/Prev File';

answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

for i=1:obj.DataNumber
    tmp1=answer{2*i-1};
    tmp2=answer{2*i};
    
    if isempty(tmp1)
        tmp1=obj.PrevFiles{i};
    end
    if isempty(tmp2)
        tmp2=obj.NextFiles{i};
    end
    
    fdir=fileparts(obj.FileNames{i});
    if exist(fullfile(fdir,tmp1),'file')==7
        tmp1='';
    elseif ~isempty(tmp1)&&~exist(fullfile(fdir,tmp1),'file')
        h = errordlg([tmp1,' not found in ',fdir,' !']);
        return
    end
    
    if exist(fullfile(fdir,tmp2),'file')==7
        tmp2='';
    elseif ~isempty(tmp2)&&~exist(fullfile(fdir,tmp2),'file')
        h = errordlg([tmp2,' not found in ',fdir,' !']);
        return
    end
    
    obj.PrevFiles{i}=tmp1;
    obj.NextFiles{i}=tmp2;
end
end



