####

d=beta_before_go-beta_before_target;

newdata_baseline=aggregate(d~Pt+Med+Targets+Session,data,mean);
d=newdata_baseline$d;

f1=factor(newdata_baseline$Targets);
f2=factor(newdata_baseline$Med)


t=aov(d~f1*f2);
summary(t);
pvalue=signif(summary(t)[[1]]['Pr(>F)'][[1]][1], digits = 2)
bxp=boxplot(d~f2+f1,ylab='Power (dB)',main=paste('p-value ',pvalue),
            ylim=c(min(d)-2,max(d)+2))

points(c(1,2,3,4),tapply(d,list(f1,f2),mean),pch=8,col='red')
text (c(1,2,3,4) , bxp$stats [5,]+0.5 , paste ('n=',bxp$n))

#plot(TukeyHSD(t))
####