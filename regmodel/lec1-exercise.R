library(UsingR)
data(galton)

p<-galton$parent
c<-galton$child

meanp<-mean(p)
meanc<-mean(c)

n<-nrow(galton)

cov<-1/(n-1)*sum((p-meanp)*(c-meanc))

cor<- cov/(sd(p)*sd(c))

cor

cp<-(p-meanp)
mean(cp)
cc<-(c-meanc)
mean(cc)

