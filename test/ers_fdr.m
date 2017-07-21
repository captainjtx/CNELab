f=[60,200];
fr=s.f>=f(1)&s.f<=f(2);
N=length(s.channame);

t_start=zeros(N,1);
t_end=t_start;
p=0.05;

test=zeros(length(s.t),N);
%val=zeros(length(s.t),N);

for i=1:length(s.trial_mat)
    %contact
    ers=[];
    
    baseline=mean(mean(s.ref_mat{i}(fr,:),2),1);
    for j=1:length(s.trial_mat{i})
        %trial
        normalized=mean(s.trial_mat{i}{j}(fr,:),1)/baseline;
        ers=cat(1,ers,normalized);
    end
    
    for k=1:size(ers,2)
        [~,test(k,i)]=ttest(10*log10(ers(:,k)),0,'alpha',p,'tail','right');
    end
end
%%
q=0.05;
sig=zeros(size(test));
for k=1:size(test,1)
    [pID,pN]=FDR(test(k,:),q);
    
    if(~isempty(pN))
        sig(k,:)=test(k,:)<pN;
    end
end
t_start=nan(1,N);
for c=1:N
   tmp=s.t(find(sig(:,c),1,'first'));
   if ~isempty(tmp)
       t_start(c)=tmp;
   end
end
fid=fopen(sprintf('s2_start_time_%d_%d.txt',f(1),f(2)),'w');
for c=1:N
    if ~isnan(t_start(c))
        fprintf(fid,'%s,%f\n',s.channame{c},t_start(c));
    end
end


