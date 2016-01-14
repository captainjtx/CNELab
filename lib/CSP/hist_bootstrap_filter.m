function F = hist_bootstrap_filter( datA,datB,SpL,NumTrial,NumRep )
F=zeros(size(datA,1),1);
for i=1:NumRep
    CA=0;
    CB=0;
   for t=1:NumTrial
       sA=round(rand()*(size(datA,3)-1)+1);
       sB=round(rand()*(size(datB,3)-1)+1);
       
       tmp=cov(datA(:,:,sA));
       CA=CA+tmp/trace(tmp);
       
       tmp=cov(datB(:,:,sB));
       CB=CB+tmp/trace(tmp);
   end
   
   CA=CA/NumTrial;
   CB=CB/NumTrial;
   
   [f,~]=oscillating_search(CA,CB,SpL,1,'OS');
   
   F(f>0)=F(f>0)+1;
end
end

