function [eVec,eVal,stat] = fast_scsp(A,B,SpL,chanind,varargin)
%A computational efficient sparse common spatial pattern algorithms using
%divide and conquer approach

%Been proved not to be optimal...:(
if nargin<4
    %should only be executed at the first entry
    chanind=true(size(A,1),1);
end

if nargin>=5
    stat=varargin{1};
else
    stat=zeros(SpL,1);
end

N=length(chanind);
eVec=zeros(N,1);

M=size(A,1);

if SpL==0
    eVal=-inf;
    return
elseif SpL==M
    if SpL==1
        % naive case, no need to call eig and other functions
        eVal=A/B;
        eVec(chanind)=1;
    else
        [V,D] = eig(A,B);
        [eVal,id]=max(diag(D));
        eVec(chanind)=V(:,id);
    end
    
    stat(M)=stat(M)+1;
    return
% elseif SpL>M
% this case only appear when 0:SpL
%     eVal=-inf;
%     return
else
    %divide
    m=round(M/2);
    
    %conquer
    cross_rq=-inf;
    cross_eVec=zeros(N,1);

    for i=max(0,SpL-M+m):min(SpL,m)% bettern than 0:SpL
        tmp=find(chanind);
        chanind_left=false(N,1);
        chanind_left(tmp(1:m))=true;
        [eVec_left,~,stat]=fast_scsp(A(1:m,1:m),B(1:m,1:m),i,chanind_left,stat);
        
        chanind_right=false(N,1);
        chanind_right(tmp(m+1:end))=true;
        [eVec_right,~,stat]=fast_scsp(A(m+1:end,m+1:end),B(m+1:end,m+1:end),SpL-i,chanind_right,stat);
        
        %this can be optimized later, should be directly obtained
        %prove from math
        ind=[find(eVec_left);find(eVec_right)];
        subind=ismember(tmp,ind);
        
        [eVec_tmp,cross_rq_tmp]=eig(A(subind,subind),B(subind,subind));
        
        stat(size(eVec_tmp,1))=stat(size(eVec_tmp,1))+1;
        
        [cross_rq_tmp,id]=max(diag(cross_rq_tmp));
        
        cross_eVec_tmp=zeros(N,1);
        cross_eVec_tmp(ind)=eVec_tmp(:,id);
        %******************************************************************
        if cross_rq_tmp>cross_rq
            cross_rq=cross_rq_tmp;
            cross_eVec=cross_eVec_tmp;
        end
        
    end
    eVec=cross_eVec;
    eVal=cross_rq;
    return
end
end

