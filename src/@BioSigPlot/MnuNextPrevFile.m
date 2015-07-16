function MnuNextPrevFile(obj)

prompt={};
def={};
for i=1:obj.DataNumber
    prompt=cat(2,prompt,['DATA ',num2str(i),' : Previous File: '],['DATA ',num2str(i),' : Next File: ']);
    def=cat(2,def,obj.PrevFiles{i},obj.NextFiles{i});
end

title='Set Next/Prev File';

answer=inputdlg(prompt,title,1,def);

for i=1:obj.DataNumber
    tmp1=answer{2*i-1};
    tmp2=answer{2*i};
    
    if isempty(tmp1)||isnan(tmp1)
        tmp1=obj.PrevFiles{i};
    end
    if isempty(tmp2)||isnan(tmp2)
        tmp2=obj.NextFiles{i};
    end
    
    fdir=fileparts(obj.FileNames{i});
    if ~isempty(tmp1)&&~exist(fullfile(fdir,tmp1),'file')
        h = errordlg([tmp1,' not found in ',fdir,' !']);
        return
    end
    
    if ~isempty(tmp2)&&~exist(fullfile(fdir,tmp2),'file')
        h = errordlg([tmp2,' not found in ',fdir,' !']);
        return
    end
    
    obj.PrevFiles{i}=tmp1;
    obj.NextFiles{i}=tmp2;
end
end



