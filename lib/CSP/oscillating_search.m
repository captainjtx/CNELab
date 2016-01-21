function [eVec,eVal] = oscillating_search(A,B,SpL,NF,method,Winit)
% [eVec,eVal] = oscillation_search(A,B,SpL)
% Input  : A (Between Class = (m1-m2)'(m1-m2)), B (Within Class = CovA+CovB) scatter matrices  => NxN matrix
% Output : eVec NxN sparse eigenvectors from sparsity level 1 to N
%        : eVal Nx1 corresponding max eigenvalues (Rayleigh Quotients)
% Ref    : Generalized Spectral Bounds for Sparse LDA, NIPS 2005
%          B. Moghaddam, Y. Weiss, S. Avidan
% Method : 3 discrete, 1 continous
%     FS : Forward Selection Search
%     BE : Backward Elimination Search
%     OS : Oscillating Search (FS + BE)

%Modified by Tianxiao Jiang 12-31-2015

if nargin<5
    method='OS';
end

FS = strcmp(method,'FS');
BE = strcmp(method,'BE');
OS = strcmp(method,'OS');

% FS = 0;
% BE = 0;
% GS = 0; if GS; FS =1; BE = 1; end
% ST = 1;

eVec=zeros(size(A,1),NF);
eVal=zeros(NF,1);

Anew=A;

for n=1:NF
    % FS : Forward Selection
    if FS
        [~,eVec(:,n),eVal(n)]=forward_search(Anew,B,[],SpL);
    end
    
    % BE : Backward Elimination
    if BE
        [~,eVec(:,n),eVal(n)]=backward_search(Anew,B,[],SpL);
    end
    
    % Oscillating Search : FS + BE
    if OS
        N = size(A,1);
        
        % Initializes with RWE
        if nargin< 6
            [W, ~] = recursive_eliminate(Anew,B,SpL,1);
        else
            W=Winit;
        end
        AddIndx=find(W');
        %===================================
        [V,D] = eig(Anew(AddIndx,AddIndx),B(AddIndx,AddIndx));
        [maxEV,EVIx] = max(abs(diag(D)));
        OldEV=maxEV;
        % Storing the Initial Solution
        eVec(AddIndx,n) = V(:,EVIx);
        eVal(n) = D(EVIx,EVIx);
        
        % Down SWING
        
        if SpL>1
            AddIndx1=AddIndx;
            AddIndx2=AddIndx;
            count=0;
            c=1;
            
            if SpL>2
                C=2;
            else
                C=1;
            end
            
            while 1%count<10
                if (SpL-c)<1
                    break;
                end
                [AddIndx1,~,~]=backward_search(Anew,B,AddIndx1,SpL-c); %#ok<NASGU,ASGLU>
                [AddIndx1,W,newEVn]=forward_search(Anew,B,AddIndx1,SpL);
                %         newEV=max(newEVn(newEVn>0));
                
                if ~sum(setdiff(AddIndx2,AddIndx1)) && c<C
                    c=c+1;
                elseif ~sum(setdiff(AddIndx2,AddIndx1)) && c==C
                    break;
                end
                AddIndx2=AddIndx1;
                count=count+1;
                
                if count>10
                    fprintf('Down Swing %d search\n',count);
                    break;
                end
            end
            
            if maxEV<newEVn
                AddIndx=AddIndx1;
                eVal(n)=newEVn;
                maxEV=newEVn;
                eVec(:,n)=W;
            end
        end
        
        
        % UP SWING
        if SpL<N
            newEVn=maxEV+1;
            AddIndx1=AddIndx;
            AddIndx2=AddIndx;
            count=0;
            c=1;
            
            if SpL>10
                C=2;
            else
                C=4;
            end
            
            
            while 1;%count<10
                if (SpL+c)>N
                    break;
                end
                [AddIndx1,~,~]=forward_search(Anew,B,AddIndx1,SpL+c);
                [AddIndx1,W,newEVn]=backward_search(Anew,B,AddIndx1,SpL);
                %         newEV=min(newEVn(newEVn>0));
                
                if ~sum(setdiff(AddIndx2,AddIndx1)) && c<C
                    c=c+1;
                elseif ~sum(setdiff(AddIndx2,AddIndx1)) && c==C
                    break;
                end
                AddIndx2=AddIndx1;
                count=count+1;
                
                if count>=10
                    fprintf('Up Swing %d search\n',count);
                    break;
                end
            end
            
            if maxEV<newEVn
                eVal(n)=newEVn;
                eVec(:,n)=W;
            end
        end
        
%         if OldEV>maxEV
%             fprintf('\nMinimized\n');
%         end
    end
    
    %Deflation method to remove the effect of the extracted eigenvector
    v=eVec(:,n)/sqrt(eVec(:,n)'*B*eVec(:,n));
    s=find(v);
    Anew(s,s) = (eye(length(s))-B(s,s)*v(s)/(v(s)'*B(s,s)*v(s))*v(s)')*Anew(s,s);
end

function [AddIndx,eVec,eVal]=forward_search(A,B,AddIndx,SpL)

N = size(A,1);
VecFS = zeros(N,1);
Indx  = ones(1,N);

AddIndx=AddIndx(:);

if isempty(AddIndx)
    AddIndx = [];
else
    Indx(AddIndx)=0;
end

for n = length(AddIndx):SpL-1 %N
    %fprintf('Adding:%d\n',n);
    maxEigVal = zeros(1,N);
    for j=1:N
        if Indx(j)
            ix = [AddIndx;j];
            [~,D] = eig(A(ix,ix),B(ix,ix));
            [maxEigVal(j),~] = max(abs(diag(D))); %max eigenvalue
        end
    end
    [~, six] = max(maxEigVal);
    AddIndx = [AddIndx;six];
    [V,D] = eig(A(AddIndx,AddIndx),B(AddIndx,AddIndx));
    Indx(six) = 0;
    [~,EVIx] = max(abs(diag(D)));
end

VecFS(AddIndx) = V(:,EVIx);
ValFS = D(EVIx,EVIx);
eVec = VecFS;
eVal = ValFS;

function [AddIndx,eVec,eVal]=backward_search(A,B,AddIndx,SpL)

N = size(A,1);
VecBE = zeros(N,1);
Indx  = ones(1,N);

% [V,D] = eig(A,B);
% [~,EVIx] = max(abs(diag(D)));
% VecBE(:,N) = V(:,EVIx);
% ValBE(N) = D(EVIx,EVIx);

if isempty(AddIndx)
    AddIndx = 1:N;
else
    Indx(setdiff(1:N,AddIndx))=0;
end

for n = length(AddIndx)-1:-1:SpL
    %     fprintf('Eliminating:%d\n',n);
    maxEigVal = zeros(1,N);
    for j=1:N
        if Indx(j)
            ix = setdiff(AddIndx,j);
            [~,D] = eig(A(ix,ix),B(ix,ix));
            % maxEigVal(j) = D(end,end) ;
            [maxEigVal(j),~] = max(abs(diag(D))); %max eigenvalue
        end
    end
    [~, six] = max(maxEigVal);
    AddIndx = setdiff(AddIndx,six);
    [V,D] = eig(A(AddIndx,AddIndx),B(AddIndx,AddIndx));
    Indx(six) = 0;
    [~,EVIx] = max(abs(diag(D)));
end
VecBE(AddIndx) = V(:,EVIx);
ValBE = D(EVIx,EVIx);
eVec = VecBE;
eVal = ValBE;