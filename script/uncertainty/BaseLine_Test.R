####

pt=5;
chan=3;
med='MedicineOff';
session=3;

ind=(Pt==pt)&(Chan==chan)&(Med==med);

d=beta_before_target[ind];
d=10*log10(d);

f=Targets[ind];
s=Session[ind];

s=factor(s);
bxp=boxplot(d~s,xlab='Session',ylab='Power (dB)',main=paste('Pt ',pt,' Chan ',chan,' ',med),
            ylim=c(min(d)-1,max(d)+1))

points(c(1,2,3),tapply(d,s,mean),pch=8,col='red')
text (c(1.25,2.25,3.25) , bxp$stats [5,]+0.7 , paste ('n=',bxp$n))


t=aov(d~s);
summary(t);

#plot(TukeyHSD(t))
####