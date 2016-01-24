function [eVec,eVal] = fast_scsp(A,B,SpL,chanind)
%A computational efficient sparse common spatial pattern algorithms using
%divide and conquer approach
if nargin<4
    %should only be executed at the first entry
    chanind=ones(size(A,1),1);
end

chanind=logical(chanind);
N=length(chanind);
eVec=zeros(N,1);

M=size(A,1);

if SpL==0
    eVal=-inf;
    return
elseif SpL==M
    [V,D] = eig(A,B);
    [eVal,id]=max(diag(D));
    eVec(chanind)=V(:,id);
    
    return
elseif SpL>M
    eVal=-inf;
    return
else
    %divide
    m=round(M/2);
    
    %conquer
    cross_rq=-inf;
    cross_eVec=zeros(N,1);
    for i=0:SpL
        tmp=find(chanind);
        chanind_left=zeros(N,1);
        chanind_left(tmp(1:m))=1;
        [eVec_left,~]=fast_scsp(A(1:m,1:m),B(1:m,1:m),i,chanind_left);
        
        chanind_right=zeros(N,1);
        chanind_right(tmp(m+1:end))=1;
        [eVec_right,~]=fast_scsp(A(m+1:end,m+1:end),B(m+1:end,m+1:end),SpL-i,chanind_right);
        
        %this can be optimized later, should be directly obtained
        ind=[find(eVec_left);find(eVec_right)];
        subind=ismember(tmp,ind);
        try [eVec_tmp,cross_rq_tmp]=eig(A(subind,subind),B(subind,subind));
        catch
            display
        end
        
        [cross_rq_tmp,id]=max(diag(cross_rq_tmp));
        
        cross_eVec_tmp=zeros(N,1);
        cross_eVec_tmp(ind)=eVec_tmp(:,id);
        %******************************************************************
        if cross_rq_tmp>cross_rq
            cross_rq=cross_rq_tmp;
            cross_eVec=cross_eVec_tmp;
        end
    end
    
    tmp=find(chanind);
    chanind_left=zeros(N,1);
    chanind_left(tmp(1:m))=1;
    [left_eVec,left_rq]=fast_scsp(A(1:m,1:m),B(1:m,1:m),SpL,chanind_left);
    
    chanind_right=zeros(N,1);
    chanind_right(tmp(m+1:end))=1;
    [right_eVec,right_rq]=fast_scsp(A(m+1:end,m+1:end),B(m+1:end,m+1:end),SpL,chanind_right);
    
    %     try
    if cross_rq>=left_rq&&cross_rq>=right_rq
        eVec=cross_eVec;
        eVal=cross_rq;
        return
    elseif left_rq>=cross_rq&&left_rq>=right_rq
        eVec=left_eVec;
        eVal=left_rq;
        return
    else
        eVec=right_eVec;
        eVal=right_rq;
        return
    end
    %     catch
    %         disp(cross_rq,left_rq,right_rq);
    %     end
end
end

