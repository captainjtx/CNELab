function [W,eV]=recursive_eliminate(A,B,SpL,NF)
[Nc] = size(A,1);
St = B;
Anew = A;
Bnew=  B;

W=zeros(Nc,NF);
D=[];
for n=1:NF
    AddIndx=[1:Nc];
    % Indx=ones(1,Nc);
    v=zeros(Nc,1);
    % r=1;
    for k=Nc:-1:SpL+1 % sparse filters
        [eVec,EigVal]=eig(Anew(AddIndx,AddIndx),Bnew(AddIndx,AddIndx));%+Bnew(AddIndx,AddIndx));
        
        EigVal=diag(EigVal);
        [EigVal,si]=sort(EigVal); %#ok<ASGLU>
        eVec=eVec(:,si);
        
        % Storing all solutions for different Sparsity Levels
        d = eVec(:,end);
        
        % Sort the abs weigths and set the min val to zero
        [ds,si]=sort(abs(d)); %#ok<ASGLU>
        AddIndx=setdiff(AddIndx,AddIndx(si(1)));
    end
    
    [eVec,EigVal]=eig(Anew(AddIndx,AddIndx),Bnew(AddIndx,AddIndx));%+Bnew(AddIndx,AddIndx));
    EigVal=diag(EigVal);
    [EigVal,si]=sort(EigVal); %#ok<ASGLU>
    eVec=eVec(:,si);
    
    % use when hard coded
    v(AddIndx) = eVec(:,end);
    v = v/sqrt(v'*Bnew*v); % make A norm to 1
    W(:,n)=v;
    
    D = [D;v'];  %#ok<AGROW>
    eV(n) = (v'*Anew*v)/(v'*B*v); %#ok<AGROW>
    s = find(v);
    % Anew = [eye(Nc)-St*D'*inv(D*St*inv(B)*St*D')*D*St*inv(B)]*A;
    % Anew = [eye(Nc)-St*D'*inv(D*St*D')*D]*A;
    %Deflation method to remove the effect of the extracted eigenvector
    Anew(s,s) = (eye(length(s))-St(s,s)*v(s)/(v(s)'*St(s,s)*v(s))*v(s)')*Anew(s,s);
%     Bnew(s,s) = (eye(length(s))-St(s,s)*v(s)/(v(s)'*St(s,s)*v(s))*v(s)')*Bnew(s,s);
%     As = (eye(Nc)-St*v/(v'*St*v)*v')*Anew;
%     Anew = 
%     Anew = (Anew + Anew')/2;
    % Anew = (eye(Nc)-St*D'/(D*St/B*St*D')*D*St/B)*A;
end