data=read.csv('~/Desktop/Projects/data/uncertainty/Analysis/2015-04-06/uncertainty_beta_power.csv')
attach(data)
pid=c(1,2,3,4,5,10);
chan=c(1,2,3);
med=c('Off','On');

for (pi in 1:length(pid))
{
  for (ci in 1:length(chan))
  {
    for(mi in 1:length(med))
    {
      ind=(Pt==pid[pi])&(Chan==chan[ci])&(Med==med[mi]);
      session=unique(Session[ind]);
      
      for(si in 1:length(session))
      {
        ind1=ind&(Session==session[si]);
        
        baseline=mean(beta_before_target[ind1]);
        data$beta_before_target[ind1]=10*log10(beta_before_target[ind1]/baseline);
        data$beta_after_target[ind1]=10*log10(beta_after_target[ind1]/baseline);
        data$beta_before_go[ind1]=10*log10(beta_before_go[ind1]/baseline);
        data$beta_exit_centered[ind1]=10*log10(beta_exit_centered[ind1]/baseline);
        
      }
      
    }
  }
}

detach(data)
attach(data)
